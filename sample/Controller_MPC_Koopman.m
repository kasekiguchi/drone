function Controller = Controller_MPC_Koopman(~)
%UNTITLED この関数の概要をここに記述
%   各種値
    Controller_param.m = 0.5884; %ドローンの質量、質量は統一
    Controller_param.dt = 0.025; % MPCステップ幅
    Controller_param.H = 10; %ホライズン数
    Controller_param.state_size = 12;
    Controller_param.input_size = 4;
    Controller_param.total_size = Controller_param.state_size + Controller_param.input_size;

    %% change equation 
    switch Controller_param.H
        case 10
            Controller_param.change_equation_func = @change_equation_mex_H10;
        case 20
            Controller_param.change_equation_func = @change_equation_mex_H20;
        otherwise
            error('No selected change_equation');
    end

    %% Koopman
    % modeファイルとファイル名をそろえる
    load("EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出.mat",'est') %vzから算出したzで学習、総推力
%     load("EstimationResult_2024-05-02_Exp_Kiyama_code01.mat", "est");

    args = ss(est.A, est.B, est.C, zeros(size(est.C,1), size(est.B,2)), Controller_param.dt); % サンプリングタイムの変更
    %--------------------------------------------------------------------
    % 要チェック!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     torque = 1; % 1:クープマンモデルが総推力トルクのとき
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    %--------------------------------------------------------------------

    Controller_param.A = args.A; % default: est.A
    Controller_param.B = args.B;
    Controller_param.C = args.C;

    %% 重み MCとは感覚ちがう。yawの重み付けない方が良い
    Controller_param.weight.P = diag([20; 1; 30]);    % 位置　10,20刻み  20;1;30
    Controller_param.weight.V = diag([30; 20; 10]);    % 速度  10,20刻み  30;20;10
    Controller_param.weight.R = diag([1; 1; 1; 1]); % 入力
    % Controller_param.weight.RP = 0 * diag([1; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)
    Controller_param.weight.QW = diag([10; 1; 1; 1; 1; 1]);  % 姿勢角，角速度　1,2刻み

    Controller_param.weight.Pf = Controller_param.weight.P;
    Controller_param.weight.Vf = Controller_param.weight.V;
    Controller_param.weight.QWf = Controller_param.weight.QW;

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

    %% 以下は変更なし
    fprintf("Koopman MPC controller\n")

    Controller_param.ref_input = Controller_param.input.u; %入力の目標値

    Controller.name = "mpc";
    Controller.type = "MPC_controller_org";
    Controller.param = Controller_param;

end