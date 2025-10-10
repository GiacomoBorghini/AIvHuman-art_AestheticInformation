
Measuring Aesthetic Information in AI-Generated Artistic Images

To run the code without modifying any variable is sufficient to create a folder called "ImageDatabase" containing two sub-folders called "Human" (where human paintings should be saved) and "AI" (where AI paintings should be saved) in the same Matlab workspace where the scripts are placed. Since this is a code designed to produce a comparison between the values of metrics obtained from couples of images (each composed of an AI and a Human painting) it's mandatory to rename the images with numerical labels (1,2,3...). Images with same label will be analyzed as a couple. The code can be used as you prefer, but it is designed to compare metrics obatined from images which are somehow related (e.g. they have same subject and artistic style).

Global Aesthetics Measures

The main code to run to get the results is contained in Global_Aesthetics_general.m . This is main function and provides the graphics of the comparison, between AI and human paintings, of the M_H and M_K metrics. To run this code is necessary to have in the same folder where the main script is saved the following functions:

resize_save.m
M_H_K_Calculation.m
natsort.m
natsortfiles.m
The last two scripts has been taken from the File Exchange section of Matlab website (link: https://it.mathworks.com/matlabcentral/fileexchange/47434-natural-order-filename-sort).

Compositional Aesthetics Measures

The main code to run to get the results is contained in Compositional_Aesthetics_general.m. This is the main function and provides the graphics of the comparison, between AI and human paintings, of the M_J and M_NCD metrics. To run this code is necessary to have in the same folder where tha main script is placed the following functions:

resize_save.m
M_NCD_Calculation.m
M_J_Calculation.m
natsort.m
natsortfiles.m

The last two scripts has been taken from the File Exchange section of Matlab website (link: https://it.mathworks.com/matlabcentral/fileexchange/47434-natural-order-filename-sort).

Mutual-Information-based Partitioning
The main code to get results is contained in Mutual_Information_Partitionig_L.m. This is the main function and provides the graphis of the comparison, betweem AI and human paintings, of the result obtained by applying the Mutual-Information-based Partitiong algorithm. To run this code is necessary to have in the same folder where tha main script is placed the following functions:

PartitionAlg_L.m
horzPartitionL.m
vertPartitionL.m
natsort.m
natsortfiles.m
