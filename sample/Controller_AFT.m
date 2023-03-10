function Controller= Controller_AFT(dt,param,alp)
% 近似線形化コントローラの設定
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
m = param(1);
lx = param(4);
ly = param(5);
jx = param(6);
jy = param(7);
jz = param(8);
g = param(9);
k1=param(10);
k2=param(11);
k3=param(12);
k4=param(13);


Acz = [0,1;0,0];
Bcz = [0;1/m];
Acp = [0,1;0,0];
Bcp = [0;1/jz];
Acx = diag([1,g,1],1);
Bcx = [0;0;0;1/jy];
Acy = diag([1,-g,1],1);
Bcy = [0;0;0;1/jx];

Controller_param.F1 = [2.23 2.28];
Controller_param.F2 = 0.1*[3.16 6.79 40.54 12.27];
Controller_param.F3 = 0.1*[-3.16 -6.79 40.54 12.27];
Controller_param.F4 = [1.41 1.35];
 
% Controller_param.F1=lqrd(Acz,Bcz,diag([100,1]),[0.1],dt);                                % 
% Controller_param.F2=lqrd(Acx,Bcx,diag([100,10,10,1]),[0.01],dt); % xdiag([100,10,10,1])
% Controller_param.F3=lqrd(Acy,Bcy,diag([100,10,10,1]),[0.01],dt); % ydiag([100,10,10,1])
% Controller_param.F4=lqrd(Acp,Bcp,diag([100,10]),[0.1],dt);                       % ヨー角 
% 
% Controller_param.F1 = place(Acz,Bcz,[-4.0293 + 3.4920i,-4.0293 - 3.4920i]);%FTと同じ極
% Controller_param.F2 = place(Acx,Bcx,[-7.3469, -3.5435, -1.2645 + 1.2608i,-1.2645 - 1.2608i]);%FTと同じ極
% Controller_param.F3 = place(Acy,Bcy,[-7.3469, -3.5435, -1.2645 + 1.2608i,-1.2645 - 1.2608i]);%FTと同じ極
% Controller_param.F4 = place(Acp,Bcp,[-3.4561,-7.8378]);%FTと同じ極

syms uz ux uy upsi real
invG = inv([ones(1,4); ly*[-1 -1 1 1]; lx*[1 -1 1 -1];[k1 -k2 -k3 k4]]);
Controller_param.Uthrust = matlabFunction(invG*[uz + m*g; uy; ux; upsi],"Vars",{uz, ux, uy, upsi});

% 入力のalphaを計算

anum = 4; %変数の数
alpha = zeros(anum + 1, 1);
alpha(anum + 1) = 1;
alpha(anum) = alp; %alphaの初期値
for a = anum - 1:-1:1
    alpha(a) = (alpha(a + 2) * alpha(a + 1)) / (2 * alpha(a + 2) - alpha(a + 1));
end
Controller_param.alpha = alpha(anum);
Controller_param.ax = alpha(1:4,1);
Controller_param.ay = alpha(1:4,1);
Controller_param.az = alpha(1:2, 1);
Controller_param.apsi = alpha(1:2, 1);

eig(diag(1, 1) - [0; 1/m] * Controller_param.F1)
eig(diag([1, g, 1], 1) - [0; 0; 0; 1/jy] * Controller_param.F2)
eig(diag([1, -g, 1], 1) - [0; 0; 0; 1/jx] * Controller_param.F3)
eig(diag(1, 1) - [0; 1/jz] * Controller_param.F4)
Controller.type="AFTC";
Controller.name="hlc";
Controller.param=Controller_param;
end
