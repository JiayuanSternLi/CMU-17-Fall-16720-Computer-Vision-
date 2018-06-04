% Q4.2:
% Integrating everything together.
% Loads necessary files from ../data/ and visualizes 3D reconstruction
% using scatter3
im1=imread('im1.png');
im2=imread('im2.png');
load('templeCoords.mat');
% load('q2_6.mat');
load('q3_3.mat');
load('intrinsics.mat');

M=size(im1);
F=eightpoint(pts1,pts2,M);

ptsNum=length(x1);
x2=[];
y2=[];
for i=1:ptsNum
    [x2_i,y2_i]=epipolarCorrespondence(im1,im2,F,x1(i),y1(i));
    x2=[x2;x2_i];
    y2=[y2;y2_i];   
end
p1=[x1,y1];
p2=[x2,y2];
M1=[eye(3),zeros(3,1)];
C1=K1*M1;

E=essentialMatrix(F,K1,K2);
M2=camera2(E);
M2=M2(:,:,3);
C2=K2*M2;

[P,err]=triangulate(C1,p1,C2,p2);
scatter3(P(:,1),P(:,2),P(:,3),'filled')
