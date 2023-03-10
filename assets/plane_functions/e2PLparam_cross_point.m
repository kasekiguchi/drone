function [d, P, W] = e2PLparam_cross_point(e, Pi)
% e2pl_cross_point の複数平面版
% Pi = [inv(P1);inv(P2);...] : triangleの逆行列が縦に並んだ行列
tmp = reshape(-Pi*e,3,[])';
P = sum(tmp,2);
W = tmp./P;
ids = (W>=0 & W<=1)*[1;1;1]==3; % 交点が面分内にある平面インデックス
if isempty(find(ids, 1))
    d = nan;
else
%d = -1/max(P(ids)); % 壁面までの最小距離
    d = -1./min(P(ids));
%p = d*e; % 最近壁面上の交点
end
end