function [p,w] = e2pl_cross_point(e, pl)
% pl の３本の列ベクトルで張る平面とeで既定される原点を通る直線の交点pと
% plの３本のベクトルの線形結合としての係数[a,b,c]'を求める．
% e = unit vector
% pl = [perp, p1,p2,p3] = [e1 e2 e3; x1 y1 z1;x2 y2 z2; x3 y3 z3]'
% perp : 平面plの単位法線ベクトル
% p = d e = a p1 + b p2 + c p3;
% w = [a;b;c];
if e'*pl(1:3,1)
abcd = [pl(1:3,2:4),-e;1 1 1 0]\[0;0;0;1];
p = abcd(4)*e;
w = abcd(1:3);
else
    warning("ACSL: there is no cross point.");
end
end