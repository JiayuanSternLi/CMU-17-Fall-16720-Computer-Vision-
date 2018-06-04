function [panoImg] = imageStitching(img1, img2, H2to1)
%
% INPUT
% Warps img2 into img1 reference frame using the provided warpH() function
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear
%         equation
%
% OUTPUT
% Blends img1 and warped img2 and outputs the panorama image

nIter=1000;
tol=1;
%% img initialization
[locs1, desc1] = briefLite(img1);
[locs2, desc2] = briefLite(img2);
[matches] = briefMatch(desc1, desc2);
 
[~,~,numchan1]=size(img1);
[~,~,numchan2]=size(img2);

if numchan1~=3 % if the image is not 3 channel, change it into 3 ch
    img1=repmat(img1,[1 1 3]); 
end
if numchan2~=3
    img2=repmat(img2,[1 1 3]); 
end

%% img size
[im1_row,im1_col,~]=size(img1);
[im2_row,im2_col,~]=size(img2);
warp_im2=warpH(img2, H2to1, [im1_row im1_col+im2_col/2]);
[im2_row,im2_col,~]=size(warp_im2);

% pano_img_row=min([im1_row im2_row]);

warp_im2(1:im1_row,1:im1_col,:)=img1;

panoImg=warp_im2;

end