function Controller = Controller_MCMPC_case(Agent)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述
    Controller_param.dt = 0.1; % MPCステップ幅
    Controller_param.H = 10;
    Controller_param.Maxparticle_num = 5000;
    Controller_param.particle_num = Controller_param.Maxparticle_num;
    Controller_param.Minparticle_num = 1000;
    Controller_param.input.Initsigma = 0.01*[1;0.1;0.1;0.1];
    Controller_param.input.Constsigma = 5.0*[1;1;1;1];
    Controller_param.input.Maxsigma = 1.0 * [1;1.5;1.5;1.5];
    Controller_param.input.Minsigma = 0.001 * [1;1;1;1];
    Controller_param.input.Maxinput = 1.5 * [1;1;1;1];

    Controller_param.ConstEval = 100000;

    Controller_param.total_size = 16;
    Controller_param.state_size = 12;
    Controller_param.input_size = 4;

    %% normal
%     Controller_param.P = diag([1e4; 1e4; 1e3]);    % 座標   1000 1000 10000
    Controller_param.P = diag([1e6; 1e6; 1e4]);    % 座標   1000 1000 10000
    Controller_param.V = diag([1e2; 1e2; 1e4]);    % 速度
    Controller_param.R = 0.1*diag([1.0; 1e3; 1e3; 1e3]); % 入力
    Controller_param.RP = 0 * diag([1.0,; 1e3; 1e3; 1e3]);  % 1ステップ前の入力との差    0*(無効化)
    Controller_param.QW = diag([1e1; 1e1; 1e1; 1e1; 1e1; 1e1]);  % 姿勢角、角速度

    Controller_param.Pf = diag([1e2; 1e2; 1e4]); % 6
    Controller_param.Vf = diag([1e2; 1e2; 1e3]); % 6
    Controller_param.QWf = diag([1e1; 1e1; 1; 1; 1; 1]); % 7,8

    Controller_param.input.u = Agent.parameter.mass*9.81 * [1;0;0;0];  % old version
    Controller_param.ref_input = Agent.parameter.mass*9.81 * [1;0;0;0];
    Controller_param.input.v = Controller_param.input.u;

    fprintf("\n\n======================\n")
    fprintf("MCMPC controller\n")

    Controller.name = "mcmpc";
    Controller.type = "MCMPC_controller";
    Controller.param = Controller_param;

end