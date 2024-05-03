function [X_background, X_foreground, video_full, Omega_continuous] = dmd_with_separation(video, T, r, p)
% This function performs background/foreground separation on a video,
% combiing compressed and sliding window techniques. 
% Inputs: 
% 'video': String with the file name of the video
% 'T': Prescribed window width for sliding window DMD 
% 'r': Target rank for rank-reduction procedure
% 'p': Target dimensionality reduction for compressed DMD 
% Outputs: 
% 'X_background': Tensor with the isolated background
% 'X_foeground': Tensor with the isolated foreground
% 'video_full': Tensor of the original video 
% 'Omega_continous': Matrix of the continuous eigenvalues (used in one of
% the figures of the paper) 
%
% Author: Marco Mignacca

v = VideoReader(video);
v_frames = read(v); 
num_frames = v.NumFrames; 
height = v.Height; 
width = v.Width;
dim = height*width;
video_mat = zeros(height*width, num_frames); 

for j = 1:num_frames
    v1 = rgb2gray(v_frames(:,:,:,j)); 
    v1 = reshape(v1, [], 1); 
    video_mat(:,j) = v1;
end


%% Apply Sliding Window DMD 
num_windows = num_frames - T;
x_bg = zeros(dim, num_frames);
GaussSum = zeros(1,num_frames); 
tgrid = 0:num_frames-1;
sig = T / 8; 

% Create random measurement matrix and get the dimension-reduced video
C = randn(p, dim); 
video = C*video_mat;

% Keep track of the eigenvalues in each window 
Omega = zeros(r, num_windows);
Omega_continuous = zeros(r, num_windows);

% Windowed computations
for k = 1:num_windows

    X1 = video_mat(:,k:k+T-1); X2 = video_mat(:,k+1:k+T);
    Y1 = video(:,k:k+T-1); Y2 = video(:,k+1:k+T); 

    [U, S, V] = svd(Y1, 'econ'); 
    Ur = U(:, 1:r); Sr = S(1:r, 1:r); Vr = V(:, 1:r);
    
    Sinv = diag(1./diag(Sr)); 
    Atilde = Ur' * Y2 * Vr * Sinv;
    [eVecs, eVals] = eig(Atilde);
    Phi = X2 * Vr * Sinv * eVecs; 

    lambda = diag(eVals); 
    omega = log(lambda); 
    Omega_continuous(:,k) = omega; 
    Omega(:,k) = abs(omega);
    
    % Prep for foreground/background separation 
    cutoff = 0.01;
    bg = find(abs(omega) < cutoff)';

    % Frequency thresholding
    bg_ev = 1i*imag(log(lambda(bg)));
    Phi_bg = Phi(:,bg);  

    win_mid = (tgrid(k)+tgrid(k+T-1))/2;   

    b_bg = Phi_bg \ X1(:, 1);

    % Formula for reconstructing video with sliding window DMD
    for t = 1:size(b_bg)
        x_bg = x_bg + b_bg(t) .* Phi_bg(:,t) .* exp(-(tgrid - win_mid).^2/sig^2 + bg_ev(t) .* tgrid);  
    end

    GaussSum = GaussSum + exp(-(tgrid'-win_mid).^2/sig^2 )';
    
end

x_bg = x_bg./GaussSum;

% Now we make the result real and positive 
x_fg = video_mat - abs(x_bg);
check_neg = (x_fg < 0);
R = x_fg.*check_neg;
X_background = abs(x_bg);
X_foreground = x_fg - R;

X_background = (reshape(X_background, [height, width, num_frames]));
X_foreground = (reshape(X_foreground, [height, width, num_frames]));
video_full = reshape(video_mat, [height, width, num_frames]); 

end


