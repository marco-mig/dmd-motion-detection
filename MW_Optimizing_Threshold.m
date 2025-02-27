% -------------------------------------------------------------------------
% This code plots optimizes the threshold parameter for the videos in the
% Microsoft Wallflower database. It calculates the optimal value for each
% video and the corresponding error score. 
%
% Author: Marco Mignacca
% -------------------------------------------------------------------------

clear all;
close all;
clc

% Parameters
num_vids = 6;  % We do not perform test on Bootstrap video
T = 80; 
r = 5;
p = 20; 
P = 0.001:0.001:1; 
c = 100; 
d_star = 30;  % Leeway in time in detecting events (30 frames)

% Creating matrix of events to be detected for each video (each row
% corresponds to a video, and a 1 indicates an event)
events_MW = zeros(5000,num_vids);

% Camouflage (353)
events_MW(241-T, 1) = 1; 

% ForegroundAperture (2113) 
events_MW(505,2) = 1; events_MW(919-T,2) = 1; events_MW(1509, 2) = 1;

% LightSwitch (2714) 
events_MW(796-T,3) = 1; events_MW(829,3) = 1; events_MW(1844-T,3) = 1; events_MW(2202,3) = 1;

% MovedObject (1744) 
events_MW(637-T,4) = 1; events_MW(891,4) = 1; events_MW(1389-T,4) = 1; events_MW(1502,4) = 1;

% TimeOfDay (5889) 
events_MW(1831-T,5) = 1; events_MW(1918,5) = 1; events_MW(3072-T,5) = 1; events_MW(3244,5) = 1; 
events_MW(4739-T,5) = 1; events_MW(4933,5) = 1; 

% WavingTrees (286)
events_MW(242-T,6) = 1; 

% Loading in generated matrices, calcilated using the 'dmd.m' function.
Omega_MW{1} = readmatrix('Omega_MW1.txt');  % Camouflage
Omega_MW{2} = readmatrix('Omega_MW2.txt');  % ForegroundAperture
Omega_MW{3} = readmatrix('Omega_MW3.txt');  % LightSwitch
Omega_MW{4} = readmatrix('Omega_MW4.txt');  % MovedObject
Omega_MW{5} = readmatrix('Omega_MW5.txt');  % TimeOfDay
Omega_MW{6} = readmatrix('Omega_MW6.txt');  % WavingTrees

% Optimizing the threshold
optimal_params = zeros(2, num_vids);  % Storing optimized parameters
error = zeros(num_vids, length(P)); 
for i=1:num_vids
    Detects = {}; 
    omega = Omega_MW{i};
    key_frames = find(events_MW(:,i)==1);  % Extracting frames of key events
    for j=1:length(P)
        Detect = eigen_detect(omega, P(j));
        error(i,j) = error_score(Detect, key_frames, c, d_star);
        Detects{j} = Detect;  % Storing the detection vectors for each 
    end
    [err, idx] = min(error(i,:));
    optimal_params(:,i) = [err; P(idx)]; 
    detected_windows{i} = find(Detects{idx}==1);  % Extracting which events the algo detects
end

% Showing the results (top row: error, bottom row: optimal threshold)
disp(optimal_params)

%% Plotting results for video 4 (MovedObject)

% Plotting error curve
figure(1)
plot(P, error(4,:))
xlabel('Threshold value')
ylabel('Error score')

% Plotting result for video 4 (MovedObject)
actual_frames = find(events_MW(:,4)==1);
temp = detected_windows{4};
omega = Omega_MW{4}; 
detections = -1*ones(1, size(omega,2));
omega_mean = mean(omega); 
detections(temp) = omega_mean(temp);

figure(2)
plot(1:size(omega,2), mean(omega), '-')
hold on
plot(1:size(omega,2), detections, '*', 'linewidth',2)
ylim([0 max(mean(omega))+0.5])
xlabel('Window number')
ylabel('Eigenvalue modulus')


