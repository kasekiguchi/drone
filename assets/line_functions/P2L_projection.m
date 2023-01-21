function O = P2L_projection(P,L,flag)
% 点Pの直線Lへの射影点座標を返す
% P : P(i,:)が直線L(i,:)に射影される．
% L : line [a,b,c]
% 前提：[a,b]の大きさ1，c <= 0
arguments
    P
    L
    flag = 1 % 上記前提が満たされているとき1
end
if ~flag
    L = make_standard_line(L);
end
% XY = [(b_pow_2 .* map.x - a_multi_b .* map.y - a_multi_c) ./ a_plus_b_pow_2,
%       (a_pow_2 .* map.y - a_multi_b .* map.x - b_multi_c) ./ a_plus_b_pow_2];
LP = (L.a.*P.x + L.b.*P.y + L.c);
O.x = P.x - L.a.*LP;
O.y = P.y - L.b.*LP;
end
