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
%     Params.dt = 0.25; %MPCステップ幅
    Params.dt = 0.08; %MPCステップ幅
    idx = 0; %プログラムの周回数
    totalT = 0;
    Params.flag = 0; %1：PtoPでのリファレンスの入れ替え
    Params.PtoP = 0; %1：PtoP制御
    Params.T = 0; %1ステップにかかった計算時間

    %% 重みの設定
    
    % 円旋回(重みの設定)
    Params.Weight.P = diag([13; 6; 3]);    % 座標   1000 10
    Params.Weight.V = diag([1; 1; 1]);    % 速度
    Params.Weight.R = diag([15; 15; 10; 10]); % 入力
    Params.Weight.RP = diag([0; 0; 0; 0]);  % 1ステップ前の入力との差    0*(無効化)
    Params.Weight.QW = diag([8; 3; 10; 1; 1; 5]);  % 姿勢角、角速度

    Params.Weight.Pf = diag([1; 1; 1]);
    Params.Weight.QWf = diag([1; 1; 1; 1; 1; 1]); %姿勢角、角速度終端
  
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
    Params.ur = 0.5884*9.81/4 * ones(4, 1);

    %-- quadprog設定
    options = optimoptions('quadprog');
    options = optimoptions(options,'MaxIterations',      1.e+9);     % 最大反復回数
    options = optimoptions(options,'ConstraintTolerance',1.e-5);%制約違反に対する許容誤差
    options.Display = 'none';
    problem.solver = 'quadprog';

    x = agent.estimator.result.state.get();

    %Koopman
%     load('EstimationResult_12state_6_26_circle.mat','est') %観測量:状態のみ 入力:GUI
%     load('EstimationResult_12state_7_19_circle=circle_estimation=circle.mat','est'); %観測量:状態のみ
%       load('drone\MCMPC_Koopman\drone\koopman_data\EstimationResult_12state_7_26_circle=takeoff_estimation=circle.mat','est'); %take offをデータセットに含む，入力：4プロペラ
%     load('drone\MCMPC_Koopman\drone\koopman_data\EstimationResult_12state_7_7_circle=takeoff_estimation=takeoff.mat','est'); %take offをデータセットに含む，入力：GUI
%     load('drone\MCMPC_Koopman\drone\koopman_data\EstimationResult_12state_7_19_circle=circle_estimation=circle_InputandConst.mat','est'); %観測量:状態+非線形項
%     load('drone\MCMPC_Koopman\drone\koopman_data\EstimationResult_12state_7_20_simulation_circle_InputandConst.mat','est') %観測量:状態+非線形項、シミュレーションモデル
%     load('drone\MCMPC_Koopman\drone\koopman_data\EstimationResult_12state_7_20_simulation_circle.mat','est') %観測量:状態のみ、シミュレーションモデル
load('EstimationResult_12state_10_12_data=revcirandcir_circle=circle_estimation=circle_Inputandconst.mat','est') %観測量：状態＋非線形項、データセット：円旋回(各方向)
    Params.A = est.A;
    Params.B = est.B;
    Params.C = est.C;

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
        
        FH.CurrentCharacter = 'f'; %fを押さずに実行できる
        %% estimator, reference generator, controller
        for i = 1:N
            % estimator
            agent(i).do_estimator(cell(1, 10));
            %if (fOffline);exprdata.overwrite("estimator",time.t,agent,i);end
            % reference 目標値       
        %-- 目標軌道生成
%             if Params.PtoP == 1 %PtoPの場合はコメントイン
%                 xr = Reference2(Params, time.t, agent); %PtoP
%                 if agent.estimator.result.state.p(2) < -1
%                     Params.flag = 1;
%                 elseif agent.estimator.result.state.p(2) > 1
%                     Params.flag = 0;
%                 end
%                 if Params.flag == 1
%                     param(i).reference.point = {FH, [1;1;1;], time.t};
%                 else
%                     param(i).reference.point = {FH, [1;-1;1], time.t};
%                 end
%             else
%                 xr = Reference(Params, time.t, agent); %TimeVarying
%                 param(i).reference.point = {FH, [0;1;1], time.t};  % 目標値[x, y, z]
%             end
            
            %PtoPの場合はコメントオフ
            xr = Reference(Params, time.t, agent); %TimeVarying 目標値の更新
            param(i).reference.point = {FH, [0;1;1], time.t};  % 目標値[x, y, z]

            param(i).reference.covering = [];
%             param(i).reference.point = {FH, [0;0;1], time.t};  % 目標値[x, y, z]
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
%             previous_state = repmat([agent.estimator.result.state.get(); x0], 1, Params.H);
            % previous_state の1行目
           
            %MPC設定(quadprog)
            [H, f] = Change_equation(Params);
            A = [];
            b = [];
            Aeq = [];
            beq = [];
            lb = [];
            ub = [];
            x0 = repmat(x0,1,Params.H);

            [var, fval, exitflag, output, lambda] = quadprog(H, f, A, b, Aeq, beq, lb, ub, x0, options, problem);
            data.exitflag(idx) = exitflag;

            % 制御入力の決定
            previous_state = var;   % 初期値の書き換え(最適化計算で求めたホライズン数分の値)
            previous_state = reshape(previous_state,[4,Params.H])
            fprintf("\tfval : %f\n", fval)
%         TODO: 1列目のvarが一切変動しない問題に対処
%             if var(Params.state_size+1:Params.total_size, end) > 1.0  
%                 var(Params.state_size+1:Params.total_size, end) = 1.0 * ones(4, 1);
%             end
            
            fprintf("pos: %f %f %f \t u: %f %f %f %f \t ref: %f %f %f \t flag: %d",...
                state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                agent.input(1), agent.input(2), agent.input(3), agent.input(4),...
                ref_monte.p(1), ref_monte.p(2), ref_monte.p(3), exitflag);

            agent.input = var(1:4, 1);    % 2なら飛んだ(ホライズンの一番はじめの入力のみを代入)
    
        end   
        %-- データ保存
            data.bestcost(idx) = fval; %もっともよい評価値を保存

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
        if agent.estimator.result.state.p(3) < 0
            error('墜落しました');
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
        Params.T(idx) = calT; %計算時間の保存
        totalT = totalT + calT; %すべての計算を終えるまでにかかった時間
        
        %%
%         drawnow 
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

% size_best = size(data.bestcost, 2);
% Edata = logger.data(1, "p", "e")';
% Rdata = logger.data(1, "p", "r")';
% Diff = Edata - Rdata;

% fprintf("%f秒\n", totalT)
Fontsize = 15;  timeMax = 100;
set(0, 'defaultAxesFontSize', Fontsize);
set(0, 'defaultTextFontSize', Fontsize);

logger.plot({1,"p","er"},{1,"v","e"},{1,"q","e"},{1,"w","e"},{1,"input",""},{1, "p1-p2", "e"}, "fig_num",1,"row_col",[2,3]);
% logger.plot({1,"p","er"},{1,"v","e"},{1,"q","e"},{1,"w","e"},{1,"input",""},{1, "p1-p2-p3", "e"}, "fig_num",1,"row_col",[2,3]);

fig = figure(2);
subplot(2,2,1)
plot(logger.Data.t(1:find(logger.Data.t,1,'last'),:),data.exitflag, 'LineWidth',1.2)
grid on
xlabel('time t [s]')
ylabel('exitflag')

subplot(2,2,2)
plot(logger.Data.t(1:find(logger.Data.t,1,'last'),:),Params.T, 'LineWidth',1.2)
grid on
ylim([0, 0.05])
xlabel('time t [s]')
ylabel('Simulation time [s]')

subplot(2,2,3)
plot(logger.Data.t(1:find(logger.Data.t,1,'last'),:),data.bestcost, 'LineWidth',1.2)
grid on
xlabel('time t [s]')
ylabel('Best cost')

set(fig, 'Position', [1250, 60, 600, 400])

% save('simulation','logger')
% Graphplot
% delete simulation.mat
%% Difference of Pos
% figure(7);
% plot(logger.data('t', [], [])', Diff, 'LineWidth', 2);
% legend("$$x_\mathrm{diff}$$", "$$y_\mathrm{diff}$$", "$$z_\mathrm{diff}$$", 'Interpreter', 'latex', 'Location', 'southeast');
% set(gca,'FontSize',15);  grid on; title(""); ylabel("Difference of Pos [m]"); xlabel("time [s]"); xlim([0 10])

%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
% agent(1).animation(logger,"target",1);
% agent(1).animation(logger,"mp4",1);
% agent(1).animation(logger,"gif", 1);
