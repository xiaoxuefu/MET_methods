%% Extract Data Pairs based on selected segment(s) of one dyad's data stream
%Written by Xiaoxue Fu
%Updated: 05/25/2023

function MET_fig4_extractPairs()

clear 
close all

% Run the function from the directory where this program is saved
directory=pwd;
timevpDir = uigetdir(directory, 'Please select the timevp folder');
addpath(genpath(timevpDir));

%% 1. Setup Inputs and Outputs
inputDirName = [directory filesep 'cleanedData' filesep];
dir_save = [directory filesep 'pairedData' filesep];
if exist(dir_save, 'dir') ~= 7
    mkdir(dir_save)
end

inputFiles = struct2table(dir(inputDirName)); 
inputFiles(inputFiles.isdir==1, :) = [];

aoiCol=3; 
%Settings for AOI codes
nonToys =  [3,25,5];
minCode=3; maxCode=28;
mapping = [(minCode:maxCode)' (minCode:maxCode)']; 
%set time relations between the two events
timing_relation = 'more(on1, off2, 0.1) & more(on2, off1, 0.1) & more(on1, off1, 0.1) & more(on2, off2, 0.1)';  

%Get file indices
fileIdx.InfantEye = find(contains(inputFiles.name, 'eye_aoi_infant')); 
fileIdx.ParentEye = find(contains(inputFiles.name, 'eye_aoi_parent')); 
fileIdx.InfantLH = find(contains(inputFiles.name, 'left_hand_aoi_infant')); 
fileIdx.InfantRH = find(contains(inputFiles.name, 'right_hand_aoi_infant')); 
fileIdx.ParentLH = find(contains(inputFiles.name, 'left_hand_aoi_parent')); 
fileIdx.ParentRH = find(contains(inputFiles.name, 'right_hand_aoi_parent')); 

%% Align data for L and R hands
%infant
[allpairs, events1_wo, events2_wo] = timevp_extract_pairs_XF([inputDirName inputFiles.name{fileIdx.InfantLH}], ...
 [inputDirName inputFiles.name{fileIdx.InfantRH}], timing_relation, mapping);

idx=find(ismember(allpairs(:,aoiCol), nonToys));
if ~isempty(idx)
allpairs(idx, :)=[]; 
end

%Onset is the smaller number, offset is the bigger number
onset = min(allpairs(: , [1 5]), [],2);
offset = max(allpairs(: , [2 6]), [],2);
aoi = allpairs(:,aoiCol);
output = cleanPairs(onset, offset, aoi);

%write out data to file
write2csv(output, [inputDirName 'combined_hands_aoi_infant.csv'], {}, '%.3f')

%parent
[allpairs, events1_wo, events2_wo] = timevp_extract_pairs_XF([inputDirName inputFiles.name{fileIdx.ParentLH}], ...
    [inputDirName inputFiles.name{fileIdx.ParentRH}], timing_relation, mapping);

nopairs = vertcat(events1_wo, events2_wo);

idx=find(ismember(allpairs(:,aoiCol), nonToys) & ismember(nopairs(:,aoiCol), nonToys));
if ~isempty(idx)
allpairs(idx, :)=[]; 
end

%Onset is the smaller number, offset is the bigger number
onset = min(allpairs(: , [1 5]), [],2);
onset = vertcat(onset, nopairs(:,1));
[onset, sortIdx] = sort(onset);

offset = max(allpairs(: , [2 6]), [],2);
offset = vertcat(offset, nopairs(:,2));
offset = offset(sortIdx);

aoi = vertcat(allpairs(:,aoiCol), nopairs(:,aoiCol));
aoi = aoi(sortIdx);

output = cleanPairs(onset, offset, aoi);

%write out data to file
write2csv(output, [inputDirName 'combined_hands_aoi_parent.csv'], {}, '%.3f')

%% Extract Pairs of events

pairNames = {'InfantEye_ParentEye', 'InfantEye_InfantHand', 'ParentEye_InfantHand', ...
    'InfantEye_ParentHand', 'ParentEye_ParentHand'};

inputFiles = struct2table(dir(inputDirName)); 
inputFiles(inputFiles.isdir==1, :) = [];
fileIdx.InfantHand = find(contains(inputFiles.name, 'hands_aoi_infant')); 
fileIdx.ParentHand = find(contains(inputFiles.name, 'hands_aoi_parent')); 
pairIdx = [fileIdx.InfantEye fileIdx.ParentEye; fileIdx.InfantEye fileIdx.InfantHand;
    fileIdx.ParentEye fileIdx.InfantHand; fileIdx.InfantEye fileIdx.ParentHand; 
    fileIdx.ParentEye fileIdx.ParentHand];

% Start extracting pairs of events
for p=1:length(pairNames)
    display(['Extracting pairs: ' pairNames{p}])
[allpairs, events1_wo, events2_wo] = timevp_extract_pairs_XF([inputDirName inputFiles.name{pairIdx(p,1)}], ...
    [inputDirName inputFiles.name{pairIdx(p,2)}], timing_relation, mapping);

idx=find(ismember(allpairs(:,aoiCol), nonToys));
if ~isempty(idx)
allpairs(idx, :)=[]; 
end

%Onset is the bigger number, offset is the smaller number
onset = max(allpairs(: , [1 5]), [],2);
offset = min(allpairs(: , [2 6]), [],2);
aoi = allpairs(:,aoiCol);
output = cleanPairs(onset, offset, aoi);

%write out data to file
write2csv(output, [dir_save pairNames{p} '.csv'], {}, '%.3f')

end %end loop extract pairs
end

%% clean combined data function
function output = cleanPairs(onset, offset, aoi)

threshold = 0.3;
%newOffset = offset; newOnset = onset; newAOI = aoi;

i=2; %start from 2nd row of data
while i < (length(onset)+1)
gap = onset(i) - offset(i-1); 
%offsetIdx = find(gap<threshold);    %identify gap of events < 0.3s
if gap<threshold
%nextOffsetIdx = offsetIdx + 1; 
%combine events if gap < 0.3s
offset(i-1)=offset(i);
offset(i)=[];
onset(i)=[];
aoi(i)=[];
else
     i=i+1;
end %end if
end %end while loop

%check duration
dur = offset-onset;     
idx = find(dur<threshold);
onset(idx)=[];
offset(idx)=[];
aoi(idx)=[];
output=horzcat(onset, offset, aoi);

end

