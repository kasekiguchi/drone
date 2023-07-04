function dx = zup_cable_suspended_rigid_body_with_3_drones(x,u,P)
r0 = x(4:7);
ri = reshape(x(32:43),4,[]);
[~,L0] = RodriguesQuaternion(r0);
[~,Li] = RodriguesQuaternion(ri);
r0 = [1;1;-1;-1].*r0;
ri = [1;1;-1;-1].*ri;
R0 = RodriguesQuaternion(r0);
Ri = RodriguesQuaternion(ri);
rp = [1 -1 -1]'; rq = [1;1;1;1];
Rzup = [rp; rq; rp; rp; repmat(rp, 2*3,1); repmat(rq, 3,1); repmat(rp, 3,1)];
X = Rzup.*x;
ddX = ddx0do0_3(X,R0,Ri,u,P,inv(Addx0do0_3(X,R0,u,P)));
dX = tmp_cable_suspended_rigid_body_with_3_drones(X,R0,Ri,u,P,ddX);
dx = Rzup.*dX;
dx(4:7) = L0'*x(11:13)/2;
for i = 1:3
dx(31+4*(i-1)+1:31+4*i) = Li(:,:,i)'*x(43+3*(i-1)+1:43+3*i)/2;
end
end
%% 状態：
% 牽引物: 位置，姿勢角，速度，角速度，
% リンク: 角度，角速度
% ドローン:姿勢角，角速度
% x = [p0 Q0 v0 O0 qi wi Qi Oi]
