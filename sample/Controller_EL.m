function Controller= Controller_EL(dt,fFT)
% 階層型線形化コントローラの設定
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
Ac4 = diag([1,1,1],1);
Bc4 = [0;0;0;1];
Ac2 = diag(1,1);
Bc2 = [0;1];

% Controller.F1=lqrd(Ac4,Bc4,diag([100,10,0.01,1]),[1],dt);
% Controller.F1=[56.8586  101.4052   54.6051   11.0586];%-4.0293 + 3.4920i,-4.0293 - 3.4920i,-2,-1
% Controller.F1=[300  220.7778   82.2737   15.0030];%-4.0293 + 3.4920i,-4.0293 - 3.4920i,-2,-1
% Controller.F1=lqrd(Ac4,Bc4,diag([100,100,10,1]),[0.01],dt);
% Controller.F2=lqrd(Ac4,Bc4,diag([1000,100,10,1]),[0.01],dt);
% Controller.F3=lqrd(Ac4,Bc4,diag([1000,100,10,1]),[0.01],dt);
% Controller.F4=lqrd(Ac2,Bc2,diag([100,10]),[0.1],dt);                       % ヨー角 

Controller.F1=lqrd(Ac4,Bc4,diag([100,10,10,1]),[0.01],dt);
Controller.F2=lqrd(Ac4,Bc4,diag([500,10,10,1]),[0.01],dt);
Controller.F3=lqrd(Ac4,Bc4,diag([500,10,10,1]),[0.01],dt);
Controller.F4=lqrd(Ac2,Bc2,diag([100,10]),[0.1],dt);                       % ヨー角 

eF1=Controller.F1;
eF2=Controller.F2;
eF3=Controller.F3;
eF4=Controller.F4;

%% finite-time settling controlのalphaを計算

% 入力のalphaを計算
alp = [0.88,0.85,0.85,0.85];%alphaの値 0.85より大きくないと吹っ飛ぶ恐れがある.
anum = 4; %最大の変数の個数
anum=5;%servo
alpha = zeros(anum + 1, 4);
alpha(anum + 1,:) = 1*ones(1,4);
alpha(anum,:) = alp; %alphaの初期値
for a = anum - 1:-1:1
    alpha(a,:) = (alpha(a + 2,:) .* alpha(a + 1,:)) ./ (2 .* alpha(a + 2,:) - alpha(a + 1,:));
end
Controller.alpha = alpha(anum);
% Controller.az = alpha(1:4,1);
Controller.az = alpha(1:5,1);%servo
Controller.ax = alpha(2:5,2);
Controller.ay = alpha(2:5,3);
Controller.apsi = alpha(2:3, 4);
%各サブシステムでalpを変える場合
% Controller.az = alpha(3:4, 1);
% Controller.ax = alpha(1:4,2);
% Controller.ay = alpha(1:4,3);
% Controller.apsi = alpha(3:4, 4);
az =Controller.az ;
ax =Controller.ax ;
ay =Controller.ay;
apsi =Controller.apsi;

syms ez1 [4 1] real
syms ez2 [4 1] real
syms ez3 [4 1] real
syms ez4 [2 1] real
if fFT ==1
    %FT
    crossPoint1 = 2.5*ones(1,4);%線形入力と交わる場所を指定
    crossPoint2 = 1*ones(1,4);%線形入力と交わる場所を指定
    crossPoint3 = 1*ones(1,4);%線形入力と交わる場所を指定
    crossPoint4 = 1*ones(1,2);%線形入力と交わる場所を指定
    isDiffrenceCrossPoint=0;
    if isDiffrenceCrossPoint
        Controller.F1 = Controller.F1.*crossPoint1./diag(crossPoint1.^az)';
        Controller.F2 = Controller.F2.*crossPoint2./diag(crossPoint2.^ax)';
        Controller.F3 = Controller.F3.*crossPoint3./diag(crossPoint3.^ay)';
        Controller.F4 = Controller.F4.*crossPoint4./diag(crossPoint4.^apsi)';
        eF1 = Controller.F1;
        eF2 = Controller.F2;
        eF3 = Controller.F3;
        eF4 = Controller.F4;
    end
    Controller.Vep = matlabFunction([-eF1 * (sign(ez1).*abs(ez1).^az); -eF2 * (sign(ez2).*abs(ez2).^ax); -eF3 * (sign(ez3).*abs(ez3).^ay); -eF4 * (sign(ez4).*abs(ez4).^apsi)], "Vars", {ez1,ez2, ez3, ez4});
else
    %LS
    crossPoint1 = 2.5*ones(1,4);%線形入力と交わる場所を指定
    crossPoint2 = 1*ones(1,4);%線形入力と交わる場所を指定
    crossPoint3 = 1*ones(1,4);%線形入力と交わる場所を指定
    crossPoint4 = 1*ones(1,2);%線形入力と交わる場所を指定
    isDiffrenceCrossPoint=0;
    if isDiffrenceCrossPoint
        Controller.F1 = Controller.F1.*crossPoint1./diag(crossPoint1.^az)';
        Controller.F2 = Controller.F2.*crossPoint2./diag(crossPoint2.^ax)';
        Controller.F3 = Controller.F3.*crossPoint3./diag(crossPoint3.^ay)';
        Controller.F4 = Controller.F4.*crossPoint4./diag(crossPoint4.^apsi)';
        eF1 = Controller.F1;
        eF2 = Controller.F2;
        eF3 = Controller.F3;
        eF4 = Controller.F4;
    
        % FTC.confirmParam2(vF1,lF1,Controller.az,'z')
        % FTC.confirmParam2(vF2,lF2,Controller.ax,'x')
        % FTC.confirmParam2(vF3,lF3,Controller.ay,'y')
        % FTC.confirmParam2(vF4,lF4,Controller.apsi,'yaw')
    end
    Controller.Vep = matlabFunction([-eF1*ez1;-eF2*ez2;-eF3*ez3;-eF4*ez4],"Vars",{ez1,ez2,ez3,ez4});
end
% %servo
syms z
Cc4 = [1 0 0 0];
% [Ad4,Bd4,~,~] = ssdata(c2d(ss(Ac4,Bc4,Cc4,0),dt));
% Ad
Ac5=[Ac4,zeros(4,1);-Cc4,0];
Bc5=[Bc4;0];
Controller.F1s=lqrd(Ac5,Bc5,diag([100,10,10,10,0.1]),0.01,dt);
eF1s=Controller.F1s;
Controller.Vep = matlabFunction([-eF1s*[ez1;z];-eF2*ez2;-eF3*ez3;-eF4*ez4],"Vars",{ez1,ez2,ez3,ez4,z});
% Controller.Vep = matlabFunction([-eF1s * (sign([ez1;z]).*abs([ez1;z]).^az); -eF2 * (sign(ez2).*abs(ez2).^ax); -eF3 * (sign(ez3).*abs(ez3).^ay); -eF4 * (sign(ez4).*abs(ez4).^apsi)], "Vars", {ez1, ez2, ez3, ez4, z});

Controller.dt = dt;
Controller.type = "ELC";
% eig(Ac4 - Bc4 * eF1)
% eig(Ac4 - Bc4 * eF2)
% eig(Ac4 - Bc4 * eF3)
% eig(Ac2 - Bc2 * eF4)
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
end
function v = MCMPC_Vs(z2, z3, z4, S, M, Q)
% S : sample number
v2 =  Q.V2.*randn(1,S);
v3 = Q.V3.*randn(1,S);
v4 = Q.V4.*randn(1,S);
Z2=M.A4*z2 + M.B4*v2;
Z3=M.A4*z3 + M.B4*v3;
Z4=M.A2*z4 + M.B2*v4;
% 実入力で評価できるようにしても面白い
[~,i2]=min(sum([(Z2'*Q.Q2).*Z2',Q.R2*v2'.*v2'],[],2));
[~,i3]=min(sum([(Z3'*Q.Q3).*Z3',Q.R3*v3'.*v3'],[],2));
[~,i4]=min(sum([(Z4'*Q.Q4).*Z4',Q.R4*v4'.*v4'],[],2));
v = [v2(i2);v3(i3);v4(i4)];% とりあえず最小評価の入力を算出
end