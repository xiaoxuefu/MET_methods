function [error] = MET_visual_angle_error_calculator(scene_cam_deg_x,scene_cam_deg_y,scene_pixels_x,scene_pixels_y,radius)

% GET VISUAL ANGLE ACCOUNTED FOR BY BULLSEYE -OR- RECOMMENDED BULLSEYE SIZE
%   Written by Dr. Julia Yurkovic-Harding
%   Updated May 2024 for Fu et al. (2023)
%   Contact info: yurkovicharding@sc.edu

% REQUIRED VARIABLES:
%   scene_cam_deg_x: visual angle (degrees) of the camera on the x-axis
%   scene_cam_deg_y: visual angle (degrees) of the camera on the y-axis
%       ** This information is available through the hardware manufacturer
%   scene_pixels_x: pixels on the x dimension of the recorded video
%   scene_pixels_y: pixels on the x dimension of the recorded video
%       ** for example, some videos are recorded as 640*480p
%   radius: the radius in pixels of the space used for ROI coding


% -- Calculate the Visual Angle Accounted for by the Gaze Bullseye --------

% Convert scene pixels to degrees
scene_vid_deg_x = scene_pixels_x/scene_cam_deg_x;
scene_vid_deg_y = scene_pixels_y/scene_cam_deg_y;

% Suppose we have a gaze point at (320,240)
gaze_x = 0;
gaze_y = 0;

% Find points on the circle of the bullseye (360 degrees)
target_x = nan(360,1);
target_y = nan(360,1);
for d = 1:360
    target_x(d,1) = gaze_x + (radius * cosd(d));
    target_y(d,1) = gaze_y + (radius * sind(d));
end

% Pre-allocate error table
error = table;
error.X_Distance_Pixels = nan(360,1);
error.X_Distance_Angle = nan(360,1);
error.Y_Distance_Pixels = nan(360,1);
error.Y_Distance_Angle = nan(360,1);
error.Euclidean_Distance_Angle = nan(360,1);

% Calculate visual angle of each point of the bullseye circle
for d = 1:360
    error.X_Distance_Pixels(d) = gaze_x - target_x(d,1);
    error.Y_Distance_Pixels(d) = gaze_y - target_y(d,1);
    error.X_Distance_Angle(d) = (gaze_x - target_x(d,1)) / scene_vid_deg_x;
    error.Y_Distance_Angle(d) = (gaze_y - target_y(d,1)) / scene_vid_deg_y;
end

% Use the distance formula to calculate the visual angle of x and y error
error.Euclidean_Distance_Angle = ...
    sqrt(error.X_Distance_Angle.^2 + error.Y_Distance_Angle.^2); 
