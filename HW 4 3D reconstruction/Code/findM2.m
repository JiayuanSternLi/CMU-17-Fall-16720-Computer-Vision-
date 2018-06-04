% Q3.3:
%       1. Load point correspondences
%       2. Obtain the correct M2
%       3. Save the correct M2, p1, p2, R and P to q3_3.mat
im1=imread('im1.png');
load('some_corresp.mat');
load('intrinsics.mat');
M = size(im1);
F=eightpoint(pts1,pts2,M);
E=essentialMatrix(F,K1,K2);
M1=[eye(3),zeros(3,1)];
M2s=camera2(E);

% Get 4 sets of 3D points by using 4 M2s
P3D=zeros(length(p1),4,4);
Error=zeros(1,4);
for i = 1:4
    [P3D_i,~] = triangulate( K1*M1, p1, K2*M2s(:,:,i), p2 );
    P3D_i=P3D_i./repmat(P3D_i(:,4),[1,4]);
    P3D(:,:,i)=P3D_i;
    
end

% Find the correct 3D points
M2=zeros(3,4);
for i=1:4
    if(P3D(:,3,i)>0) % the correct P3D should have a positive z axis value
        P=P3D(:,:,i);
        P(:,4)=[];
        M2=M2s(:,:,i);
    end
end
C2=K2*M2;