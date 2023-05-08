% initialize 
    clc; close all; clear;
    tmp = matlab.desktop.editor.getActive;
    cd(fileparts(tmp.Filename));
    DATAdir = cd(fileparts(tmp.Filename));
    
%%  ディレクトリ生成
    mkdir(DATAdir,'/simdata');
    Outputdir = strcat(DATAdir,'/simdata/2020_11_16_soft_constraint2');
    mkdir(Outputdir,'eps/Animation1');
    mkdir(Outputdir,'eps/Animation_omega');
    mkdir(Outputdir,'fig');
    mkdir(Outputdir,'data');
    mkdir(Outputdir,'png/Animation1');
    mkdir(Outputdir,'png/Animation_omega');
    mkdir(Outputdir,'video');

%% Setup
    %-- パラメータ
        dt = 0.05;          % - 離散時間幅（チューニング必要かも）
        Te = 2;	            % - シミュレーション時間
        x0 = [0.0; 0.0];    % - 初期状態
        u0 = [0.0; 0.0];    % - 初期状態
        ur = [0.0; 0.0];    % - 目標速度
        Particle_num = 10; % - 粒子数（要チューニング）
        Csigma = 0.001;     % - 予測ステップごとに変化する分散値の上昇定数(未来は先に行くほど不確定だから予測ステップが進む度に標準偏差を大きくしていく、工夫だからやらなくても問題ないと思う)
        Count_sigma = 0;
        Initux = 0.05;      % - 初期推定解
        Inituy = 0.00;      % - 初期推定解
        umax = 1.0;         % - 入力の最大値、入力制約と最大入力の抑制項のときに使う
        InitSigma_x = 0.03; % - 初期の分散（要チューニング）
        InitSigma_y = 0.01; % - 初期の分散（要チューニング）

    %-- MPC関連
        Params.H = 26;                         % - ホライゾン（チューニング）
        Params.dt = 0.1;                       % - 予測ステップ幅（チューニング）
        Params.Weight.Qf = diag([1.0; 1.0]);   % - モデル予測制御の状態に対する終端コスト重み（要チューニング）
        Params.Weight.Q  = diag([1.0; 1.0]);   % - モデル予測制御の状態に対するステージコスト重み（要チューニング）
        Params.Weight.R  = diag([0.01; 0.01]); % - モデル予測制御の入力に対するステージコスト重み（要チューニング）
        %%- モデル予測制御の最大入力を超過しないよう抑制する項に対するステージコスト重み（要チューニング）
        %%- 西川先輩の修論に載ってる、今回は重み0にして項の役割をなくした
            Params.Weight.Rs = 0.0;                
        
    %-- 構造体へ格納
        Params.x0 = x0;
        Params.Particle_num = Particle_num;
        Params.Csigma = Csigma;
        Params.reset_flag = 0;
        Params.PredStep = repmat(dt*3, Params.H, 1); % - ホライズンの半分後半の予測ステップ幅を大きく(未来は先に行くほど不確定だから予測ステップ幅を大きくしていく、工夫だからやらなくても問題ないと思う)
        Params.PredStep(1:Params.H/2, 1) = dt;
        Params.umax = umax;
    
    %-- 制御対象のシステム行列
        [Ad, Bd, Cd, Dd] = MassModel(dt);
            Params.Ad = Ad;
            Params.Bd = Bd;
            Params.Cd = Cd;
            Params.Dd = Dd;
            [~, state_size] = size(Ad);
        [~, input_size] = size(Bd);
%         total_size = state_size + input_size;
 
    %-- 予測モデルのシステム行列
        [MPC_Ad, MPC_Bd, MPC_Cd, MPC_Dd] = MassModel(Params.dt);
            Params.A = MPC_Ad;
            Params.B = MPC_Bd;
            Params.C = MPC_Cd;
            Params.D = MPC_Dd;
               
    %-- データ配列初期化
        x = x0;
        u = u0;

        idx = 0;
        dataNum = 8;
        data.state           = zeros(round(Te/dt + 1), dataNum);
%         data.state(idx+1, 1) = idx * dt; % - 現在時刻
%         data.state(idx+1, 2) = x(1);     % - 状態 x
%         data.state(idx+1, 3) = x(2);     % - 状態 y
%         data.state(idx+1, 4) = 0;        % - 入力 ux  
%         data.state(idx+1, 5) = 0;        % - 入力 uy
%         data.state(idx+1, 6) = 0;        % - ux,uyのノルム
%         data.state(idx+1, 7) = 0;        % - 目標状態 xr
%         data.state(idx+1, 8) = 0;        % - 目標状態 yr        
        data.path{idx+1}  = {}; % - 全サンプル全ホライズンの値
        data.pathJ{idx+1} = {}; % - 全サンプルの評価値
        data.state(idx+1, 1) = idx * dt; % - 現在時刻
        data.state(idx+1, 2) = x(1);     % - 状態 x
        data.state(idx+1, 3) = x(2);     % - 状態 y
        data.state(idx+1, 4) = 0;        % - 入力 ux  
        data.state(idx+1, 5) = 0;        % - 入力 uy
        data.state(idx+1, 6) = 0;        % - ux,uyのノルム
        data.state(idx+1, 7) = 0;        % - 目標状態 xr
        data.state(idx+1, 8) = 0;        % - 目標状態 yr
        data.bestcost(idx+1) = 0;        % - もっともよい評価値
        data.bestx(idx+1, :) = repelem(x(1), Params.H); % - もっともよい評価の軌道x成分
        data.besty(idx+1, :) = repelem(x(2), Params.H); % - もっともよい評価の軌道y成分
        data.sigmax(idx+1, :) = 0; % - xの標準偏差の値
        data.sigmay(idx+1, :) = 0; % - yの標準偏差の値  
        
        sigma_cnt = 1:Params.H; % - 標準偏差の上昇に使ってる
    
%% main-loop
while idx * dt < Te + dt
    %-- 1制御周期にかかる時間をtictocで計測
        tic
        
    %-- 何回目のループか
        idx = idx + 1;
        
	%-- 実行状態の表示
%         disp(['Time: ', num2str(idx * Td, '%.2f'), ' s, state: ', num2str(x','[%.2f\t]'), ', input: ', num2str(u','[%.2f\t]')]);       
    
    %-- 観測方程式
        y = Cd * x;

	%-- 目標軌道生成
        xr = Reference(idx * dt, Params);
        
    %-- MPCでパラメータを配列に格納
        Params.Ur = ur;
        Params.Xr = xr;
        Params.X0 = x;
        Params.input_size = input_size;
        Params.state_size = state_size;
   
%-- モンテカルロモデル予測制御
    %-- MPCのホライズン間の分散
        if Count_sigma == 0 || Count_sigma ==1
            sigmax = repmat(InitSigma_x + Csigma * (sigma_cnt - 1), Particle_num, 1)'; % - 初期時刻
            sigmay = repmat(InitSigma_y + Csigma * (sigma_cnt - 1), Particle_num, 1)';
        else
            sigmax = repmat(sigmanext_x + Csigma * (sigma_cnt - 1), Particle_num, 1)'; % - 初期時刻以降
            sigmay = repmat(sigmanext_y + Csigma * (sigma_cnt - 1), Particle_num, 1)';
        end

    %-- 準最適化入力を格納
        if Count_sigma == 0 
            ux_ten = repmat(Initux, Params.H, Particle_num);
            uy_ten = repmat(Inituy, Params.H, Particle_num);
            %-- fminconで算出した値を代入、初期推定解だけ勾配法を用いて算出するパターンもある
            %-- こういう一例があることを知って欲しいから残しておいた
                % ux_ten = repmat(u_previous_opt(1,:)', 1, Particle_num);
                % uy_ten = repmat(u_previous_opt(1,:)', 1, Particle_num);
        else
            ux_ten = reshape(u_x, size(nx)); % - 初期時刻以降，準最適化入力を格納
            uy_ten = reshape(u_y, size(ny));
        end
    
    %-- 分散によるノイズを格納，入力の広がりを決定
        nx = normrnd(zeros(Params.H,Particle_num), sigmax);
        ny = normrnd(zeros(Params.H,Particle_num), sigmay);

    %-- 各方向の入力列を格納
        ux = ux_ten + nx;   % ux_ten : 平均値として扱う
        uy = uy_ten + ny;
        ux = reshape(ux, [1, size(ux)]);
        uy = reshape(uy, [1, size(uy)]);
        u1 = [ux; uy];

    %-- 入力制約の確認 (Checking Input Constraint)、入力の制約を行う場合はInput_Constをコメントイン
    %-- 入力制約を使う際には状態制約(State_Const)のファイル内の入力制約を棄却する部分(Input_Const)をコメントアウトを外す    
        remove_flagI = 1;
        remove_data = 0;
%         [u1, remove_flagI, remove_ID, remove_data] = Input_Const(Params, u1); % 入力制約 このプログラムは状態に入力入ってないからコメントアウトしてる
%         data.remove_data(idx) = remove_data;
%         Params.remove_ID = remove_ID;

    if remove_flagI == 0
        uOpt = repmat(unow(:, 1), 1,Params.H);
        u_x = repmat(unow(1, :), Params.H, Params.Particle_num);
        u_y = repmat(unow(2, :), Params.H, Params.Particle_num);
    %     u_x = repmat(uOpt.u(1).u(1,:)',1,Params.Particle_num);
    %     u_y = repmat(uOpt.u(1).u(2,:)',1,Params.Particle_num);
        sigmanext_x = 0.5;
        sigmanext_y = 0.5;
        sigma_reset_flag = 1;

        data.path{idx} = state_data;
        data.pathJ{idx} = Evaluationtra;
        data.state(idx, 1) = idx * dt;  % 現在時刻
        data.state(idx, 2) = x(1);      % 状態 x
        data.state(idx, 3) = x(2);      % 状態 y
    %     data.state(idx,4) = x(3);      % 速度 vx
    %     data.state(idx,5) = x(4);      % 速度 vx
    %     data.state(idx,6) = x(5);      % 電力 E
        data.state(idx, 4) = unow(1, 1); % 入力 u  
        data.state(idx, 5) = unow(2, 1);
        data.state(idx, 6) = norm(unow(:, 1));
        data.state(idx, 7) = xr(1, 1);  % 目標状態 xr
        data.state(idx, 8) = xr(2, 1);
    %     data.state(idx,11) = xr(3,1);  
    %     data.state(idx,12) = xr(4,1);
        data.bestcost(idx) = Bestcost; %もっともよい評価値
        data.bestx(idx, :) = state_data(1, :, BestcostID); %もっともよい評価の時の軌道
        data.besty(idx, :) = state_data(2, :, BestcostID);
        data.sigmax(idx, :) = sigmax(1, 1);
        data.sigmay(idx, :) = sigmay(1, 1);

    %     x = Ad*x + Bd*unow(:,1) + [0; 0; 0; 0; (Winnow - Woutnow)*Td];
        x = Ad * x + Bd * unow(:,1) + [0; 0];
        Count_sigma = Count_sigma + 1;

        disp(['Time: ', num2str(idx * dt, '%.2f')]); %, num2str(unow(:,1)','[%.2f\t]')
        disp('Input reset')
        continue
    end

    u1_size = size(u1, 3);

    %-- 全予測軌道のパラメータの格納変数を定義
        x_data = zeros(Params.H, Particle_num);
        x_data = reshape(x_data, [1, size(x_data)]);
        y_data = zeros(Params.H, Particle_num);
        y_data = reshape(y_data, [1, size(y_data)]);

        state_data = [x_data; y_data];

    %-- 状態方程式による予測軌道計算
        for i = 1:u1_size
            x0 = x;
            state_data(:, 1, i) = x0;
            for j = 1 : Params.H-1
                x1 = Params.A * x0 + Params.B * u1(:, j, i);
                y = Params.C * x1;
                x0 = y;
                state_data(:, j+1, i) = x0;
            end 
        end
        % disp('finish trajectory generate');

    %-- 評価値計算
        Evaluationtra = zeros(1, u1_size);
        for i = 1:u1_size
            eve = EvaluationFunction(state_data(:, :, i), u1(:, :, i), Params);
            Evaluationtra(1, i) = eve;
        end
        % disp('Finish Calculating Evaluation Cost ');
        [Bestcost, BestcostID] = min(Evaluationtra); %最小評価値を算出

    %-- 状態制約(不等式制約)の確認、状態の制約を行う場合はInput_Constをコメントイン
    %-- 西川先輩の充電量しか制約がないため、現状コメントインしても意味がない、今後制約を入れる際に参考にして
        remove_flag = 1;
%         [remove_flag, Evaluation_update, s_update, u_update] = State_Const(Params, Evaluationtra, state_data, u1);

    %-- クラスタリング
        if remove_flag ~= 0
            [uOpt, ~] = clustering(Params, Evaluationtra, u1, state_data);
        end
        
    %-- 最小評価値の入力をリサンプリング，格納,次時刻の分散決定
        if remove_flag ~= 0
            [Params, L_norm] = Normalize(Params, Evaluationtra);
            [u_y, ~, u_x] = Resampling(Params, u1, L_norm);
        end

    if remove_flag(1) == 0 % - 全サンプルが状態制約で棄却された場合
        uOpt = repmat(unow(:, 1), 1, Params.H);
        u_x = repmat(unow(1, :), Params.H, Params.Particle_num);
        u_y = repmat(unow(2, :), Params.H, Params.Particle_num);
        sigmamext_x = 0.5;
        sigmanext_y = 0.5;
        sigma_reset_flag = 1;
    else
        unow = uOpt.u(1).u(:, 1);

        %-- プラントモデル内で制約を超える入力を補正
            unormnow = norm(unow(:, 1));
            if unormnow > Params.umax
                unow(:, 1) = (Params.umax/unormnow) * unow(:, 1);   
            end

        %-- 次時刻の分散の決定
        %-- 前時刻と現時刻の評価値を比較して，評価が悪くなったら標準偏差を広げて，評価が良くなったら標準偏差を狭めるようにしている
            if Count_sigma == 0 || sigma_reset_flag == 1 % - 最初は全時刻の評価値がないから現時刻/現時刻にしてる
                Bestcost_pre = Bestcost;
                Bestcost_now = Bestcost;
                sigma_reset_flag = 0;
            else
                Bestcost_pre = Bestcost_now;
                Bestcost_now = Bestcost;
            end
            sigmanext_x = sigmax(1,1) * (Bestcost_now/Bestcost_pre);
            sigmanext_y = sigmay(1,1) * (Bestcost_now/Bestcost_pre);
%             sigmanext_x = sigmax(1,1);
%             sigmanext_y = sigmay(1,1);
    end

    %-- データ保存
        data.path{idx+1}  = state_data;    % - 全サンプル全ホライズンの値
        data.pathJ{idx+1} = Evaluationtra; % - 全サンプルの評価値
        data.state(idx+1, 1) = idx * dt;         % - 現在時刻
        data.state(idx+1, 2) = x(1);             % - 状態 x
        data.state(idx+1, 3) = x(2);             % - 状態 y
        data.state(idx+1, 4) = unow(1, 1);       % - 入力 ux  
        data.state(idx+1, 5) = unow(2, 1);       % - 入力 uy
        data.state(idx+1, 6) = norm(unow(:, 1)); % - ux,uyのノルム
        data.state(idx+1, 7) = xr(1, 1);         % - 目標状態 xr
        data.state(idx+1, 8) = xr(2, 1);         % - 目標状態 yr
        data.bestcost(idx+1) = Bestcost; % - もっともよい評価値
        data.bestx(idx+1, :) = state_data(1, :, BestcostID); % - もっともよい評価の軌道x成分
        data.besty(idx+1, :) = state_data(2, :, BestcostID); % - もっともよい評価の軌道y成分
        data.sigmax(idx+1, :) = sigmax(1, 1); % - xの標準偏差の値
        data.sigmay(idx+1, :) = sigmay(1, 1); % - yの標準偏差の値        

    %-- 状態更新
        x = Ad * x + Bd * unow(:, 1);
        Count_sigma = Count_sigma + 1;
        
    %-- ticの対、制御周期をグラフにしたかったらtocの左辺に変数おいて、それをプロットすればできると思う
        toc
        
        disp(['Time: ', num2str(idx * dt, '%.2f')]); %, num2str(unow(:,1)','[%.2f\t]')
end

%% Save data
    cd(strcat(Outputdir, '/data'));
    writematrix(data.state, 'result.csv');
    writematrix([data.state(:, 1), data.bestcost'], 'result_bestcost.csv');
    writematrix(data.bestx, 'result_bestx.csv');
    writematrix(data.besty, 'result_besty.csv');
    save('Parameter.mat', '-struct', 'Params', '-v7.3'); % - 2GBを超える.matを保存する場合'-v7.3'の追記が必要、今後ドローンに適用したら2GB超えると思う
    cd(fileparts(tmp.Filename))
    
%% Plot
    %-- 画像生成
        PlotFig

    %-- 動画生成
        PlotMov

%% Model
    function [Ad, Bd, Cd, Dd]  = MassModel(Td)
        %-- 連続系システム
                Ac = [1.0, 0.0;
                      0.0, 1.0];
                Bc = [1.0, 0.0;
                      0.0, 1.0];
                Cc = diag([1, 1]);
                Dc = 0;
                sys = ss(Ac, Bc, Cc, Dc);

        %-- 離散系システム
                dsys = c2d(sys, Td); % - 連続系から離散系への変換
                [Ad, Bd, Cd, Dd] = ssdata(dsys);

    end

