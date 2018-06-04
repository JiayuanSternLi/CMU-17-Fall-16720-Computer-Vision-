function [h] = getImageFeaturesSPM(layerNum, wordMap, dictionarySize)
% Compute histogram of visual words using SPM method
% Inputs:
%   layerNum: Number of layers (L+1)
%   wordMap: WordMap matrix of size (h, w)
%   dictionarySize: the number of visual words, dictionary size
% Output:
%   h: histogram of visual words of size {dictionarySize * (4^layerNum - 1)/3} (l1-normalized, ie. sum(h(:)) == 1)

% TODO Implement your code here
L=layerNum-1;
[M,N]=size(wordMap);
chopNum=L^2;
L2subHist=cell(4,4);
L1subHist=cell(2,2);

for i=1:chopNum-1
    colBreakDot(i)=fix(N/chopNum)*i;
    rowBreakDot(i)=fix(M/chopNum)*i;
end
colBreakDot=[1,colBreakDot,N]; % mark up the cut point
rowBreakDot=[1,rowBreakDot,M];
%% creat L2 histogram
L2weight=1/2; % initial the weight of layer 2 
for i=1:chopNum
    for j=1:chopNum
        subWordMapL2=wordMap(rowBreakDot(i):rowBreakDot(i+1),...
            colBreakDot(j):colBreakDot(j+1));
        L2subHist{i,j}=getImageFeatures(subWordMapL2, dictionarySize)*(1/chopNum^2*L2weight);
        % calculate the subhistogram in each subregion seperately, then put
        % them into L2subHistogram
    end
end
%% creat L1 histogram
L1weight=1/4; % initial the weight of layer 1
for i=1:chopNum/2
    for j=1:chopNum/2
        subWordMapL1=wordMap(rowBreakDot(i):rowBreakDot(2*i+1),...
            colBreakDot(j):colBreakDot(2*j+1));
        L1subHist{i,j}=getImageFeatures(subWordMapL1, dictionarySize)*(1/chopNum*L1weight); 
        % calculate the subhistogram in each subregion seperately, then put
        % them into L1subHistogram
    end
end
%% creat L0 histogram
L0weight=1/4; % initial the weight of layer 0
L0subHist=getImageFeatures(wordMap, dictionarySize)*L0weight;

%% combine full histogram
L1Hist=cell2mat(reshape(L1subHist,[4,1]));
L2Hist=cell2mat(reshape(L2subHist,[16,1]));
h=[L0subHist;L1Hist;L2Hist];



end