function [W, b] = InitializeNetwork(layers)
% InitializeNetwork([INPUT, HIDDEN, OUTPUT]) initializes the weights and biases
% for a fully connected neural network with input data size INPUT, output data
% size OUTPUT, and HIDDEN number of hidden units.
% It should return the cell arrays 'W' and 'b' which contain the randomly
% initialized weights and biases for this neural network.

% Your code here

% layers=[N H1 H2 H3...HN C]

layerNum=length(layers);
weightLayNum=layerNum-1;
W=cell(1,weightLayNum);

for i=1:layerNum-1
    unitNum1=layers(i);
    unitNum2=layers(i+1);
    W{i}=0.01*randn(unitNum2,unitNum1)./sqrt(unitNum2);
    %     W{i} = rand(unitNum2,unitNum1) - 0.5;
%     v=sqrt(1/layers(i));
%     W{i}=normrnd(0,v,[unitNum2 unitNum1]);
    b{i}=zeros(unitNum2,1);
end

C = size(b{end},1);
% assert(size(W{1},2) == 1024, 'W{1} must be of size [H,N]');
assert(size(b{1},2) == 1, 'b{end} must be of size [H,1]');
assert(size(W{end},1) == C, 'W{end} must be of size [C,H]');



end
