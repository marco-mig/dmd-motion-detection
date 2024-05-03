function [optimal_deltas, avg_validation_error, avg_training_error] = cross_validation(windows, num_vids, delta_vals, k, c, dist_star) 
% This function performs pseudo-k-fold cross-validation on a set of videos
% whose eigenvalue matrices 'Omega' were calculated using the function dmd
% and are stored in txt files of the form 'OmegaX.txt' where X is the video
% number. 
% Returns a vector containing 'optimal_deltas' contaning the k optimal
% threshold values for each iteration, and their corresponding average
% error on the validation set in the vector 'avg_validation_error'. It also
% returns a matrix with k rows which gives the average error for each
% threshold value applied to the videos in each of the k training sets. 
% The inputs are: 
% 'frames': a matrix of zeros whose ith column contains ones at the
%          indices corresponding to the earliest window in which motion
%          could be detected in the ith video 
% 'num_vids': the number of videos in the dataset
% 'delta_vals': a vector containing the threshold values to test over 
% 'k': the number of folds 
% 'c': the weight for false negatives 
% 'dist_star': the leeway in detecting events 
% 
% Author: Marco Mignacca

indices = randperm(num_vids);
num_per_fold = num_vids/k;  % Number of videos per fold

optimal_deltas = zeros(1,k);  % Storing optimal thresholds 
avg_training_error = zeros(k,length(delta_vals));  % Storing avg training error
avg_validation_error = zeros(1, k);  % Storing avg validation error

% Performing pseudo k-fold cross-validation
for j = 1:k

    training_error = zeros(num_vids - (num_vids/k), length(delta_vals));  % Matrix containing error vectors of training set

    val_ind = (num_per_fold)*j-(num_per_fold-1):1:num_per_fold*j;  
    val_ind = indices(val_ind);  % Indices of validation set

    train_ind = setdiff(1:num_vids, val_ind);  
    train_ind = indices(train_ind);  % Indices of training set
    
    for m = 1:num_vids - (num_vids/k)  % Ranging over the number of videos in each training set
        
        index = train_ind(m);  % Index of our video in the training set
        string = strcat('Omega', num2str(index), '.txt');
        Omega = readmatrix(string);
        
        % Calculate the error vector
        iter = 1;
        error_vec = zeros(length(delta_vals),1); 
        key_frames = find(windows(:,index)==1);
        for threshold = delta_vals
            Detect = eigen_detect(Omega, threshold); 
            error_vec(iter) = error_score(Detect, key_frames, c, dist_star);
            iter = iter + 1;
        end

        training_error(m,:) = error_vec;  % List where we store each of the error vectors

    end

    % Calculate the optimal threshold based on the training set videos 

    avg_training_error(j,:) = mean(training_error);  % Average error vector 
    [~, temp] = min(avg_training_error(j,:));
    optimal_deltas(j) = delta_vals(temp);  % Threshold value producing minimum error

    % With this optimal value of delta, we test it on the validation set 

    val_err = zeros(1, num_per_fold);  % Vector containing error of each vid in validation set

    for m = 1:num_per_fold  % Ranging over the number of videos in each training set
        
        index = val_ind(m);  % Index of our video in the training set
        string = strcat('Omega', num2str(index), '.txt');
        Omega = readmatrix(string);

        key_frames = find(windows(:,index)==1);
        Detect = eigen_detect(Omega, optimal_deltas(j));
        [val_err(m)] = error_score(Detect, key_frames, c, dist_star);

    end

    % Calculate average error of videos in validation set 

    avg_validation_error(j) = mean(val_err); 

end 

end 