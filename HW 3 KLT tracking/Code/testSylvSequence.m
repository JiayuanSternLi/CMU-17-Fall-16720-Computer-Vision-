tic
% clear
load('sylvseq.mat');
load('sylvbases.mat');
[Vid_height,Vid_width,fram_num]=size(frames);
rect=[102,62,156,108];
Baserects=zeros(fram_num,4);
for i=1:fram_num-1
    rects(i,:)=rect;
    Baserects(i,:)=rect;
    It=frames(:,:,i);It1=frames(:,:,i+1);
    [dp_x,dp_y]=LucasKanadeBasis(It, It1, rect, bases);
    rect(1)=rect(1)+dp_x;
    rect(2)=rect(2)+dp_y;
    rect(3)=rect(3)+dp_x;
    rect(4)=rect(4)+dp_y;
    
    
%     if i==1 || i==200 || i==300 || i==350 || i==400
%         x1=Baserects(i,1);y1=Baserects(i,2);x2=Baserects(i,3);y2=Baserects(i,4);
%         x3=rects(i,1);y3=rects(i,2);x4=rects(i,3);y4=rects(i,4);
%         figure,
%         hold on
%         imshow(frames(:,:,i));
%         rectangle('Position',[x1 y1 x2-x1 y2-y1],'EdgeColor','y');
%         rectangle('Position',[x3 y3 x4-x3 y4-y3],'EdgeColor','g');
%         hold off
%     end
end
toc