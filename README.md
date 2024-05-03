# Real-Time Video Surveillance Using Dynamic Mode Decomposition 

This GitHub repository includes all of the necessary files and scripts in order to generate the figures in the paper 'Real-Time Video Surveillance Using Dynamic Mode Decomposition' by Marco Mignacca, Simone Brugiapaglia and Jason Bramburger. 

# Required Matlab Packages 

No external packages are required to run the codes. Codes were written in Matlab version R2023a - Academic Use. 

# Layout of Repository 

The first 6 files alongside this document are functions written in Matlab needed to generate the figures in the paper. The files beginning with 'figures' are scripts that use the functions to generate the figures. 

The 'Omegas' folder contains the matrices of eigenvalues for each of the 20 videos in the database stored in txt files. These must be relocated to be in the same folder as the codes prior to use. 

The 'Videos' folder contains the resized gate video from the Background Models Challenge database (http://backgroundmodelschallenge.eu) which must be relocated to the same folder as the codes prior to use. 
