% Your code here.
clear
% img=imread('01_list.jpg');
img=imread('02_letters.jpg');
% img=imread('03_haiku.jpg');
% img=imread('04_deep.jpg');
% img=imread('05_test.jpg');
% img=imread('06_test.jpg');
[lines, bw]=findLetters(img);

imshow(img);
hold on
for i=1:length(lines)
    boxCoordinates=lines{i};
    % convert [x1 y1 width height] into [x1 y1 x2 y2]
    boxCoordinates(:,3)=boxCoordinates(:,3)-boxCoordinates(:,1);
    boxCoordinates(:,4)=boxCoordinates(:,4)-boxCoordinates(:,2);
    
    for j=1:length(boxCoordinates(:,1))
        box=boxCoordinates(j,:);
        rectangle('Position',[box(1) box(2) box(3) box(4)],'EdgeColor','green');
    end
end
