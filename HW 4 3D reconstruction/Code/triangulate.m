function [ P, err ] = triangulate( C1, p1, C2, p2 )
% triangulate:
%       C1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       C2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points

%       P - Nx3 matrix of 3D coordinates
%       err - scalar of the reprojection error

% Q3.2:
%       Implement a triangulation algorithm to compute the 3d locations
%
pointsNum=length(p1(:,1));
homoP1=[p1,ones(pointsNum,1)]';
homoP2=[p2,ones(pointsNum,1)]';
c11=C1(1,:);c12=C1(2,:);c13=C1(3,:);
c21=C2(1,:);c22=C2(2,:);c23=C2(3,:);

for i=1:pointsNum
    x1=homoP1(1,i);y1=homoP1(2,i);
    x2=homoP2(1,i);y2=homoP2(2,i);
    A=[x1*c13-c11;y1*c13-c12;x2*c23-c21;y2*c23-c22];
    [~,~,V]=svd(A);
    Xi=V(:,end);
    X(:,i)=Xi;
end
% X(1:3,:)=X(1:3,:)./repmat(X(4,:),[3,1]);
P=X';
P=P./P(:,4);
P(:,4)=[];
projP1=C1*X;
projP2=C2*X;
% projP1(1:2,:)=projP1(1:2,:)./repmat(projP1(3,:),[2,1]);
% projP2(1:2,:)=projP2(1:2,:)./repmat(projP2(3,:),[2,1]);
projP1=projP1./repmat(projP1(3,:),[3,1]);
projP2=projP2./repmat(projP2(3,:),[3,1]);

error1=sum((projP1(1:2,:)-homoP1(1:2,:)).^2);
error2=sum((projP2(1:2,:)-homoP2(1:2,:)).^2);
err=sum(error1+error2);



end
