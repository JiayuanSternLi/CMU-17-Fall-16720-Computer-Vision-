clc
clear
num_epoch = 50;
classes = 26;
layers = [32*32, 400, classes];
learning_rate = 0.01;

load('../data/nist26_train.mat', 'train_data', 'train_labels')
load('../data/nist26_test.mat', 'test_data', 'test_labels')
load('../data/nist26_valid.mat', 'valid_data', 'valid_labels')

[W, b] = InitializeNetwork(layers);

train_acc=zeros(num_epoch,1);
train_loss=zeros(num_epoch,1);
valid_acc=zeros(num_epoch,1);
valid_loss=zeros(num_epoch,1);
for j = 1:num_epoch
    [W, b] = Train(W, b, train_data, train_labels, learning_rate);

    [train_acc(j), train_loss(j)] = ComputeAccuracyAndLoss(W, b, train_data, train_labels);
    [valid_acc(j), valid_loss(j)] = ComputeAccuracyAndLoss(W, b, valid_data, valid_labels);

    fprintf('Epoch %d - accuracy: %.5f, %.5f \t loss: %.5f, %.5f \n', j, train_acc(j), valid_acc(j), train_loss(j), valid_loss(j))
end

% save('nist26_model.mat', 'W', 'b')
train_accData=[train_acc,[1:num_epoch]'];
train_lossData=[train_loss,[1:num_epoch]'];
valid_accData=[valid_acc,[1:num_epoch]'];
valid_lossData=[valid_loss,[1:num_epoch]'];

plot(train_accData(:,2),train_accData(:,1),'b-');
hold on
plot(valid_accData(:,2),valid_accData(:,1),'r-');
xlabel('Epoch number');ylabel('Accuracy');
title('Accuracy with learning rate 0.01');
hold off
legend('trainData','validData');

figure,
plot(train_lossData(:,2),train_lossData(:,1),'b-');
hold on
plot(valid_lossData(:,2),valid_lossData(:,1),'r-');
xlabel('Epoch number');ylabel('Average Entropy-Loss');
title('Loss with learning rate 0.01');
hold off
legend('trainData','validData');