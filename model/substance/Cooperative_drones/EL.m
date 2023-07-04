clear
clc
% 以下の論文に基づくモデル化
% Geometric Control of Multiple Quadrotor UAVs Transporting a Cable-Suspended Rigid Body
% https://ieeexplore.ieee.org/document/7040353
% 軸の取り方に注意
% e3 = [0;0;1]; % 鉛直下向き
dir = "model/substance/Cooperative_drones/";
N = 3; % エージェント数

%% symbol定義
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
syms R0 [3 3] real
syms Ri [3 3 N] real

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
%%
[~,L0] = RodriguesQuaternion(r0); % 牽引物回転行列
[~,Li] = RodriguesQuaternion(ri);
O0 = Skew(o0); % 牽引物の角速度行列（歪対象行列）
Oi = arrayfun(@(i) Skew(oi(:,i)),1:N,'UniformOutput',false); % ドローン角速度行列
J0 = diag(j0); % 牽引物の慣性行列
Ji = arrayfun(@(i) diag(ji(:,i)),1:N,'UniformOutput',false); % ドローン慣性行列
e3 = [0;0;1]; %
Rho = arrayfun(@(i) Skew(rho(:,i)),1:N,'UniformOutput',false); % rho の歪対称化
Qi = arrayfun(@(i) Skew(qi(:,i)),1:N,'UniformOutput',false); % qi の歪対称化
%% 状態：
% 牽引物: 位置，姿勢角，速度，角速度， : 13
% リンク: 角度，角速度 : N x 6
% ドローン:姿勢角，角速度
x = [x0;r0;dx0;o0;reshape([qi,wi],6*N,1);reshape(ri,4*N,1);reshape(oi,3*N,1)];
 % 13 + 13 * N states
u = reshape([fi;Mi],4*N,1);
%%
syms dqi [3 N] real
rT = 0;
for i = 1:N
rT = rT + mi(i)*(dx0+(R0'*O0)*rho(:,i)-li(i)*dqi(:,i))'*(dx0+(R0'*O0)*rho(:,i)-li(i)*dqi(:,i))/2 + oi(:,i)'*Ji{i}*oi(:,i)/2;
rU = mi(i)*g*e3'*(x0 + R0*rho(:,i)-li(i)*qi(:,i));
end
T = m0*dx0'*dx0/2 + o0'*J0*o0/2 + rT;
U = -m0*g*x0(3) - rU;
L = T-U;
%%


