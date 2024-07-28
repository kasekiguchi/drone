function Controller=Controller_HL_ATMEC(dt)
%% controller class demo (1) : construct
% controller property をController classのインスタンス配列として定義
%% ====HL_Controller====
% %-------------定量誤差大-------------
% Controller.F1=lqrd([0 1;0 0],[0;1],diag([10,1]),[1],dt);                                % z 
% Controller.F2=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([1000,10,10,1]),[1],dt); % xdiag([100,10,10,1])
% Controller.F3=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([1000,10,10,1]),[1],dt); % ydiag([100,10,10,1])
% Controller.F4=lqrd([0 1;0 0],[0;1],diag([100,1]),[1],dt);                       % ヨー角 
%-----------------定量誤差小------------
Controller.F1=lqr([0 1;0 0],[0;1],diag([1,1]),[1]);
Controller.F2=lqr([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,10,10,1]),[0.1]);
Controller.F3=lqr([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,10,10,1]),[0.1]);
Controller.F4=lqr([0 1;0 0],[0;1],diag([1,1]),[1]);
%------------最初期に使っていたゲイン----------
% Controller.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),[1],dt);
% Controller.F2=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[1],dt);
% Controller.F3=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[1],dt);
% Controller.F4=lqrd([0 1;0 0],[0;1],diag([1,1]),[1],dt);

Controller.dt = dt;
 eig(diag([1,1,1],1)-[0;0;0;1]*Controller.F2)

%% ====サブシステムモデル====
Controller.A2 = [0 1;0 0];
Controller.B2 = [0;1];
Controller.A4 =diag([1 1 1],1);
Controller.B4 = [0;0;0;1];

%% ====MEC 補償ゲイン====
%-------dt = 0.1 s 実験的に求めた最適値-------
% Kz = [450 0];
% Kx = [50 0 0 0];
% Ky = [50 0 0 0];

%---------w/o MEC--------
Kz = [0 0];
Kx = [0 0 0 0];
Ky = [0 0 0 0];
 
Controller.K = [Kz Kx Ky];

%% ====FRIT,RLS パラメーター====
%---------推定, 更新開始時刻----------
Controller.FRIT_begin = 5;%補償ゲインの推定を始める時間
Controller.RLS_begin = 10;%補償ゲインのを更新始める時間
%------------------z------------------
Controller.gamma.z = 1; %初期相関係数
Controller.alpha.z = 0.01; %ローパスフィルタ強度
% Controller.alpha.z = 0; %100%古い情報で更新->更新しない
Controller.lambda.z = 0.99; %忘却係数
%------------------x----------------
Controller.gamma.x = 1; %初期相関係数
Controller.alpha.x = 0.01; %ローパスフィルタ強度
Controller.lambda.x = 0.99; %忘却係数
%------------------y-----------------
Controller.gamma.y = 1; %初期相関係数
Controller.alpha.y = 0.01; %ローパスフィルタ強度
Controller.lambda.y = 0.99; %忘却係数

end
