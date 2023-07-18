function Controller= Controller_FHL(dt)
% 階層型線形化コントローラの設定
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
Ac2 = [0,1;0,0];
Bc2 = [0;1];
Ac4 = diag([1,1,1],1);
Bc4 = [0;0;0;1];
Controller.F1=lqrd(Ac2,Bc2,diag([100,1]),[0.1],dt);                                % 
Controller.F2=lqrd(Ac4,Bc4,diag([100,10,10,1]),[0.01],dt); % xdiag([100,10,10,1])
Controller.F3=lqrd(Ac4,Bc4,diag([100,10,10,1]),[0.01],dt); % ydiag([100,10,10,1])
Controller.F4=lqrd(Ac2,Bc2,diag([100,10]),[0.1],dt);                       % ヨー角 

syms sz1 [2 1] real
syms sF1 [1 2] real
[Ad1,Bd1,~,~] = ssdata(c2d(ss(Ac2,Bc2,[1,0],[0]),dt));
Controller.Vf = matlabFunction([-sF1*sz1, -sF1*(Ad1-Bd1*sF1)*sz1, -sF1*(Ad1-Bd1*sF1)^2*sz1, -sF1*(Ad1-Bd1*sF1)^3*sz1],"Vars",{sz1,sF1});

syms sz2 [4 1] real
syms sF2 [1 4] real
syms sz3 [4 1] real
syms sF3 [1 4] real
syms sz4 [2 1] real
syms sF4 [1 2] real
Controller.Vs = matlabFunction([-sF2*sz2;-sF3*sz3;-sF4*sz4],"Vars",{sz2,sz3,sz4,sF2,sF3,sF4});
Controller.dt = dt;

%% 線形システムにMCMPCコントローラを適用する場合
% H : horizon
% A2 = [0 1;0 0]; B2 = [0;1];
% [Ad,Bd] = c2d(A2,B2,dt);
% [AN2,BN2] = calc_horizon_for_linear_system(Ad,Bd,H);
% A4 = [zeros(3,1),eye(3);zeros(1,4)]; B4 = [0;0;0;1];
% [Ad,Bd] = c2d(A4,B4,dt);
% [AN4,BN4] = calc_horizon_for_linear_system(Ad,Bd,H);
% Q2 = eye(2);
% Q4 = eye(4);
% R2 = 1;
% R4 = 1;
% QH2 = kron(eye(H),Q2);
% QH4 = kron(eye(H),Q4);
% RH2 = kron(eye(H),R2);
% RH4 = kron(eye(H),R4);
% % 以下サブシステムごとに評価関数を計算
% syms V1 [H 1] real
% syms V2 [H 1] real
% syms V3 [H 1] real
% syms V4 [H 1] real
% syms z01 [2 1] real
% syms z02 [4 1] real
% syms z03 [4 1] real
% syms z04 [2 1] real
% 
% ZH1 = AN2*z01+BN2*V1;
% ZH2 = AN4*z02+BN4*V2;
% ZH3 = AN4*z03+BN4*V3;
% ZH4 = AN2*z04+BN2*V4;
% JH1 = ZH1'*QH2*ZH1 + V1'*RH2*V1;
% JH2 = ZH2'*QH4*ZH2 + V2'*RH4*V2;
% JH3 = ZH3'*QH4*ZH3 + V3'*RH4*V3;
% JH4 = ZH4'*QH2*ZH4 + V4'*RH2*V4;
% Controller.J = matlabFunction(JH1 + JH2 + JH3 + JH4,'vars',{z01,z02,z03,z04,V1,V2,V3,V4}); % 評価関数
% Controller.S = 200; % サンプル数
% 
% 
% Controller.dt = dt;
% 
% Controller.Vf = str2func("Vf");
% Controller.Vs = str2func("MCMPC_Vs");
%%
Controller.type="FUNCTIONAL_HLC";
Controller.name="hlc";
Controller.param=Controller;
end

% function v = MCMPC_Vs(z2, z3, z4, S, M, Q)
% % S : sample number
% v2 =  Q.V2.*randn(1,S);
% v3 = Q.V3.*randn(1.S);
% v4 = Q.V4.*randn(1,S);
% Z2=M.A4*z2 + M.B4*v2;
% Z3=M.A4*z3 + M.B4*v3;
% Z4=M.A2*z4 + M.B2*v4;
% % 実入力で評価できるようにしても面白い
% [~,i2]=min(sum([(Z2'*Q.Q2).*Z2',Q.R2*v2'.*v2'],[],2));
% [~,i3]=min(sum([(Z3'*Q.Q3).*Z3',Q.R3*v3'.*v3'],[],2));
% [~,i4]=min(sum([(Z4'*Q.Q4).*Z4',Q.R4*v4'.*v4'],[],2));
% v = [v2(i2);v3(i3);v4(i4)];% とりあえず最小評価の入力を算出
% end
