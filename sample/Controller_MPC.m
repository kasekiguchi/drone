function Controller = Controller_MPC(Agent)
%UNTITLED この関数の概要をここに記述
%   HLをモデルとしたMCMPC
    Controller_param.dt = 0.25; % MPCステップ幅
    Controller_param.H = 5;

    Controller_param.ConstEval = 100000;

    Controller_param.total_size = 16;
%     Controller_param.total_size = 15;
    Controller_param.state_size = 12;
    Controller_param.input_size = 3;

    %% normal
%     Controller_param.P = diag([1e4; 1e4; 1e3]);    % 座標   1000 1000 10000
    Controller_param.P = 1e6 * diag([1e6; 1e6; 1e4]);    % 座標   1000 1000 10000
    Controller_param.V = 1e6 * diag([1e2; 1e2; 1e4]);    % 速度
    Controller_param.R = 0.1 * diag([1.0; 1e3; 1e3; 1e3]); % 入力
    Controller_param.RP = 0 * diag([1.0; 1e3; 1e3; 1e3]);  % 1ステップ前の入力との差    0*(無効化)
    Controller_param.Q = 1e3 * diag([1e1; 1e1; 1e1]);  % 姿勢角
    Controller_param.W = diag([1e1; 1e1; 1e1]);  % 角速度

    Controller_param.Pf = diag([1e2; 1e2; 1e4]); % 6
    Controller_param.Vf = diag([1e2; 1e2; 1e3]); % 6
    Controller_param.Qf = diag([1e1; 1e1; 1]); % 7,8
    Controller_param.Wf = diag([1; 1; 1]);

    Controller_param.input.u = Agent.parameter.mass*9.81 * [1;0;0;0];  % 総推力トルク
    torque_th = 2; thrust_th = 1.5;
    Controller_param.input_max = [Agent.parameter.mass*9.81 + thrust_th; torque_th; torque_th; torque_th];
    Controller_param.input_min = [Agent.parameter.mass*9.81 - thrust_th;-torque_th;-torque_th;-torque_th];
    Controller_param.torque_TH = 2;

    Controller_param.ref_input = Controller_param.input.u;
    % Controller_param.input.v = Controller_param.input.u;

    fprintf("勾配MPC controller\n")

%     Controller.name = "mcmpc";
    Controller.name = "mpc";
    Controller.type = "MPC_controller_org";
    Controller.param = Controller_param;

end