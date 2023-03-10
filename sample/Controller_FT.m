function Controller = Controller_FT(dt)
%% flag and approximate range
            fApproxZ = 10;%z方向に適用するか:1 else:~1 Approximate Zdirection subsystem
            fApproxXY = 10;%%%xy近似するか:1 else:~1
            %FTは誤差が大きいとxyのみに適用でも発散するので想定する誤差に合わせてalphaを調整する必要がある
            alp = 0.9;%alphaの値 0.85より大きくないと吹っ飛ぶ恐れがある.
            approxRangeZ=[0 1];%近似する範囲z
            approxRangeXY=[0 1];%近似する範囲xy
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
Ac2 = [0, 1; 0, 0];
Bc2 = [0; 1];
Ac4 = diag([1, 1, 1], 1);
Bc4 = [0; 0; 0;1];
Controller_param.F1 = lqrd(Ac2, Bc2, diag([100, 1]), [0.1], dt); 
Controller_param.F2 = lqrd(Ac4, Bc4, diag([100, 10, 10, 1]), [0.01], dt); % xdiag([100,10,10,1])
Controller_param.F3 = lqrd(Ac4, Bc4, diag([100, 10, 10, 1]), [0.01], dt); % ydiag([100,10,10,1])
Controller_param.F4 = lqrd(Ac2, Bc2, diag([100, 10]), [0.1], dt); % ヨー角

%approxi.と一緒の極
% Controller_param.F1 = place(Ac2,Bc2,[-1.1283, -7.3476]);%appと同じgain
% Controller_param.F2 = place(Ac4,Bc4,[-37.6509 ,-1.3739 + 1.4255i,-1.3739 - 1.4255i,-0.7037]);%appと同じgain
% Controller_param.F3 = place(Ac4,Bc4,[-51.4247 ,-1.3739 + 1.4255i,-1.3739 - 1.4255i,-0.7037]);%appと同じgain
% Controller_param.F4 = place(Ac2,Bc2,[-1.0864,-27.0167]);%appと同じgain

syms sz1 [2 1] real
syms sF1 [1 2] real
[Ad1, Bd1, ~, ~] = ssdata(c2d(ss(Ac2, Bc2, [1, 0], [0]), dt));
%入力を近似しない場合はLSの入力を使う
if fApproxZ~= 1
    Controller_param.Vf = matlabFunction([-sF1 * sz1, -sF1 * (Ad1 - Bd1 * sF1) * sz1, -sF1 * (Ad1 - Bd1 * sF1)^2 * sz1, -sF1 * (Ad1 - Bd1 * sF1)^3 * sz1], "Vars", {sz1, sF1});
end
%% 入力のalphaを計算

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
%% 有限整定の近似微分　一層
syms k [1 2] real
Controller_param.fzapr = fApproxZ;

if fApproxZ == 1
    u = 0; du = 0; ddu = 0; dddu = 0;
    syms zF1 [1 3]
        xz0 = [2, 2, 2];
        fvals12z = zeros(2, 1);
        f1 = zeros(2, 3);
        %z,dzの入力の項のパラメータを計算
        for i = 1:2
            fun = @(x)(integral(@(e) abs(-k(i) * abs(e).^alpha(i) + x(1) * tanh(x(2) * e) + x(3) * e), approxRangeZ(1), approxRangeZ(2)));
            [x, fval] = fminsearch(fun, xz0);
            fvals12z(i) = 2 * fval;%元の入力との誤差
            f1(i, :) = x;%パラメータを格納
        end
%入力の微分を計算
            ub =- zF1(1) * tanh(zF1(2) * z(t)) - zF1(3) * z(t);
            dub = diff(ub, t);
            ddub = diff(dub, t);
            dddub = diff(ddub, t);
          
            for i = 1:2
                u = u + subs(ub, [zF1 z], [f1(i, :) sz1(i)]);
            end
                       dz = Ad1*sz1 + Bd1*u;
            for i = 1:2
                du = du + subs(dub, [zF1 diff(z, t) z], [f1(i, :) dz(i) sz1(i)]);
            end
                       ddz = Ad1*dz + Bd1*du;
            for i = 1:2
                ddu = ddu + subs(ddub, [zF1 diff(z, t, 2)  diff(z, t) z], [f1(i, :) ddz(i)  dz(i) sz1(i)]);
            end
                       dddz = Ad1*ddz + Bd1*ddu;
            for i = 1:2
                dddu = dddu + subs(dddub, [zF1 diff(z, t, 3) diff(z, t, 2)  diff(z, t) z], [f1(i, :) dddz(i) ddz(i)  dz(i) sz1(i)]);
            end

        Controller_param.Vf = matlabFunction([u, du, ddu, dddu], "Vars", {sz1});%入力の微分を関数にする
end

%% 二層
syms sz2 [4 1] real
syms sF2 [1 4] real
syms sz3 [4 1] real
syms sF3 [1 4] real
syms sz4 [2 1] real
syms sF4 [1 2] real
Controller_param.Vs = matlabFunction([-sF2 * sz2; -sF3 * sz3; -sF4 * sz4], "Vars", {sz2, sz3, sz4, sF2, sF3, sF4});

%% x,y方向サブシステムの近似のパラメータ
kf2 = Controller_param.F2;
Controller_param.fxyapr = fApproxXY;
gain_ser1 = zeros(4, 3);

if fApproxXY == 1%近似する場合
        %fminserch tanh 1つ
        x0 = [2, 2, 2];
        fvals12 = zeros(4, 1);
        gain_ser1 = zeros(4, 3);

        for i = 1:4
            fun = @(x)(integral(@(e) abs(-1 * kf2(i) * abs(e).^alpha(i) + x(1) * tanh(x(2) * e) + x(3) * e), approxRangeXY(1), approxRangeXY(2)));
            options = optimset('MaxFunEvals', 1e5);
            [x, fval] = fminsearch(fun, x0, options);
            fvals12(i) = 2 * fval;
            gain_ser1(i, :) = x; % gain_ser1(4,2)["f1", "a1"] * [x; dx; ddx; dddx]
        end
end
Controller_param.gain1 = gain_ser1;
%%
Controller_param.dt = dt;
eig(diag(1, 1) - [0; 1] * Controller_param.F1)
eig(diag([1, 1, 1], 1) - [0; 0; 0; 1] * Controller_param.F2)
eig(diag([1, 1, 1], 1) - [0; 0; 0; 1] * Controller_param.F3)
eig(diag(1, 1) - [0; 1] * Controller_param.F4)
Controller.type = "FTC";
% Controller.name="ftc";%hlcでもいい
Controller.name = "hlc";
Controller.param = Controller_param;

%assignin('base',"Controller_param",Controller_param);

end
