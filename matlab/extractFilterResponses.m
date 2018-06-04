function [filterResponses] = extractFilterResponses(img, filterBank)
% Extract filter responses for the given image.
% Inputs:
%   img:                a 3-channel RGB image with width W and height H
%   filterBank:         a cell array of 20 filters
% Outputs:
%   filterResponses:    a W x H x 20*3 matrix of filter responses


% TODO Implement your code here
img_size=size(img);
img=img.*255;% if test this function along, don't use this multiply. since main function already double the img, so
% img=double(img);
% filterResponses=[];
if length(img_size)==2 % if imput img is a gray image, then create 3 channels for it
    img=repmat(img,[1,1,3]);
else
    
    img=rgb2lab(img);    % in imput img is a RGB img, then convert it into Lab
end

filtRspIdex=1;
for i=1:20
    for j=1:3
        filterSize=size(filterBank{i});
        padimg=padarray(img,filterSize); % padding img with 0
        cutimg=imcrop(padimg,[filterSize(1)+1,filterSize(2)+1,img_size(2)-1,img_size(1)-1]);
        % after padding along the edge, the size of img will change
        % from 3 channels, so we need to crop into original size
        filterResponses(:,:,filtRspIdex)=imfilter(cutimg(:,:,j),filterBank{i}); % put filterresponses into matrix filterResponses, whose size is [W,H,3*20]
        filtRspIdex=filtRspIdex+1;
    end
end




end
