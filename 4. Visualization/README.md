# Visualization

## Figure 4

We coded the child’s looking behavior and the mother’s parenting behavior during the parent-child challenge task. Detailed information about the task, eye tracking, and behavior coding are provided in [MacNeill, Fu, Buss, and Pérez-Edgar (2022)](https://www.cambridge.org/core/journals/development-and-psychopathology/article/abs/do-you-see-what-i-mean-using-mobile-eye-tracking-to-capture-parentchild-dynamics-in-the-context-of-anxiety-risk/32732C037360DCAE1879786204BC0C82). Onset and offset times are in milliseconds. 

### Figure 4a

* Requires the *timevp* toolkit
* Input data (PC_MET_input.csv, PC_BEH_input.csv) were exported from Datavyu. PC_MET_input.csv contains onset times, offset times, and area of interest (AOI) categories. PC_BEH_input.csv contains onset times, offset times, and parenting behavior categories. All categorical data were recoded based on timevp colormap.

### Figure 4b

* Requires *GridWare 1.15a*
* We aligned the onset and offset times for looking behavior and parenting behavior using Datavyu functions.
* Please refer to GridWare Manual for instructions on preparing input data (fig4_trjs/PC_METandBEHgrid.txt, fig4.gwf).
* Input variable definition in GridWare:

<img width="404" alt="GridWare define variables" src="https://github.com/xiaoxuefu/MET_methods/assets/13022157/a2126b66-6cd0-4486-84d5-1cde6a9eb769">

* The GridWare Manual provides instructions for obtaining the State and Space Grid and related measures.

## Figure 5

* Requires the *timevp* toolkit
* We coded the onset, offset, and AOIs of infant looking, parent looking, infant manual manipulation of toys, and parent manual manipulation of toys.
* Input data (in the “cleanedData” folder) were exported from Datavyu. AOI categories were recoded based on the *timevp* colormap.
* First, MET_fig5_extractPairs.m is run to extract pairs of events according to user-defined temporal relations.
* Next, MET_fig5_visualizaeStreams.m uses the paired data for visualization.
* Also see [Yu and Smith (2017)](https://srcd.onlinelibrary.wiley.com/doi/full/10.1111/cdev.12730?casa_token=zsalP2ZSyFsAAAAA%3Am6aVB-b62G171qHMkM2VCVI_cPtj9xGdfrCzCfG2bs8CNAKfGetNoUohMQOY9VfMUljJmER_P6_fCnw) Figure 3.
