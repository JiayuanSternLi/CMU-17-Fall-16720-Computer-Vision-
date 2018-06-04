function mask = SubtractDominantMotion(image1, image2)

% input - image1 and image2 form the input image pair
% output - mask is a binary image of the same size

%% image warp
image1=im2double(image1);image2=im2double(image2);
M=LucasKanadeAffine(image1, image2); % get the affine matrix
warp_im = warpH(image1,M,size(image1),0); 

[row,col]=size(warp_im);

difIm=image2-warp_im;
difIm=abs(difIm);
binaMask=imbinarize(difIm,0.04); % keep the pixes which greater than 0.1
binaMask(1:10,:)=0;binaMask(row-10:row,:)=0; % cut out boundary 
binaMask(:,1:10)=0;binaMask(:,col-10:col)=0;
[r,c]=find(abs(difIm)>0.10);

mask=bwselect(binaMask,c,r,8); % step1 select the piexs and its 8 neighbor
mask2=bwareaopen(mask,8); % step2 throgh away points who don't have 8 neighbor
se = strel('disk',4); 
dilatedI = imdilate(mask2,se); % step3 dilate the original mask, making it expand
se = strel('disk',4);
erodeI=imerode(dilatedI,se);% step4 erode the bigger mask into approatiate size
% se = strel('disk',4); 
mask=erodeI;

end