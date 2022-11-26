function Controller = Controller_MCMPC(~)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

    Controller_param.dt = 0.1; % MPCステップ幅
    Controller_param.H = 10;
    Controller_param.particle_num = 5000;
    Controller_param.input.Initsigma = 0.1;
    Controller_param.input.Constsigma = 2.0;
    Controller_param.input.Maxsigma = 1.0;
    Controller_param.input.Minsigma = 0.05;
    Controller_param.input.Maxinput = 1.5;
    Controller_param.ref_input = (0.269 * 9.81 / 4) * ones(4,1);
    Controller_param.ConstraintsY = 0.6;

    Controller_param.total_size = 16;
    Controller_param.state_size = 12;
    Controller_param.input_size = 4;

    %% 離陸
%     obj.param.P = diag([1000.0; 1000.0; 100.0]);    % 座標   1000 1000 100
%     obj.param.V = diag([1.0; 1.0; 1.0]);    % 速度
%     obj.param.R = diag([1.0,; 1.0; 1.0; 1.0]); % 入力
%     obj.param.RP = diag([1.0,; 1.0; 1.0; 1.0]);  % 1ステップ前の入力との差    0*(無効化)
%     obj.param.QW = diag([10; 10; 10; 0.01; 0.01; 100.0]);  % 姿勢角、角速度

    %% 円旋回
    Controller_param.P = diag([100.0; 100.0; 100.0]);    % 座標   1000 1000 100
    Controller_param.V = diag([100.0; 100.0; 1.0]);    % 速度
    Controller_param.R = diag([1.0,; 1.0; 1.0; 1.0]); % 入力
    Controller_param.RP = diag([1.0,; 1.0; 1.0; 1.0]);  % 1ステップ前の入力との差    0*(無効化)
    Controller_param.QW = diag([100; 100; 100; 1; 1; 1]);  % 姿勢角、角速度




    Controller.name = "mcmpc";
    Controller.type = "MCMPC_controller";
    Controller.param = Controller_param;

end