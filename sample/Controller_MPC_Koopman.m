function Controller = Controller_MPC_Koopman(dt, model)
%UNTITLED この関数の概要をここに記述
%   各種値
    Controller_param.m = 0.5884; %ドローンの質量、質量は統一
    Controller_param.dt = 0.08; % MPCステップ幅 0.07
    Controller_param.H = 10 %ホライズン数
    Controller_param.state_size = 12;
    Controller_param.input_size = 4;
    Controller_param.total_size = Controller_param.state_size + Controller_param.input_size;
    % ssflg = 1;

    %% Koopman
    % modeファイルとファイル名をそろえる
    % load("EstimationResult_2024-06-04_Exp_KiyamaX_20data_code00_saddle","est");
    % load("EstimationResult_2024-05-02_Exp_Kiyama_code02.mat", "est");

    %% 今はこっちの検証
    % load("EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出.mat",'est') %vzから算出したzで学習、総推力
    % load('2024-07-14_Exp_KiyamaX20_code00_saddle.mat', 'est'); % x方向増加データ
    % load('EstimationResult_2024-05-13_Exp_Kiyama_code04_1.mat', 'est');
    % load('2024-07-14_Exp_Kiyama_code08_saddle.mat', 'est'); % 観測量を変えただけのやつ 71次元
    load(model, 'est');
    try
        ssmodel = ss(est.A, est.B, est.C, zeros(size(est.C,1), size(est.B,2)), dt); % サンプリングタイムの変更
        args = d2d(ssmodel, Controller_param.dt);
        Controller_param.A = args.A;
        Controller_param.B = args.B;
        Controller_param.C = args.C;
    catch
        Controller_param.A = est.A;
        Controller_param.B = est.B;
        Controller_param.C = est.C;
    end
    % Controller_param.A = model{1};
    % Controller_param.B = model{2};
    % Controller_param.C = model{3};
    %--------------------------------------------------------------------
    % 要チェック!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     torque = 1; % 1:クープマンモデルが総推力トルクのとき
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    %--------------------------------------------------------------------

    %% quadprogを実行するmexファイルを選択
    % 観測量によってファイルが異なる
    if size(Controller_param.A,1) == 26 || size(Controller_param.A,1) == 23
        Controller_param.quad_drone = @quad_drone_code00_mex;
    elseif size(Controller_param.A,1) == 39
        Controller_param.quad_drone = @quad_drone_code04_mex;
    elseif size(Controller_param.A,1) == 71
        Controller_param.quad_drone = @quad_drone_code08_mex;
    else
        error('観測量に合うコントローラーがありませｎ')
    end

    %% 重み MCとは感覚ちがう。yawの重み付けない方が良い
    Controller_param.weight.P = diag([20; 1; 100]);    % 位置　10,20刻み  20;1;30
    Controller_param.weight.Q = diag([30; 20; 10]);    % 速度  10,20刻み  30;20;10
    Controller_param.weight.V = diag([10; 1; 1]); % 15良い気がする
    Controller_param.weight.W = diag([1; 1; 1]);  % 姿勢角，角速度　1,2刻み 
    Controller_param.weight.R = diag([1; 1; 1; 1]); % 入力
    % Controller_param.weight.RP = 0 * diag([1; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)

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

    % 実質制約なし
    % Controller_param.input.lb = [0; -10; -10; -10];
    % Controller_param.input.ub = [100;10;  10;  10];
    
    
%     Controller_param.torque_TH = 0;

    %% HL param
    Controller_param.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),[0.1],dt);                                % z 
    Controller_param.F2=lqrd(diag([1,1,1],1),[0;0;0;1],diag([100,100,1,1]),[0.01],dt); % xdiag([100,10,10,1])
    Controller_param.F3=lqrd(diag([1,1,1],1),[0;0;0;1],diag([100,100,1,1]),[0.01],dt); % ydiag([100,10,10,1])
    Controller_param.F4=lqrd([0 1;0 0],[0;1],diag([200,10]),[0.1],dt); 

    %% 以下は変更なし
    fprintf("Koopman MPC controller\n")

    Controller_param.ref_input = Controller_param.input.u; %入力の目標値

    Controller.name = "mpc";
    Controller.type = "MPC_CONTROLLER_KOOPMAN_quadprog_simulation";
    Controller.param = Controller_param;

end