function Controller = Controller_MPC_Koopman(~) %%#codegen
%UNTITLED この関数の概要をここに記述
%   各種値
   % Controller_param.m = 0.540; %下限sim30s
   % Controller_param.m = 0.5884; %ドローンの質量、質量は統一 eachine+4cell
   % Controller_param.m = 0.540;
   % Controller_param.m = 0.669; %上限sim30s
   % Controller_param.m = 0.640;
    Controller_param.m = 0.595; %ドローンの質量、質量は統一 iflight
    Controller_param.dt = 0.07; % MPCステップ幅
    Controller_param.H = 10; %ホライズン数
    Controller_param.state_size = 12;
    Controller_param.input_size = 4;
    Controller_param.total_size = Controller_param.state_size + Controller_param.input_size;

    %% Koopman
    % modeファイルとファイル名をそろえる
   load("EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出.mat",'est') %vzから算出したzで学習、総推力 木山データ(EACHINEで取得)
  % load("20241110_iflight_randam100_z50_est.mat",'est') %vzから算出したzで学習、総推力 加藤データ(iFlightで取得(1回目))
  % load("2025KatoGUI3ver.iFlight_Dataset_xyz100_z50_est.mat",'est') %vzから算出したzで学習、総推力 加藤データ(iFlightで取得(2回目:est修正後))
  % load("2025ver.iFlight_Dataset_xyz200_z100_est.mat",'est') %vzから算出したzで学習、総推力 (木山データ＋加藤データ(1回目))
  % load("2025ver2.iFlight_Dataset_xyz200_z100_est.mat",'est') %vzから算出したzで学習、総推力 (木山データ＋加藤データ(2回目))
  % load("EstimationResult_2024-05-03_Exp_Kiyama_code03_2.mat", "est");
  % load("EstimationResult_2024-06-10_Exp_Kiyama_code03_2.mat", "est");
  % load("EstimationResult_2024-06-10_code02_Exp_Kiyama_code03_2.mat", "est"); 
  % load("code03.mat", "est");

    %--------------------------------------------------------------------
    % 要チェック!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     torque = 1; % 1:クープマンモデルが総推力のとき
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    %--------------------------------------------------------------------

    Controller_param.A = est.A;
    Controller_param.B = est.B;
    Controller_param.C = est.C;

    %% 重み MCとは感覚ちがう。
   % Controller_param.weight.P = diag([20; 1; 30]);    % 位置　10,20刻み 木山
    Controller_param.weight.P = diag([20; 1; 30]);    % 位置　10,20刻み 調整用 10倍× 1/10×
   % Controller_param.weight.Q = diag([30; 20; 1]);    % 姿勢角  10,20刻み 木山
    Controller_param.weight.Q = diag([60; 20; 1]);    % 姿勢角  10,20刻み　調整用 yaw,pitchのみ10倍× rollのみ10倍悪くない　rollのみ1/10× yaw,pitchのみ1/10悪くない
    Controller_param.weight.R = diag([1; 1; 1; 1]); % 入力
    Controller_param.weight.RP = 0 * diag([1; 1; 1; 1]);  % 1ステップ前の入力との差    0*(無効化)
   % Controller_param.weight.QW = diag([10; 1; 1; 1; 1; 1]);  % 姿勢角，角速度　1,2刻み 木山
    Controller_param.weight.V = diag([10; 1; 1]);  % 速度 1,2刻み　調整用 速度 vx10倍xの位置が-方向にゆっくり発散 vy10倍yの位置が-方向に発散 vz10倍landingみたいになる vxvy1/10× vz1/10悪くはないが…                                
    Controller_param.weight.W = diag([1; 1; 1]); %角速度 1,2刻み 10倍xyだめ　z10倍x良いyだめ　1/10×

    Controller_param.weight.Pf = Controller_param.weight.P;
    Controller_param.weight.Qf = Controller_param.weight.Q;
    Controller_param.weight.Vf = Controller_param.weight.V;
    Controller_param.weight.Wf = Controller_param.weight.W;

    %% 4inputs
    if torque == 1
        Controller_param.input.u = [Controller_param.m * 9.81;0;0;0]; % 総推力，トルク
    else
        Controller_param.input.u = Controller_param.m * 9.81 / 4 * [1;1;1;1]; % 4入力
    end
    
%     Controller_param.torque_TH = 0;

    %% 以下は変更なし
    fprintf("勾配MPC controller\n")

    Controller_param.ref_input = Controller_param.input.u; %入力の目標値

    Controller.name = "mpc";
    Controller.type = "MPC_controller_org";
    Controller.param = Controller_param;

end