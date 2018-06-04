function [filterBank, dictionary] = getFilterBankAndDictionary(imPaths)
% Creates the filterBank and dictionary of visual words by clustering using kmeans.

% Inputs:
%   imPaths: Cell array of strings containing the full path to an image (or relative path wrt the working directory.
% Outputs:
%   filterBank: N filters created using createFilterBank()
%   dictionary: a dictionary of visual words from the filter responses using k-means.

filterBank  = createFilterBank();

% TODO Implement your code here
alpha=150;
K=200;
randFitResponses=zeros(alpha*length(imPaths),60);

for i=1:length(imPaths)
    image=imread(imPaths{i});% load the ith image name
    [filterResponses] = extractFilterResponses(image, filterBank);
    
    [row,col]=size(image(:,:,1));
    randIndex=randperm(row*col,alpha); % get alpha random pixels 
%     [sub_row,sub_col]=ind2sub(size(image(:,:,1)),randIndex);% map the index back to cordinates
%     for j=1:alpha
%         randFiltResp(j,:)=filterResponses(sub_row(j),sub_col(j),:); 
%     end
    new_filterResponses=reshape(filterResponses,[row*col,60]);
    randFiltResp=new_filterResponses(randperm(row*col,alpha),:);
    startIndex=(i-1)*alpha+1;
    endIndex=i*alpha;
    randFitResponses(startIndex:endIndex,:)=randFiltResp;% collect the filterreponses from all training images
end

[~, dictionary] = kmeans(randFitResponses, K, 'EmptyAction','drop');
dictionary=dictionary';

end
