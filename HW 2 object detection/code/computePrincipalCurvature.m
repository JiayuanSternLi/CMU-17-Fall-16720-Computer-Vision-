function PrincipalCurvature = computePrincipalCurvature(DoGPyramid)
%%Edge Suppression
% Takes in DoGPyramid generated in createDoGPyramid and returns
% PrincipalCurvature,a matrix of the same size where each point contains the
% curvature ratio R for the corre-sponding point in the DoG pyramid
%
% INPUTS
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
%
% OUTPUTS
% PrincipalCurvature - size (size(im), numel(levels) - 1) matrix where each
%                      point contains the curvature ratio R for the
%                      corresponding point in the DoG pyramid
% [imgR,imgC]=size(DoGPyramid(:,:,1));
PrincipalCurvature=zeros(size(DoGPyramid));
PrincipalCurvature_i=PrincipalCurvature(:,:,1);
[~,~,num_DoGPyramid]=size(DoGPyramid);

% for i=1:num_DoGPyramid
%     [fx,fy]=gradient(DoGPyramid(:,:,i));
%     [fxx,fxy]=gradient(fx);% !!!need to adjust
%     [~,fyy]=gradient(fy);
%     for index=1:numel(DoGPyramid(:,:,1))
%         %     H_point=[fxx(index),fxy(index);fxy(index),fyy(index)];
%         HTrace=fxx(index)+fyy(index); % get the trace of Hessian matrix
%         HDet=fxx(index)*fyy(index)-fxy(index)^2;% get the determinant of Hessian matrix
%
%         R=HTrace^2/HDet;
%         PrincipalCurvature_i(index)=R;
%         PrincipalCurvature(:,:,i)=PrincipalCurvature_i;
%     end
% end

for i=1:num_DoGPyramid
    [fx,fy]=gradient(DoGPyramid(:,:,i));
    [fxx,fxy]=gradient(fx);% !!!need to adjust
    [~,fyy]=gradient(fy);
    
    %     H_point=[fxx(index),fxy(index);fxy(index),fyy(index)];
    HTrace=fxx+fyy; % get the trace of Hessian matrix
    HDet=fxx.*fyy-fxy.^2;% get the determinant of Hessian matrix
    
    R=HTrace.^2./HDet;
    
    PrincipalCurvature(:,:,i)=R;
    
end








end