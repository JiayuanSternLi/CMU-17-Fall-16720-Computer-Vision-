clear
%  load('sylvseq.mat');
load('carseq.mat'); % car data
[Vid_height,Vid_width,fram_num]=size(frames);
%  rect=[102,62,156,108];
rect=[50,110,150,157]; % car data
rects=zeros(fram_num,4);
epsilon=4;% set the threshold of difference bewteen p and p_star

for i=1:fram_num-1
    %% calculate the delta_p, same with KLT
    rects(i,:)=rect;
    It=frames(:,:,i);It1=frames(:,:,i+1);
    [dp_x,dp_y] = LucasKanade(It, It1, rect);
    p=[dp_x;dp_y];
   
%     T_rect=[102,62,156,108]; % toy
    T_rect=[50,110,150,157]; % T1's rectangular
    It=frames(:,:,1);It1=frames(:,:,i+1); % It is fixed as the 1st frame
    
    update_rect(1)=rect(1)+dp_x;update_rect(2)=rect(2)+dp_y;
    update_rect(3)=rect(3)+dp_x;update_rect(4)=rect(4)+dp_y;
    %% calculate updated delta_p with templete correction
    [dp_x_star,dp_y_star] = LucasKanadeTpCorrection(It, It1,update_rect);
    p_star=[dp_x_star;dp_y_star];
    
    dif_px=abs(p(1)-p_star(1));
    dif_py=abs(p(2)-p_star(2));
    %% stratergy 3
    if dif_px<epsilon && dif_py<epsilon
%         rect(1)=rect(1)+dp_x_star;rect(2)=rect(2)+dp_y_star;
%         rect(3)=rect(3)+dp_x_star;rect(4)=rect(4)+dp_y_star;
        
        rect(1)=update_rect(1)+dp_x_star;rect(2)=update_rect(2)+dp_y_star; % it seems like double update
        rect(3)=update_rect(3)+dp_x_star;rect(4)=update_rect(4)+dp_y_star; % one for I(W(x;p)), one for p_star
    else
        rect=rects(i,:);
    end

end


% since It and It1 don't use the same rect any longer, 
% so we need to write a new function. It use the fixxed rect=[50,110,150,157]
% but It1 uses updated one
% except this, this function is almost same with [dp_x,dp_y] = LucasKanade


function [dp_x,dp_y] = LucasKanadeTpCorrection(It, It1, rect)

% input - image at time t, image at t+1, rectangle (top left, bot right coordinates)
% output - movement vector, [dp_x, dp_y] in the x- and y-directions.

% rect=[x1,y1,x2,y2]

%% initialization
It=im2double(It); It1=im2double(It1); % convert img into gray
x1=rect(1,1);y1=rect(1,2);x2=rect(1,3);y2=rect(1,4);
x1=round(x1);x2=round(x2);y1=round(y1);y2=round(y2);

%  T_rect=[102,62,156,108]; % toy
T_rect=[50,110,150,157];
Tx1=T_rect(1,1);Ty1=T_rect(1,2);Tx2=T_rect(1,3);Ty2=T_rect(1,4);
% in each iteration, it seems like coordinates should be integer, otherwise there will be some bugs using meshgrid
dp_x=0;dp_y=0;
iter=100;% iteration number in calculating delta_p
epsilon=0.001; % the threshold converging the delta_p
% preparation get the original image, the same size with templete
[TX,TY]=meshgrid(Tx1:Tx2,Ty1:Ty2);
TempImg=interp2(It,TX,TY);

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