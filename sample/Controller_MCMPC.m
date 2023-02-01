function Controller = Controller_MCMPC(~)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

    Controller_param.dt = 0.1; % MPCステップ幅
    Controller_param.H = 10;
    Controller_param.Mparticle_num = 10000;
    Controller_param.particle_num = Controller_param.Mparticle_num;
    Controller_param.MIparticle_num = 500;
    Controller_param.input.Initsigma = 1.0;
    Controller_param.input.Constsigma = 2.0;
    Controller_param.input.Maxsigma = 2.0;
    Controller_param.input.Minsigma = 0.01;
    Controller_param.input.Maxinput = 1.5;
    Controller_param.input.InitU = 0.269 * 9.81 / 4;
    Controller_param.ConstEval = 100000;
    Controller_param.ref_input = (0.269 * 9.81 / 4) * ones(4,1);
    Controller_param.const.X = -0.5;
    Controller_param.const.Y = -0.5;

    Controller_param.total_size = 16;
    Controller_param.state_size = 12;
    Controller_param.input_size = 4;

    %% HLParam
%     Controller_param.model.param=getParameter();
    % Controller_param.F1=lqrd([0 1;0 0],[0;1],diag([10,1]),[1],dt);                                % z 
    % Controller_param.F2=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,10,10,1]),[1],dt); % x
    % Controller_param.F3=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,10,10,1]),[1],dt); % y
    % Controller_param.F4=lqrd([0 1;0 0],[0;1],diag([100,1]),[1],dt);                       % ヨー角 


    % 使うほう
%     Controller_param.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),0.5,dt);                                % z 
%     Controller_param.F2=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,100,10,1]),0.01,dt); % xdiag([100,10,10,1])
%     Controller_param.F3=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,100,10,1]),0.01,dt); % ydiag([100,10,10,1])
%     Controller_param.F4=lqrd([0 1;0 0],[0;1],diag([10,1]),0.1,dt);                       % ヨー角 
%     Controller_param.dt = dt;

    %% 離陸
%     Controller_param.P = diag([1000.0; 1000.0; 100.0]);    % 座標   1000 1000 100
%     Controller_param.V = diag([1.0; 1.0; 1.0]);    % 速度
%     Controller_param.R = diag([1.0,; 1.0; 1.0; 1.0]); % 入力
%     Controller_param.RP = diag([1.0,; 1.0; 1.0; 1.0]);  % 1ステップ前の入力との差    0*(無効化)
%     Controller_param.QW = diag([10; 10; 10; 0.01; 0.01; 100.0]);  % 姿勢角、角速度

    %% 円旋回
    Controller_param.P = diag([100.0; 100.0; 100.0]);    % 座標   1000 1000 100
    Controller_param.V = diag([100.0; 100.0; 100.0]);    % 速度
    Controller_param.R = diag([1.0,; 1.0; 1.0; 1.0]); % 入力
    Controller_param.RP = diag([1.0,; 1.0; 1.0; 1.0]);  % 1ステップ前の入力との差    0*(無効化)
    Controller_param.QW = diag([100; 100; 100; 1; 1; 1]);  % 姿勢角、角速度
    
    Controller_param.Pf = 100 * diag([1000.0; 1000.0; 1000.0]);
    Controller_param.Vf = diag([100.0; 100.0; 100.0]);
    Controller_param.QWf = diag([100; 100; 100; 1; 1; 1]);

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
    Controller.type = "MCMPC_controller";
    Controller.param = Controller_param;

end