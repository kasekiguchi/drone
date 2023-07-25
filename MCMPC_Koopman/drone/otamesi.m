clear all
close all 
clc

%初期化
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

% load('EstimationResult_12state_6_26_circle.mat','est')
load('drone\MCMPC_Koopman\drone\koopman_data\EstimationResult_12state_7_7_circle=takeoff_estimation=takeoff.mat','est'); %take offをデータセットに含む，入力：GUI
% load('drone\MCMPC_Koopman\drone\koopman_data\EstimationResult_12state_7_20_simulation_circle_InputandConst.mat','est')
% load('drone\MCMPC_Koopman\drone\koopman_data\EstimationResult_12state_7_20_simulation_circle.mat','est')
A = est.A;
B = est.B;
C = est.C;
F = @(x) [x;1];
% a = [B A*B A^2*B A^3*B A^4*B A^5*B A^6*B A^7*B A^8*B A^9*B A^10*B A^11*B A^12*B]
% Co = ctrb(A,B)
% rank(a)
% rank(Co)

%制御対象モデルの定義と各種解析
disp("eig(A) = ");
eig(A) % TODO : 安定性確認
Uc = ctrb(A,B) % TODO : 可制御性確認
%Uc = ctrb(A,b);
rank(Uc)
% c = [1 0];
% Uo = [c;c*A]; % TODO : 可観測性確認
%Uc = obsv(A,c);
% rank(Uo)
% eig(A)
%制御系設計
At = A(1:12,1:12);
Bt = B(1:12,:);
Ct = C(:,1:12);
Q = eye(12);
Q(1,1) = 10;
Q(2,2) = 10;
Q(3,3) = 10;
Q(4,4) = 1000000;
Q(5,5) = 1000000;
Q(6,6) = 1000000;
Q(7,7) = 10;
Q(8,8) = 10;
Q(9,9) = 10;
Q(10,10) = 10000;
Q(11,11) = 10000;
Q(12,12) = 10000;
Q
% 状態フィードバック設計
% f = care(At,Bt,eye(12),1);
f = lqr(At,Bt,Q,eye(4)); %lqr=最適制御               % TODO : フィードバックゲイン
% disp("eig(A-b*f) = ");
% eig(At-Bt*f)                  % 正しく設計できているか確認

%シミュレーション
% simulation setting
x0 = [1;1;1;0;0;0;0;0;0;0;0;0];         % 初期状態
dt = 0.01;          % 刻み時間（サンプリングタイム）
tspan = 0:dt:20;    % 試行時間
% 結果格納用配列用意
xt = zeros(size(At,1),length(tspan));
yt = Ct*xt;
ut = zeros(size(Bt,2),length(tspan));

xt(:,1) = x0;        % 実状態初期値
% z = F(xt);
z = xt;
% Bn = inv(Bt);
for i = 1:length(tspan)-1 % 範囲注意
  % 出力取得
  xt(:,i) = Ct*z(:,i); % TODO
  % 入力算出
  ut(:,i) = -f*z(:,i); % TODO
  % オブザーバ更新 : i に対応した時刻での状態を求めるので状態方程式の右辺のインデックスはi-1
%   [~,tmpx] = ode45(@(t,x) A*x+b*ut(:,i) + h*(yt(:,i)-c*xht(:,i)),[0,dt],xht(:,i));
%   xht(:,i+1) = tmpx(end,:)'; % TODO 
  % 実状態更新
  [~,tmpx] = ode45(@(t,x) At*x+Bt*ut(:,i),[0,dt],z(:,i));
  z(:,i+1) = tmpx(end,:)';
end

%% 

%結果のプロット
for i = 1:12
    figure(i)
    plot(tspan,xt(i,:))
    grid on
end
% figure(1);
% plot(tspan,xt(1,:)); % 状態１
% legend('状態１');
% figure(2);
% plot(tspan,xt(2,:)); % 状態２
% legend('状態２', 'オブザーバの状態２');
figure(13)
plot(tspan,ut,tspan,yt);            % 入出力
grid on
legend('入力','出力');

