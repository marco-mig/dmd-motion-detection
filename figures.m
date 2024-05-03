% -------------------------------------------------------------------------
% This program generates various figures in the paper. The corresponding
% labels in the paper are given, in order of appearance in this program. 
% 
% Figures 1-3: Corresponds to Figure 1 in the paper
% Plot the background, foreground, and original video frame in the gate
% video. We use a scaled-down and greyscaled version of video 4 in the
% bmc_real dataset from backgroundmodelschallenge.eu and we plot the 100th
% frame in each video. 
%
% Figure 4: Corresponds to Figure 3 in the paper
% Plot of the continuous eigenvalues using the same video as above in the 
% 100th window. 
%
% Figure 5: Corresponds to part of Figure 2 in the paper
% Plot of the moduli of the eigenvalues in each window after performing DMD 
% on video 3 in the database.
% 
% Figure 6: Corresponds to part of Figure 6 in the paper 
% Plot of the mean of the moduli of the eigenvalues in each window after 
% perfoming DMD on video 3 in the database.
%
% Author: Marco Mignacca
% -------------------------------------------------------------------------


clear;
close all;
clc;

video = 'gate_low.mp4';  
T = 100;
% r = 5;  % For background/foreground separation
r = 20;  % For plotting purposes
p = 20; 
[X_background, X_foreground, video_full, Omega_continuous] = dmd_with_separation(video, T, r, p); 

figure(1)
imshow(uint8(X_foreground(:,:,100)), "InitialMagnification", 400)

figure(2)
imshow(uint8(X_background(:,:,100)), "InitialMagnification", 400)

figure(3)
imshow(uint8(video_full(:,:,100)), "InitialMagnification", 400)


figure(4)
eigenvals = sort(Omega_continuous(:,100));  
plot(eigenvals, 'r*', 'linewidth', 4)  % Background eigenvalue
hold on
plot(eigenvals(2:end), 'b*', 'linewidth', 4)  % Foreground eigenvalues
grid on
xlabel('Real Part')
ylabel('Imaginary Part')
set(gca,'Fontsize',16)


Omega = readmatrix('Omega3.txt');

figure(5)
axis tight
plot(1:size(Omega,2), Omega, '*')
xlim([0, size(Omega,2)])
xlabel('Window Number')
ylabel('Eigenvalue Modulus')


figure(6)
axis tight
plot(1:size(Omega,2), mean(Omega), '-','linewidth',1.5)
xlim([0, size(Omega,2)])
ylim([0, max(mean(Omega))])
xlabel('Window Number')
ylabel('Eigenvalue Average')



