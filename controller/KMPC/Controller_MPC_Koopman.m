function Controller = Controller_MPC_Koopman(~)
%UNTITLED この関数の概要をここに記述
%   各種値
    Controller_param.mass = 0.5884; %ドローンの質量
    Controller_param.dt = 0.08; % MPCステップ幅
    Controller_param.H = 10; %ホライズン数
    Controller_param.state_size = 12; %状態数
    Controller_param.input_size = 4; %入力数
    Controller_param.total_size = Controller_param.state_size + Controller_param.input_size;

    %% Koopman

    load("EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出.mat",'est') %vzから算出したzで学習、総推力
    
    %--------------------------------------------------------------------
    % 要チェック!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     torque = 1; % 1:クープマンモデルが総推力のとき
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    %--------------------------------------------------------------------

    Controller_param.A = est.A; %クープマンモデルの係数行列
    Controller_param.B = est.B; %クープマンモデルの入力ベクトル
    Controller_param.C = est.C; %クープマンモデルの出力ベクトル

    %% 重み
    Controller_param.weight.P = diag([1; 1; 1]);    % 位置
    Controller_param.weight.V = diag([1; 1; 1]);    % 速度
    Controller_param.weight.R = diag([1; 1; 1; 1]); % 入力
    Controller_param.weight.RP = 0 * diag([1; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)
    Controller_param.weight.QW = diag([10; 1; 1; 1; 1; 1]);  % 姿勢角，角速度

    Controller_param.weight.Pf = Controller_param.weight.P; % 6
    Controller_param.weight.Vf = Controller_param.weight.V;
    Controller_param.weight.QWf = Controller_param.weight.QW; % 7,8

    %% 4inputs
    if torque == 1
        Controller_param.input.u = [Controller_param.mass * 9.81;0;0;0]; % 総推力，トルク
    else
        Controller_param.input.u = Controller_param.mass * 9.81 / 4 * [1;1;1;1]; % 4入力
    end

    %% 以下は変更なし
    fprintf("勾配MPC controller\n")

    Controller_param.ref_input = Controller_param.input.u; %入力の目標値

    Controller.name = "mpc";
    Controller.type = "MPC_controller_org";
    Controller.param = Controller_param;

end