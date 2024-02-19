function out = tform_manual(pd,rot,T)
% 合同変換
% [Input]
% pd : point data : N x 3 
% rot : rotation matrix : 3 x 3
% T : translational drift : 1 x 3
% [Output]
% out : transformed point cloud data
out = (rot*pd' + T')' ;
end