function locsDoG = getLocalExtrema(DoGPyramid, DoGLevels, ...
    PrincipalCurvature, th_contrast, th_r)
%%Detecting Extrema
% INPUTS
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
% DoG Levels  - The levels of the pyramid where the blur at each level is
%               outputs
% PrincipalCurvature - size (size(im), numel(levels) - 1) matrix contains the
%                      curvature ratio R
% th_contrast - remove any point that is a local extremum but does not have a
%               DoG response magnitude above this threshold
% th_r        - remove any edge-like points that have too large a principal
%               curvature ratio
%
% OUTPUTS
% locsDoG - N x 3 matrix where the DoG pyramid achieves a local extrema in both
%           scale and space, and also satisfies the two thresholds.

[rowNum,colNum]=size(DoGPyramid(:,:,1));
%% remove the points whose DoG response<0.03
locsDoG_cont=[];
for i=1:length(DoGLevels)
    [row,col]=find(DoGPyramid(:,:,i)>th_contrast);   
    locsDoG_cont_i=[row,col,ones(length(col),1)*DoGLevels(i)];
    locsDoG_cont=[locsDoG_cont;locsDoG_cont_i];
end
%% remove the points whose R<12
locsDoG_R=[];
for i=1:length(DoGLevels)
    [row,col]=find(PrincipalCurvature(:,:,i)<th_r);
    locsDoG_R_i=[row,col,ones(length(col),1)*DoGLevels(i)];
    locsDoG_R=[locsDoG_R;locsDoG_R_i];
end
%% combine those two kept points
locsDoG=intersect(locsDoG_R,locsDoG_cont,'rows');

%% find the local extrema


elim_num=find(locsDoG(:,1)>=rowNum-2|locsDoG(:,1)<=3);
locsDoG(elim_num,:)=[];
elim_num=find(locsDoG(:,2)>=colNum-2|locsDoG(:,2)<=3);
locsDoG(elim_num,:)=[];
new_locsDoG=locsDoG;
% first step is to eliminate the points along the edges of figure
for i=1:length(locsDoG)
    row=locsDoG(i,1);
    col=locsDoG(i,2);
    scal_level=locsDoG(i,3)+1;
    
    if scal_level==1 % if the level is bottom one, its neighbor are space with upper one
        neighbor(:,:,1)=DoGPyramid(row-1:row+1,col-1:col+1,scal_level);
        neighbor(:,:,2)=DoGPyramid(row,col,scal_level+1).*ones(3,3);
        if DoGPyramid(row,col,scal_level)~=max(max(max(neighbor)))...
                &&   DoGPyramid(row,col,scal_level)~=min(min(min(neighbor)))
            new_locsDoG(i,:)=0; % if the points is neither max nor min extrema, it will be eliminated
        end
        
    elseif scal_level==5 % if the level is top one, its neighbor are space with lower one
        neighbor(:,:,1)=DoGPyramid(row-1:row+1,col-1:col+1,scal_level);
        neighbor(:,:,2)=DoGPyramid(row,col,scal_level-1).*ones(3,3);
        if DoGPyramid(row,col,scal_level)~=max(max(max(neighbor)))...
                && DoGPyramid(row,col,scal_level)~=min(min(min(neighbor)))
            new_locsDoG(i,:)=0;
        end
        
    else % if the level is neither top and bottom, its neighbor are space with upper and lower levels
%         neighbor(:,:,1)=DoGPyramid(row-1:row+1,col-1:col+1,scal_level-1);
        neighbor(:,:,1)=DoGPyramid(row,col,scal_level-1).*ones(3,3);  
        neighbor(:,:,2)=DoGPyramid(row-1:row+1,col-1:col+1,scal_level);
        neighbor(:,:,3)=DoGPyramid(row,col,scal_level+1).*ones(3,3);
%         neighbor(:,:,3)=DoGPyramid(row-1:row+1,col-1:col+1,scal_level+1);
        if DoGPyramid(row,col,scal_level)~=max(max(max(neighbor)))...
                && DoGPyramid(row,col,scal_level)~=min(min(min(neighbor)))
            new_locsDoG(i,:)=0;
        end
    end
end
length(find(new_locsDoG(:,1)~=0));
locsDoG=new_locsDoG(new_locsDoG(:,1)~=0,:);
% finalloca=new_locsDoG(:,1:2);
% locsDoG=new_locsDoG;
% imshow(testimg);hold on;plot(finalloca(:,2),finalloca(:,1),'r*');


end