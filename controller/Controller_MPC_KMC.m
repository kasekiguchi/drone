function Controller = Controller_MPC_KMC(dt, model_file, agent)
%Koopman-MCMPC parameter setting
 %% HL param
    Controller = Controller_HL(dt);
    Controller.dt_drone = Controller.dt;
   

%% common param
    Controller.m = agent.parameter.mass;
    Controller.state_size = 12;
    Controller.input_size = 4;
    Controller.total_size = Controller.state_size + Controller.input_size;
    Controller.Kmodel = model_file;
    Controller.dt = 0.025;          % MPCステップ幅
    Controller.H = 12;              %predict horizon
    Controller.particle_num = 50000;%mento carlo number of samples

   
    %% MPC param
    % Controller.input.Initsigma = 1*[2,1,1,1];
    % Controller.input.Constsigma = 100 * [0.01, 1,1,1];
    % Controller.input.Maxsigma = 10 * [0.1,1,1,1]; % 10 0.3452
    % Controller.input.Minsigma = 0.1 * [0.1,1,1,1]; %0.5
    
    Controller.input.Maxinput = 1.5;
    Controller.input.Constinput = 10;
    Controller.input.range = [[10;30;30;10], [0.1;0.1;0.1;0.1]]; % max min
    Controller.input.Bestcost_now = [1e5, 1e3];
    Controller.input.Constsigma = 5.0*[1;1;1;1];
    Controller.input.Initsigma = [0.1;1.5e-2;1.5e-2;1.5e-2]; % default 0.1
    Controller.input.Maxsigma = [1;1e-3;1e-3;1e-3];
    Controller.input.Minsigma = [0.01;1e-5;1e-5;1e-5];
    Controller.input.u = [Controller.m * 9.81;0;0;0]; % 総推力，トルク
    torque_th = 1; thrust_th = 1.5;
    Controller.input_max = [Controller.m * 9.81 + thrust_th; torque_th; torque_th; torque_th];
    Controller.input_min = [Controller.m * 9.81 - thrust_th;-torque_th;-torque_th;-torque_th];
    Controller.ref_input = Controller.input.u; %入力の目標値ー初設定
    Controller.input.lb = [0; -1; -1; -1];
    Controller.input.ub = [10; 1;  1;  1];
    % Controller.input.lb = Controller.input_min;%%%%???
    % Controller.input.ub = Controller.input_max;%%%%???
    % Controller.input.Maxinput = 1.5 * [1;1;1;1];

    
    %% load model from koopman setting in the simxxx & change sampling time
    load(model_file, 'est');
    [Controller.koopman.A, Controller.koopman.B, Controller.koopman.C]  = AB_transfer(est.A, est.B, est.C, dt, Controller.dt);
    if isfield(est, 'Ae'); [Controller.koopman.Ae,Controller.koopman.Be,Controller.koopman.Ce] = AB_transfer(est.Ae, est.Be, est.Ce, dt, Controller.dt); end

    % Controller.A = model{1};
    % Controller.B = model{2};
    % Controller.C = model{3};

    %-- 観測量の選択
    [Controller.F, Controller.code] = select_observable(model_file);

     %% 重み MCとは感覚ちがう。yawの重み付けない方が良い
    
%%%%%%%%%%%%%%%%%%%stl ok qp bad
    % Controller.weight.P = 1e1*diag([10;10;20]);    % 位置　10,20刻み  20;1;30
    % Controller.weight.Q = 1e3*diag([1;1;0]);    % 速度  10,20刻み  30;20;10
    % Controller.weight.V = 1e0*diag([10;10;1000]); % 15良い気がする
    % Controller.weight.W = 1e0*diag([1;1;0]);  % 姿勢角，角速度　1,2刻み 
    % Controller.weight.R = 1e0*diag([1; 1; 1; 1000]); % 入力
    % Controller.weight.RP = 0*diag([100; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%stl no qp ok
    %  Controller.weight.P = diag([10;10;5000]);    % 位置　10,20刻み  20;1;30
    % Controller.weight.Q = 1e1*diag([1000;1000;0]);    % 速度  10,20刻み  30;20;10
    % Controller.weight.V = 1e1*diag([15;15;200]); % 15良い気がする
    % Controller.weight.W = 1e1*diag([1;1;0]);  % 姿勢角，角速度　1,2刻み 
    % Controller.weight.R = 1e1*diag([1; 1; 1; 1000]); % 入力
    % Controller.weight.RP = 0*diag([100; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Controller.weight.P = diag([500;500;200]);    % 位置　10,20刻み  20;1;30
    % Controller.weight.Q = 1e4*diag([1;1;1]);    % 速度  10,20刻み  30;20;10
    % Controller.weight.V = diag([50;50;100]); % 15良い気がする
    % Controller.weight.W = diag([1;1;0]);  % 姿勢角，角速度　1,2刻み 
    % Controller.weight.R = diag([1; 1; 1; 1000]); % 入力
    % Controller.weight.RP = 0*diag([100; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%test
  Controller.weight.P = diag([500;500;200]);    % 位置　10,20刻み  20;1;30
    Controller.weight.Q = 1e4*diag([1;1;10]);    % 速度  10,20刻み  30;20;10
    Controller.weight.V = diag([50;50;100]); % 15良い気がする
    Controller.weight.W = diag([1;1;0]);  % 姿勢角，角速度　1,2刻み 
    Controller.weight.R = diag([1; 1; 1; 1000]); % 入力
    Controller.weight.RP = 0*diag([100; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)
%

    Controller.weight.Pf = Controller.weight.P;
    Controller.weight.Vf = Controller.weight.V;
    Controller.weight.Qf = Controller.weight.Q;
    Controller.weight.Wf = Controller.weight.W;

    


    Controller.test.sigma = 1; % 標準偏差を固定
    Controller.test.input = 0; % 推力以外の入力を0固定: 0:固定なし,1:トルク,2:自由

    %% input
   
    
    %% 以下は変更なし
    fprintf("Koopman Monte Carlo MPC controller\n")
    disp(strcat('model:', model_file));
    Controller.name = "kmpc";
    Controller.type = "MPC_CONTROLLER_KMC";
    % Controller.param = Controller_param;
end