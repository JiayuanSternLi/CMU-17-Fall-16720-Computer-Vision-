function [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a)
% [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a) computes the gradient
% updates to the deep network parameters and returns them in cell arrays
% 'grad_W' and 'grad_b'. This function takes as input:
%   - 'W' and 'b' the network parameters
%   - 'X' and 'Y' the single input data sample and ground truth output vector,
%     of sizes Nx1 and Cx1 respectively
%   - 'act_h' and 'act_a' the network layer pre and post activations when forward
%     forward propogating the input smaple 'X'
N = size(X,1);
H = size(W{1},1);
C = size(b{end},1);
assert(size(W{1},2) == N, 'W{1} must be of size [H,N]');
assert(size(b{1},2) == 1, 'b{end} must be of size [H,1]');
assert(size(W{end},1) == C, 'W{end} must be of size [C,H]');
assert(all(size(act_a{1}) == [H,1]), 'act_a{1} must be of size [H,1]');
assert(all(size(act_h{end}) == [C,1]), 'act_h{end} must be of size [C,1]');
% assert(all(size(outputs) == [C,1]), 'output must be of size [C,1]');

% Your code here

intervNum = length(W);
grad_W = cell(1,intervNum);
grad_b = cell(1,intervNum);
term = cell(1,intervNum);

for i=intervNum:-1:1
    %% not output layer sigmoid function
    if i~=intervNum 
        term11 = W{i+1}; % d(act_a i+1)/d(act_h i)
        term12 = act_h{i} .* (ones(size(act_h{i})) - act_h{i}); % d(act_h i)/d(act_a i)
        term{i} = term11'*term{i+1}.*term12;
        % if it is the input layer or not
        if i==1
            self=X;
        else
            self=act_h{i-1};
        end       
        grad_W{i}=term{i}*self';
        grad_b{i}=term{i};  
    end  
    %% output layer softmax function
    if i==intervNum
        %% 1?i=j (diagonal of Jacobian) 2?i~=j (others)
        term2 = act_h{i} - Y;% dL/df(x) * d(act_h)/d(act_a)
        term{i} = term2;
        grad_W{i} = term{i} * act_h{i-1}'; % act_h{i-1} is : d(act_a)/dw
        grad_b{i} = term{i};
    end
end




assert(size(grad_W{1},2) == N, 'grad_W{1} must be of size [H,N]');
assert(size(grad_W{end},1) == C, 'grad_W{end} must be of size [C,N]');
assert(size(grad_b{1},1) == H, 'grad_b{1} must be of size [H,1]');
assert(size(grad_b{end},1) == C, 'grad_b{end} must be of size [C,1]');
end

function diff=diff_softmax(S)
diff=zeros(length(S),length(S));
for i_ind=1:length(S)
    for j_ind=1:length(S)
        if i_ind==j_ind
            diff(i_ind,j_ind)=S(i_ind)*(1-S(i_ind));
        else
            diff(i_ind,j_ind)=-S(i_ind)*S(j_ind);
        end
    end
end
end

function diff=diff_sigmoid(S)
    diag_mt=(1-S).*S;
    diff=diag(diag_mt);
end
