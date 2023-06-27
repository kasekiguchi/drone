function dX = cable_suspended_rigid_body_with_3_drones(x,u,P)
ddX = ddx0do0_3(x,u,P,inv(Addx0do0_4(x,u,P)));
dX = tmp_cable_suspended_rigid_body_with_3_drones(x,u,P,ddX);
end
%% 状態：
% 牽引物: 位置，姿勢角，速度，角速度，
% リンク: 角度，角速度
% ドローン:姿勢角，角速度
% x = [p0 Q0 v0 O0 qi wi Qi Oi]
% [x01, x02, x03, r01, r02, r03, r04, dx01, dx02, dx03, o01, o02, o03, qi1_1, qi1_2, qi1_3, qi2_1, qi2_2, qi2_3, qi3_1, qi3_2, qi3_3, wi1_1, wi1_2, wi1_3, wi2_1, wi2_2, wi2_3, wi3_1, wi3_2, wi3_3, ri1_1, ri1_2, ri1_3, ri1_4, ri2_1, ri2_2, ri2_3, ri2_4, ri3_1, ri3_2, ri3_3, ri3_4, oi1_1, oi1_2, oi1_3, oi2_1, oi2_2, oi2_3, oi3_1, oi3_2, oi3_3]
% u = [f1 M1 f2 M2 f3 M3]
% [fi1, Mi1_1, Mi1_2, Mi1_3, fi2, Mi2_1, Mi2_2, Mi2_3, fi3, Mi3_1, Mi3_2, Mi3_3]
% P = [g m0 j0 rho li mi ji]
% [g, m0, j01, j02, j03, rho1_1, rho1_2, rho1_3, rho2_1, rho2_2, rho2_3, rho3_1, rho3_2, rho3_3, li1, li2, li3, mi1, mi2, mi3, ji1_1, ji1_2, ji1_3, ji2_1, ji2_2, ji2_3, ji3_1, ji3_2, ji3_3]

% x0 = [zeros(3,1);[1;0;0;0];zeros(6,1);repmat([0;0;1],4,1);zeros(12,1);repmat([1;0;0;0],4,1);repmat([0;0;0],4,1)];
% u0 = zeros(4*4,1);
% P = [9.81, 1, [0.01, 0.01, 0.01], [0.2,0.1,-0.1, -0.2,0.1,-0.1, -0.2,-0.1,-0.1, 0.2,-0.1,-0.1], [1 1 1 1], [1 1 1 1],0.005*ones(1,12)]