function [Detect] = eigen_detect(Omega, delta_star)
% This function performs the eigenvalue detection scheme by checking if the
% relative change in eigenvalue average between consecutive windows exceeds
% a prescribed threshold 'delta_star'. The matrix 'Omega' contains the 
% moduli of the eigenvalues in each window.
% This function returns a vector 'Detect' with ones in the indices
% corresponding to detected events, and zeroes everywhere else. 
%
% Author: Marco Mignacca

num_windows = size(Omega, 2);
Detect = zeros(1, num_windows);

% We check if the relative average has increased above the threshold, and
% that another event has not been detected in the last 5 frames to avoid
% consecutive activations. 
Average = mean(Omega); 
for k = 6:num_windows
    delta = abs((Average(k) - Average(k-1))/Average(k-1));
    if (delta > delta_star) && isempty(find(Detect(k-5:k-1),1))
        Detect(k) = 1;
    end
end

end