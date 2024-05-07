% -------------------------------------------------------------------------
% This code was used to generate the matrices of eigenvalues 'OmegaX.txt'
% based on the videos labelled 'vid_X.mp4' in the filmed database. This 
% code can be modified to be used with your own database. 
%
% The code saves the matrices 'OmegaX.txt' in the same directory as the
% code. 
%
% Author: Marco Mignacca
% -------------------------------------------------------------------------

num_vids = 20; 
T = 80;
r = 5;
p = 20;

for i=1:num_vids
    video = strcat('vid_', num2str(i), '.mp4'); 
    Omega = dmd(T, r, p, video); 
    writematrix(Omega, strcat('Omega', num2str(i), '.txt'))
end


