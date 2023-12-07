function Controller = Controller_MPC_Koopman(Agent)
%UNTITLED この関数の概要をここに記述
%   各種値
    Controller_param.dt = 0.08; % MPCステップ幅
    Controller_param.H = 10;
    Controller_param.state_size = 12;
    Controller_param.input_size = 4;
    Controller_param.total_size = Controller_param.state_size + Controller_param.input_size;

    %% Koopman
    % load("EstimationResult_12state_7_19_circle=circle_estimation=circle.mat",'est');
    % load("EstimationResult_12state_10_30_data=cirandrevsadP2Pxy_cir=cir_est=cir_Inputandconst.mat",'est');
    % load("EstimationResult_12state_11_29_GUIsimdata.mat",'est') %シミュレーションデータで構築したクープマンモデル
    % load("EstimationResult_12state_11_29_GUIsimdata_input=torque.mat",'est') %シミュクープマンモデル，総推力で学習
    load("EstimationResult_12state_12_6_Expalldata_input=torque.mat",'est') %実機モデル，総推力
    Controller_param.A = est.A;
    Controller_param.B = est.B;
    Controller_param.C = est.C;

    %% 重み
    Controller_param.weight.P = diag([5000; 2000; 100]);    % 座標   1000 1000 10000
    Controller_param.weight.V = diag([2000; 2000; 100]);    % 速度
    Controller_param.weight.R = diag([1; 1; 1; 1]); % 入力
    Controller_param.weight.RP = 0 * diag([1; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)
    Controller_param.weight.QW = diag([1500; 3000; 1000; 100; 100; 1000]);  % 姿勢角，角速度

    Controller_param.weight.Pf = Controller_param.weight.P; % 6
    Controller_param.weight.Vf = Controller_param.weight.V;
    Controller_param.weight.QWf = Controller_param.weight.QW; % 7,8

    % Controller_param.weight.Pf = diag([1; 1; 1]); % 6
    % Controller_param.weight.Vf = diag([1; 1; 1]);
    % Controller_param.weight.QWf = diag([1; 1; 1; 1; 1; 1]); % 7,8

    % Controller_param.weight.P = diag([20; 20; 10]);    % 座標   1000 1000 10000
    % Controller_param.weight.V = diag([350; 300; 300]);    % 速度
    % Controller_param.weight.R = diag([1; 1; 1; 1]); % 入力
    % Controller_param.weight.RP = 0 * diag([1; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)
    % Controller_param.weight.QW = diag([100; 100; 100; 1; 1; 300]);  % 姿勢角，角速度
    % 
    % Controller_param.weight.Pf = diag([1; 1; 1]); % 6
    % Controller_param.weight.Vf = diag([400; 300; 300]);
    % Controller_param.weight.QWf = diag([1; 1; 1; 1; 1; 1]); % 7,8

    %% 4inputs
    % Controller_param.input.u = Agent.parameter.mass * 9.81 / 4 * [1;1;1;1]; % 4入力
    Controller_param.input.u = [Agent.parameter.mass * 9.81;0;0;0]; % 4総推力，トルク
%     Controller_param.torque_TH = 0;

    %% 以下は変更なし
    fprintf("勾配MPC controller\n")

    Controller_param.ref_input = Controller_param.input.u; %入力の目標値

    Controller.name = "mpc";
    Controller.type = "MPC_controller_org";
    Controller.param = Controller_param;

end