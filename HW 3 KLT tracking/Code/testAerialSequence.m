load('aerialseq.mat');
[~,~,fram]=size(frames);
for i=1:fram-1
    image1=frames(:,:,i);
    image2=frames(:,:,i+1);
    mask=uint8(~SubtractDominantMotion(image1, image2));
    movingCar=image2.*mask;
    MotionTracking=imfuse(image2,movingCar,'scaling','joint','ColorChannels',[1 2 2]);
    imshow(MotionTracking);
    
%     if i==30 || i==60 || i==90 || i==120
%         figure,imshow(MotionTracking);
%     end
end

