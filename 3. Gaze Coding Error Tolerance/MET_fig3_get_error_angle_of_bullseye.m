% EXTERNAL SCRIPT THAT RUNS MET_visual_angle_error_calculator FUNCTION

%   Written by Dr. Julia Yurkovic-Harding
%   Updated May 2024 for Fu et al. (2023)
%   Contact info: yurkovicharding@sc.edu

% PROCESS
% + This script will run the error calculator to get the degrees of visual
%   angle accounted for by the coding bullseye.
% + The scene camera x and y degrees were calculated by the manufacturer.
% + The scene pixels x and y are the area in pixels of the scene video
% + The radius is the distance of the edge of the bullseye to gaze center.
%   This was calculated offline by simply counting the number of pixels.

% ADDITIONAL NOTES
% + The script is currently pre-set to run using the angle and recording
%   size of data presented in Figure 3 in Fu et al. (2023)

%% == MET_fig3_get_error_angle_of_bullseye.m ==============================

% -- Clean the Workspace --------------------------------------------------

clear
close all
warning('off')
clc


% -- Input Data -----------------------------------------------------------
% Based on Pupil Core specs
% Scene camera degrees
scene_cam_deg_x = 82.1;
scene_cam_deg_y = 52.2;

% Scene camera pixels
scene_pixels_x = 1280;
scene_pixels_y = 720;

% Radius
radius = 38.4; % red bullseye: 2% of the screen resolution
%radius = 96; % yellow bullseye: 5% of the screen resolution
% radius = 152.6; % green bullseye: 8% of the screen resolution


% -- Run MET_visual_angle_error_calculator --------------------------------

[error] = MET_visual_angle_error_calculator(...
    scene_cam_deg_x,scene_cam_deg_y,scene_pixels_x,scene_pixels_y,radius);

fprintf('The bullseye accounts for %4.2f%c error\n',mean(error.Euclidean_Distance_Angle,'omitnan'),char(176));
