function [fig,rmse_gazeCenter,rmse_sceneCenter] = MET_gaze_heatmap(x_coord,y_coord,pupil,x_pixels,y_pixels)

% EYE GAZE HEAT MAP FROM X- AND Y-COORDINATES OF GAZE (MOBILE EYE TRACKING)
%   Written by Drs. Julia Yurkovic-Harding and Samuel M. Harding
%   Updated May 2024 for Fu et al. (2023)
%   Contact info: yurkovicharding@sc.edu, sh138@mailbox.sc.edu

% VARIABLES
%   x_coord: a vector of the x-position in pixels of gaze at each timepoint
%   y_coord: a vector of the y-position in pixels of gaze at each timepoint
%       ** x_coord and y_coord should be the same length!
%   pupil: a vector of 1s (pupil detected) and 0s (pupil not detected)
%   x_pixels: number of pixels on the x dimension of the recorded video
%   y_pixels: number of pixels on the y dimension of the recorded video
%       ** for example, some videos are recorded as 640*480p

% ADDITIONAL NOTES
%   The code uses image space and therefore assumes that (0,0) is the top
%   left corner of the screen          


% -- Set X and Y Boundaries with Buffer for Plotting ----------------------

% Set buffer of pixels and upper bound for x- and y-coordinates
%   We set a buffer here because MET software will occassionally suggest
%   gaze points that are out of the bounds of the recorded scene view
buffer = 50;
x_upbound = x_pixels + buffer*2;
y_upbound = y_pixels + buffer*2;


% -- Make a Kernel for Plotting -------------------------------------------

% Set all variables for the kernel
%   Each gaze coordinate is set at an exact x- and y-coordinate. However,
%   our visual acuity is larger than one exact pixel. Additionally, there
%   can be some error in calculating gaze location.
%   We therefore consider a kernel density around the actual gaze point
%   when creating the heatmaps.

half_kernel = 100/2;
[kernel_x,kernel_y] = ...
    meshgrid(-half_kernel:half_kernel,-half_kernel:half_kernel);
dist_gazeCenter = sqrt(kernel_y.^2 + kernel_x.^2);

% Create the kernel probability
sigma = 10;
kernel = normpdf(dist_gazeCenter,0,sigma);


% -- Clean Gaze Replay Data -----------------------------------------------

% Adjust x_coord and y_coord to account for the buffer
%   Because we're adding a buffer of pixels on all edges of the video, we
%   need to adjust the coordinates to include that buffer
x_coord = x_coord + buffer;
y_coord = y_coord + buffer;

% Set looks above and below buffer threshold to NaN
x_ind = x_coord < 0 | x_coord > x_upbound;
y_ind = y_coord < 0 | y_coord > y_upbound;
x_coord(x_ind) = NaN;
y_coord(x_ind) = NaN;
x_coord(y_ind) = NaN;
y_coord(y_ind) = NaN;
clear x_ind y_ind

% Remove gaze coordinates where pupil was not detected
x_coord(~pupil) = NaN;
y_coord(~pupil) = NaN;

% Create 3d histogram that tracks how many times the x and y
% variables end up in each of the pixels of the image
h = hist3([y_coord,x_coord],{1:y_upbound,1:x_upbound});
h = h./sum(sum(h));
clear gr

% Create the kernel density (aka the heatmap) from the 3d histogram
kerneldensity = convn(h,kernel,'same');
clear h


% -- Create Heatmap Figure ------------------------------------------------

% Open the figure, set some parameters
fig = figure;
fig.Position = [1 1 x_upbound y_upbound];
fig.Color = 'white';

% Plot the heatmap of eye gaze location
imagesc(kerneldensity);
axis equal

% Set axis parameters, get limit of colorbar (x_upbound by y_upbound)
axis([0 x_upbound 0 y_upbound])
axis ij % this sets the axes to image space (y=0 is top left)
ax = gca;
ax.XTick = [];
ax.YTick = [];
ax.FontSize = 18;
ax.FontName = 'Verdana';
clim([0 1e-3])
colormap('jet')
colorbar


% -- Distance of Each Gaze Point to Center of Gaze Points -----------------

% Save only the data points with pupil detected
x_coord_inc = x_coord(~isnan(x_coord));
y_coord_inc = y_coord(~isnan(y_coord));

% Get the mean x and y gaze coordinates --> center of all gaze points
x_center = mean(x_coord_inc);
y_center = mean(y_coord_inc);

% Get the distance of each gaze point to the center of all gaze points
%   a2 + b2 = c2 --> c = sqrt([x_coord - x_center] + [y_coord - y_center])
%   Normalized by maximum possible distance between points
max_dist = sqrt((x_upbound-0).^2 + (y_upbound-0).^2);
dist_gazeCenter = sqrt((x_coord_inc-x_center).^2 + (y_coord_inc-y_center).^2);
dist_gazeCenter = dist_gazeCenter ./ max_dist;

% Calculate the root mean squared error of distance to center of gaze
rmse_gazeCenter = rmse(0,dist_gazeCenter);


% -- Distance of Each Gaze Point to Center of Scene Video -----------------

% Save only the data points with pupil detected
x_coord_inc = x_coord(~isnan(x_coord));
y_coord_inc = y_coord(~isnan(y_coord));

% Get the center point of the scene video
x_center = x_upbound/2;
y_center = y_upbound/2;

% Get the distance of each gaze point to the center of scene video
%   a2 + b2 = c2 --> c = sqrt([x_coord - x_center] + [y_coord - y_center])
%   Normalized by maximum possible distance from center
max_dist = sqrt((x_center-0).^2 + (y_center-0).^2);
dist_screenCenter = sqrt((x_coord_inc-x_center).^2 + (y_coord_inc-y_center).^2);
dist_screenCenter = dist_screenCenter ./ max_dist;

% Calculate the root mean squared error of distance to center of scene vid
rmse_sceneCenter = rmse(0,dist_screenCenter);

end
