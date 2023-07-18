function Controller = Controller_MCMPC(~)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述
    
    %各値の設定(ステップ幅，ホライズン数，サンプル数，標準偏差，初期入力)
    Controller_param.dt = 0.1;            % MPCステップ幅
    Controller_param.H = 10;              %ホライズン数
    Controller_param.particle_num = 2000;  %サンプル数
    Controller_param.Initsigma = 0.1;     %初期標準偏差
    Controller_param.ref_input = [0.5884 * 9.81 / 4 0.5884 * 9.81 / 4 0.4 * 9.81 / 4 0.5884 * 9.81 / 4]'; %初期入力
    Controller_param.model = load('drone\MCMPC_Koopman\drone\koopman_data\EstimationResult_12state_6_26_circle.mat','est');
    %loadで別の場所からの値を引っ張ってくる「''」でパスを書けば別のファイルからデータを引っ張ってこれる

    %% 離陸(以前のやつ)
%     obj.param.P = diag([1000.0; 1000.0; 100.0]);    % 座標   1000 1000 100
%     obj.param.V = diag([1.0; 1.0; 1.0]);    % 速度
%     obj.param.R = diag([1.0,; 1.0; 1.0; 1.0]); % 入力
%     obj.param.RP = diag([1.0,; 1.0; 1.0; 1.0]);  % 1ステップ前の入力との差    0*(無効化)
%     obj.param.QW = diag([10; 10; 10; 0.01; 0.01; 100.0]);  % 姿勢角、角速度

    %% 重みの設定
    Controller_param.P = diag([100.0; 100.0; 3000.0]);    % 座標   1000 1000 100
    Controller_param.V = diag([100.0; 100.0; 100.0]);    % 速度
    Controller_param.R = diag([1.0,; 1.0; 1.0; 1.0]);    % 入力
    Controller_param.RP = diag([1.0,; 1.0; 1.0; 1.0]);   % 1ステップ前の入力との差    0*(無効化)
    Controller_param.Q = diag([1000; 1000; 1000]);                % 姿勢角
    Controller_param.W = diag([1000; 1000; 1000]);          % 角速度
    
    %終端での重みの設定
    Controller_param.Pf = diag([100.0; 100.0; 100.0]);


    Controller.name = "mcmpc";
    Controller.type = "MCMPC_controller";
%     Controller.type = "HLMPC_controller_ToKiyama"; %コントローラでHLMPCの方を使う
    Controller.param = Controller_param;

end