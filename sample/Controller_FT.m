function Controller = Controller_FT(dt, fApprox_FTxy, fNewParam, fConfirmFig)
%% flag and approximate range
            % fApproxXY xy方向を近似する: 1 
            % fNewParam 新しく更新する場合: 1
            % fConfirmFig 近似入力のfigureを確認するか: 1
            % alp = [0.9,0.85,0.85,0.85];%alphaの値 0.85より大きくないと吹っ飛ぶ恐れがある.
            alp = [0.8,0.82,0.82,0.85];%alphaの値 0.85より大きくないと吹っ飛ぶ恐れがある.

            %1.近似範囲を決める2.a,bで調整(bの大きさを大きくするとFTからはがれにくくなる．aも同様だがFT,LSの近似範囲を見て調整)
            %zを近似する
            x0 = [50, 0.01];%最小化の初期値
            r=0.05;%緩和区間
            ar = [1, 1];%近似に使う区間
            % br=[1.8,1.6];%制約の大きさ, 最小は0(a=0.88)
            br=[1.2,1];%制約の大きさ, 最小は0

            %xyを近似する場合
            %x方向
            x0xy = [50, 0.01];%最小化の初期値
            rx=0.02;%緩和区間
            arx = [1,1,1,1];%近似に使う区間
            brx=[1.8, 1.6, 0.5 ,0.2];%制約の大きさ, 最小は0
            %y方向
            ry=0.02;%緩和区間
            ary = [1,1,1,1];%近似に使う区間
            bry=[1.8, 1.6, 0.5 ,0.2];%制約の大きさ, 最小は0
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
Ac2 = [0, 1; 0, 0];
Bc2 = [0; 1];
Ac4 = diag([1, 1, 1], 1);
Bc4 = [0; 0; 0;1];
Controller.F1 = lqrd(Ac2, Bc2, diag([100, 1]), [0.1], dt);% zdiag([100,1])
Controller.F2 = lqrd(Ac4, Bc4, diag([100, 10, 10, 1]), [0.01], dt); % xdiag([100,10,10,1])
Controller.F3 = lqrd(Ac4, Bc4, diag([100, 10, 10, 1]), [0.01], dt); % ydiag([100,10,10,1])
Controller.F4 = lqrd(Ac2, Bc2, diag([100, 10]), [0.1], dt); % ヨー角

vF1 = Controller.F1;
vF2 = Controller.F2;
vF3 = Controller.F3;
vF4 = Controller.F4;
lF1 = Controller.F1;
lF2 = Controller.F2;
lF3 = Controller.F3;
lF4 = Controller.F4;
%% FTCの同次性のパラメータalphaを計算
anum = 4; %最大の変数の個数
alpha = zeros(anum + 1, 4);
alpha(anum + 1,:) = 1*ones(1,anum);
alpha(anum,:) = alp; %alphaの初期値
for a = anum - 1:-1:1
    alpha(a,:) = (alpha(a + 2,:) .* alpha(a + 1,:)) ./ (2 .* alpha(a + 2,:) - alpha(a + 1,:));
end
Controller.alpha = alpha(anum);
Controller.az = alpha(1:2,1);
Controller.ax = alpha(1:4,2);
Controller.ay = alpha(1:4,3);
Controller.apsi = alpha(1:2, 4);
%各サブシステムでalpを変える場合
Controller.az = alpha(3:4, 1);
Controller.ax = alpha(1:4,2);
Controller.ay = alpha(1:4,3);
Controller.apsi = alpha(3:4, 4);
az =Controller.az ;
ax =Controller.ax ;
ay =Controller.ay;
apsi =Controller.apsi;
%%
isDiffrenceCrossPoint = 10;
%0.2m 位置のみ数倍している
% crossPoint1 = [0.2*5    0.4919];%線形入力と交わる場所を指定
% crossPoint2 = [0.2000*1.1    0.1425    0.2222    0.8192];%線形入力と交わる場所を指定
% crossPoint3 = [0.2000*1.1   0.1425    0.2222    0.8192];%線形入力と交わる場所を指定
% crossPoint4 = 1.0e-04 *[0.0823    0.6698];%線形入力と交わる場所を指定
%0.2m
% crossPoint1 = [0.2 0.1];%線形入力と交わる場所を指定
% crossPoint2 = [0.2000    0.1    0.2    0.1];%線形入力と交わる場所を指定
% crossPoint3 = [0.2000    0.1    0.2    0.1];%線形入力と交わる場所を指定
% crossPoint4 = 1.0e-04 *[0.0823    0.6698];%線形入力と交わる場所を指定
% %1m
% crossPoint1 = [0.9978    2.1631];%線形入力と交わる場所を指定
% crossPoint2 = [1.0000    0.8459    1.5447    5.5188];%線形入力と交わる場所を指定
% crossPoint3 = [1.0000    0.8458    1.5438    5.5177];%線形入力と交わる場所を指定
% crossPoint4 = [0.0006    0.0062];%線形入力と交わる場所を指定
%1m
% crossPoint1 = [0.9978*1    2.1631];%線形入力と交わる場所を指定
% crossPoint2 = [1.0000*1.5    0.8459    1.5447    5.5188];%線形入力と交わる場所を指定
% crossPoint3 = [1.0000*1.5    0.8458    1.5438    5.5177];%線形入力と交わる場所を指定
% crossPoint4 = [0.0006*2    0.0062];%線形入力と交わる場所を指定
%1.5m
% crossPoint1 = [1.5    3];%線形入力と交わる場所を指定
% crossPoint2 = [1.5000    1.7136    3.9338   17.3780];%線形入力と交わる場所を指定
% crossPoint3 = [1.5000    1.7136    3.9338   17.3780];%線形入力と交わる場所を指定
% crossPoint4 = [0.0065    0.0598];%線形入力と交わる場所を指定
%1.5m
crossPoint1 = 1.5*ones(1,2);%線形入力と交わる場所を指定
crossPoint2 = 1.5*ones(1,4);%線形入力と交わる場所を指定
crossPoint3 = 1.5*ones(1,4);%線形入力と交わる場所を指定
crossPoint4 = 1.5*ones(1,2);%線形入力と交わる場所を指定
if isDiffrenceCrossPoint
    Controller.F1 = Controller.F1.*crossPoint1./diag(crossPoint1.^az)';
    Controller.F2 = Controller.F2.*crossPoint2./diag(crossPoint2.^ax)';
    Controller.F3 = Controller.F3.*crossPoint3./diag(crossPoint3.^ay)';
    Controller.F4 = Controller.F4.*crossPoint4./diag(crossPoint4.^apsi)';
    vF1 = Controller.F1;
    vF2 = Controller.F2;
    vF3 = Controller.F3;
    vF4 = Controller.F4;

    FTC.confirmParam2(vF1,lF1,Controller.az)
    FTC.confirmParam2(vF2,lF2,Controller.ax)
    FTC.confirmParam2(vF3,lF3,Controller.ay)
    FTC.confirmParam2(vF4,lF4,Controller.apsi)
end
%%
%z方向FTCの近似
pz=FTC.paramSetting("z", r, ar, br, vF1, az',  x0, fNewParam, fConfirmFig);
%xy方向FTCの近似
if fApprox_FTxy
    %x方向
    px=FTC.paramSetting("x", rx, arx, brx, vF2, ax',  x0xy, fNewParam, fConfirmFig);
    %y方向
    py=FTC.paramSetting("y", ry, ary, bry, vF3, ay',  x0xy, fNewParam, fConfirmFig);
end

%servoの時
%バッテリーのヘリを考慮したさあーぼのゲインを作る
%lqrとサーボの部分を置き換え
% Cc2 = [1 0];
% [Ad1,Bd1,~,~] = ssdata(c2d(ss(Ac2,Bc2,Cc2,0),dt));
% Controller.F1s=lqrd([Ac2,zeros(2,1);-Cc2,0],[Bc2;0],diag([1000,10,1]),0.1,dt);
% syms z real % Model_EulerAngle_Servoを使う前提
% syms sz1 [2 1] real
% Ad1 = [Ad1,zeros(2,1);-Cc2,1];
% Bd1 = [Bd1;0];
% vF1s = Controller.F1s;
% Controller.Vf = matlabFunction([-vF1s*[sz1;z], -vF1s*(Ad1-Bd1*vF1s)*[sz1;z], -vF1s*(Ad1-Bd1*vF1s)^2*[sz1;z], -vF1s*(Ad1-Bd1*vF1s)^3*[sz1;z]],"Vars",{sz1,z});

%% 二層
syms sz2 [4 1] real
syms sz3 [4 1] real
syms sz4 [2 1] real
if fApprox_FTxy 
    %xy方向を近似
    Controller.Vs = matlabFunction([-vF2 * (tanh(px(:,1).*sz2).*sqrt(px(:,2)+sz2.^2).^ax); -vF3 * (tanh(py(:,1).*sz3).*sqrt(py(:,2)+sz3.^2).^ay); -vF4 * (sign(sz4).*abs(sz4).^apsi)], "Vars", {sz2, sz3, sz4});
else
    %近似しない
    Controller.Vs = matlabFunction([-vF2 * (sign(sz2).*abs(sz2).^ax); -vF3 * (sign(sz3).*abs(sz3).^ay); -vF4 * (sign(sz4).*abs(sz4).^apsi)], "Vars", {sz2, sz3, sz4});
end
%%
Controller.approx_z = [Controller.F1', pz, az];%近似パラメータ
Controller.dt = dt;
eig(diag(1, 1) - [0; 1] * Controller.F1)
eig(diag([1, 1, 1], 1) - [0; 0; 0; 1] * Controller.F2)
eig(diag([1, 1, 1], 1) - [0; 0; 0; 1] * Controller.F3)
eig(diag(1, 1) - [0; 1] * Controller.F4)
Controller.type = "FTC";
% Controller.name = "hlc";

%assignin('base',"Controller",Controller);

%% FTCのz方向サブシステムの入力の3階微分まで求める関数Vzftを作成
%刻み時間を変えるときは生成し直す
% syms zF [2 4]
%  syms z(t)
%  syms sz1 [2 1] real
%             u = 0; du = 0; ddu = 0; dddu = 0;
%             for i=1:2
%             ub(i) = -zF(i,1).*tanh(zF(i,2).*z(t)).*sqrt(z(t).^2 + zF(i,3)).^zF(i,4);
%             dub(i) = diff(ub(i), t);
%             ddub(i) = diff(dub(i), t);
%             dddub(i) = diff(ddub(i), t);
%             end
% 
%             for i = 1:2
%                 u = u + subs(ub(i), z, sz1(i));
%             end
%                        dz = Ad1*sz1 + Bd1*u;
%             for i = 1:2
%                 du = du + subs(dub(i), [diff(z, t) z], [dz(i) sz1(i)]);
%             end
%                        ddz = Ad1*dz + Bd1*du;
%             for i = 1:2
%                 ddu = ddu + subs(ddub(i), [diff(z, t, 2)  diff(z, t) z], [ddz(i)  dz(i) sz1(i)]);
%             end
%                        dddz = Ad1*ddz + Bd1*ddu;
%             for i = 1:2
%                 dddu = dddu + subs(dddub(i), [diff(z, t, 3) diff(z, t, 2)  diff(z, t) z], [dddz(i) ddz(i)  dz(i) sz1(i)]);
%             end
% 
%         matlabFunction([u, du, ddu, dddu],'file','Vzft.m', "Vars", {zF, sz1},'outputs',{'Vftc'});
%% FTCのz方向サブシステム+servoの入力の3階微分まで求める関数Vzftを作成
%刻み時間を変えるときは生成し直す
% syms zF [2 4]
% syms g
%  syms z(t)
%  syms sz1 [3 1] real
%  dt =0.025;
%  Ac2 = [0, 1; 0, 0];
% Bc2 = [0; 1];
%  Cc2 = [1 0];
% [Ad1,Bd1,~,~] = ssdata(c2d(ss(Ac2,Bc2,Cc2,0),dt));
% Ad1 = [Ad1,zeros(2,1);-Cc2,1];
% Bd1 = [Bd1;0];
% 
%             u = 0; du = 0; ddu = 0; dddu = 0;
%             for i=1:2
%             ub(i) = -zF(i,1).*tanh(zF(i,2).*z(t)).*sqrt(z(t).^2 + zF(i,3)).^zF(i,4) ;
%             dub(i) = diff(ub(i), t);
%             ddub(i) = diff(dub(i), t);
%             dddub(i) = diff(ddub(i), t);
%             end
% 
%             for i = 1:2
%                 u = u + subs(ub(i), z, sz1(i));
%             end
%                 u = u-g*sz1(3);
%                        dz = Ad1*sz1 + Bd1*u;
%             for i = 1:2
%                 du = du + subs(dub(i), [diff(z, t) z], [dz(i) sz1(i)]);
%             end
%                du = du-g*dz(3);        
%                        ddz = Ad1*dz + Bd1*du;
%             for i = 1:2
%                 ddu = ddu + subs(ddub(i), [diff(z, t, 2)  diff(z, t) z], [ddz(i)  dz(i) sz1(i)]);
%             end
%                 ddu = ddu - g*ddz(3);
%                        dddz = Ad1*ddz + Bd1*ddu;
%             for i = 1:2
%                 dddu = dddu + subs(dddub(i), [diff(z, t, 3) diff(z, t, 2)  diff(z, t) z], [dddz(i) ddz(i)  dz(i) sz1(i)]);
%             end
%                 dddu = dddu - g*dddz(3);
% 
%         matlabFunction([u, du, ddu, dddu],'file','Vzft_srv.m', "Vars", {zF, sz1,g},'outputs',{'Vftc_srv'});
end