function O = P2DA_projection(P,DA)
% 点Pの直線DAへの射影点座標を返す
% P : P(i,:)が直線DA(i,:)に射影される．
% DA : line [d, alpha]
% d < 0 でも成り立つアリゴリズム
arguments
    P
    DA
end
ex = cos(DA.alpha);
ey = sin(DA.alpha);
perpd = DA.d - ex.*P.x - ey.*P.y;
O.x = P.x + perpd.*ex;
O.y = P.y + perpd.*ey;
end
