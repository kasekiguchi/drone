%% Drone 班用共通プログラム update sekiguchi
%-- 連続時間モデル　リサンプリングつき これを基に変更
%% Initialize settings
% set path
activeFile = matlab.desktop.editor.getActive;
cd(fileparts(activeFile.Filename));
[~, activeFile] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), activeFile, 'UniformOutput', false);
close all hidden; clear all; clc;
userpath('clear');
% warning('off', 'all');
run("main1_setting.m");
run("main2_agent_setup_sqp.m");
%agent.set_model_error("ly",0.02);
%% set logger
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
LogData = [     % agentのメンバー関係以外のデータ
        ];
LogAgentData = [% 下のLOGGER コンストラクタで設定している対象agentに共通するdefault以外のデータ
            ];
logger = LOGGER(1:N, size(ts:dt:te, 2), fExp, LogData, LogAgentData);

%-- MPC関連 変数定義 
    Params.H = 10;  % 10
    Params.dt = 0.025;
    idx = 0; %プログラムの周回数
    totalT = 0;

    %% 重みの設定
    
%     Params.Weight.P =  diag([1.0; 1.0; 1.0]);    % 座標   1000 1000 100
%     Params.Weight.V = diag([1.0; 1.0; 1.0]);    % 速度
%     Params.Weight.Q = diag([1.0; 1.0; 1.0]);    % 姿勢角
%     Params.Weight.W = diag([1.0; 1.0; 1.0]);    % 角速度
%     Params.Weight.R = 0.01 * diag([1.0,; 1.0; 1.0; 1.0]); % 入力
%     Params.Weight.RP = 0.01 * diag([1.0,; 1.0; 1.0; 1.0]);  % 1ステップ前の入力との差
%     Params.Weight.QW = diag([1.0,; 1.0; 1.0; 1.0; 1.0; 1000.0]);  % 姿勢角、角速度

% 離陸
%     Params.Weight.P = diag([1000.0; 1000.0; 100.0]);    % 座標   1000 1000 100
%     Params.Weight.V = diag([1.0; 1.0; 1.0]);    % 速度
%     Params.Weight.R = diag([1.0,; 1.0; 1.0; 1.0]); % 入力
%     Params.Weight.RP = diag([1.0,; 1.0; 1.0; 1.0]);  % 1ステップ前の入力との差    0*(無効化)
%     Params.Weight.QW = diag([10; 10; 10; 0.01; 0.01; 100.0]);  % 姿勢角、角速度

    % 円旋回(重みの設定)
    Params.Weight.P = diag([10.0; 10.0; 100.0]);    % 座標   1000 10
    Params.Weight.V = diag([1.0; 1.0; 1.0]);    % 速度
    Params.Weight.R = diag([1.0,; 1.0; 1.0; 1.0]); % 入力
    Params.Weight.RP = diag([1.0,; 1.0; 1.0; 1.0]);  % 1ステップ前の入力との差    0*(無効化)
    Params.Weight.QW = diag([1000; 1000; 1000; 1; 1; 1]);  % 姿勢角、角速度
    %% 
    
%-- data
    data.bestcost(idx+1) = 0;           % - もっともよい評価値
%     data.pathJ{idx+1} = 0;              % - 全サンプルの評価値
%     data.sigma(idx+1) = 0;
%     data.state{idx+1} = 0;
%     data.input{idx+1} = 0;

%-- 配列サイズ
    Params.state_size = 12; %12状態
    Params.input_size = 4;  %4つの入力
    Params.total_size = Params.state_size + Params.input_size;

%-- 目標値等
    Params.ur = 0.269*9.81/4 * ones(4, 1);

%-- fmincon 設定
    options = optimoptions('fmincon');
%     options = optimoptions(options,'Diagnostics','off');
%     options = optimoptions(options,'MaxFunctionEvaluations',1.e+12);     % 評価関数の最大値
    options = optimoptions(options,'MaxIterations',      1.e+9);     % 最大反復回数
    options = optimoptions(options,'ConstraintTolerance',1.e-4);%制約違反に対する許容誤差
    
    %-- fmincon設定
    options.Algorithm = 'sqp';  % 逐次二次計画法
%     options.Display = 'iter';   % 計算結果の表示
    problem.solver = 'fmincon'; % solver
    problem.options = options;  % 

    x = agent.estimator.result.state.get();

    %Koopman
    load('drone\MCMPC_Koopman\drone\koopman_data\EstimationResult_12state_6_26_circle.mat','est');
    Params.A = est.A;
    Params.B = est.B;
    Params.C = est.C;
%     f = @(x) [x;1];
%     Params.f = {f};

%     xc = f(x); %複素空間へ値を写像
    previous_state  = zeros(Params.state_size + Params.input_size, Params.H);

    xr = zeros(Params.state_size+Params.input_size, Params.H);

    %-- パラメータ確認
    Params
    
run("main3_loop_setup.m");


try
    while round(time.t, 5) <= te
        tic
        idx = idx + 1;
%         profile on;
        %% sensor
        %    tic
        tStart = tic;
if time.t == 9
    time.t;
end
        if (fOffline)
            expdata.overwrite("plant", time.t, agent, i);
            FH.CurrentCharacter = char(expdata.Data{1}.phase(offline_time));
            time.t = expdata.Data{1}.t(offline_time);
            offline_time = offline_time + 1;
        end

        if fMotive
            %motive.getData({agent,["pL"]},mparam);
            motive.getData(agent, mparam);
        end

        for i = 1:N
            % sensor
            if fMotive; param(i).sensor.motive = {}; end
            param(i).sensor.rpos = {agent};
            param(i).sensor.imu = {[]};
            param(i).sensor.direct = {};
            param(i).sensor.rdensity = {Env};
            param(i).sensor.lrf = Env;
            for j = 1:length(agent(i).sensor.name)
                param(i).sensor.list{j} = param(i).sensor.(agent(i).sensor.name(j));
            end
            agent(i).do_sensor(param(i).sensor.list);
            %if (fOffline);    expdata.overwrite("sensor",time.t,agent,i);end
        end
        

        %% estimator, reference generator, controller
        for i = 1:N
            % estimator
            agent(i).do_estimator(cell(1, 10));
            %if (fOffline);exprdata.overwrite("estimator",time.t,agent,i);end
            % reference 目標値       
        %-- 目標軌道生成
            xr = Reference(Params, time.t, agent);
            param(i).reference.covering = [];
            param(i).reference.point = {FH, [0;0;1], time.t};  % 目標値[x, y, z]
            param(i).reference.timeVarying = {time};
            param(i).reference.tvLoad = {time};
            param(i).reference.wall = {1};
            param(i).reference.agreement = {logger, N, time.t};
            for j = 1:length(agent(i).reference.name)
                param(i).reference.list{j} = param(i).reference.(agent(i).reference.name(j));
            end
            agent(i).do_reference(param(i).reference.list);
            %if (fOffline);exprdata.overwrite("reference",time.t,agent,i);end
    %-- newton and sqp MPC controller
        x = agent.estimator.result.state.get(); % これ追加10/14　よくなった気がする
        %-- MPCパラメータを構造体に格納
            Params.ts = 0;
            Params.xr = xr;
%             Params.ur = ur;
            Params.X0= x;   % 現在状態の記録
            
        %-- 状態の表示
            state_monte = agent.model.state;
            ref_monte = agent.reference.result.state;
            
        %-- 初期値の設定
            if idx == 1
                initial_u1 = 0.5884 * 9.81 / 4;   % 初期値
                initial_u2 = initial_u1;
                initial_u3 = initial_u1;
                initial_u4 = initial_u1;
            else
                initial_u1 = agent.input(1);
                initial_u2 = agent.input(2);
                initial_u3 = agent.input(3);
                initial_u4 = agent.input(4);
            end
            x0 = [initial_u1; initial_u2; initial_u3; initial_u4];% 初期値＝入力
            previous_state = repmat([agent.estimator.result.state.get(); x0], 1, Params.H);
            % previous_state の1行目

%                 previous_state(Params.state_size+1:Params.total_size, 1:Params.H) = repmat(x0, 1, Params.H);
            
            % MPC設定(problem)
            problem.x0		  = previous_state;       % 状態，入力を初期値とする      % 現在状態
%             problem.objective = @(x) Objective(x, Params, agent);            % 評価関数
            problem.objective = @(x) Objective(x,  Params, agent);            % 評価関数
%             problem.nonlcon   = @(x) Constraints(x, Params, agent, time);    % 制約条件
            problem.nonlcon   = @(x) Constraints(x, Params, agent, time);    % 制約条件
            [var, fval, exitflag, output, lambda, grad, hessian] = fmincon(problem); %最適化計算
            % 制御入力の決定
            previous_state = var   % 初期値の書き換え(最適化計算で求めたホライズン数分の値)
            fprintf("\tfval : %f\n", fval)
        %TODO: 1列目のvarが一切変動しない問題に対処
%             if var(Params.state_size+1:Params.total_size, end) > 1.0
%                 var(Params.state_size+1:Params.total_size, end) = 1.0 * ones(4, 1);
%             end
            
            fprintf("pos: %f %f %f \t u: %f %f %f %f \t ref: %f %f %f \t flag: %d",...
                state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                agent.input(1), agent.input(2), agent.input(3), agent.input(4),...
                ref_monte.p(1), ref_monte.p(2), ref_monte.p(3), exitflag);

            agent.input = var(Params.state_size+1:Params.total_size, 1);    % 2なら飛んだ(ホライズンの一番はじめの入力のみを代入)
    
        end   
        %-- データ保存
            data.bestcost = fval; %もっともよい評価値を保存

%             data.bestcost(idx) = output.bestfeasible.fval; 
%             data.pathJ{idx} = output.bestfeasible.fval; % - 全サンプルの評価値
%             data.sigma(idx) = sigma;
%             data.state{idx} = state_data(:, 1, BestcostID);
%             data.input{idx} = u;

        %% update state
        % with FH
        figure(FH)
        drawnow

        for i = 1:N  % 状態更新(実際にドローンがどう動くかの計算)
            model_param.param = agent(i).model.param;
            model_param.FH = FH;
            agent(i).do_model(model_param); % 算出した入力と推定した状態を元に状態の1ステップ予測を計算 model_param：DRONE_PARAMで設定した値
            % ここでモデルの計算
            model_param.param = agent(i).plant.param;
            agent(i).do_plant(model_param);
        end

        % for exp
        if fExp %実機
            %% logging
            calculation1 = toc(tStart);
            time.t = time.t + calculation1;
            logger.logging(time.t, FH, agent, []);
            calculation2 = toc(tStart);
            time.t = time.t + calculation2 - calculation1;
        else
            logger.logging(time.t, FH, agent); %値の記録

            if (fOffline)
                time.t
            else
                time.t = time.t + dt % for sim 時刻の更新
            end

        end
        calT = toc % 1ステップ（25ms）にかかる計算時間
        totalT = totalT + calT; %すべての計算を終えるまでにかかった時間
        
        %% 逐次プロット
%         figure(10);
%         clf
%         Tv = time.t:Params.dt:time.t+Params.dt*(Params.H-1);
%         TvC = 0:Params.dt:te;
%         %% circle
%         CRx = cos(TvC/2);
%         CRy = sin(TvC/2);
% 
%         plot(Tv, xr(1, :), '-', 'LineWidth', 2);hold on;
%         plot(Tv, xr(2, :), '-', 'LineWidth', 2);
% 
%         plot(TvC, CRx, '--', 'LineWidth', 1);
%         plot(TvC, CRy, '--', 'LineWidth', 1);
%         plot(time.t, agent.estimator.result.state.p(1), 'h', 'MarkerSize', 20);
%         plot(time.t, agent.estimator.result.state.p(2), '*', 'MarkerSize', 20);
%         hold off;
%         xlabel("Time [s]"); ylabel("Reference [m]");
%         legend("xr.x", "xr.y", "h.x", "h.y", "est.x", "est.y", "Location", "southeast");
% %         legend("xr.x", "xr.y", "xr.z", "est.x", "est.y", "est.z");
%         xlim([0 te]); ylim([-inf inf+0.1]); 
        %%
        drawnow 
%        profile viewer;
    end

catch ME % for error
    % with FH
    for i = 1:N
        agent(i).do_plant(struct('FH', FH), "emergency");
    end

    warning('ACSL : Emergency stop! Check the connection.');
    rethrow(ME);
end
%% 

%profile viewer
%%グラフの描画
close all
opengl software

size_best = size(data.bestcost, 2);
Edata = logger.data(1, "p", "e")';
Rdata = logger.data(1, "p", "r")';
Diff = Edata - Rdata;

fprintf("%f秒\n", totalT)
Fontsize = 15;  timeMax = 10;
set(0, 'defaultAxesFontSize', Fontsize);
set(0, 'defaultTextFontSize', Fontsize);
% logger.plot({1,"p","e"})
% hold on
% logger.plot({1,"p","r"})
logger.plot({1,"p", "er"},  "fig_num",1); % set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference");
logger.plot({1,"v", "e"},   "fig_num",2); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Velocity [m/s]"); legend("x.vel", "y.vel", "z.vel");
logger.plot({1,"q", "p"},   "fig_num",3); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw");
logger.plot({1,"w", "p"},   "fig_num",4); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Angular velocity [rad/s]"); legend("roll.vel", "pitch.vel", "yaw.vel");
logger.plot({1,"input", ""},"fig_num",5); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Input"); 
% logger.plot({1,"p","e"},{1,"v","e"},{1,"q","e"},{1,"w","e"},{1,"input",""},{1, "p1-p2-p3", "e"}, "time", [0, timeMax], "fig_num",1,"row_col",[2,3]);

%% Difference of Pos
figure(7);
plot(logger.data('t', [], [])', Diff, 'LineWidth', 2);
legend("$$x_\mathrm{diff}$$", "$$y_\mathrm{diff}$$", "$$z_\mathrm{diff}$$", 'Interpreter', 'latex', 'Location', 'southeast');
set(gca,'FontSize',15);  grid on; title(""); ylabel("Difference of Pos [m]"); xlabel("time [s]"); xlim([0 10])

%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
agent(1).animation(logger,"target",1);
% agent(1).animation(logger,"gif", 1);
%%
% logger.save();

function [eval] = Objective(x, params, Agent) % x : p q v w input
%-- 評価計算をする関数
%-- 現在の状態および入力
%     x = repmat(x, 1, params.H);
    Xp = x(1:3, :);
    Xq = x(4:6, :);
    Xv = x(7:9, :);  
    Xw = x(10:12, :);
    U = x(13:16, :);
    
%-- 状態及び入力に対する目標状態や目標入力との誤差を計算
    tildeXp = Xp - params.xr(1:3, :);  % 位置
    tildeXq = Xq - params.xr(4:6, :);
    tildeXv = Xv - params.xr(7:9, :);  % 速度
    tildeXw = Xw - params.xr(10:12,:);
    tildeXqw = [tildeXq; tildeXw];     % 原点との差分ととらえる
    tildeUpre = U - Agent.input;
    tildeUref = U - params.xr(13:16,:);
    
%-- 状態及び入力のステージコストを計算 長くなるから分割
    stageStateP  = arrayfun(@(L) tildeXp(:, L)'   * params.Weight.P         * tildeXp(:, L),   1:params.H-1);
    stageStateV  = arrayfun(@(L) tildeXv(:, L)'   * params.Weight.V         * tildeXv(:, L),   1:params.H-1);
    stageStateQW = arrayfun(@(L) tildeXqw(:, L)'  * params.Weight.QW        * tildeXqw(:, L),  1:params.H-1);
    stageInputP  = arrayfun(@(L) tildeUpre(:, L)' * params.Weight.RP        * tildeUpre(:, L), 1:params.H-1);
    stageInputR  = arrayfun(@(L) tildeUref(:, L)' * params.Weight.R         * tildeUref(:, L), 1:params.H-1);
    stageState = stageStateP + stageStateV +  stageStateQW + stageInputP + stageInputR; % ステージコスト
    
%-- 状態の終端コストを計算
    terminalState =  tildeXp(:, end)'   * params.Weight.P   * tildeXp(:, end)...
                    +tildeXv(:, end)'   * params.Weight.V   * tildeXv(:, end)...
                    +tildeXqw(:, end)'  * params.Weight.QW  * tildeXqw(:, end);

%-- 評価値計算
    eval = sum(stageState) + terminalState;
end

function [c, ceq] = Constraints(x, params, Agent, ~)
% モデル予測制御の制約条件を計算するプログラム
    c  = zeros(params.state_size, params.H);
    ceq_ode = zeros(params.state_size, params.H);

%-- MPCで用いる予測状態 Xと予測入力 Uを設定
    X = x(1:params.state_size, :);          % 12 * Params.H 
    one = ones(1,params.H);
    Xc = vertcat(X,one);
%     Xc = [X(1:params.state_size, 1);1];     % 13 * 1(観測量に通したつもり)
%     Xc = repmat(Xc,1,params.H);
    U = x(params.state_size+1:params.total_size, :);   % 4 * Params.H

%- ダイナミクス拘束
%-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定　非線形等式を計算します．
%-- 連続の式をダイナミクス拘束に使う
    for L = 2:params.H
%         xx = X(:, L-1);
%         xu = U(:, L-1);
%         xp = params.X0;
%         [~,tmpx]=Agent.model.solver(@(t,X) Agent.model.method(xx, xu, Agent.parameter.get()), [0 0+params.dt],params.X0);
%         [~,tmpx]=Agent.model.solver(@(t,X) Agent.model.method(xx, xu, Agent.parameter.get()), [0 0+params.dt],xp);
%         [~,tmpx]=Agent.model.solver(@(t,X) Agent.model.method(xx, xu, Agent.parameter.get()), [0 0+params.dt],xp);
%         tmpx = xp + params.dt * Agent.model.method(xx, xu, Agent.parameter.get()); %非線形モデル

        tmpx = params.A * Xc(:,L-1) + params.B * U(:,L-1); %クープマンモデル
        tmpx = params.C * tmpx;
        ceq_ode(:, L) = X(:, L) - tmpx;   % tmpx : 縦ベクトル？ 入力が正しいかを確認
    end
    ceq = [X(:, 1) - params.X0, ceq_ode];
%     c(:, 1) = [];
%     c = X(1,:) - 2;
end
