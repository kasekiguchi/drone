function Controller = Controller_MCMPC(~)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述
    Controller_param.dt = 0.1; % MPCステップ幅
    Controller_param.H = 10;
    Controller_param.Maxparticle_num = 5000;
    Controller_param.particle_num = Controller_param.Maxparticle_num;
    Controller_param.Minparticle_num = 1000;
    Controller_param.input.Initsigma = 0.01;
    Controller_param.input.Constsigma = 5.0;
    Controller_param.input.Maxsigma = 2.0;
    Controller_param.input.Minsigma = 0.01;
    Controller_param.input.Maxinput = 1.5;

    Controller_param.ConstEval = 100000;
    
    Controller_param.const.X = -0.5;
    Controller_param.const.Y = -0.5;

    Controller_param.obsX = 3;
    Controller_param.obsY = 0;

    Controller_param.total_size = 16;
    Controller_param.state_size = 12;
    Controller_param.input_size = 4;

    %% 離陸
%     Controller_param.P = diag([1000.0; 1000.0; 100.0]);    % 座標   1000 1000 100
%     Controller_param.V = diag([1.0; 1.0; 1.0]);    % 速度
%     Controller_param.R = diag([1.0,; 1.0; 1.0; 1.0]); % 入力
%     Controller_param.RP = diag([1.0,; 1.0; 1.0; 1.0]);  % 1ステップ前の入力との差    0*(無効化)
%     Controller_param.QW = diag([10; 10; 10; 0.01; 0.01; 100.0]);  % 姿勢角、角速度

    %% 円旋回
    Controller_param.P = diag([1000.0; 1000.0; 10000.0]);    % 座標   1000 1000 10000
    Controller_param.V = diag([100.0; 100.0; 10000.0]);    % 速度
    Controller_param.R = diag([1.0,; 1.0; 1.0; 1.0]); % 入力
    Controller_param.RP = diag([1.0,; 1.0; 1.0; 1.0]);  % 1ステップ前の入力との差    0*(無効化)
    Controller_param.QW = diag([1000; 1000; 1000; 1; 1; 1]);  % 姿勢角、角速度

    Controller_param.Qapf = 0;
    Controller_param.C = 10;
    Controller_param.CA = 10;
    Controller_param.CV = 10;
    
    
    Controller_param.Pf = 10000 * diag([1.0; 1.0; 1.0]);
    Controller_param.Vf = diag([1000.0; 1000.0; 1.0]);
    Controller_param.QWf = diag([100; 100; 100; 1; 1; 1]);
    Controller_param.input.u = 0.269*9.81/4 * [1;1;1;1];  % old version
    Controller_param.ref_input = 0.269*9.81/4 * [1;1;1;1];

    %% 姿勢角
%     Controller_param.P = diag([100.0; 100.0; 100.0]);    % 座標   1000 1000 100
%     Controller_param.V = diag([100.0; 100.0; 1.0]);    % 速度
%     Controller_param.R = diag([1.0,; 1.0; 1.0; 1.0]); % 入力
%     Controller_param.RP = diag([1.0,; 1.0; 1.0; 1.0]);  % 1ステップ前の入力との差    0*(無効化)
%     Controller_param.QW = diag([100000; 100000; 100000; 100; 100; 1]);  % 姿勢角、角速度
%     
%     Controller_param.Pf = 100 * diag([100.0; 100.0; 100.0]);
%     Controller_param.Vf = diag([100.0; 100.0; 1.0]);
%     Controller_param.QWf = diag([100; 100; 100; 1; 1; 1]);

    %%
%     Controller_param.P = diag([1.0; 1.0; 1.0]);    % 座標   1000 1000 100
%     Controller_param.V = diag([100.0; 100.0; 1.0]);    % 速度
%     Controller_param.R = diag([1.0,; 1.0; 1.0; 1.0]); % 入力
%     Controller_param.RP = diag([1.0,; 1.0; 1.0; 1.0]);  % 1ステップ前の入力との差    0*(無効化)
%     Controller_param.QW = diag([1000; 1000; 1000; 1; 1; 1]);  % 姿勢角、角速度




    Controller.name = "mcmpc";
    Controller.type = "MCMPC_controller_org";
    Controller.param = Controller_param;

end