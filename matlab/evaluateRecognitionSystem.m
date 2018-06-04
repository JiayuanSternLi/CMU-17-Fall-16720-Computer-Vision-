function [conf] = evaluateRecognitionSystem()
% Evaluates the recognition system for all test-images and returns the confusion matrix

	load('vision.mat');
	load('../data/traintest.mat');

	% TODO Implement your code here
    testNum=length(test_imagenames);
    C=zeros(length(mapping),length(mapping));
for k=1:testNum
    image=im2double(imread(test_imagenames{k}));
    testLab=test_labels(k);% get the test_image labels
    wordMap = getVisualWords(image, filterBank, dictionary);
	h = getImageFeaturesSPM(3, wordMap, size(dictionary,2));
	distances = distanceToSet(h, train_features);
	[~,nnI] = max(distances);
% 	guessedImage = mapping{train_labels(nnI)};
    guesLab=train_labels(nnI); % get the guess_image labels
    
    C(testLab,guesLab)=C(testLab,guesLab)+1; % confusion matrix
    
    
end
conf=trace(C)/sum(C(:));
    
end