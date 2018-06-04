function [locs,desc] = computeBrief(im, GaussianPyramid, locsDoG, k, ...
                                        levels, compareA, compareB)
%%Compute BRIEF feature
% INPUTS
% im      - a grayscale image with values from 0 to 1
% locsDoG - locsDoG are the keypoint locations returned by the DoG detector
% levels  - Gaussian scale levels that were given in Section1
% compareA and compareB - linear indices into the patchWidth x patchWidth image 
%                         patch and are each nbits x 1 vectors
%
% OUTPUTS
% locs - an m x 3 vector, where the first two columns are the image coordinates 
%		 of keypoints and the third column is the pyramid level of the keypoints
% desc - an m x n bits matrix of stacked BRIEF descriptors. m is the number of 
%        valid descriptors in the image and will vary

%% initial parameter
sigma0=1;
k=2^0.5;
levels=[-1 0 1 2 3 4];
th_contrast=0.03;
th_r=12;
%% pre-processing

im=im2double(im);
[rowNum,colNum]=size(im(:,:,1));
% [locsDoG, GaussianPyramid]=DoGdetector(im, sigma0, k, ...
%                      levels, th_contrast, th_r);
boundryPoints=find((locsDoG(:,1)<5|locsDoG(:,1)>rowNum-4)|...
    (locsDoG(:,2)<5|locsDoG(:,2)>colNum-4));% remove the points on the boundry
locsDoG(boundryPoints,:)=[];

locs=locsDoG;

despPatch=zeros(9);
%% create despPatch
desc_i=zeros(1,256);
desc=zeros(length(locs(:,1)),256);% desc should be m*n, m is the number of descriptor, n is 256 dimension

for i=1:length(locs(:,1))
    row=locs(i,1);col=locs(i,2);scale_level=locs(i,3)+1;
    GausPym_level_i=GaussianPyramid(:,:,scale_level);
    despPatch=GausPym_level_i(row-4:row+4,col-4:col+4); % extract neighbour from the the image in charastical sacle
    dif=despPatch(compareA)-despPatch(compareB);
    desc_i(dif<=0)=1; % if P(A)<P(B) let result=1
    desc_i(dif>0)=0; 
    desc(i,:)=desc_i;
end



end