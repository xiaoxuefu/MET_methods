function [rmse] = MET_sample2sample_rmse(x_coord,y_coord)

% MET_sample2sample_rmse 

% Code developed by Drs. Julia Yurkovic-Harding and Samuel M. Harding for 
% "Implementing Mobile Eye Tracking in Psychological Research: A Practical 
% Guide" (Fu et al., 2024);

% INPUTS:
%   x_coord: the x coordinates of gaze
%   y_coord: the y coordinates of gaze

% SAMPLE DATA:
% + To use the accompanying sample data, read the sample data table into
%   MATLAB as data: data = readtable('sampledata1.csv');
% + Next, use the porX and porY columns as input into the function:
%   [rmse] = MET_sample2sample_rmse(data.porX,data.porY);
% + The sample data are specific rows of a Yarbus calibration output from
%   the Positive Science system.

%% == DETAILS FOR CALCULATING VISUAL ANGLE ================================

% The scene camera details are specific to a Positive Science head-mounted
% eye tracking system and may differ for other systems.

% - Scene camera FOV in degrees
x_cam_angle = 84.28;
y_cam_angle = 69.26;

% - Scene camera pixels
x_screen_res = 640;
y_screen_res = 480;

% - Convert to degrees
to_degreesx = x_screen_res/x_cam_angle;
to_degreesy = y_screen_res/y_cam_angle;

% The calibration object size and distance from the subject is specific to
% work conducted by Drs. Bradshaw, Fu, and Yurkovic-Harding and will differ
% based on each lab's calibration procedure.

% - Calibration object info
calib_obj_size = 1.75; % Object diameter in inches
calib_distance = 48;   % Distance between the subject and calibration target in inches
calib_angle_constant = 2;
xPx = calib_angle_constant/x_cam_angle * x_screen_res;
yPx = calib_angle_constant/y_cam_angle * y_screen_res;

%% == CALCULATE PRECISION (SAMPLE-TO-SAMPLE ROOT MEAN SQUARED ERROR) ======

% x-coord and y-coord are the porX and porY columns in a Yarbus calibration
% output table from the Positive Science system.

% Distance in visual angle
x_ang = 2 * atand( x_coord * (calib_obj_size/xPx) / (2*calib_distance) );
y_ang = 2 * atand( y_coord * (calib_obj_size/yPx) / (2*calib_distance) );

% Compute the distance between consecutive (x,y) samples
dX = diff(x_ang);
dY = diff(y_ang);
h = hypot(dX,dY);

% Average of these distances
distSquared = diff(h).^2;
avgDistance = mean(distSquared);

% Square root of these distances
rmse = sqrt(avgDistance);

end