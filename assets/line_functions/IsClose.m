function ids = IsClose(xs, ys, xm, ym,d)
% 線分[xm,ym]の内 線分[xs,ys]と端点距離が十分近い（d以下）のxmのインデックスを返す．
% xs, ys : line segment edge by sensor : xs : 1x2
% xm, ym : line segment edge by map : xm : mx2 : m is number of line in map
% x* : [x11 x12;x21 x22; ...] : i-th row is x of two edge in i-th line
% y* : the same above
% regurn indices corresponding to the row of [xm,ym]
%   that is line segment whose one edge is inside the [xs,ys].

flag1=(xs(1)-xm).^2 + (ys(1)-ym).^2 < d^2;
flag2=(xs(2)-xm).^2 + (ys(2)-ym).^2 < d^2;
ids = find(flag1&flag2);

% Determine if line segments overlap
%x1:mesured start point
%x2:mesured end point
%x3:map start point
%x4:map end point
%     flag = false(size(x3));
%     flag(x1 >= x3 & x1 <= x4) = true;%観測された始点がマップの始点と終点の間
%     flag(x1 >= x4 & x1 <= x3) = true;%反対
%     flag(x2 >= x3 & x2 <= x4) = true;%観測された終点がマップの始点と終点の間
%     flag(x2 >= x4 & x2 <= x3) = true;%反転
%     flag(x1 <= x3 & x1 <= x4 & x2 >= x3 & x2 >= x4) = true;%観測された始点と終点がマップを超えている
%     flag(x1 >= x3 & x1 >= x4 & x2 <= x3 & x2 <= x4) = true;%反転
%     flag(x1 >= x3 & x2 >= x3 & x1 <= x4 & x2 <= x4) = true;%中に入ってる
%     flag(x1 <= x3 & x2 <= x3 & x1 >= x4 & x2 >= x4) = true;%反転
end
