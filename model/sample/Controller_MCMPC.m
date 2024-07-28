function Controller = Controller_MCMPC(dt,H)
% 線形システムにMCMPCコントローラを適用する場合
% H : horizon
A2 = [0 1;0 0]; B2 = [0;1];
[Ad,Bd] = c2d(A2,B2,dt);
[AN2,BN2] = calc_horizon_for_linear_system(Ad,Bd,H);
A4 = [zeros(3,1),eye(3);zeros(1,4)]; B4 = [0;0;0;1];
[Ad,Bd] = c2d(A4,B4,dt);
[AN4,BN4] = calc_horizon_for_linear_system(Ad,Bd,H);
Q2 = eye(2);
Q4 = eye(4);
R2 = 1;
R4 = 1;
QH2 = kron(eye(H),Q2);
QH4 = kron(eye(H),Q4);
RH2 = kron(eye(H),R2);
RH4 = kron(eye(H),R4);
% 以下サブシステムごとに評価関数を計算
syms V1 [H 1] real
syms V2 [H 1] real
syms V3 [H 1] real
syms V4 [H 1] real
syms z01 [2 1] real
syms z02 [4 1] real
syms z03 [4 1] real
syms z04 [2 1] real

ZH1 = AN2*z01+BN2*V1;
ZH2 = AN4*z02+BN4*V2;
ZH3 = AN4*z03+BN4*V3;
ZH4 = AN2*z04+BN2*V4;
JH1 = ZH1'*QH2*ZH1 + V1'*RH2*V1;
JH2 = ZH2'*QH4*ZH2 + V2'*RH4*V2;
JH3 = ZH3'*QH4*ZH3 + V3'*RH4*V3;
JH4 = ZH4'*QH2*ZH4 + V4'*RH2*V4;
Controller.J = matlabFunction(JH1 + JH2 + JH3 + JH4,'vars',{z01,z02,z03,z04,V1,V2,V3,V4}); % 評価関数
Controller.S = 200; % サンプル数
Controller.dt = dt;
end
