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
end
