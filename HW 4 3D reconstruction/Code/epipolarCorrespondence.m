function [ x2, y2 ] = epipolarCorrespondence( im1, im2, F, x1, y1 )
% epipolarCorrespondence:
%       im1 - Image 1
%       im2 - Image 2
%       F - Fundamental Matrix between im1 and im2
%       x1 - x coord in image 1
%       y1 - y coord in image 1

% Q4.1:
%           Implement a method to compute (x2,y2) given (x1,y1)
%           Use F to only scan along the epipolar line
%           Experiment with different window sizes or weighting schemes
%           Save F, pts1, and pts2 used to generate view to q4_1.mat
%
%           Explain your methods and optimization in your writeup
im1=im2double(im1);
im2=im2double(im2);
homoPts1=[x1;y1;1]; % change to homogeneous coordinates

%% ax+by+c=0
line2=F*homoPts1;
a=line2(1);b=line2(2);c=line2(3); % get the line equation

windowSize=15; % set windowsize as 61
im2Window=zeros(windowSize,windowSize,101);
searchDist=30; % set searchdistance along the epipolar line as 30
i=1;
for y=y1-searchDist:y1+searchDist
    x=(-b/a)*y-c/a;
    x=round(x);
    im2Window(:,:,i)=im2(y-(windowSize-1)/2:y+(windowSize-1)/2,x-(windowSize-1)/2:x+(windowSize-1)/2);
    i=i+1;
end
im1Window=im1(y1-(windowSize-1)/2:y1+(windowSize-1)/2,x1-(windowSize-1)/2:x1+(windowSize-1)/2);
im1Window=repmat(im1Window,[1,1,101]);


dif=im1Window-im2Window;
dif=abs(dif); % abs first, then sum it!!!!
SAD=sum(sum(dif,2),1);
SAD=reshape(SAD,1,size(SAD,3));
[~,index]=find(SAD==min(SAD));
%% map back to image axis
y2=index+y1-searchDist+1;
x2=(-b/a)*y2-c/a;



end

