% function Controller = Controller_FT(dt, fApproxZ, fTanh1Z, fApproxXY, fTanh1XY, alp, approxRangeZ, approxRangeXY)
function Controller = Controller_FT(dt,fz)
%% flag and approximate range
            fApproxZ = fz;%z方向に適用するか:1 else:~1 Approximate Zdirection subsystem
            alp = [0.85,0.85,0.85,0.85];%alphaの値 0.85より大きくないと吹っ飛ぶ恐れがある.
            x0 = [50, 0.01];
            r=0.02;%緩和区間
            ar = [1, 1];%近似に使う区間
            br=[1.6,1.5];%制約の大きさ最小は0
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
Ac2 = [0, 1; 0, 0];
Bc2 = [0; 1];
Ac4 = diag([1, 1, 1], 1);
Bc4 = [0; 0; 0;1];
Controller.F1 = lqrd(Ac2, Bc2, diag([100, 1]), [0.1], dt);
Controller.F2 = lqrd(Ac4, Bc4, diag([100, 10, 10, 1]), [0.01], dt); % xdiag([100,10,10,1])
Controller.F3 = lqrd(Ac4, Bc4, diag([100, 10, 10, 1]), [0.01], dt); % ydiag([100,10,10,1])
Controller.F4 = lqrd(Ac2, Bc2, diag([100, 10]), [0.1], dt); % ヨー角

vF1 = Controller.F1;
vF2 = Controller.F2;
vF3 = Controller.F3;
vF4 = Controller.F4;
%% 入力のalphaを計算

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
% Controller.az = alpha(3:4, 1);
% Controller.ax = alpha(1:4,2);
% Controller.ay = alpha(1:4,3);
% Controller.apsi = alpha(3:4, 4);
az =Controller.az ;
ax =Controller.ax ;
ay =Controller.ay;
apsi =Controller.apsi;
%%
syms sz1 [2 1] real
[Ad1, Bd1, ~, ~] = ssdata(c2d(ss(Ac2, Bc2, [1, 0], [0]), dt));
Controller.fzapr = fApproxZ;
if fApproxZ~= 1
    %一層
    Controller.Vf = matlabFunction([-vF1 * sz1, -vF1 * (Ad1 - Bd1 * vF1) * sz1, -vF1 * (Ad1 - Bd1 * vF1)^2 * sz1, -vF1 * (Ad1 - Bd1 * vF1)^3 * sz1], "Vars", {sz1});
else
% 有限整定の近似微分　一層   
    syms z(t)
    syms zF1 [1 4]
        f1 =zeros(2,4);
        for i = 1:2
             %tanh absolute
             %1.近似範囲を決める2.a,bで調整(bの大きさを大きくするとFTからはがれにくくなる．aも同様だがFT,LSの近似範囲を見て調整)
            fun=@(x)(integral(@(w) abs( -vF1(i).*abs(w).^az(i) + vF1(i).*tanh(x(1).*w).*sqrt(w.^2 + x(2)).^az(i)), r ,r+ar(i)) +integral(@(w) abs( vF1(i).*w-vF1(i).*tanh(x(1).*w).*sqrt(w.^2 + x(2)).^az(i)), 0, r));
            c =@(x)0;
            ceq = @(x) 1 - x(1).*x(2).^(az(i)./2)+br(i);
            nonlinfcn = @(x)deal(c(x),ceq(x));
            
            options = optimoptions("fmincon",...
                "Algorithm","interior-point",...
                "EnableFeasibilityMode",true,...
                "SubproblemAlgorithm","cg");
            
            [p,fval] = fmincon(fun,x0,[],[],[],[],[0,0],[inf,inf],nonlinfcn,options) 
            fvals12z(i) = 2 * fval%誤差の大きさの確認
            f1(i, :) = [vF1(i),p,az(i)];
        end
        %matlabfunctionにしてもいいかも matlabFunction([u, du, ddu, dddu], "Vars", {sz1,vF1(i),p,alpha(i)});
        u = 0; du = 0; ddu = 0; dddu = 0;
            ub = -zF1(1).*tanh(zF1(2).*z(t)).*sqrt(z(t).^2 + zF1(3)).^zF1(4);
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

        Controller.Vf = matlabFunction([u, du, ddu, dddu], "Vars", {sz1});
end

%% 二層
syms sz2 [4 1] real
syms sz3 [4 1] real
syms sz4 [2 1] real
Controller.Vs = matlabFunction([-vF2 * (sign(sz2).*abs(sz2).^ax); -vF3 * (sign(sz3).*abs(sz3).^ay); -vF4 * (sign(sz4).*abs(sz4).^apsi)], "Vars", {sz2, sz3, sz4});

%%
Controller.dt = dt;
eig(diag(1, 1) - [0; 1] * Controller.F1)
eig(diag([1, 1, 1], 1) - [0; 0; 0; 1] * Controller.F2)
eig(diag([1, 1, 1], 1) - [0; 0; 0; 1] * Controller.F3)
eig(diag(1, 1) - [0; 1] * Controller.F4)
Controller.type = "FTC";
% Controller.name = "hlc";

%assignin('base',"Controller",Controller);

end
