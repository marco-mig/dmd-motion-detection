function [Omega] = dmd(T, r, video, C)
% This function performs sliding window DMD on a given video incorporating
% the rank reduction procedure and compressed DMD.
% 'T' is the prescribed window width, 'r' is the target rank of the
% rank-reduction step, 'C' is the measurement matrix,
% and 'video' is a string containing the name of the video file. 
% This function returns a matrix 'Omega' with the moduli of the eigenvalues
% correspoding to each window in its columns. 
%
% Author: Marco Mignacca

vid = VideoReader(video); 
vid_frames = read(vid); 
num_frames = vid.NumFrames;
height = vid.Height; 
width = vid.Width;
video_mat = zeros(height*width, num_frames); 

% Transform the RGB video into a greyscale matrix 
for j = 1:num_frames
    v1 = rgb2gray(vid_frames(:,:,:,j)); 
    v1 = reshape(v1, [], 1); 
    video_mat(:,j) = v1;
end

% Apply Sliding Window DMD  
num_windows = num_frames - T;
Video_comp = C*video_mat;  % Compressed video matrix
Omega = zeros(r, num_windows);

% Windowed computations
for k = 1:num_windows
    Y1 = Video_comp(:,k:k+T-1);
    Y2 = Video_comp(:,k+1:k+T); 

    [U, S, V] = svd(Y1, 'econ'); 
    Ur = U(:,1:r); Sr = S(1:r,1:r); Vr = V(:,1:r);

    Atilde = Ur' * Y2 * Vr * diag(1./diag(Sr));
    [~, eVals] = eig(Atilde);

    lambda = diag(eVals); 
    omega = log(lambda);  
    Omega(:,k) = abs(omega);  

end
