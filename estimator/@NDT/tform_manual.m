function out = tform_manual(pd,rot,T)
% 合同変換
% [Input]
% pd : point data : N x 3 
% rot : rotation matrix : 3 x 3
% T : translational drift : 1 x 3
% [Output]
% out : transformed point cloud data
out = (rot*pd' + T')' ;
    % for i = 1:size(pd,1)
    %     tform = rot * pd(i,:)' + T';
    %     pdobj_tform(i,1) = tform(1,1);
    %     pdobj_tform(i,2) = tform(2,1);
    %     pdobj_tform(i,3) = tform(3,1);
    % end
    % out=pdobj_tform;
end