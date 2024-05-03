% -------------------------------------------------------------------------
% This code plots the mean receiver operating characteristic (ROC) curve, 
% corresponding to Figure 7 in the paper. This is done in order to assess 
% the performance of classifying frames as positive (foreground action)
% versus negative (no foreground action). 
%
% Author: Marco Mignacca
% -------------------------------------------------------------------------

clear;
close all;
clc;

T = 80;  
event_tol = 15;  % Tolerance in event detection (+- 15 frames) 
num_vids = 20; 

% We list the frame numbers corresponding to each video. 
frames{1} = [756-T, 921];
frames{2} =  [366-T, 648];
frames{3} = [333-T, 786, 1086-T, 1494];
frames{4} = [660-T, 966, 1365-T, 1638];
frames{5} = [393-T, 444];
frames{6} = [351-T, 567, 987];
frames{7} = [477-T, 594, 621];
frames{8} = [426-T, 762];
frames{9} = [543-T, 657];
frames{10} = [354-T, 876, 1590, 1617-T, 1728, 2067];
frames{11} = [423-T, 669, 1017-T, 1290, 1545-T, 1620];
frames{12} = [759-T, 948-T, 1413-T, 1836-T, 1917, 2175, 2346, 2469];
frames{13} = [456-T, 720-T, 1269-T, 1335];
frames{14} = [327-T, 534, 987-T, 1131, 1479-T, 1572, 1617-T, 1707 ];
frames{15} = [1269, 1296, 1299, 1656-T, 1794, 2280-T, 2340];
frames{16} = [180-T, 984-T, 1059, 1089, 1572-T, 1722];
frames{17} = [312-T, 573-T, 888-T, 1332, 1671, 1728];
frames{18} = [132-T, 630-T, 687, 1107, 1668-T, 1725, 2052-T, 2109, 2403-T, 2559, 3126-T];
frames{19} = [732-T, 1407-T, 1500, 1941];
frames{20} = [738-T, 822-T, 981, 1002, 1287-T, 1560];

% Import the matrices
for i=1:num_vids
    string = strcat('Omega', num2str(i), '.txt');
    Omega{i} = readmatrix(string);
end

% Thresholds we test over 
vals = 10.^(-10:0.01:10);

% Initialize matrices where TPR and FPR will be stored 
TPR = zeros(num_vids, length(vals)); 
FPR = zeros(num_vids, length(vals)); 

for i=1:num_vids
    iter = 1;
    for threshold = vals
        [FPR(i,iter), TPR(i,iter)] = ROC(Omega{i}, threshold, frames{i}, event_tol);
        iter = iter + 1;
    end
end

AUC = abs(trapz(mean(FPR), mean(TPR)));
disp(strcat('AUC:  ', num2str(AUC)))

figure
plot(mean(FPR), mean(TPR), 'LineWidth', 2)
xlim([0 1])
xlabel('False Positive Rate (FPR)')
ylabel('True Positive Rate (TPR)')
axis square
set(gca, 'fontsize', 16)



