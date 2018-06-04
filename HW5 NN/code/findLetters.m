function [lines, bw] = findLetters(im)
% [lines, BW] = findLetters(im) processes the input RGB image and returns a cell
% array 'lines' of located characters in the image, as well as a binary
% representation of the input image. The cell array 'lines' should contain one
% matrix entry for each line of text that appears in the image. Each matrix entry
% should have size Lx4, where L represents the number of letters in that line.
% Each row of the matrix should contain 4 numbers [x1, y1, x2, y2] representing
% the top-left and bottom-right position of each box. The boxes in one line should
% be sorted by x1 value.


%Your code here

img=rgb2gray(im);
gausFiltImg=imgaussfilt(img,1.5);% blur image

filtImg=imbinarize(gausFiltImg); % binarize image

filtImg=imcomplement(filtImg); % white and black exchange

% se=strel('line',11,90);
% filtImg=imdilate(filtImg,se);

bw=filtImg;
boundingBox=regionprops(filtImg,'boundingBox');

boxCoordinate=zeros(length(boundingBox),4);
for i=1:length(boundingBox)
    boxCoordinate(i,:)=boundingBox(i).BoundingBox;
    %     rectangle('Position',[boxCoordinate(1) boxCoordinate(2) boxCoordinate(3) boxCoordinate(4)],'EdgeColor','green');
end

%% eliminate the small box
[row,~]=find(boxCoordinate(:,3)<30);
boxCoordinate(row,:)=[];
[row,~]=find(boxCoordinate(:,4)<30);
boxCoordinate(row,:)=[];

%% convert bounding box into [x1 y1 x2 y2]
boxCoordinate(:,3)=boxCoordinate(:,1)+boxCoordinate(:,3);
boxCoordinate(:,4)=boxCoordinate(:,2)+boxCoordinate(:,4);
[~,index]=sort(boxCoordinate(:,4));
boxCoordinate=boxCoordinate(index,:);

%% classify letters based on lines

i=1;
while length(boxCoordinate)~=0  
    [row,~]=find(boxCoordinate(:,4)==min(boxCoordinate(:,4)));
    [row,~]=find(boxCoordinate(:,2)<boxCoordinate(row(1),4));
    lines{i}=boxCoordinate(row,:);
    boxCoordinate(row,:)=[];  
    i=i+1;
end

%% order letters in each line
linesNum=length(lines);
for i=1:linesNum
    Line_i_letter=lines{i};
    [~,index]=sort(Line_i_letter(:,1));
    Line_i_letter=Line_i_letter(index,:);
    lines{i}=Line_i_letter;
end

assert(size(lines{1},2) == 4,'each matrix entry should have size Lx4');
assert(size(lines{end},2) == 4,'each matrix entry should have size Lx4');
lineSortcheck = lines{1};
assert(issorted(lineSortcheck(:,1)) | issorted(lineSortcheck(end:-1:1,1)),'Matrix should be sorted in x1');

end
