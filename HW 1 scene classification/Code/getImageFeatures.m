function [h] = getImageFeatures(wordMap, dictionarySize)
% Compute histogram of visual words
% Inputs:
% 	wordMap: WordMap matrix of size (h, w)
% 	dictionarySize: the number of visual words, dictionary size
% Output:
%   h: vector of histogram of visual words of size dictionarySize (l1-normalized, ie. sum(h(:)) == 1)

	% TODO Implement your code here
	
% 	assert(numel(h) == dictionarySize);
    [hist,~]=histcounts(wordMap,1:dictionarySize+1);% count the appearence number of visual words
    h=hist';
    h=h./sum(h);% normalize
    
end