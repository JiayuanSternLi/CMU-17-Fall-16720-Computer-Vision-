function [dp_x,dp_y] = LucasKanade(It, It1, rect)

% input - image at time t, image at t+1, rectangle (top left, bot right coordinates)
% output - movement vector, [dp_x, dp_y] in the x- and y-directions.

% rect=[x1,y1,x2,y2]

% initialization
It=im2double(It); It1=im2double(It1); % convert img into gray
x1=rect(1,1);y1=rect(1,2);x2=rect(1,3);y2=rect(1,4);
x1=round(x1);x2=round(x2);y1=round(y1);y2=round(y2); 
% in each iteration, it seems like coordinates should be integer, otherwise there will be some bugs using meshgrid
dp_x=0;dp_y=0;
iter=100;% iteration number in calculating delta_p
epsilon=0.001; % the threshold converging the delta_p
% preparation get the original image, the same size with templete
[X,Y]=meshgrid(x1:x2,y1:y2);
TempImg=interp2(It,X,Y);

% step3 warp gradient I with W(x;p)
[fx,fy]=gradient(TempImg);
DeltaImg=[reshape(fx,[],1),reshape(fy,[],1)];% vectorize all points into N*1 vector 

% step4 evaluate Jacobian
JacobWarp=[1 0;0 1];

% step5 compute steepest descent
stepDescentImg=DeltaImg*JacobWarp;

% step6 compute Hessian
Hessian=stepDescentImg'*stepDescentImg;

for i=1:iter
    % step1 using W(x;p) to warp the image_t to get I(W(x;p))
    [X, Y]=meshgrid(x1+dp_x:x2+dp_x,y1+dp_y:y2+dp_y);
    warpImg=interp2(It1,X,Y);
    % step2 compute the error image T(x)-I(W(x;p))
    ErImg=TempImg-warpImg;
    ErImg=reshape(ErImg,[],1);
    % step7 Delta_p
    delta_p=Hessian\(stepDescentImg'*ErImg);
    % step8 update parameter delta_p
    dp_x=dp_x+delta_p(1);
    dp_y=dp_y+delta_p(2);
    
    if abs(delta_p(1))<epsilon && abs(delta_p(2))<epsilon
        break
    end
end


end