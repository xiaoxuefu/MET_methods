# Precision

MET_sample2sample_rmse.m calcuates the root mean squared error (RMSE) of sample-to-sample deviation when a participant is assumed to fixate at the same location. The example input data provided were taken from calibration sessions where the infants were directed to look at an calibration object. 

Example data can be read in by using: data = readtable('sampledata1.csv');

Additional user-input parameters:
* Scene camera field of view (FOV) in degrees and scene camera resolutions in pixels. Those parameters are provided by the eye tracker manufacturer. 
* Calibration (target) object diameter in inches
* The distance between the participant and the calibration (target) object in inches

