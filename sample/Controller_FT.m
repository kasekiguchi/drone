% function Controller = Controller_FT(dt, fApproxZ, fTanh1Z, fApproxXY, fTanh1XY, alp, approxRangeZ, approxRangeXY)
function Controller = Controller_FT(dt)
%% flag and approximate range
            fApproxZ = 1;%z方向に適用するか:1 else:~1 Approximate Zdirection subsystem
            fTanh1Z = 1;%tanhが一つか:1 tanh2:~1
            fApproxXY = 10;%%%xy近似するか:1 else:~1
            fTanh1XY = 1;%%% tanh1:1 or tanh2 :~1
            %FTは誤差が大きいとxyのみに適用でも発散するので想定する誤差に合わせてalphaを調整する必要がある
            alp = 0.85;%alphaの値 0.85より大きくないと吹っ飛ぶ恐れがある.
            approxRangeZ=[0 1];%近似する範囲z
            approxRangeXY=[0 1];%近似する範囲xy
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
Ac2 = [0, 1; 0, 0];
Bc2 = [0; 1];
Ac4 = diag([1, 1, 1], 1);
Bc4 = [0; 0; 0;1];
Controller_param.F1 = lqrd(Ac2, Bc2, diag([100, 1]), [0.1], dt);
% Controller_param.F1 = lqrd(Ac2, Bc2, diag([1000, 1]), [0.1], dt);
% if fexpand
%     Controller_param.F1 = lqrd(Ac4, Bc4, diag([500, 10, 10, 1]), [0.01], dt);
% end

% Controller_param.F1 = place(Ac2,Bc2,[-8.2518 + 4.9876i,-8.2518 - 4.9876i]);%近似線形化と同じ極
% 有限整定用
Controller_param.F2 = lqrd(Ac4, Bc4, diag([100, 10, 10, 1]), [0.01], dt); % xdiag([100,10,10,1])
Controller_param.F3 = lqrd(Ac4, Bc4, diag([100, 10, 10, 1]), [0.01], dt); % ydiag([100,10,10,1])
%併用
% Bcm = [0; 0; 0; 2];
% Controller_param.F2 = lqrd(Ac4, Bcm, diag([100, 10, 10, 1]), [0.01], dt); % xdiag([100,10,10,1])
% Controller_param.F3 = lqrd(Ac4, Bcm, diag([100, 10, 10, 1]), [0.01], dt); % ydiag([100,10,10,1])

% Controller_param.F2(1)=Controller_param.F2(1)*1.5;
% Controller_param.F3(1)=Controller_param.F3(1)*1.5; 
Controller_param.F4 = lqrd(Ac2, Bc2, diag([100, 10]), [0.1], dt); % ヨー角

%approと一緒の極
% Controller_param.F1 = place(Ac2,Bc2,[-1.1283, -7.3476]);%appと同じgain
% Controller_param.F2 = place(Ac4,Bc4,[-37.6509 ,-1.3739 + 1.4255i,-1.3739 - 1.4255i,-0.7037]);%appと同じgain
% Controller_param.F3 = place(Ac4,Bc4,[-51.4247 ,-1.3739 + 1.4255i,-1.3739 - 1.4255i,-0.7037]);%appと同じgain
% Controller_param.F4 = place(Ac2,Bc2,[-1.0864,-27.0167]);%appと同じgain

syms sz1 [2 1] real
syms sF1 [1 2] real
[Ad1, Bd1, ~, ~] = ssdata(c2d(ss(Ac2, Bc2, [1, 0], [0]), dt));
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
    syms fza [1 2] real
    syms tanha [1 2] real
    syms dtanha [1 2] real
    syms ddtanha [1 2] real
    syms dddtanha [1 2] real

    syms z(t) ub
    syms zF1 [1 3]
    syms zF1 [1 4]%------------------------------------

    if fTanh1Z == 1
        xz0 = [2, 2, 2];
        fvals12z = zeros(2, 1);
        f1 = zeros(2, 3);

        xz0 = [50, 0.01];%------------------------------------
        f1 =zeros(2,4);%------------------------------------
%         b=[5,3];
        b=[1.6,1.5];
        %alhpa=0.8 rang=0.05:[4.5,2.5]/rang=0.01:[6,4.8]
        %alpha=0.85rng=0.01[5,3]
        k = Controller_param.F1;
        %         erz=0.4; %近似する範囲を指定
        for i = 1:2
%             fun = @(x)(integral(@(e) abs(-k(i) * abs(e).^alpha(i) + x(1) * tanh(x(2) * e) + x(3) * e), approxRangeZ(1), approxRangeZ(2)));
% % fun = @(x)(integral(@(e) abs(-k(i) * abs(e).^alpha(i) + x(1) * tanh(x(2) * e) + k(i) * e), approxRangeZ(1), approxRangeZ(2)));%比例固定
%              [p, fval] = fminsearch(fun, xz0);

             %tanh absolute-----------------
             %1.近似範囲を決める2.a,bで調整(bの大きさを大きくするとFTからはがれにくくなる．aも同様だがFT,LSの近似範囲を見て調整)
             rng = 0.02;
            fun=@(x)(integral(@(w) abs( -k(i).*abs(w).^alpha(i) + k(i).*tanh(x(1).*w).*sqrt(w.^2 + x(2)).^alpha(i)), rng,rng+1) +integral(@(w) abs( k(i).*w-k(i).*tanh(x(1).*w).*sqrt(w.^2 + x(2)).^alpha(i)), 0,rng));
            c =@(x)0;
            ceq = @(x) 1 - x(1).*x(2).^(alpha(i)./2)+b(i);
            nonlinfcn = @(x)deal(c(x),ceq(x));
            
            options = optimoptions("fmincon",...
                "Algorithm","interior-point",...
                "EnableFeasibilityMode",true,...
                "SubproblemAlgorithm","cg");
            % [p,fval] = fmincon(fun,x0,[],[],[],[],[0,1E-4*0],[inf,1]) 
            [p,fval] = fmincon(fun,xz0,[],[],[],[],[0,0],[inf,inf],nonlinfcn,options) 
             % ----------------------------

            
            fvals12z(i) = 2 * fval;
%             f1(i, :) = p;
%             f1(i, :) = [x,k(i)];%比例固定
            f1(i, :) = [k(i),p,alpha(i)];%------------------------------------
        end
%sigmoidを使う,こっちの方が計算は早い感じ
%             for i = 1:2
%                 fza(i) = 1 / (1 + exp(-f1(i, 2) * 2 * sz1(i)));
%                 tanha(i) = 2 * fza(i) - 1;
%                 dtanha(i) = 4 * f1(i, end - 1) * fza(i) * (1 - fza(i));
%                 ddtanha(i) = 8 * f1(i, end - 1)^2 * fza(i) * (1 - fza(i)) * (1 - 2 * fza(i));
%                 dddtanha(i) = 16 * f1(i, end - 1)^3 * fza(i) * (1 - fza(i)) * (1 - 6 * fza(i) + 6 * fza(i)^2);
% 
%             end
% 
%             for i = 1:2
%                 u = u -f1(i, 1) * tanha(i) -f1(i, 3) * sz1(i);
%             end
% 
%             dz = Ad1 * sz1 + Bd1 * u;
% 
%             for i = 1:2
%                 du = du -f1(i, 1) * dtanha(i) * dz(i) -f1(i, 3) * dz(i);
%             end
% 
%             ddz = Ad1 * dz + Bd1 * du;
% 
%             for i = 1:2
%                 ddu = ddu -f1(i, 1) * ddtanha(i) * (dz(i))^2 -f1(i, 1) * dtanha(i) * ddz(i) -f1(i, 3) * ddz(i);
%             end
% 
%             dddz = Ad1 * ddz + Bd1 * ddu;
% 
%             for i = 1:2
%                 dddu = dddu -f1(i, 1) * dddtanha(i) * (dz(i))^3 -3 * f1(i, 1) * ddtanha(i) * dz(i) * ddz(i) -f1(i, 1) * dtanha(i) * dddz(i) -f1(i, 3) * dddz(i);
%             end

%diffを用いた===========================================
%             ub =- zF1(1) * tanh(zF1(2) * z(t)) - zF1(3) * z(t);
%                x = [100,1E-9;80,1E-9];%------------------------------------手動
%             for i =1:2
%                 f1(i, :) = [k(i),x(i,:),alpha(i)];
%             end
            ub = -zF1(1).*tanh(zF1(2).*z(t)).*sqrt(z(t).^2 + zF1(3)).^zF1(4);%------------------------------------
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

        Controller_param.Vf = matlabFunction([u, du, ddu, dddu], "Vars", {sz1});
%     else
%         xz0 = [7, 10, 2, 100];
%         fvals22z = zeros(4, 1);
%         f2 = zeros(2, 4);
%         k = Controller_param.F1;
%         er = 1; %近似する範囲を指定 0.8 以上でないと近似精度高すぎで止まる．入力負になる
% 
%         for i = 1:2
%             fun = @(x)(integral(@(e) abs(-k(i) * abs(e).^alpha(i) + x(1) * tanh(x(2) * e) + x(3) * tanh(x(4) * e) + k(i) * e), 0, er));
%             options = optimset('MaxFunEvals', 1e5);
%             [x, fval] = fminsearch(fun, xz0, options);
%             fvals22z(i) = 2 * fval;
%             f2(i, :) = x; % gain_ser2(4*4)["f1", "a1", "f2", "a2"] * [x; dx; ddx; dddx]
% 
%         end
% 
%         for i = 1:2
%             fza(i) = 1 / (1 + exp(-f2(i, 2) * 2 * sz1(i)));
%             tanha(i) = 2 * fza(i) - 1;
%             dtanha(i) = 4 * f2(i, 2) * fza(i) * (1 - fza(i));
%             ddtanha(i) = 8 * f2(i, 2)^2 * fza(i) * (1 - fza(i)) * (1 - 2 * fza(i));
%             dddtanha(i) = 16 * f2(i, 2)^3 * fza(i) * (1 - fza(i)) * (1 - 6 * fza(i) + 6 * fza(i)^2);
% 
%             fzb = 1 / (1 + exp(-f2(i, 4) * 2 * sz1(i)));
%             tanhb = 2 * fzb - 1;
%             dtanhb = 4 * f2(i, 4) * fzb * (1 - fzb);
%             ddtanhb = 8 * f2(i, 4)^2 * fzb * (1 - fzb) * (1 - 2 * fzb);
%             dddtanhb = 16 * f2(i, 4)^3 * fzb * (1 - fzb) * (1 - 6 * fzb + 6 * fzb^2);
% 
%             u = u -f2(i, 1) * tanha(i) -f2(i, 3) * tanhb -k(i) * sz1(i);
%             dz = Ad1 * sz1 + Bd1 * u;
%             du = du -f2(i, 1) * dtanha(i) * f2(i, 2) * dz(i) -f2(i, 3) * dtanhb * f2(i, 4) * dz(i) -k(i) * dz(i);
%             ddz = Ad1 * dz + Bd1 * du;
%             ddu = ddu -f2(i, 1) * ddtanha(i) * (f2(i, 2) * dz(i))^2 -f2(i, 3) * ddtanhb * (f2(i, 4) * dz(i))^2 -f2(i, 1) * dtanha(i) * f2(i, 2) * ddz(i) -f2(i, 3) * dtanhb * f2(i, 4) * ddz(i) -k(i) * ddz(i);
%             dddz = Ad1 * ddz + Bd1 * ddu;
%             dddu = dddu -f2(i, 1) * dddtanha(i) * (f2(i, 2) * dz(i))^3 -f2(i, 3) * dddtanhb * (f2(i, 4) * dz(i))^3 -3 * f2(i, 1) * ddtanha(i) * f2(i, 2)^2 * dz(i) * ddz(i) -3 * f2(i, 3) * dtanhb * f2(i, 4)^2 * dz(i) * ddz(i) -f2(i, 1) * dtanha(i) * f2(i, 2) * dddz(i) -f2(i, 3) * dtanhb * f2(i, 4) * dddz(i) - k(i) * dddz(i);
% 
%         end
% 
%         Controller_param.Vf = matlabFunction([u, du, ddu, dddu], "Vars", {sz1});
    end
end

%% 二層
syms sz2 [4 1] real
syms sF2 [1 4] real
syms sz3 [4 1] real
syms sF3 [1 4] real
syms sz4 [2 1] real
syms sF4 [1 2] real
Controller_param.Vs = matlabFunction([-sF2 * sz2; -sF3 * sz3; -sF4 * sz4], "Vars", {sz2, sz3, sz4, sF2, sF3, sF4});

%% 再現実験
% Controller_param.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),[0.1],dt);                                % z
% Controller_param.F2=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,100,10,1]),[0.01],dt); % xdiag([100,10,10,1])
% Controller_param.F3=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,100,10,1]),[0.01],dt); % ydiag([100,10,10,1])
% Controller_param.F4=lqrd([0 1;0 0],[0;1],diag([100,10]),[0.1],dt);
% % 極配置
% Eig=[-3.2,-2,-2.5,-2.1];
% Controller_param.F1=lqrd([0 1;0 0],[0;1],diag([10,1]),[1],dt);                                % z
% % Controller_param.F2=place(diag([1,1,1],1),[0;0;0;1],Eig);
% % Controller_param.F3=place(diag([1,1,1],1),[0;0;0;1],Eig);
% Controller_param.F4=lqrd([0 1;0 0],[0;1],diag([100,1]),[1],dt);                       % ヨー角

%% 近似のパラメータ
% fxyapr=1;%%%近似するか
% faprxm1=1;%%% tanh1 or tanh2

kf2 = Controller_param.F3;
% kf2(1)=3*kf2(1);
Controller_param.fxyapr = fApproxXY;
gain_ser1 = zeros(4, 3);
gain_ser2 = zeros(4, 5);

if fApproxXY == 1

    if fTanh1XY == 1
        %fminserch tanh 1つ
        x0 = [2, 2, 2];
        fvals12 = zeros(4, 1);
        %     er=0.1; %近似する範囲を指定
        gain_ser1 = zeros(4, 3);
        ee = approxRangeXY;

        for i = 1:4
            %         if i==5
            %             erxy=[0.2 0.3];
            %         else
            %             erxy=ee;
            %         end
            %         fun=@(x)(integral(@(e) abs( -kf2(i)*abs(e).^alpha(i) + x(1)*tanh(x(2)*e) + kf2(i)*e ) ,erxy(1), erxy(2)));
            fun = @(x)(integral(@(e) abs(-1 * kf2(i) * abs(e).^alpha(i) + x(1) * tanh(x(2) * e) + x(3) * e), approxRangeXY(1), approxRangeXY(2)));
            options = optimset('MaxFunEvals', 1e5);
            [x, fval] = fminsearch(fun, x0, options);
            fvals12(i) = 2 * fval;
            gain_ser1(i, :) = x; % gain_ser1(4*2)["f1", "a1"] * [x; dx; ddx; dddx]
        end

    else
        %fminserch tanh 2つ
        x0 = [5, 5, 5, 5];
        fvals22 = zeros(4, 1);
        %     er=0.4; %近似する範囲を指定
        gain_ser2 = zeros(4, 4);

        for i = 1:4
            fun = @(x)(integral(@(e) abs(-kf2(i) * abs(e).^alpha(i) + x(1) * tanh(x(2) * e) + x(3) * tanh(x(4) * e) + kf2(i) * e), approxRangeXY(1), approxRangeXY(2)));
            options = optimset('MaxFunEvals', 1e5);
            [x, fval] = fminsearch(fun, x0, options);
            fvals22(i) = 2 * fval;
            gain_ser2(i, :) = x; % gain_ser2(4*4)["f1", "a1", "f2", "a2"] * [x; dx; ddx; dddx]
        end

    end

end

Controller_param.gain1 = gain_ser1;
Controller_param.gain2 = gain_ser2;
%%
Controller_param.dt = dt;
eig(diag(1, 1) - [0; 1] * Controller_param.F1)
eig(diag([1, 1, 1], 1) - [0; 0; 0; 1] * Controller_param.F2)
eig(diag([1, 1, 1], 1) - [0; 0; 0; 1] * Controller_param.F3)
eig(diag(1, 1) - [0; 1] * Controller_param.F4)
Controller.type = "FTC";
% Controller.name="ftc";
Controller.name = "hlc";
Controller.param = Controller_param;

%assignin('base',"Controller_param",Controller_param);

end
