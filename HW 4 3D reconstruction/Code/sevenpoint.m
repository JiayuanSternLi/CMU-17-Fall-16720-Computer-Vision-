function [ F ] = sevenpoint( pts1, pts2, M )
% sevenpoint:
%   pts1 - 7x2 matrix of (x,y) coordinates
%   pts2 - 7x2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.2:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save recovered F (either 1 or 3 in cell), M, pts1, pts2 to q2_2.mat

%     Write recovered F and display the output of displayEpipolarF in your writeup

Xl=[pts1,ones(length(pts1),1)];
Xr=[pts2,ones(length(pts2),1)];
% scale matrix T
NormMat=[2/M(1) 0 -1; 0 2/M(2) -1; 0 0 1];

% get normalized x: x_norm=Tx
X1_norm=Xl*NormMat;
X2_norm=Xr*NormMat;
[X1_norm, X2_norm] = deal(X1_norm(:,1:2),X2_norm(:,1:2));
[x1, y1] = deal(X1_norm(:,1), X1_norm(:,2));
[x2, y2] = deal(X2_norm(:,1), X2_norm(:,2));

%% creat A matrix
m = length(pts1);
A = zeros(m, 9);
for i=1:7
    A(i,:)=[x1(i)*x2(i), x1(i)*y2(i), x1(i), y1(i)*x2(i), y1(i)*y2(i), y1(i), x2(i), y2(i), 1];
end

%% using SVD to get F
[~,~,V] = svd(A);
F1=reshape(V(:,end),[3,3]);
F2=reshape(V(:,end-1),[3,3]);
F1=refineF(F1, X1_norm, X2_norm);
F2=refineF(F2, X1_norm, X2_norm);

% General solution of the form: F=(1-?)F1+?F2
% Constraint: det((1-?)F1+?F2)
syms lamda
constraint=det((1-lamda)*F1+lamda*F2);

det_F=coeffs(constraint);
lab_roots=roots(double(det_F));

for i=1:3
    if isreal(lab_roots(i))==1
        realRoots(i)=real(lab_roots(i));
    end
end

realRoots=real(roots(double(det_F)));

%% denormalize F
numRoots=length(realRoots);
F=zeros(3,3, numRoots);
for i=1:numRoots
    F(:,:,i)=(1-realRoots(i))*F1+realRoots(i)*F2;
    F(:,:,i) = NormMat'*F(:,:,i)*NormMat;
end
Fcell{1}=F(:,:,1);
Fcell{2}=F(:,:,2);
Fcell{3}=F(:,:,3);
F=Fcell;
end

