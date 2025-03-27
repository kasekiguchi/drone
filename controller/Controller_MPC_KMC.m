
function Controller = Controller_MPC_KMC(dt, model_file, agent)
%Koopman-MCMPC parameter setting
    %% HL param
    Controller = Controller_HL(dt);
    Controller.dt_drone = Controller.dt;

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

    
    % Controller.input.Maxinput = 1.5 * [1;1;1;1];

    %% common param
    Controller.m = agent.parameter.mass;
    Controller.state_size = 12;
    Controller.input_size = 4;
    Controller.total_size = Controller.state_size + Controller.input_size;
    Controller.Kmodel = model_file;

    %% load model & change sampling time
    load(model_file, 'est');
    [Controller.A, Controller.B, Controller.C]  = AB_transfer(est.A, est.B, est.C, dt, Controller.dt);
    if isfield(est, 'Ae'); [Controller.Ae,Controller.Be,Controller.Ce] = AB_transfer(est.Ae, est.Be, est.Ce, dt, Controller.dt); end

    % Controller.A = model{1};
    % Controller.B = model{2};
    % Controller.C = model{3};

    %-- 観測量の選択
    [Controller.F, Controller.code] = select_observable(model_file);

    % %% 重み MCとは感覚ちがう。yawの重み付けない方が良い
    % Controller.weight.P = diag([20; 1; 30]);    % 位置　10,20刻み  20;1;30
    % Controller.weight.Q = diag([30; 20; 10]);    % 速度  10,20刻み  30;20;10
    % Controller.weight.V = diag([10; 1; 1]); % 15良い気がする
    % Controller.weight.W = diag([1; 1; 1]);  % 姿勢角，角速度　1,2刻み 
    % Controller.weight.R = diag([1; 1; 1; 1]); % 入力
    % Controller.weight.RP = 0 * diag([1; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)

    % Controller.weight.P = 1 * diag([20; 10; 3000]);    % 位置　10,20刻み  20;1;30
    % Controller.weight.Q = 10 * diag([30; 20; 10]);    % 速度  10,20刻み  30;20;10
    % Controller.weight.V = diag([10; 1; 1]); % 15良い気がする
    % Controller.weight.W = 10 * diag([1; 1; 1]);  % 姿勢角，角速度　1,2刻み 
    % Controller.weight.R = diag([1; 1; 1; 1]); % 入力
    % Controller.weight.RP = 0 * diag([1; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)

    % Controller.weight.P = 1e2*diag([1000;1000;3000]);    % 位置　10,20刻み  20;1;30
    % Controller.weight.Q = 1e3*diag([1;1;100]);    % 速度  10,20刻み  30;20;10
    % Controller.weight.V = 1e3*diag([1;1;1]); % 15良い気がする
    % Controller.weight.W = diag([1000;1000;1000]);  % 姿勢角，角速度　1,2刻み 
    % Controller.weight.R = 1e2*diag([1; 1000; 1000; 1000]); % 入力
    % Controller.weight.RP = diag([100; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)
    % Controller.weight.P = 1e3*diag([1000;1000;5000]);    % 位置　10,20刻み  20;1;30
    % Controller.weight.Q = 1e3*diag([1;1;1]);    % 速度  10,20刻み  30;20;10
    % Controller.weight.V = 1e0*diag([1;1;100]); % 15良い気がする
    % Controller.weight.W = 1e0*diag([1;1;1]);  % 姿勢角，角速度　1,2刻み 
    % Controller.weight.R = 1e3*diag([1; 1; 1; 1]); % 入力
    % Controller.weight.RP = 0*diag([1; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)

    Controller.weight.P = 1e0*diag([1000;1000;5000]);    % 位置　10,20刻み  20;1;30
    Controller.weight.Q = 1e3*diag([1;1;1]);    % 速度  10,20刻み  30;20;10
    Controller.weight.V = 1e0*diag([1;1;10000]); % 15良い気がする
    Controller.weight.W = 1e0*diag([1;1;1]);  % 姿勢角，角速度　1,2刻み 
    Controller.weight.R = 1e2*diag([1; 1; 1; 1]); % 入力
    Controller.weight.RP = 1*diag([100; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)

    Controller.weight.Pf = Controller.weight.P;
    Controller.weight.Vf = Controller.weight.V;
    Controller.weight.Qf = Controller.weight.Q;
    Controller.weight.Wf = Controller.weight.W;

    Controller.input.Initsigma = [0.5;1e-3;1e-3;1e-3]; % default 0.1
    Controller.input.Maxsigma = [1;1e-3;1e-3;1e-3];
    Controller.input.Minsigma = [0.01;1e-5;1e-5;1e-5];

    % Controller.dt = 0.1; % MPCステップ幅
    % Controller.H = 3;
    Controller.dt = 0.025; % MPCステップ幅
    Controller.H = 10;
    Controller.particle_num = 500;

    Controller.test.sigma = 0; % 標準偏差を固定
    Controller.test.input = 0; % 推力以外の入力を0固定: 0:固定なし,1:トルク,2:自由

    %% input
    Controller.input.u = [Controller.m * 9.81;0;0;0]; % 総推力，トルク
    torque_th = 2; thrust_th = 1.5;
    Controller.input_max = [0.5884*9.81 + thrust_th; torque_th; torque_th; torque_th];
    Controller.input_min = [0.5884*9.81 - thrust_th;-torque_th;-torque_th;-torque_th];
    Controller.ref_input = Controller.input.u; %入力の目標値
    Controller.input.lb = [0; -1; -1; -1];
    Controller.input.ub = [10; 1;  1;  1];
    
    %% 以下は変更なし
    fprintf("Koopman Monte Carlo MPC controller\n")
    disp(strcat('model:', model_file));
    Controller.name = "mpc";
    Controller.type = "MPC_CONTROLLER_KMC";
    % Controller.param = Controller_param;
end