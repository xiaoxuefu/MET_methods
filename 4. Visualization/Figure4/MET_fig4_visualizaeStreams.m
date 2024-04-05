%% Visualize Paired Data Streams
%Written by Xiaoxue Fu
%Updated: 05/25/2023

clear 
close all

% Run this program after MET_fig5_extractPairs
% Run the program from the directory where this program is located

directory=pwd;
timevpDir = uigetdir(directory, 'Please select the timevp folder');
addpath(genpath(timevpDir));

% Set up inputs 

inputDirName1 = [directory filesep 'cleanedData' filesep];
inputDirName2 = [directory filesep 'pairedData' filesep];

InfantEyeFile = [inputDirName1 'cleaned_eye_aoi_infant_seg.csv'];
ParentEyeFile = [inputDirName1 'cleaned_eye_aoi_parent_seg.csv'];
JAFile = [inputDirName2 'InfantEye_ParentEye.csv']; 
IEyeIHandFile = [inputDirName2 'InfantEye_InfantHand.csv']; 
PEyeIHandFile = [inputDirName2 'ParentEye_InfantHand.csv']; 
IEyePHandFile = [inputDirName2 'InfantEye_ParentHand.csv']; 
PEyePHandFile = [inputDirName2  'ParentEye_ParentHand.csv']; 

%Set up outputs
dir_save = [directory filesep 'plots' filesep];
if exist(dir_save, 'dir') ~= 7
    mkdir(dir_save)
end

% Visualize infant looking and parent looking event
csvfile_list = {InfantEyeFile, ParentEyeFile};
vis_args.annotation = {'Infant Look', 'Parent Look'};
%vis_args.windows = [0 250; 250 500; 500 750];
vis_args.xlim_list = [1016 1058];
vis_args.save_name = [dir_save 'plot_IEyePEye'];
% call the function 
timevp_visualization(csvfile_list, vis_args);

% Visualize JA
csvfile_list = {JAFile};
vis_args.annotation = {'Joint Attention'};
vis_args.save_name = [dir_save 'plot_JA'];
timevp_visualization(csvfile_list, vis_args);

% Visualize Infant-Parent Eye-Hand Coordination
csvfile_list = {IEyeIHandFile, PEyeIHandFile, IEyePHandFile, PEyePHandFile};
vis_args.annotation = {'Infant Look Infant Hand', 'Parent Look Infant Hand', ...
    'Infant Look Parent Hand', 'Parent Look Parent Hand'};
vis_args.save_name = [dir_save 'plot_EyeHandCoordination'];
timevp_visualization(csvfile_list, vis_args);
