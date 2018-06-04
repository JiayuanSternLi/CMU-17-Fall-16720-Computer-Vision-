function H2to1 = computeH(p1,p2)
% INPUTS:
% p1 and p2 - Each are size (2 x N) matrices of corresponding (x, y)'  
%             coordinates between two images
%
% OUTPUTS:
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear 
%         equation

% assume that:
%   x2    h11 h12 h13   u1
%  [y2] =[h21 h22 h23]*[v1]
%   1     h31 h32 h33   1

% ax=[-u1 -v1 -1 0 0 0 x2u1 x2v1 x2]
% ay=[0 0 0 -u1 -v1 -1 y2u1 y2v1 y2]

homo_p1=[p1;ones(1,length(p1(2,:)))];
homo_p2=[p2;ones(1,length(p2(2,:)))];
N=length(p1(1,:));

index=1;
for i=1:N
    u1=homo_p1(1,i); v1=homo_p1(2,i);
    x2=homo_p2(1,i); y2=homo_p2(2,i);
    ax=[-x2,-y2,-1,0,0,0,u1*x2,u1*y2,u1];
    A(index,:)=ax; index=index+1;
    ay=[0,0,0,-x2,-y2,-1,v1*x2,v1*y2,v1];
    A(index,:)=ay; index=index+1;
end
%% solve Ah=0
[U,S,V]=svd(A'*A);
% [V2,D]=eig(A'*A);

H=V(:,end);

H2to1(1,1:3)=H(1:3);
H2to1(2,1:3)=H(4:6);
H2to1(3,1:3)=H(7:9);

% H2to1=(1/H2to1(3,3)).*H2to1;

% Temp = zeros(2*size(p1,2),9);
% for i = 1:size(p1,2)
%     [u,v] = deal(p2(1,i),p2(2,i));
%     [x,y]= deal(p1(1,i),p1(2,i));
%     Temp(i*2-1,:) = [x,y,1,0,0,0,-u*x,-u*y,-u];
%     Temp(i*2,:) = [0,0,0,x,y,1,-v*x,-v*y,-v];
% end
% [U,S,V] = svd(transpose(Temp)*Temp);
% H2to1 = transpose(reshape(U(:,end), 3, 3));


% H2to1=(1/H2to1(3,3)).*H2to1;


end