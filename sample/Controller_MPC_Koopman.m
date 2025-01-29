function Controller = Controller_MPC_Koopman(dt, model, agent)
%UNTITLED この関数の概要をここに記述
%   各種値

% Controller_param.m = 0.595; % これは実験用

    %% HL param
    Controller_param = Controller_HL(dt);

    % Controller_param.m = 0.5884; %ドローンの質量、質量は統一
    Controller_param.m = agent.parameter.mass;

    
    
    %%
    Controller_param.dt = 0.08; % MPCステップ幅 1222:0.08 0.07
    Controller_param.H = 10; %ホライズン数
    Controller_param.state_size = 12;
    Controller_param.input_size = 4;
    Controller_param.total_size = Controller_param.state_size + Controller_param.input_size;

    load(model, 'est');
    [Controller_param.A, Controller_param.B, Controller_param.C]  = AB_transfer(est.A, est.B, est.C, dt, Controller_param.dt);
    if isfield(est, 'Ae'); [Controller_param.Ae,Controller_param.Be,Controller_param.Ce] = AB_transfer(est.Ae, est.Be, est.Ce, dt, Controller_param.dt); end

    % Controller_param.A = model{1};
    % Controller_param.B = model{2};
    % Controller_param.C = model{3};
    %--------------------------------------------------------------------
    % 要チェック!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    % torqueモデルなら1をとるように．ifを使わない方法で実装してみた
    torque_mat = [0 1];
    if strcmp(class(agent.plant), 'DRONE_EXP_MODEL')
        torque = 1;
    else
        torque = torque_mat(strcmp(func2str(agent.plant.method), 'roll_pitch_yaw_thrust_torque_physical_parameter_model') + 1);
    end

    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    %--------------------------------------------------------------------

    %% quadprogを実行するmexファイルを選択
    % 観測量によってファイルが異なる
    % Controller_param.F = @quaternions_all;
    % if size(Controller_param.A,1) == 26 || size(Controller_param.A,1) == 23
    %     Controller_param.quad_drone = @quad_drone_code00_mex;
    %     Controller_param.F = @quaternions_all_00; % isobe code00
    % elseif size(Controller_param.A,1) == 39
    %     Controller_param.quad_drone = @quad_drone_code04_mex;
    % elseif size(Controller_param.A,1) == 71
    %     Controller_param.quad_drone = @quad_drone_code08_mex;
    % else
    %     Controller_param.quad_drone = @quad_drone;
    %     warning('観測量に合うmexコントローラーがありませｎ');
    % end
    Controller_param.quad_drone = @quad_drone;
    [Controller_param.F, code] = select_observable(model);

    % %% 重み MCとは感覚ちがう。yawの重み付けない方が良い
    % Controller_param.weight.P = diag([20; 1; 30]);    % 位置　10,20刻み  20;1;30
    % Controller_param.weight.Q = diag([30; 20; 10]);    % 速度  10,20刻み  30;20;10
    % Controller_param.weight.V = diag([10; 1; 1]); % 15良い気がする
    % Controller_param.weight.W = diag([1; 1; 1]);  % 姿勢角，角速度　1,2刻み 
    % Controller_param.weight.R = diag([1; 1; 1; 1]); % 入力
    % Controller_param.weight.RP = 0 * diag([1; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)

    % Controller_param.weight.P = 10 * diag([20; 1; 30]);    % 位置　10,20刻み  20;1;30
    % Controller_param.weight.Q = 1 * diag([30; 20; 10]);    % 速度  10,20刻み  30;20;10
    % Controller_param.weight.V = diag([10; 1; 1]); % 15良い気がする
    % Controller_param.weight.W = 1 * diag([1; 1; 1]);  % 姿勢角，角速度　1,2刻み 
    % Controller_param.weight.R = diag([1; 1; 1; 1]); % 入力
    % Controller_param.weight.RP = 0 * diag([1; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)

    if strcmp(code, '23')
        % ちょっと良かったやつ
    % Controller_param.weight.P = 1*diag([20; 10; 30]);  
    % Controller_param.weight.Q = 10*diag([30; 20; 1]);
    % Controller_param.weight.V = diag([10; 1; 1]);  
    % Controller_param.weight.W = 5 * diag([1; 1; 1]); 
    % Controller_param.weight.R = diag([1; 1; 1; 1]); 
    % Controller_param.weight.RP = 0 * diag([1; 1; 1; 1]); 

        % 試験中のやつ
    % Controller_param.weight.P = 1*diag([20; 10; 10]);  
    % Controller_param.weight.Q = 10*diag([20; 10; 1]);
    % Controller_param.weight.V = diag([10; 1; 1]);  
    % Controller_param.weight.W = 10 * diag([1; 1; 1]); 
    % Controller_param.weight.R = 0.1 * diag([1; 1; 1; 1]); 
    % Controller_param.weight.RP = 0 * diag([1; 1; 1; 1]); 

        % 00と同じやつ
    Controller_param.weight.P = diag([20; 1; 30]);    % 位置　10,20刻み  20;1;30
    Controller_param.weight.Q = diag([30; 20; 10]);    % 速度  10,20刻み  30;20;10
    Controller_param.weight.V = diag([10; 1; 1]); % 15良い気がする
    Controller_param.weight.W = diag([1; 1; 1]);  % 姿勢角，角速度　1,2刻み 
    Controller_param.weight.R = diag([1; 1; 1; 1]); % 入力
    Controller_param.weight.RP = 0 * diag([1; 1; 1; 1]); 
    elseif strcmp(code, '00')
    Controller_param.weight.P = diag([20; 1; 30]);    % 位置　10,20刻み  20;1;30
    Controller_param.weight.Q = diag([30; 20; 10]);    % 速度  10,20刻み  30;20;10
    Controller_param.weight.V = diag([10; 1; 1]); % 15良い気がする
    Controller_param.weight.W = diag([1; 1; 1]);  % 姿勢角，角速度　1,2刻み 
    Controller_param.weight.R = diag([1; 1; 1; 1]); % 入力
    Controller_param.weight.RP = 0 * diag([1; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)
    end

    %% 誤差モデル
    % Controller_param.weight.P = diag([100; 100; 10]);    % 位置　10,20刻み  20;1;30
    % Controller_param.weight.Q = diag([1; 1; 1]);        % 速度  10,20刻み  30;20;10
    % Controller_param.weight.V = diag([1; 1; 1]);      % 15良い気がする
    % Controller_param.weight.W = diag([1; 1; 1]);        % 姿勢角，角速度　1,2刻み 
    % Controller_param.weight.R = diag([1; 1; 1; 1]);     % 入力

    Controller_param.weight.Pf = Controller_param.weight.P;
    Controller_param.weight.Vf = Controller_param.weight.V;
    Controller_param.weight.Qf = Controller_param.weight.Q;
    Controller_param.weight.Wf = Controller_param.weight.W;

    %% 4inputs
    if torque == 1
        Controller_param.input.u = [Controller_param.m * 9.81;0;0;0]; % 総推力，トルク
    else
        Controller_param.input.u = Controller_param.m * 9.81 / 4 * [1;1;1;1]; % 4入力
    end
    Controller_param.input.lb = [0; -1; -1; -1];
    Controller_param.input.ub = [10; 1;  1;  1];
    
    %% 以下は変更なし
    fprintf("Koopman MPC controller\n")
    disp(strcat('model:', model, '// code', code));

    Controller_param.ref_input = Controller_param.input.u; %入力の目標値

    %% 誤差モデル
    % Controller_param.ref_input = [0; 0; 0; 0]; % 誤差モデル
    % Controller_param.weight.R = diag([0.1; 0.1; 0.1; 0.1]);     % 入力

    Controller.name = "mpc";
    Controller.type = "MPC_CONTROLLER_KOOPMAN_quadprog_simulation";
    Controller.param = Controller_param;

end