% -------------------------------------------------------------------------
% This program generates modified k-fold cross validation figure (i.e.,
% Figure 8) in the paper. 
% Uses the function 'cross_validation.m' which notably requires the
% matrices of the moduli of continuous eigenvalues generated from 'dmd.m'
% By default, the 20 matrices labelled 'OmegaX.txt' generated from the
% sample video database are used.
%
% Author: Marco Mignacca 
% -------------------------------------------------------------------------

clear;
close all;
clc; 

% Parameters 
num_vids = 20;  
T = 80; 
r = 5;
p = 20; 
P = 0.001:0.001:1; 
k = 4; 
c = 100; 
d_star = 30; 
dim = 426*240; 


% Constructing matrix with the frame numbers of the actual events 
frames = zeros(3500,num_vids);
frames(756-T, 1) = 1; frames(921, 1) = 1; 
frames(366-T, 2) = 1; frames(648, 2) = 1; 
frames(333-T, 3) = 1; frames(786, 3) = 1; frames(1086-T,3) = 1;  frames(1494, 3) = 1; 
frames(660-T, 4) = 1; frames(966, 4) = 1; frames(1365-T, 4) = 1; frames(1638, 4) = 1; 
frames(393-T, 5) = 1; frames(444, 5) = 1; 
frames(351-T, 6) = 1; frames(567, 6) = 1; frames(987, 6) = 1; 
frames(477-T, 7) = 1; frames(594, 7) = 1; frames(621, 7) = 1; 
frames(426-T, 8) = 1; frames(762, 8) = 1; 
frames(543-T, 9) = 1; frames(657, 9) = 1; 
frames(354-T, 10) = 1; frames(876, 10) = 1; frames(1590, 10) = 1; frames(1617-T, 10) = 1; frames(1728, 10) = 1; frames(2067, 10) = 1; 
frames(423-T, 11) = 1; frames(669, 11) = 1; frames(1017-T, 11) = 1; frames(1290, 11) = 1; frames(1545-T, 11) = 1; frames(1620, 11) = 1; 
frames(759-T, 12) = 1; frames(948-T, 12) = 1; frames(1413-T, 12) = 1; frames(1836-T, 12) = 1; frames(1917, 12) = 1; frames(2175, 12) = 1; frames(2346, 12) = 1; frames(2469, 12) = 1; 
frames(456-T, 13) = 1; frames(720-T, 13) = 1; frames(1269-T, 13) = 1; frames(1335, 13) = 1; 
frames(327-T, 14) = 1; frames(534, 14) = 1; frames(987-T, 14) = 1; frames(1131, 14) = 1; frames(1479-T, 14) = 1; frames(1572, 14) = 1; frames(1617-T, 14) = 1; frames(1707, 14) = 1;  
frames(1269, 15) = 1; frames(1296, 15) = 1; frames(1299, 15) = 1; frames(1656-T, 15) = 1; frames(1794, 15) = 1; frames(2280-T, 15) = 1; frames(2340, 15) = 1; 
frames(180-T, 16) = 1; frames(984-T, 16) = 1; frames(1059, 16) = 1; frames(1089, 16) = 1; frames(1572-T, 16) = 1; frames(1722, 16) = 1; 
frames(312-T, 17) = 1; frames(573-T, 17) = 1; frames(888-T, 17) = 1; frames(1332, 17) = 1; frames(1671, 17) = 1; frames(1728, 17) = 1;
frames(132-T, 18) = 1; frames(630-T, 18) = 1; frames(687, 18) = 1; frames(1107, 18) = 1; frames(1668-T, 18) = 1; frames(1725, 18) = 1; frames(2052-T, 18) = 1; frames(2109, 18) = 1; frames(2403-T, 18) = 1; frames(2559, 18) = 1; frames(3126-T, 18) = 1; 
frames(732-T, 19) = 1; frames(1407-T, 19) = 1; frames(1500, 19) = 1; frames(1941, 19) = 1; 
frames(738-T, 20) = 1; frames(822-T, 20) = 1; frames(981, 20) = 1; frames(1002, 20) = 1; frames(1287-T, 20) = 1; frames(1560, 20) = 1; 


% Performing the modified k-fold cross-validation
[optimal_deltas, avg_validation_error, avg_training_error] = cross_validation(frames, num_vids, P, k, c, d_star);
disp(['Optimal Thresholds: ', num2str(optimal_deltas)])
disp(['Average Errors: ', num2str(avg_validation_error)])


% Plotting the error curve
figure(1) 
plot(P, mean(avg_training_error), 'linewidth', 2)
[a,b] = min(mean(avg_training_error));
hold on 
scatter(P(b),a, 100,'filled')
xlabel('Threshold Values')
ylabel('Error')
xlim([0,1])
ylim([0, max(mean(avg_training_error))+10])
set(gca, 'fontsize', 16)



