function buildRecognitionSystem()
% Creates vision.mat. Generates training features for all of the training images.

	load('dictionary.mat');
	load('../data/traintest.mat');

	% TODO create train_features
[~,K]=size(dictionary);
[N,~]=size(train_imagenames);
L=2;
train_features=ones(K*(4^(2+1)-1)/3,N);% creat train_features matrix with size [K*(4^(2+1)-1)/3,N]

for i=1:N
    imgName=train_imagenames{i};% get the image path
    wordMapName=strrep(imgName,'.jpg','.mat');% switch .jpg into .mat
    wordMap=load(wordMapName,'-mat');% get the wordmap.mat path
    wordMap=wordMap.wordMap;% why does the structure come up????
    h=getImageFeaturesSPM(L+1, wordMap, K);
    train_features(:,i)=h;
end

	save('vision.mat', 'filterBank', 'dictionary', 'train_features', 'train_labels');

end