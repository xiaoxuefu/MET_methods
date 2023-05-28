# MET_methods
**Manuscript:** Implementing Mobile Eye tracking in Psychological Research: A Practical Guide

**Authors:** Xiaoxue Fu, John M. Franchak, Leigha A. MacNeill, Kelley E. Gunther, Jeremy I. Borjon, Julia Yurkovic-Harding, Samuel Harding, Jessica Bradshaw, Koraly E. Pérez-Edgar

## Descriptions:

***Mobile eye tracking (MET)***, or head-mounted eye tracking, is a tool for recording participant-perspective gaze in the context of active behavior. Recent technological developments in MET hardware enable researchers to capture egocentric vision as early as infancy and across the lifespan. However, challenges remain in MET data collection, processing, and analysis. The paper and the assoicated repository aims to provide a practical guide and computer programs that facilitate the use of MET in psychological research. 

**Code Contributors:** John M. Franchak, Xiaoxue Fu, Kelley E. Gunther, Samuel Harding, Julia Yurkovic-Harding

**We provide programs for:** 

* **Inspecting Accuracy** (Manuscript Sction 4.1): A MATLAB tool for annotating and calculating the spatial offset (in degree of visual angle) between the point of gaze and the target location that the participant is directed to look at during validation procedure. 
* **Inspecting Precision** (Section 4.2): A MATLAB tool for visualizing and estimating the patial distribution of gaze coordinates. 
* **Estimating Error Tolerance** (Section 5): A MATLAB tool for calculating the size of a bullseye (in degree of visual angle) used for manual annotation of the are of interest (AOI). A visual aid (e.g., a bullseye) is often used for determining the AOI that the participant is look at in manual annotation. This tool help researchers to determine the appropriate sizes of the circles based on the participants' gaze data accuracy.  
* **Visualization of Gaze Events**: Examples for implementing *timevp* (A MATLAB toolkit) and *GridWare* (A JAVA program) for data visualization. 
* **Growth Curve Modeling and Visualization**: An R Markdown for fitting growth curve models using the gaze event data and visualizing the results. 

## Tools / Programs Implemented:

[Eye Tracking Accuracy Calculator](https://john-franchak.shinyapps.io/Eye-Tracking-Accuracy-Calculator/): An R shiny app for marking points of gaze and locations of the calibration targets in video frames and use the inputs to estimate the spatial offset in degrees for a participant's calibration

[timevp](https://github.com/xiaoxuefu/timevp): A MATLAB toolkit for processing and visualizing time series data 

[GridWare](https://www.queensu.ca/psychology/adolescent-dynamics-lab/state-space-grids): A JAVA applicatoin that generates State Space Grids for visualizing dyadic data

## Example Data Information:

The example data provided are collected from the iTRAC and ACTION studies. In the iTRAC study (R21 grant MH111980 to Pérez-Edgar), 5- to 7-year-old children completed several laboratory episodes involving active social interactions with adults and same-age peers. We oversampled for children with high behavioral inhibition, a fearful temperament type that serves as a reliable risk factor for anxiety problems. A key aim of the study was to identify altered ambulatory attention patterns that are associated with high risk for anxiety problems. 

The ACTION study (James S. Mcdonnell Foundation grant to Bradshaw) examines 4- and 8-month-old infants' looking behavior during free plays with their caregivers at homes. The study oversamples siblings of children with a diagnosis of autism spectrum disorder (ASD). The ongoing study aims to investigate altered attention-motor coordination patterns that are linked to early-emerging elevated risk for ASD and social communicative problems. 

## Additional MET Resources:

[ICIS Head-Mounted Eye Tracking Workshop 2022](https://github.com/ICIS-HMET-Workshop/workshop_materials_2022): A tutorial on using head-mounted eye tracking in infant research. It also provide links to additional MET data processing and visualization tools. 

