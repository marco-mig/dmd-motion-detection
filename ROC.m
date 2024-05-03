function [FPR, TPR] = ROC(Omega, delta_star, frames, event_tol)
% This function performs the eigenvalue detection scheme by checking if the
% relative change in eigenvalue average between consecutive windows exceeds
% a prescribed threshold 'delta_star'. The matrix 'Omega' contains the 
% moduli of the eigenvalues in each window. 
% Then, it uses this information to return the false positive rate (FPR)
% and true positive rate (TPR) given the vector 'frames' which includes the
% frame numbers of the true events, and 'event_tol' which gives the
% tolerance in each direction for event detection. 
%
% Author: Marco Mignacca

num_windows = size(Omega, 2);
Detect = zeros(1, num_windows);

% First we experimentally find where the events are in the video 
Average = mean(Omega); 
for k = 2:num_windows
    delta = abs((Average(k) - Average(k-1))/Average(k-1));
    if (delta > delta_star)
        Detect(k) = 1;
    end
end
 
% Then we obtain the false negatives and true positives 
fn = 0;  % false negatives
tp = 0;  % true positives
for i = frames
    slice = Detect(i-event_tol:i+event_tol);  % Checking += event_tol frames
    if sum(slice==1) == 0  % If an event is detected, this sum is at least 1
        fn = fn + 1;
    else
        tp = tp + 1;
    end
    
end

% Use this to get the false positives and true negatives
fp = sum(Detect) - tp;
tn = (num_windows-1) - fp - fn - tp;

FPR = fp / (fp + tn); 
TPR = tp / (tp + fn);

end

