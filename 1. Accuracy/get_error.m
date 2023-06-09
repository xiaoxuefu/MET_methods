%% Calculate Accuracy of MET data: Spatial offset in degree angle
function get_error (fov_x, fov_y, fov_res_x, fov_res_y)

%INPUT VALUES TO MATCH FOV AND RESOLUTION OF YOUR MET system
%fov_x = SCENE CAMERA DEGREES X
%fov_y = SCENE CAMERA DEGREES Y
%fov_res_x = SCENE CAMERA PIXELS X
%fov_res_y = SCENE CAMERA PIXELS Y

%For PUPIL Core (current example):
%fov_x = 82.1; 
%fov_y = 52.2; 
%fov_res_x = 1280; 
%fov_res_y = 720; 

%Set up input and ouput directory and file name
directory=pwd;
[file_name, currentDir] = uigetfile('*.m', ...
    'Please select the directory for calibrationAccuracyCodingTool', pwd);

dir_save = [currentDir 'outputs' filesep];
if exist(dir_save, 'dir') ~= 7
    mkdir(dir_save)
end
outputFileName = 'errorOutput.txt';

%Mark target and gaze location
calOutput = calibrationAccuracyCodingTool;

%Calculate error degree and write information to file
fileID=fopen(strcat(dir_save, outputFileName),'at');
fprintf(fileID, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n', 'frameRate', 'frameCoded', ...
    'gazeX', 'gazeY', 'targetX', 'targetY', 'error_degree');

to_degreesx = fov_res_x/fov_x;
to_degreesy = fov_res_y/fov_y;

gazex = calOutput.click{1,2}(:,1); gazex=(gazex(~isnan(gazex)));
gazey = calOutput.click{1,2}(:,2); gazey=(gazey(~isnan(gazey)));

targetx = calOutput.click{1,1}(:,1); targetx=(targetx(~isnan(targetx)));
targety = calOutput.click{1,1}(:,2); targety=(targety(~isnan(targety)));

distx = abs(gazex - targetx) ./ to_degreesx;
disty = abs(gazey - targety) ./ to_degreesy;
dist_center = sqrt(distx.^2 + disty.^2); %Use the distance formula to calculate average of XY errors

frameRate = repmat(calOutput.frameRate, length(dist_center), 1);
frameCoded = repmat(calOutput.numberCoded, length(dist_center), 1);

disp(['Writing ouputs: ' outputFileName])

for i=1:length(dist_center)
      fprintf(fileID,'%.0f\t%.0f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t\n', frameRate(i,:), frameCoded(i,:), ...
          gazex(i,:), gazey(i,:), targetx(i,:), targety(i,:), dist_center(i,:)); 
end

fclose(fileID);

%Display mean error degree
fprintf('The mean error is %4.2f%c \n',mean(dist_center),char(176));

end