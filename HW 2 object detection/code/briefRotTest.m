

img1=rgb2gray(imread('model_chickenbroth.jpg'));

rotate_bar=zeros(37,1);
q=1;
for degree=0:10:350
    rotate=imrotate(img1,degree);
    [locs2, desc2] = briefLite(rotate);
    [locs1, desc1] = briefLite(img1);
    [matches] = briefMatch(desc1, desc2);
    rotate_bar(q,1)=length(matches(:,1));
    q=q+1;
end
bar(rotate_bar);