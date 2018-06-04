function M = LucasKanadeAffine(It, It1)

%% initialization
p = zeros(1,6);
[yNum,xNum] = size(It);

% get the templete
[X,Y] = meshgrid(1:xNum,1:yNum);
Temp = interp2(It,X,Y);

%set up iteration
epsilon=0.1;
iter=50;
homoTempCord=[X(:)';Y(:)';ones(1,yNum*xNum)];
[gradientX_It1,gradientY_It1] = gradient(It1);
M=[1,0,0;0,1,0;0,0,1]; % initial M

for i=1:iter
    %Get the warped x and y; reshape them
    warpHomoTempCord=M*homoTempCord;
    warpX = warpHomoTempCord(1,:)';
    warpY = warpHomoTempCord(2,:)';
    WarpIt1 = interp2(X, Y, It1, reshape(warpX,[yNum,xNum]), reshape(warpY,[yNum,xNum]));
    
    %Compute the error image
    errorImg = reshape(Temp-WarpIt1,yNum*xNum,1);
    
    %Evaluate Jacobian for affine
    gradientX = interp2(gradientX_It1,warpX,warpY);
    gradientY = interp2(gradientY_It1,warpX,warpY);
    gradientX = gradientX(:);
    gradientY = gradientY(:);
    
    %Evaluate Jacobian for affine
    JacobianX = [warpX,zeros(yNum*xNum,1),warpY,zeros(yNum*xNum,1),ones(yNum*xNum,1),zeros(yNum*xNum,1)];
    JacobianY = [zeros(yNum*xNum,1),warpX,zeros(yNum*xNum,1),warpY,zeros(yNum*xNum,1),ones(yNum*xNum,1)];
    
    for i=1:6
        steepestDescent(:,i) = gradientX.*JacobianX(:,i)+gradientY.*JacobianY(:,i);
    end
    
    %Get Hessian matrix
    gradientX_i = ~isnan(interp2(gradientX_It1,warpX,warpY));
    Hessian = steepestDescent(gradientX_i,:)'*steepestDescent(gradientX_i,:);
    %Get before delta
    beforeDeltaP=steepestDescent(gradientX_i,:)'*errorImg(gradientX_i);  
    %Compute delta p
    deltaP = Hessian\beforeDeltaP;
    %normalize
    norm_deltaP = norm(deltaP);  
    %update p
    p = p+deltaP';
    %update M
    M = [1+p(1),p(3),p(5);p(2),1+p(4),p(6);0,0,1];
    if abs(norm_deltaP)<epsilon 
        break
    end
    
end

end
