# Real-Time Motion Detection Using Dynamic Mode Decomposition 

This GitHub repository includes all of the necessary files and scripts in order to generate the figures in the paper 'Real-Time Motion Detection Using Dynamic Mode Decomposition' by Marco Mignacca, Simone Brugiapaglia and Jason Bramburger. 

# Matlab Information 

No external packages are required to run the codes. Codes were written in Matlab version R2023a - Academic Use. 

# Layout of Repository 

The file 'generating_omegas.m' is a code that can be modified to generate the matrices of eigenvalues required for the modified k-fold cross-validation and ROC curve demonstrations. 
The files beginning with 'figures' are scripts that generate the figures in the paper.
The remaining files are functions called to generate the figures in the paper. 

The 'Omegas' folder contains the matrices of eigenvalues for each of the 20 videos in the database stored in txt files. These must be relocated to be in the same folder as the codes prior to use. 

The 'Videos' folder contains the resized gate video from the Background Models Challenge database (http://backgroundmodelschallenge.eu) which must be relocated to the same folder as the codes prior to use. 

The file 'MW_Optimizing_Threshold.m' performs the threshold optimization procedure on six test videos in the Microsoft Wallflower database https://www.microsoft.com/en-us/download/details.aspx?id=54651. The matrices of eigenvalues are pre-calculated and can be found in the 'Microsoft_Wallflower_Omegas' folder. They must also be relocated in to the same folder as the .m file. 
