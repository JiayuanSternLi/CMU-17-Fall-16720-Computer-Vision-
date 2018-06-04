function im3 = generatePanorama(img1, img2)
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
%% get best H
H2to1=ransacH(matches, locs1, locs2, nIter, tol);
%% translation M
y_trans=200; % set y translation as 150
x_trans=0;
M=[1 0 x_trans; 0 1 y_trans; 0 0 1]; % translation M

[img1_row,img1_col,~]=size(img1);

warp_img2=warpH(img2,M*H2to1,[1000 1900]);
warp_img1=warpH(img1,M,[800 img1_col]);

% imshow(pana);
%% no clip
pana=warp_img2;
% imshow(pana);
pana(y_trans+1:y_trans+1+img1_row, 1:img1_col,:)=...
    warp_img1(y_trans+1:y_trans+1+img1_row,:,:);

[pana_row,pana_col]=find(pana(:,:,1)~=0);
right=max(pana_col); % find the corners, and set them as boader
bottom=max(pana_row);
top=min(pana_row);

% figure,imshow(pana(1:pana_row_max,1:pana_col_max,:));
im3=pana(top:bottom,1:right,:);
end