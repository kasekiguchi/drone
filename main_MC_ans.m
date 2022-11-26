%% Drone 班用共通プログラム update sekiguchi
%-- 連続時間モデル　リサンプリングつき これを基に変更
%% Initialize settings
% set path
activeFile = matlab.desktop.editor.getActive;
cd(fileparts(activeFile.Filename));
DATAdir = cd(fileparts(activeFile.Filename));
[~, activeFile] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), activeFile, 'UniformOutput', false);
close all hidden; clear all; clc;
userpath('clear');
% warning('off', 'all');
run("main1_setting.m");
run("main2_agent_setup_class.m");
%agent.set_model_error("ly",0.02);
%% set logger
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
LogData = [     % agentのメンバー関係以外のデータ
        ];
LogAgentData = [% 下のLOGGER コンストラクタで設定している対象agentに共通するdefault以外のデータ
            ];

logger = LOGGER(1:N, size(ts:dt:te, 2), fExp, LogData, LogAgentData);

%% main loop
    fInput = 0;
    fV = 0;
    fVcount = 1;
    fWeight = 0; % 重みを変化させる場合 fWeight = 1
    fFirst = 1; % 一回のみ回す場合
    fRemove = 0;    % 終了判定
    fLanding = 0;   % 着陸かどうか 目標軌道を変更する
    fLanding_comp = 0;
    fCount_landing = 0;
    fc = 0;     % 着陸したときだけx，y座標を取得
    totalT = 0;
    idx = 0;

    %-- 初期設定 controller.mと同期させる
    Params.H = 10;   %Params.H
    Params.dt = 0.1;  %Params.dt
    Params.dT = dt;
    %-- 配列サイズの定義
    Params.state_size = 12;
    Params.input_size = 4;
    Params.total_size = 16;
    % Reference.mを使えるようにする
    Params.ur = 0.269 * 9.81 / 4 * ones(Params.input_size, 1);
    xr0 = zeros(Params.state_size, Params.H);

    % X of HL
    load('Data/Circle_HL.mat', 'QHL','WHL','PHL','VHL');
    Params.qHL = QHL';
    Params.wHL = WHL';
    Params.pHL = PHL';
    Params.vHL = VHL';
    X = [PHL'; QHL'; VHL'; WHL'];

    % データ保存初期化
    data.xr{idx+1} = 0;
    data.path{idx+1} = 0;       % - 全サンプル全ホライズンの値
    data.pathJ{idx+1} = 0;      % - 全サンプルの評価値
    data.sigma(idx+1) = 0;      % - 標準偏差 
    data.bestcost(idx+1) = 0;   % - 評価値
    data.removeF(idx+1) = 0;    % - 棄却されたサンプル数
    data.removeX{idx+1} = 0;    % - 棄却されたサンプル番号

    dataNum = 11;
    data.state           = zeros(round(te/dt + 1), dataNum);       
    data.state(idx+1, 1) = idx * dt;        % - 現在時刻
    data.state(idx+1, 2) = initial.p(1);    % - 状態 x
    data.state(idx+1, 3) = initial.p(2);    % - 状態 y
    data.state(idx+1, 4) = initial.p(3);    % - 状態 z
    data.state(idx+1, 5) = agent.input(1);  % - 入力 u1
    data.state(idx+1, 6) = agent.input(2);  % - 入力 u2
    data.state(idx+1, 7) = agent.input(3);  % - 入力 u3
    data.state(idx+1, 8) = agent.input(4);  % - 入力 u4
    data.state(idx+1, 9) = 0;               % - 目標状態 xr
    data.state(idx+1, 10) = 0;              % - 目標状態 yr
    data.state(idx+1, 11) = 0;              % - 目標状態 zr
    data.bestx(idx+1, :) = repelem(initial.p(1), Params.H); % - もっともよい評価の軌道x成分
    data.besty(idx+1, :) = repelem(initial.p(2), Params.H); % - もっともよい評価の軌道y成分
    data.bestz(idx+1, :) = repelem(initial.p(3), Params.H); % - もっともよい評価の軌道z成分

    fprintf("Initial Position: %4.2f %4.2f %4.2f\n", initial.p);
    %%

run("main3_loop_setup.m");

try
    while round(time.t, 5) <= te
        tic
        idx = idx + 1;
        %% sensor
        %    tic
        tStart = tic;
if time.t == 9
    time.t;
end
        % CurrentCharacter Check
%             fprintf("key input : %c", FH.CurrentCharacter)
        % ----------------------
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

            param(i).reference.covering = [];
            param(i).reference.point = {FH, [1;1;1], time.t};  % 目標値[x, y, z]
            param(i).reference.timeVarying = {time};
            param(i).reference.tvLoad = {time};
            param(i).reference.wall = {1};
            param(i).reference.agreement = {logger, N, time.t};
            for j = 1:length(agent(i).reference.name)
                param(i).reference.list{j} = param(i).reference.(agent(i).reference.name(j));
            end
            agent(i).do_reference(param(i).reference.list);

            % timevarygin -> generated reference
            xr = Reference(Params, time.t, agent);
            % reference from HL
%             xr = Reference(Params, time.t, X);
            % controller
            param(i).controller.mcmpc = {idx, xr};    % 入力算出 / controller.name = hlc
            for j = 1:length(agent(i).controller.name)
                param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
            end
            agent(i).do_controller(param(i).controller.list);
        end

        %-- データ保存
        if idx == 1
            data.param = agent.controller.result.contParam;
        end
        state_data = agent.controller.result.path;
        BestcostID = agent.controller.result.BestcostID;
        data.path{idx} = state_data;
        data.pathJ{idx} = agent.controller.result.Evaluationtra; % - 全サンプルの評価値
        data.sigma(idx) = agent.controller.result.sigma;
        data.bestcost(idx) = agent.controller.result.bestcost;
        data.removeF(idx+1) = agent.controller.result.removeF;   % - 棄却されたサンプル数
        data.removeX{idx+1} = agent.controller.result.removeX;

        data.state(idx+1, 1) = idx * dt; % - 現在時刻
        data.state(idx+1, 2) = agent.estimator.result.state.p(1);   % - 状態 x
        data.state(idx+1, 3) = agent.estimator.result.state.p(2);   % - 状態 y
        data.state(idx+1, 4) = agent.estimator.result.state.p(3);   % - 状態 z
        data.state(idx+1, 5) = agent.input(1);  % - 入力 u1
        data.state(idx+1, 6) = agent.input(2);  % - 入力 u2
        data.state(idx+1, 7) = agent.input(3);  % - 入力 u3
        data.state(idx+1, 8) = agent.input(4);  % - 入力 u4
        data.state(idx+1, 9)  = xr(1, 1);    % - 目標状態 xr
        data.state(idx+1, 10) = xr(2, 1);   % - 目標状態 yr
        data.state(idx+1, 11) = xr(3, 1);   % - 目標状態 zr

        if data.removeF(idx+1) ~= data.param.particle_num
            data.bestx(idx+1, :) = state_data(1, :, BestcostID); % - もっともよい評価の軌道x成分
            data.besty(idx+1, :) = state_data(2, :, BestcostID); % - もっともよい評価の軌道y成分
            data.bestz(idx+1, :) = state_data(3, :, BestcostID); % - もっともよい評価の軌道z成分
        else
            data.bestx(idx+1, :) = data.bestx(idx, :); % - もっともよい評価の軌道x成分
            data.besty(idx+1, :) = data.besty(idx, :); % - もっともよい評価の軌道y成分
            data.bestz(idx+1, :) = data.bestz(idx, :); % - もっともよい評価の軌道z成分
        end
   
        if data.removeF(idx+1) == 0
            disp('State Constraint Violation!')
        end

        state_monte = agent.estimator.result.state;
        ref_monte = agent.reference.result.state;

        fprintf("pos: %f %f %f \t vel: %f %f %f \t q: %f %f %f \t ref: %f %f %f \n",...
                state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                state_monte.v(1), state_monte.v(2), state_monte.v(3),...
                state_monte.q(1)*180/pi, state_monte.q(2)*180/pi, state_monte.q(3)*180/pi,...
                xr(1,1), xr(2,1), xr(3,1));

        %% update state
        % with FH
        figure(FH)
        drawnow

        for i = 1:N                         % 状態更新
            model_param.param = agent(i).model.param;
            model_param.FH = FH;
            agent(i).do_model(model_param); % 算出した入力と推定した状態を元に状態の1ステップ予測を計算
            % ここでモデルの計算
            model_param.param = agent(i).plant.param;
            agent(i).do_plant(model_param);
        end

        % for exp
        if fExp
            %% logging
            calculation1 = toc(tStart);
            time.t = time.t + calculation1;
            logger.logging(time.t, FH, agent, []);
            calculation2 = toc(tStart);
            time.t = time.t + calculation2 - calculation1;
        else
            logger.logging(time.t, FH, agent);

            if (fOffline)
                time.t
            else
                time.t = time.t + dt % for sim
            end

        end
        fRemove = agent.controller.result.fRemove;
        if fRemove == 1
            warning("Emergency Stop!!!")
            break;
        end
        calT = toc % 1ステップ（25ms）にかかる計算時間
        totalT = totalT + calT;
        
        %% 逐次プロット
        figure(10);
        clf
        Tv = time.t:Params.dt:time.t+Params.dt*(Params.H-1);
        TvC = 0:Params.dt:te;
        %% circle
        plot(Tv, xr(1, :), '.', 'LineWidth', 2);hold on;
        plot(Tv, xr(2, :), '.', 'LineWidth', 2);
        plot(time.t, agent.estimator.result.state.p(1), 'h', 'MarkerSize', 20);
        plot(time.t, agent.estimator.result.state.p(2), '*', 'MarkerSize', 20);
        hold off;
        xlabel("Time [s]"); ylabel("Reference [m]");
        legend("xr.x", "xr.y", "est.x", "est.y", "Location", "southeast");
        xlim([0 te]); ylim([-inf inf+0.1]); 

        fprintf("sigma: %f\n", data.sigma(idx))

        %%
        drawnow 
    end

catch ME % for error
    % with FH
    for i = 1:N
        agent(i).do_plant(struct('FH', FH), "emergency");
    end

    warning('ACSL : Emergency stop! Check the connection.');
    rethrow(ME);
end

%profile viewer
%%
close all

size_best = size(data.bestcost, 2);
Edata = logger.data(1, "p", "e")';
Rdata = logger.data(1, "p", "r")';
Diff = Edata - Rdata;

fprintf("%f秒\n", totalT)
Fontsize = 15;  timeMax = te;
logger.plot({1,"p", "er"},  "fig_num",1); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference");
logger.plot({1,"v", "e"},   "fig_num",2); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Velocity [m/s]"); legend("x.vel", "y.vel", "z.vel");
% logger.plot({1,"q", "p"},   "fig_num",3); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw");
% logger.plot({1,"w", "p"},   "fig_num",4); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Angular velocity [rad/s]"); legend("roll.vel", "pitch.vel", "yaw.vel");
logger.plot({1,"input", ""},"fig_num",5); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Input"); 
% logger.plot({1,"p","er"},{1,"v","e"},{1,"q","p"},{1,"w","p"},{1,"input",""},{1, "p1-p2-p3", "er"}, "fig_num",1,"row_col",[2,3]);

%% Difference of Pos
% figure(7);
% plot(logger.data('t', [], [])', Diff, 'LineWidth', 2);
% legend("$$x_\mathrm{diff}$$", "$$y_\mathrm{diff}$$", "$$z_\mathrm{diff}$$", 'Interpreter', 'latex', 'Location', 'southeast');
% set(gca,'FontSize',15);  grid on; title(""); ylabel("Difference of Pos [m]"); xlabel("time [s]"); xlim([0 10])

%% 2軸グラフ
% figure(9);
% yyaxis left
% logger.plot({1, "input", ""});
% fig9_LW = 0.5;
% % plot(logger.data('t', [], []), data.input(:, 1), "Color", "blue", "LineWidth", fig9_LW, 'LineStyle','-'); hold on;
% % plot(logger.data('t', [], []), data.input(:, 2), "Color", "red", "LineWidth", fig9_LW, 'LineStyle','-')
% % plot(logger.data('t', [], []), data.input(:, 3), "Color", "#FCAF22", "LineWidth", fig9_LW, 'LineStyle','-')
% % plot(logger.data('t', [], []), data.input(:, 4), "Color", "#A757A8", "LineWidth", fig9_LW, 'LineStyle','-'); hold off;
% set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Input");
% yyaxis right
% plot(logger.data('t', [], [])', data.bestcost(1:end-1), 'LineWidth', 2, 'LineStyle','--');
% set(gca,'FontSize',15);  grid on; title(""); ylabel("Evaluation [m]"); xlabel("time [s]"); xlim([0 10]);
% legend("roter1", "roter2", "roter3", "roter4", "$$J$$", 'Interpreter', 'latex', 'Location', 'northeast')

%% 動画生成
%  ディレクトリ生成
mkdir C:\Users\student\Documents\Komatsu\MCMPC\simdata png/Animation1
mkdir C:\Users\student\Documents\Komatsu\MCMPC\simdata png/Animation_omega
mkdir C:\Users\student\Documents\Komatsu\MCMPC\simdata video
Outputdir = 'C:\Users\student\Documents\Komatsu\MCMPC\simdata';
PlotMov       % 2次元プロット
% PlotMovXYZ  % 3次元プロット
% save()

%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
agent(1).animation(logger,"target",1);

%%
% logger.save();