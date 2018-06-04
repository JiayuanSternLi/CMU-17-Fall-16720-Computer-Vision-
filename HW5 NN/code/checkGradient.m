% Your code here.
clear
load('nist26_test.mat');
load('bestWandb.mat');
[~, act_h, act_a] = Forward(W, b, test_data(1, :)');
[grad_W, grad_b] = Backward(W, b, test_data(1, :)', test_labels(1, :)', act_h, act_a);

classes = 26;
layers = [32*32, 400, classes];
learning_rate = 0.01;

epsilon =1*10^(-4);
threshold=0.1;


X = test_data(1,:)';
Y = test_labels(1,:)';
[~, act_h, act_a] = Forward(W, b, X);
[grad_W, ~] = Backward(W, b, X, Y, act_h, act_a);

%% choose a weight randomly
i=unidrnd(2);
[r,c]=size(grad_W{i});
row=unidrnd(r);col=unidrnd(c);

%% weights plus the epsilon
W_plus = W{i};
W_plus(row,col) = W_plus(row,col) + epsilon;
W_PLUS = W;
W_PLUS{i} = W_plus;
%% weights minus the epsilon
W_sub = W{i};
W_sub(row,col) = W_sub(row,col) - epsilon;
W_SUB = W;
W_SUB{i} = W_sub;
%% calculate the loss
[~,Wlarg] = ComputeAccuracyAndLoss(W_PLUS, b, X', Y);
[~,Wsmal] = ComputeAccuracyAndLoss(W_SUB, b, X', Y);

check_Gradw =(Wlarg-Wsmal)./(2*epsilon);

if abs(check_Gradw)<threshold
    sprintf('the gradient is correct')
end


