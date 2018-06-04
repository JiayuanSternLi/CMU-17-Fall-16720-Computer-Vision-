tic
clear
load('sylvseq.mat');
% load('carseq.mat'); % car
[Vid_height,Vid_width,fram_num]=size(frames);
rect=[102,62,156,108];
% rect=[50,110,150,157]; % car
rects=zeros(fram_num,4);
for i=1:fram_num-1
    rects(i,:)=rect;
    It=frames(:,:,i);It1=frames(:,:,i+1);
    [dp_x,dp_y] = LucasKanade(It, It1, rect);
    rect(1)=rect(1)+dp_x;
    rect(2)=rect(2)+dp_y;
    rect(3)=rect(3)+dp_x;
    rect(4)=rect(4)+dp_y;
    
    
%     if i==1 || i==100 || i==200 || i==300 || i==400
%         x1=carseqrects(i,1);y1=carseqrects(i,2);x2=carseqrects(i,3);y2=carseqrects(i,4);
%         figure,
%         hold on
%         imshow(frames(:,:,i));
%         rectangle('Position',[x1 y1 x2-x1 y2-y1],'EdgeColor','y');
%         hold off
%     end
end
toc
