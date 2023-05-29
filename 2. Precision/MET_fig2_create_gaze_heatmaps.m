% EXTERNAL SCRIPT THAT RUNS MET_gaze_heatmap FUNCTION TO RECREATE FIGURE 2

%   Written by Dr. Julia Yurkovic-Harding
%   Updated May 2024 for Fu et al. (2023)
%   Contact info: yurkovicharding@sc.edu

% PROCESS
%   This script will open your file structure and allow you to navigate to
%   a folder containing gaze files for which you would like to generate
%   heatmaps.
%   This script specifically loads in .txt files containing gaze
%   information. Any .txt files that are not titled "readme" within the
%   selected folder will be run.

%% == MET_fig2_create_gaze_heatmaps.m =====================================

% -- Clean the Workspace --------------------------------------------------

clear
close all
warning('off')
clc


% -- Get Folder with Downloaded Data are Stored ---------------------------

% The script will open up your file structure. Navigate to the folder that
% contains the downloaded data files. Alternatively, you can navigate to a
% folder containing your eye tracking data.
folder_name = uigetdir(pwd, 'Please select folder containing your gaze data');
folder = struct2table(dir(folder_name));

%Output folder
dir_save = fullfile(folder_name, '..', filesep, 'outputs', filesep);
if exist(dir_save, 'dir') ~= 7
    mkdir(dir_save)
end

% -- Identify .txt Files within Folder ------------------------------------

gaze_files = folder(...
     contains(folder.name,'.txt') & ...
    ~contains(folder.name,'readme'),:);

% -- Pre-allocate table to store RMSE analyses for each .txt file ---------
RMSE = table;
RMSE.FileName = cell(size(gaze_files,1),1);
RMSE.GazeCenter = nan(size(gaze_files,1),1);
RMSE.SceneCenter = nan(size(gaze_files,1),1);


% -- Read .txt File and Generate Heatmaps ---------------------------------

% Loop through all of the identified gaze .txt files
for i = 1:size(gaze_files,1)

    % Get current filename, save to table
    file_dir = [gaze_files.folder{i},filesep,gaze_files.name{i}];
    RMSE.FileName{i} = gaze_files.name{i};
    
    % Read the .txt file as a table, skipping the first 3 header lines.
    %   ** Positive Science .txt files typically have 5 header lines. The
    %   first 2 were removed from the shared .txt files accompanying Fu et
    %   al., 2023 because they contained session dates and times.
    gaze = readtable(file_dir,...
        'NumHeaderLines',3,...
        'VariableNamingRule','Preserve');

    % Read the 2nd row, 1st cell of the .txt file for screen resolution
    %   ** The x and y screen resolution is stored at the end of the 2nd
    %   line in the .txt file. Using regexp, we isolate the two numbers.
    sr = table2array(readtable(file_dir,...
        'Range',[2 1 3 1],...
        'VariableNamingRule','Preserve'));
    sr = regexp(sr{1},' ','split');
    sr = regexp(sr{end},'x','split');
    sr = cellfun(@str2num,sr);

    % Run MET_gaze_heatmap, store outcome variables in a table
    %   x_coord = gaze.porX;
    %   y_coord = gaze.porY
    %   pupil = logical variable for when pupil was not detected (-1000)
    %   x_pixels = first value in screen resolution (sr)
    %   y_pixels = second value in screen resolution (sr)
    [fig,RMSE.GazeCenter(i),RMSE.SceneCenter(i)] = ...
        MET_gaze_heatmap(gaze.porX,gaze.porY,(gaze.pupilX~=-1000),sr(1),sr(2));

    % Output figure
    saveas(gcf,[dir_save,filesep,strrep(RMSE.FileName{i},'.txt','_heatmap.png')])
    close all

end

% -- Export RMSE table as .csv file ---------------------------------------
date = char(datetime('today','Format','uuuu-MM-dd'));
writetable(RMSE,[dir_save,filesep,'rmse_gaze_',date,'.csv'])
