function [ F ] = eightpoint( pts1, pts2, M )
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save F, M, pts1, pts2 to q2_1.mat

%     Write F and display the output of displayEpipolarF in your writeup

% [imwidth, imheight]=M;
NormMat=[2/M(1) 0 -1; 0 2/M(2) -1; 0 0 1];
homoIm1=[pts1';ones(size(pts1,1),1)'];
homoIm2=[pts2';ones(size(pts2,1),1)'];
NormIm1=NormMat*homoIm1; % normalize the coordinates
NormIm2=NormMat*homoIm2;

A=[];
%% using N points to calculate the A
for i=1:size(pts1,1)
    xl_i=NormIm1(1,i);xr_i=NormIm2(1,i);
    yl_i=NormIm1(2,i);yr_i=NormIm2(2,i);
    A_i=[xl_i*xr_i xl_i*yr_i xl_i yl_i*xr_i yl_i*yr_i yl_i xr_i yr_i 1];
    A=[A;A_i];
end
[U,S,V]=svd(A);

f=V(:,end);
f=reshape(f,[3 3]);


%% denormalize F
[U,S,V]=svd(f);
S(end)=0;
F=U*S*V';
F=refineF(F,NormIm1(1:2),NormIm2(1:2));
F=NormMat'*F*NormMat;

% result=NormIm1'*F*NormIm2;

end

