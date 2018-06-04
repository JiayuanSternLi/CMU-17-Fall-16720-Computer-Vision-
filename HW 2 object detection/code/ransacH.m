function [bestH] = ransacH(matches, locs1, locs2, nIter, tol)
% INPUTS
% locs1 and locs2 - matrices specifying point locations in each of the images
% matches - matrix specifying matches between these two sets of point locations
% nIter - number of iterations to run RANSAC
% tol - tolerance value for considering a point to be an inlier
%
% OUTPUTS
% bestH - homography model with the most inliers found during RANSAC

bestH=zeros(3,3);
inlierNum=0; % initial inlier number=0
[matchNum,~]=size(matches);

for i=1:nIter
p1=locs1(matches(:,1),1:2)';
p2=locs2(matches(:,2),1:2)';
%% randomly select four points 
randPoints=randi([1 matchNum],1,4);
randp1=locs1(matches(randPoints,1),1:2)';
randp2=locs2(matches(randPoints,2),1:2)';
%% use four random points to compute H
H2to1 = computeH(randp1,randp2);
norm_H2to1=(1/H2to1(3,3)).*H2to1;
homo_p2=[p2;ones(1,length(p2(2,:)))];
conv_p1=H2to1*homo_p2; % compute the predicted p1
 
conv_p1(1,:)=conv_p1(1,:)./conv_p1(3,:);
conv_p1(2,:)=conv_p1(2,:)./conv_p1(3,:);
conv_p1(3,:)=[];
%% use RANSAC to find the best model 
dif=p1-conv_p1; % dif is the diference between p1 and predicted p1
dif=abs(dif);
TempInlierNum=length(find(dif(1,:)<tol & dif(2,:)<tol)); % count the number of inlier points
if TempInlierNum>inlierNum
    bestH=norm_H2to1; % always update the bestH
    inlierNum=TempInlierNum; % always update the most inlier points
end
end

end