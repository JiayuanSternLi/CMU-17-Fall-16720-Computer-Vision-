function [wordMap] = getVisualWords(img, filterBank, dictionary)
% Compute visual words mapping for the given image using the dictionary of visual words.

% Inputs:
% 	img: Input RGB image of dimension (h, w, 3)
% 	filterBank: a cell array of N filters
% Output:
%   wordMap: WordMap matrix of same size as the input image (h, w)

% TODO Implement your code here
filterResponses= extractFilterResponses(img, filterBank);
[row,col]=size(filterResponses(:,:,1));
convtFtResp=reshape(filterResponses,[row*col,60]);% converte filterresponses into 2D matrix

D=pdist2(convtFtResp,dictionary'); % calculate the Eu distance between and dictionary, the D value is the index of dictionary ranging from 1:K
wordMap=zeros(size(img(:,:,1)));
for i=1:length(convtFtResp)
    [~,dicIndex]=min(D(i,:));% get the dictionary index 
    [r,c]=ind2sub(size(img(:,:,1)),i);% map the index back to the cordinate of image
    wordMap(r,c)=dicIndex;
end

end
