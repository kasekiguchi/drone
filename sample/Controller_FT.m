function Controller = Controller_FT(dt,fxy,fcf)
%% flag and approximate range
            fApproxXY =fxy;%xy方向を近似する: 1 else:~1 
            fConfirmFig = fcf;%近似入力のfigureを確認するか
            alp = [0.8,0.8,0.8,0.85];%alphaの値 0.85より大きくないと吹っ飛ぶ恐れがある.

            %1.近似範囲を決める2.a,bで調整(bの大きさを大きくするとFTからはがれにくくなる．aも同様だがFT,LSの近似範囲を見て調整)
            %zを近似する
            x0 = [50, 0.01];
            r=0.02;%緩和区間
            ar = [1, 1];%近似に使う区間
            br=[1.8,1.6];%制約の大きさ, 最小は0
            
            %xyを近似する場合
            %x方向
            x0xy = [50, 0.01];
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
%z方向FTCの近似
fconstz=0;
fexist_z=exist('appox_FTC_param_z.mat','file');%近似のパラメータが保存されているのか
if fexist_z
    load('appox_FTC_param_z.mat','params_z');
    fconstz = ~isequal([params_z.r, params_z.a, params_z.b,params_z.alp'],[r,ar,br,az']);%現在の制約条件とalphaの値とloadしたものが同じか
end
if fexist_z==0 || fconstz %保存されていないまたはloadしたものと違う場合
    params_z = FTC.approx_FTC_param(ar,br,r,vF1,az,x0,"z");%新しいパラメータを計算
    filename="appox_FTC_param_z.mat";
    save(filename,"params_z");%パラメータを保存
    whos("-file",filename);
elseif fConfirmFig ==1
    FTC.confirmParam(vF1,params_z.p,az,"z");%近似した入力を確認, パラメータが新しく作成される場合は実行されない
end
%xy方向FTCの近似
if fApproxXY
    %x方向
    fconstx=0;
    fexist_x=exist('appox_FTC_param_x.mat','file');%近似のパラメータが保存されているのか
    if fexist_x
    load('appox_FTC_param_x.mat','params_x');
    fconstx = ~isequal([params_x.r, params_x.a, params_x.b, params_x.alp'],[rx,arx,brx,ax']);%現在の制約条件とalphaの値とloadしたものが同じか
    end
    if fexist_x==0 || fconstx
        params_x = FTC.approx_FTC_param(arx,brx,rx,vF2,ax,x0xy,"x");%新しいパラメータを計算
        filename="appox_FTC_param_x.mat";
        save(filename,"params_x");%パラメータを保存
        whos("-file",filename);
    elseif fConfirmFig ==1
        FTC.confirmParam(vF2,params_x.p,ax,"x");%近似した入力を確認 パラメータが新しく作成される場合は実行されない
    end
    %y方向
    fconsty=0;
    fexist_y=exist('appox_FTC_param_y.mat','file');%近似のパラメータが保存されているのか
    if fexist_y
    load('appox_FTC_param_y.mat','params_y');
    fconsty = ~isequal([params_y.r, params_y.a, params_y.b, params_y.alp'],[ry,ary,bry,ay']);%現在の制約条件とalphaの値とloadしたものが同じか
    end
    if fexist_y==0 || fconsty
        params_y = FTC.approx_FTC_param(ary,bry,ry,vF3,ay,x0xy,"y");%新しいパラメータを計算
        filename="appox_FTC_param_y.mat";
        save(filename,"params_y");%パラメータを保存
        whos("-file",filename);
    elseif fConfirmFig ==1
        FTC.confirmParam(vF3,params_y.p,ay,"y");%近似した入力を確認 パラメータが新しく作成される場合は実行されない
    end
end
%% 二層
syms sz2 [4 1] real
syms sz3 [4 1] real
syms sz4 [2 1] real
if fApproxXY 
    %xy方向を近似
    Controller.Vs = matlabFunction([-vF2 * (tanh(params_x.p(:,1).*sz2).*sqrt(params_x.p(:,2)+sz2.^2).^ax); -vF3 * (tanh(params_y.p(:,1).*sz3).*sqrt(params_y.p(:,2)+sz3.^2).^ay); -vF4 * (sign(sz4).*abs(sz4).^apsi)], "Vars", {sz2, sz3, sz4});
else
    %近似しない
    Controller.Vs = matlabFunction([-vF2 * (sign(sz2).*abs(sz2).^ax); -vF3 * (sign(sz3).*abs(sz3).^ay); -vF4 * (sign(sz4).*abs(sz4).^apsi)], "Vars", {sz2, sz3, sz4});
end
%%
Controller.approx_z = params_z.p;%近似パラメータ
Controller.dt = dt;
eig(diag(1, 1) - [0; 1] * Controller.F1)
eig(diag([1, 1, 1], 1) - [0; 0; 0; 1] * Controller.F2)
eig(diag([1, 1, 1], 1) - [0; 0; 0; 1] * Controller.F3)
eig(diag(1, 1) - [0; 1] * Controller.F4)
Controller.type = "FTC";
% Controller.name = "hlc";

%assignin('base',"Controller",Controller);

%% FTCのz方向サブシステムの入力の3階微分まで求める関数Vzftを作成
% syms zF [2 4]
%  syms z(t)
%  syms sz1 [2 1] real
%             %matlabfunctionにしてもいいかも matlabFunction([u, du, ddu, dddu], "Vars", {sz1,vF1(i),p,alpha(i)});
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
end
