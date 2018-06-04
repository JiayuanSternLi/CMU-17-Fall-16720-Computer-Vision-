function [DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels)
%%Produces DoG Pyramid
% inputs
% Gaussian Pyramid - A matrix of grayscale images of size
%                    (size(im), numel(levels))
% levels      - the levels of the pyramid where the blur at each level is
%               outputs
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
%               created by differencing the Gaussian Pyramid input
[imgR,imgC]=size(GaussianPyramid(:,:,1)); % image size
DoGPyramid=zeros(imgR,imgC,numel(levels)-1);% creat DoGpyramid
for i=1:length(levels)-1
    DoGPyramid(:,:,i)=GaussianPyramid(:,:,i+1)-GaussianPyramid(:,:,i);
end
DoGLevels=levels(2:end);
end