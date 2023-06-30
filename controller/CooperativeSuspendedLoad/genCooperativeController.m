% generate controller for cooperative suspended load system
clear
clc
% 以下の論文に基づくコントローラ
% Geometric Control of Multiple Quadrotor UAVs Transporting a Cable-Suspended Rigid Body
% https://ieeexplore.ieee.org/document/7040353
% 軸の取り方に注意
% e3 = [0;0;1]; % 鉛直下向き zup : 鉛直上向き
dir = "controller/CooperativeSuspendedLoad/";
%% symbol定義
N = 3; % エージェント数
% 牽引物に関する変数定義 %%%%%%%%%%%%%%%%%%%%
syms x0 [3 1] real % 位置
syms dx0 [3 1] real
syms ddx0 [3 1] real
syms r0 [4 1] real % 姿勢角（オイラーパラメータ）
syms o0 [3 1] real % 角速度
syms do0 [3 1] real
syms qi [N 3] real % リンクのドローンから見た方向ベクトル：論文中qi
qi = qi';
syms wi [N 3] real % リンクの角速度
wi = wi';
syms dwi [N 3] real
dwi = dwi';

% ドローンに関する変数定義 %%%%%%%%%%%%%%%%%%
syms ri [N 4] real % 姿勢角（オイラーパラメータ）
ri = ri';
syms oi [N 3] real % 角速度
oi = oi';
syms fi [1 N] real % 推力入力
syms Mi [N 3] real % モーメント入力
Mi = Mi';
%% 牽引物の物理パラメータ %%%%%%%%%%%%%%%%%%%
syms g real % 重力加速度
syms m0 real % 質量
syms j0 [3 1] real % 慣性モーメント
syms rho [N 3] real % 牽引物座標系でのリンク接続位置：第i列がi番目のドローンとの接続位置
rho = rho';
syms li [1 N] real % リンク長
% ドローンの物理パラメータ %%%%%%%%%%%%%%%%%%%
syms mi [1 N] real % 質量
syms ji [N 3] real % 慣性モーメント
ji = ji';
physicalParam = [g m0 j0' reshape(rho,1, 3*N) li mi reshape(ji,1,3*N)];
%% 参照軌道 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms x0d [3 1] real
syms dx0d [3 1] real
syms ddx0d [3 1] real
syms dddx0d [3 1] real
syms r0d [4 1] real % 姿勢角（オイラーパラメータ）
syms o0d [3 1] real % 角速度
syms do0d [3 1] real
%%
[R0,L0] = RodriguesQuaternion(r0); % 牽引物回転行列
tmp = mat2cell(ri,4,ones(1,N));
[Ri,Li] = arrayfun(@(q) RodriguesQuaternion(q{:}),tmp,'UniformOutput',false); % ドローン姿勢回転行列
O0 = Skew(o0); % 牽引物の角速度行列（歪対象行列）
tmp = mat2cell(oi,3,ones(1,N));
Oi = arrayfun(@(o) Skew(o{:}),tmp,'UniformOutput',false); % ドローン角速度行列
J0 = diag(j0); % 牽引物の慣性行列
tmp = mat2cell(ji,3,ones(1,N));
Ji = arrayfun(@(j) diag(j{:}),tmp,'UniformOutput',false); % ドローン慣性行列
e3 = [0;0;1]; %
Rho = arrayfun(@(i) Skew(rho(:,i)),1:N,'UniformOutput',false); % rho の歪対称化
Qi = arrayfun(@(i) Skew(qi(:,i)),1:N,'UniformOutput',false); % qi の歪対称化
%% 状態：
% 牽引物: 位置，姿勢角，速度，角速度， : 13
% リンク: 角度，角速度 : N x 6
% ドローン:姿勢角，角速度
x = [x0;r0;dx0;o0;reshape([qi,wi],6*N,1);reshape(ri,4*N,1);reshape(oi,3*N,1)];
%%
b3 = -ui./vecnorm(ui,1);
b1 = dx0d;

%Ric = ;
%dRic = ;
oic = cellmatfun(@(rc,i) Vee(rc'*dRic{i}),Ric,"mat");
%doic = ;
RiTRic=arrayfun(@(i) quat_times_vec(ri(:,i).*[1;-1;-1;-1],Ric{i}),1:N,'UniformOutput',false);
eri = Vee(RiTRic'-RiTRic)/2;
RiTRicoic = cellmatfun(@(R,i) R*oic(:,i),RiTRic,"mat");
eoi = oi - RiTRicoic;
%%
fi = -sum(ui.*quat_times_vec(ri,e3),1);
Mi = - kr*eri/(e^2) - ko*eoi/2 + cross(oi,ji.*oi) - ji.*(cross(oi,RiTRicoic)-cellmatfun(@(R,i) R*doic(:,i),RiTRic,"mat"));

%%
syms X [13*(N+1) 1] real
syms Xd [3*4+4+6 1] real
matlabFunction(subs(reshape([fi;Mi],[],1),[x;x0d;dx0d;ddx0d;dddx0d;r0d;o0d;do0d],[X;Xd]),"file",dir+"Uvec_CSLC_"+N+".m","Vars",{X,Xd,physicalParam});