%% Visualize Paired Data Streams
%Written by Xiaoxue Fu
%Updated: 05/26/2023

clear 
close all

% Run the program from the directory where this program is located
directory=pwd;
timevpDir = uigetdir(directory, 'Please select the timevp folder');
addpath(genpath(timevpDir));

% Set up inputs 

cFile = [directory filesep 'PC_MET_input.csv'];
pFile = [directory filesep 'PC_BEH_input.csv'];

%Set up outputs
dir_save = [directory filesep 'plots' filesep];
if exist(dir_save, 'dir') ~= 7
    mkdir(dir_save)
end

inputdata = dlmread(cFile);
minimum = min(inputdata(:,1));
xlim1 = floor(minimum/1000)*1000;
maximum = max(inputdata(:,2));
xlim2 = ceil(maximum/1000)*1000;

idx = round(length(inputdata)/2);
mid = inputdata(idx, 2);

% Visualize infant looking and parent looking event
csvfile_list = {cFile, pFile};
vis_args.annotation = {'Child Looking Behavior', 'Parenting Behavior'};
vis_args.windows = [mid xlim2; xlim1 mid];
vis_args.save_name = [dir_save 'plot_PC'];
% call the function 
timevp_visualization(csvfile_list, vis_args);
