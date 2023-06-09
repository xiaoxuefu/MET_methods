# Accuracy

**Compute the spatial offset (in degree of visual angle) between the point of gaze (POG) and the validation target that the participant is directed to look at:**

Run *get_error*: It calls *calibrationAccuracyCodingTool*, which provides a GUI for the user to annotate the target location and POG for each selected frame. The outputs are then used to calcuate the spatial offset for each frame coded. The mean spatial offset will be displayed.

The user needs to specify the MET headset scene camera specs that are provided by the manufacturer. 
