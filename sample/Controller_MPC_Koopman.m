function Controller = Controller_MPC_Koopman(dt, model, agent)
%UNTITLED この関数の概要をここに記述
%   各種値

% Controller.m = 0.595; % これは実験用

    %% HL param
    Controller = Controller_HL(dt);
    Controller.m = agent.parameter.mass;

    % Controller.m = 0.5884; % eachine
    % Controller.m = 0.730;  % iflight

    %% MPC
    Controller.dt = 0.08; % MPCステップ幅 1222:0.08 0.07
    Controller.H = 10; %ホライズン数
    Controller.state_size = 12;
    Controller.input_size = 4;
    Controller.total_size = Controller.state_size + Controller.input_size;

    load(model, 'est');
    [Controller.A, Controller.B, Controller.C]  = AB_transfer(est.A, est.B, est.C, dt, Controller.dt);
    if isfield(est, 'Ae'); [Controller.Ae,Controller.Be,Controller.Ce] = AB_transfer(est.Ae, est.Be, est.Ce, dt, Controller.dt); end

    % QPの計算，観測量を無名関数に設定．mexファイルを扱う際もここで @mexファイル名(.mex)でいける
    Controller.quad_drone = @quad_drone;
    [Controller.F, code] = select_observable(model);

    % %% 木山による重み
    Controller.weight.P = diag([20; 1; 30]);    % 位置　10,20刻み  20;1;30
    Controller.weight.Q = diag([30; 20; 10]);    % 速度  10,20刻み  30;20;10
    Controller.weight.V = diag([10; 1; 1]); % 15良い気がする
    Controller.weight.W = diag([1; 1; 1]);  % 姿勢角，角速度　1,2刻み 
    Controller.weight.R = diag([1; 1; 1; 1]); % 入力
    Controller.weight.Rp = 0 * diag([1; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)

    if strcmp(code, '23')
        % ちょっと良かったやつ
    % Controller.weight.P = 1*diag([20; 10; 30]);  
    % Controller.weight.Q = 10*diag([30; 20; 1]);
    % Controller.weight.V = diag([10; 1; 1]);  
    % Controller.weight.W = 5 * diag([1; 1; 1]); 
    % Controller.weight.R = diag([1; 1; 1; 1]); 
    % Controller.weight.RP = 0 * diag([1; 1; 1; 1]); 

        % 試験中のやつ
    Controller.weight.P = 1*diag([1; 10; 10]);  
    Controller.weight.Q = 10*diag([30; 30; 1]);
    Controller.weight.V = diag([10; 1; 1]);  
    Controller.weight.W = 10 * diag([1; 1; 1]); 
    Controller.weight.R = 0.1 * diag([1; 1; 1; 1]); 
    Controller.weight.Rp = 0 * diag([1; 1; 1; 1]); 

        % 00と同じやつ
    % Controller.weight.P = diag([20; 1; 30]);    % 位置　10,20刻み  20;1;30
    % Controller.weight.Q = diag([30; 20; 10]);    % 速度  10,20刻み  30;20;10
    % Controller.weight.V = diag([10; 1; 1]); % 15良い気がする
    % Controller.weight.W = diag([1; 1; 1]);  % 姿勢角，角速度　1,2刻み 
    % Controller.weight.R = diag([1; 1; 1; 1]); % 入力
    % Controller.weight.RP = 0 * diag([1; 1; 1; 1]); 
    elseif strcmp(code, '00')
    Controller.weight.P = diag([20; 1; 30]);    % 位置　10,20刻み  20;1;30
    Controller.weight.Q = diag([30; 20; 10]);    % 速度  10,20刻み  30;20;10
    Controller.weight.V = diag([10; 1; 1]); % 15良い気がする
    Controller.weight.W = diag([1; 1; 1]);  % 姿勢角，角速度　1,2刻み 
    Controller.weight.R = diag([1; 1; 1; 1]); % 入力
    Controller.weight.Rp = 0 * diag([1; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)
    end

    Controller.weight.Pf = Controller.weight.P;
    Controller.weight.Vf = Controller.weight.V;
    Controller.weight.Qf = Controller.weight.Q;
    Controller.weight.Wf = Controller.weight.W;

    Controller.input.u = [Controller.m * 9.81;0;0;0]; % 総推力，トルク

    % 入力制約
    trq = 0.5; %default: 0<th<10, -1<tr<1
    Controller.input.lb = [0; -trq; -trq; -trq];
    Controller.input.ub = [7.3; trq;  trq;  trq];
    
    %% 以下は変更なし
    fprintf("Koopman MPC controller\n")
    disp(strcat('model:', model, '// code', code));

    Controller.ref_input = Controller.input.u; %入力の目標値

    Controller.name = "mpc";
    Controller.type = "MPC_CONTROLLER_KOOPMAN_quadprog_simulation";
    Controller.param = Controller;

end