function [text] = extractImageText(fname)
% [text] = extractImageText(fname) loads the image specified by the path 'fname'
% and returns the next contained in the image as a string.

load('bestWandb36.mat');
img=imread(fname);
[lines, bw]=findLetters(img);

%% extract image and convert into vector data
lineNum=length(lines);
for i=1:lineNum % loop for each line
    letterNum=length(lines{i}(:,1));
    
    for j=1:letterNum % loop for each
        box=lines{i}(j,:);
        x1=box(1);y1=box(2);x2=box(3);y2=box(4);
        letterFig=bw(y1:y2,x1:x2);
        width=round(x2-x1);
        height=round(y2-y1);
        
        % imshow(letterFig);
        figLength=max(width,height);
        figLength=round(figLength*1.1);
        %% 1)width<height 2)width>height
        if width<height
            padLength=round((figLength-width)/2);
            padLetterFig=padarray(letterFig,[0,padLength]);
            padLetterFig=imresize(padLetterFig,[32 32]);
        else
            padLength=round((figLength-height)/2);
            padLetterFig=padarray(letterFig,[padLength,0]);
            padLetterFig=imresize(padLetterFig,[32 32]);
        end
        %% pad the image into size 32*32
        padLetterFig=imresize(padLetterFig,[32 32]);
        LetterFig=imcomplement(padLetterFig);
%         imshow(LetterFig);
        %% imresize image into vector
        data{i}(j,:)=reshape(LetterFig,[1,32*32]);
    end
end
%% classification
letterTable='ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
for i=1:lineNum
    letterNum=length(lines{i}(:,1));
    for j=1:letterNum
        X=data{i}(j,:);
        [output,~,~]=Forward(W,b,X');
        letterClass=output;
        [~,index]=max(output,[],1);
        character{i}(:,j)=letterTable(index);  
    end
end
text=character;

end
