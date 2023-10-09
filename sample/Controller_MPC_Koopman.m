function Controller = Controller_MPC_Koopman(Agent)
%UNTITLED この関数の概要をここに記述
%   各種値
    Controller_param.dt = 0.07; % MPCステップ幅
    Controller_param.H = 10;
    Controller_param.state_size = 12;
    Controller_param.input_size = 4;
    Controller_param.total_size = Controller_param.state_size + Controller_param.input_size;

    %% Koopman
%     load('C:\Users\student\Documents\GitHub\drone\Koopman_model\EstimationResult_12state_7_19_circle=circle_estimation=circle.mat','est');
    load('C:\Users\kiyam\Documents\卒業研究\GitHub2\drone\Koopman_model\EstimationResult_12state_7_19_circle=circle_estimation=circle.mat','est');
    Controller_param.A = est.A;
    Controller_param.B = est.B;

    %% 重み
    Controller_param.weight.P = diag([6; 7; 1]);    % 座標   1000 1000 10000
    Controller_param.weight.V = diag([1; 1; 1]);    % 速度
    Controller_param.weight.R = diag([1; 1; 1; 1]); % 入力
    Controller_param.weight.RP = 0 * diag([1; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)
    Controller_param.weight.QW = diag([2000; 2000; 1000; 1; 1; 1]);  % 姿勢角，角速度

    Controller_param.weight.Pf = diag([5; 10; 1]); % 6
    Controller_param.weight.QWf = diag([2400; 2400; 1200; 1; 1; 1]); % 7,8

    %% 4inputs
    Controller_param.input.u = Agent.parameter.mass * 9.81 / 4 * [1;1;1;1]; % 4入力
%     Controller_param.torque_TH = 0;

    %% 以下は変更なし
    fprintf("勾配MPC controller\n")

    Controller_param.ref_input = Controller_param.input.u; %入力の目標値

    Controller.name = "mpc";
    Controller.type = "MPC_controller_org";
    Controller.param = Controller_param;

end