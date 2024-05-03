function [error] = error_score(Detect, events, c, d_star)
% This function returns the error score corresponding to a particular
% threshold value used on a particular video. It takes as input:
% 'Detect': a vector outputted from the function eigen_detect
% 'events': a vector containing the indices of the windows in which events
% are taking place
% 'c': a parameter corresdponding to the weight for false negatives
% 'd_star': a parameter corresponding to the tolerance in time in 
% detecting events.  
% This function is used inside 'cross_validation.m'
% 
% Author: Marco Mignacca

false_neg = 0;
false_pos = 0; 

for i = 1:length(events)
    win = events(i);
    indices = win-d_star:win+d_star;  % Indices within the tolerance
    instances = indices(Detect(indices)==1);  % Check if we detect
    if isempty(instances)  % No event detected: false negative
        false_neg = false_neg + 1;  
    elseif length(instances)>=2  % Too many detected: false positive
        false_pos = false_pos + length(instances) - 1; 
        Detect(instances) = 0;
    else  % Exactly one detected: true positive
        Detect(instances) = 0;  
    end
end

% Adding extra detections beyond 'events' to false positives
false_pos = false_pos + length(find(Detect==1));  

error = false_pos + c*false_neg;  % Error score 
end
