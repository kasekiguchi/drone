function l = linefit(XY,type)
% XY : 1列目がx, 2列目がy に関するデータ
% 最小二乗近似で直線の式(a,b,c)を算出
% l = [a,b,c]
% [a,b] のノルムが1, c < 0 
% readme.md 参照
arguments
    XY
    type = "row"; % or struct
end
A = cov(XY); % 共分散行列
[ab,~]=eig(A);
c = -sum(XY,1)*ab(:,1)/size(XY,1); 
if c <= 0
    t = [ab(1),ab(2), c];
else
    t = -[ab(1),ab(2), c];
end
if strcmp(type,"struct")
    l.a = t(1);
    l.b = t(2);
    l.c = t(3);
else
l =  t;
end
end
