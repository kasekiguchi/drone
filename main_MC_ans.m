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
    fFirst = 0; % 一回のみ回す場合
    fRemove = 0;    % 終了判定
    fLanding = 0;   % 着陸かどうか 目標軌道を変更する
    fLanding_comp = 0;
    fCount_landing = 0;
    fc = 0;     % 着陸したときだけx，y座標を取得
    totalT = 0;
    idx = 0;
    pre_pos = 0;

    fG = zeros(3, 1);

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

    % データ保存初期化
    data.xr{idx+1} = 0;
    data.path{idx+1} = 0;       % - 全サンプル全ホライズンの値
    data.pathJ{idx+1} = 0;      % - 全サンプルの評価値
    data.sigma(idx+1) = 0;      % - 標準偏差 
    data.bestcost(idx+1) = 0;   % - 評価値
    data.removeF(idx+1) = 0;    % - 棄却されたサンプル数
    data.removeX{idx+1} = 0;    % - 棄却されたサンプル番号
    data.variable_particle_num(idx+1) = 0;  % - 可変サンプル数

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

    calT = 0;

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

        
        %--------------

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
        
%         if time.t > 2
%             FH.CurrentCharacter = 'm';
%         end
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
%             [xr, fFirst, pre_pos] = Reference(Params, time.t, agent, FH, fFirst, pre_pos);
            % Goal Position
            
%             [xr, fG] = Reference(Params, time.t, agent, G, fG);
            %% 次の目標値の設定
            TimeArray = [0, 5, 7, 10];
            if idx == 1
                Gp = [1; 0; 1]; 
                Gq = [0; 0; 0];
                ToTime = TimeArray(2);
                Cp = agent.estimator.result.state.p;
                StartT = 0;
            elseif idx == TimeArray(2)/0.025
                ToTime = TimeArray(3) - TimeArray(2);
                Cp = agent.estimator.result.state.p;
                Gp = [Cp(1); Cp(2); Cp(3)];
                Gq = [0; 0; 0];
                StartT = TimeArray(2);
            elseif idx == TimeArray(3)/0.025
                ToTime = te - TimeArray(3);
                Cp = agent.estimator.result.state.p;
                Gp = [Cp(1); 1; 1];
                Gq = [0; 0; 0];
                StartT = TimeArray(3);
            end
            [xr] = Reference(Params, time.t, agent, Gp, Gq, Cp, ToTime, StartT);
            param(i).controller.mcmpc = {idx, xr, time.t};    % 入力算出 / controller.name = hlc
            for j = 1:length(agent(i).controller.name)
                param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
            end
            agent(i).do_controller(param(i).controller.list);
        end

        %-- データ保存
        if idx == 1
            data.param = agent.controller.result.contParam;
        end
        state_data =            agent.controller.result.path;
        BestcostID =            agent.controller.result.BestcostID;
        data.path{idx} =        state_data;
        data.pathJ{idx} =       agent.controller.result.Evaluationtra; % - 全サンプルの評価値
        data.pathJN{idx} =      agent.controller.result.Evaluationtra_norm;
        data.sigma(idx) =       agent.controller.result.sigma;
        data.bestcost(idx) =    agent.controller.result.bestcost;
        data.removeF(idx) =     agent.controller.result.removeF;   % - 棄却されたサンプル数
        data.removeX{idx} =     agent.controller.result.removeX;

        data.state(idx, 1) = idx * dt; % - 現在時刻
        data.state(idx, 2) = agent.estimator.result.state.p(1);   % - 状態 x
        data.state(idx, 3) = agent.estimator.result.state.p(2);   % - 状態 y
        data.state(idx, 4) = agent.estimator.result.state.p(3);   % - 状態 z
        data.state(idx, 5) = agent.input(1);  % - 入力 u1
        data.state(idx, 6) = agent.input(2);  % - 入力 u2
        data.state(idx, 7) = agent.input(3);  % - 入力 u3
        data.state(idx, 8) = agent.input(4);  % - 入力 u4
%         data.state(idx, 9)  = xr(1, 1);    % - 目標状態 xr
%         data.state(idx, 10) = xr(2, 1);   % - 目標状態 yr
%         data.state(idx, 11) = xr(3, 1);   % - 目標状態 zr

        data.xr{idx} = xr;
        data.variable_particle_num(idx) = agent.controller.result.variable_N;
        data.survive{idx} = agent.controller.result.survive;
        COG = agent.controller.result.COG;
        data.cog.g{idx} = COG.g;
        data.cog.gc{idx} = COG.gc;

        if data.removeF(idx) ~= data.param.particle_num
            data.bestx(idx, :) = state_data(1, :, BestcostID); % - もっともよい評価の軌道x成分
            data.besty(idx, :) = state_data(2, :, BestcostID); % - もっともよい評価の軌道y成分
            data.bestz(idx, :) = state_data(3, :, BestcostID); % - もっともよい評価の軌道z成分
        else
            if idx == 1
                data.bestx(idx, :) = data.bestx(idx, :); % - 制約外は前の評価値を引き継ぐ
                data.besty(idx, :) = data.besty(idx, :); % - 制約外は前の評価値を引き継ぐ
                data.bestz(idx, :) = data.bestz(idx, :); % - 制約外は前の評価値を引き継ぐ
            else
                data.bestx(idx, :) = data.bestx(idx-1, :); % - 制約外は前の評価値を引き継ぐ
                data.besty(idx, :) = data.besty(idx-1, :); % - 制約外は前の評価値を引き継ぐ
                data.bestz(idx, :) = data.bestz(idx-1, :); % - 制約外は前の評価値を引き継ぐ
            end
        end
        state_monte = agent.estimator.result.state;
        ref_monte = agent.reference.result.state;
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
                time.t = time.t + dt; % for sim
            end

        end
        calT = toc; % 1ステップ（25ms）にかかる計算時間
        totalT = totalT + calT;
        data.calT(idx, :) = calT;

        fRemove = agent.controller.result.fRemove;
        if fRemove == 1
            warning("Z<0 Emergency Stop!!!")
            break;
        end
        fprintf("==================================================================\n")
        fprintf("==================================================================\n")
        fprintf("pos: %f %f %f \t vel: %f %f %f \t q: %f %f %f \t ref: %f %f %f \n",...
                state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                state_monte.v(1), state_monte.v(2), state_monte.v(3),...
                state_monte.q(1)*180/pi, state_monte.q(2)*180/pi, state_monte.q(3)*180/pi,...
                xr(1,1), xr(2,1), xr(3,1));
        fprintf("t: %6.3f \t calT: %f \t sigma: %f \t paritcle_num: %d \t remove: %d", time.t, calT, data.sigma(idx), data.variable_particle_num(idx), data.removeF(idx))
        fprintf("\t fGp:%d %d %d", fG(1), fG(2), fG(3))
        if data.removeF(idx) ~= 0
            fprintf('\t State Constraint Violation!')
%             data.removeX{idx}
%             data.sur{idx}
        end
        fprintf("\n");

        %% 逐次プロット
%         figure(10);
%         clf
%         Tv = time.t:Params.dt:time.t+Params.dt*(Params.H-1);
%         TvC = 0:Params.dt:te;
%         %% circle
%         plot(Tv, xr(1, :), '.', 'LineWidth', 2);hold on;
%         plot(Tv, xr(2, :), '.', 'LineWidth', 2);
%         plot(time.t, agent.estimator.result.state.p(1), 'h', 'MarkerSize', 20);
%         plot(time.t, agent.estimator.result.state.p(2), '*', 'MarkerSize', 20);
%         hold off;
%         xlabel("Time [s]"); ylabel("Reference [m]");
%         legend("xr.x", "xr.y", "est.x", "est.y", "Location", "southeast");
%         xlim([0 te]); ylim([-inf inf+0.1]); 
%         figure(20)
%         clf
%         if data.removeF(idx) == data.variable_particle_num(idx)
%             % 制約外の集合
%             xDc = reshape(data.path{idx}(1, end, data.removeX{idx}), [size(data.removeX{idx},1), 1]);
%             yDc = reshape(data.path{idx}(2, end, data.removeX{idx}), [size(data.removeX{idx},1), 1]);
%             plot(xDc, yDc, '.', 'MarkerSize', 5);
%             % 制約外の重心
%             plot(data.cog.gc{idx}(1), data.cog.gc{idx}(2), '+', 'MarkerSize', 5);
%             % 現在位置
%             plot(agent.estimator.result.state.p(1), agent.estimator.result.state.p(2), '*', 'MarkerSize', 5, 'Color', 'red');
%             xlim([-inf inf]); ylim([-inf inf]);
%             hold off;
%         elseif data.removeF(idx) == 0
%             % 制約内の集合
%             xD = reshape(data.path{idx}(1, end, data.survive{idx}), [size(data.survive{idx},1), 1]);
%             yD = reshape(data.path{idx}(2, end, data.survive{idx}), [size(data.survive{idx},1), 1]);
%             plot(xD, yD, '.', 'MarkerSize', 5); hold on;
%             % 制約内の重心
%             plot(data.cog.g{idx}(1), data.cog.g{idx}(2), '+', 'MarkerSize', 5);
%             % 現在位置
%             plot(agent.estimator.result.state.p(1), agent.estimator.result.state.p(2), '*', 'MarkerSize', 5, 'Color', 'red');
%             xlim([-inf inf]); ylim([-inf inf]);
%             hold off;
%         else
%             % 制約内の集合
%             xD = reshape(data.path{idx}(1, end, data.survive{idx}), [size(data.survive{idx},1), 1]);
%             yD = reshape(data.path{idx}(2, end, data.survive{idx}), [size(data.survive{idx},1), 1]);
%             plot(xD, yD, '.', 'MarkerSize', 5); hold on;
%             % 制約内の重心
%             plot(data.cog.g{idx}(1), data.cog.g{idx}(2), '+', 'MarkerSize', 5);
%             % 制約外の集合
%             xDc = reshape(data.path{idx}(1, end, data.removeX{idx}), [size(data.removeX{idx},1), 1]);
%             yDc = reshape(data.path{idx}(2, end, data.removeX{idx}), [size(data.removeX{idx},1), 1]);
%             plot(xDc, yDc, '.', 'MarkerSize', 5);
%             % 制約外の重心
%             plot(data.cog.gc{idx}(1), data.cog.gc{idx}(2), '+', 'MarkerSize', 5);
%             % 現在位置
%             plot(agent.estimator.result.state.p(1), agent.estimator.result.state.p(2), '*', 'MarkerSize', 5, 'Color', 'red');
%             xlim([-inf inf]); ylim([-inf inf]);
%             hold off;
%         end
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

fprintf("%f秒\n", totalT)
Fontsize = 15;  timeMax = te;
set(0, 'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',10);
% set(0,'defaultLineMarkerFaceColor',[1 1 1]);
% set(0,'defaultFigurecolor',[1 1 1]);
% set(groot,'defaultAxesTickLabelInterpreter', 'latex');
% set(groot,'defaulttextinterpreter', 'latex');
% set(groot,'defaultLegendInterpreter','latex');

% logger.plot({1,"p", "er"},  "fig_num",1); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference");
% logger.plot({1,"v", "e"},   "fig_num",2); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Velocity [m/s]"); legend("x.vel", "y.vel", "z.vel");
% logger.plot({1,"q", "p"},   "fig_num",3); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw");
% logger.plot({1,"w", "p"},   "fig_num",4); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Angular velocity [rad/s]"); legend("roll.vel", "pitch.vel", "yaw.vel");
% logger.plot({1,"input", ""},"fig_num",5); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Input"); 
% logger.plot({1,"p","er"},{1,"v","e"},{1,"q","p"},{1,"w","p"},{1,"input",""},{1, "p1-p2-p3", "er"}, "fig_num",1,"row_col",[2,3]);

%% graph
size_best = size(data.bestcost, 2);
Edata = logger.data(1, "p", "e")';
% Rdata = logger.data(1, "p", "r")';
Rdata = zeros(12, size_best-1);
for R = 1:size_best-1
    Rdata(:, R) = data.xr{R}(1:12, 1);
end
Vdata = logger.data(1, "v", "e")';
Qdata = logger.data(1, "q", "e")';
Idata = logger.data(1,"input",[])';
Diff = Edata - Rdata(1:3, :);
logt = logger.data('t',[],[]);
xmax = te;
close all

% position
figure(1); plot(logt, Edata); hold on; plot(logt, Rdata(1:3, :), '--'); hold off;
xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference");
grid on; title("Time change of Position"); xlim([0 xmax]); ylim([-inf inf+0.5]);
% atiitude
figure(2); plot(logt, Qdata); hold on; plot(logt, Rdata(4:6, :), '--'); hold off;
xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference");
grid on; title("Time change of Atiitude"); xlim([0 xmax]); ylim([-inf inf]);
% velocity
figure(3); plot(logt, Vdata); hold on; plot(logt, Rdata(7:9, :), '--'); hold off;
xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref");
grid on; title("Time change of Velocity"); xlim([0 xmax]); ylim([-inf inf]);
% input
figure(4); plot(logt, Idata); 
xlabel("Time [s]"); ylabel("Input");
grid on; title("Time change of Input"); xlim([0 xmax]); ylim([-inf inf]);
%% Difference of Pos
figure(7);
plot(logger.data('t', [], [])', Diff, 'LineWidth', 2);
legend("$$x_\mathrm{diff}$$", "$$y_\mathrm{diff}$$", "$$z_\mathrm{diff}$$", 'Interpreter', 'latex', 'Location', 'southeast');
set(gca,'FontSize',15);  grid on; title(""); ylabel("Difference of Pos [m]"); xlabel("time [s]"); xlim([0 10])

%% 2軸グラフ
% figure(9);
% yyaxis left
% logger.plot({1, "input", ""});
% set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Input");
% yyaxis right
% plot(logger.data('t', [], [])', data.bestcost(1:end-1), 'LineWidth', 2, 'LineStyle','--');
% set(gca,'FontSize',15);  grid on; title(""); ylabel("Evaluation [m]"); xlabel("time [s]"); xlim([0 10]);
% legend("roter1", "roter2", "roter3", "roter4", "$$J$$", 'Interpreter', 'latex', 'Location', 'northeast')

%%
% plot(logt, data.removeX)
%% Position
% T = 0.025:0.025:time.t-0.025;
% Const = 0.5 * sin(T);
% close(figure(8))
% figure(8)
% plot(logger.data('t',[],[]), logger.data(1,'p','e'), 'LineWidth', 2); hold on; plot(logger.data('t',[],[]), Rdata(1:3, :), '--', 'LineWidth', 2); hold off;
% xlabel("Time [s]"); ylabel("Position [m]"); %legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference");

% yyaxis right
% plot(logt, data.variable_particle_num(1:size(logt,1)), 'LineWidth', 1.5);
% xlabel("Time [s]"); ylabel("Number of Samples"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference","N");

% xlim([0 te]); ylim([-inf inf])
% set(gca,'FontSize',Fontsize);  grid on; title(""); 

%% 
% logt = logger.data('t',[],[]);
figure(10)
plot(logger.data('t',[],[]), data.removeF(1:size(logger.data('t',[],[]),1))); ylabel("remove sample")
yyaxis right
plot(logger.data('t',[],[]), data.sigma(1:size(logger.data('t',[],[]),1))); ylabel("sigma");
xlim([0 te])
set(gca,'FontSize',Fontsize);  grid on; title("");
%% calculation time
figure(11)
plot(logt, data.calT(1:size(logger.data('t',[],[]),1))); hold on;
% plot(logt, totalT/400*ones(size(logt,1),1), '--', 'LineWidth', 2); hold off;

xlim([0 te])
set(gca,'FontSize',Fontsize);  grid on; title("");
xlabel("Time [s]");
ylabel("Calculation time [s]");

%% particle_num
figure(12)
plot(logt, data.variable_particle_num(1:size(logt,1)), 'LineWidth', 1.5);
xlim([0 te])
xlabel("Time [s]"); ylabel("Number of Sample");
set(gca,'FontSize',Fontsize);  grid on; title("");
%%
% figure(13)
% SF = data.param.particle_num - data.removeF(1:size(logger.data('t',[],[]),1));
% F = [data.removeF(1:size(logger.data('t',[],[]),1))'; SF'];
% area(F)
%% 動画生成
% tic
% pathJ = data.pathJ;
% for m = 1:size(pathJ, 2)
%     pathJN{m} = normalize(pathJ{m},'range');
% end
% mkdir C:\Users\student\Documents\students\komatsu\MCMPC\simdata png/Animation1
% mkdir C:\Users\student\Documents\students\komatsu\MCMPC\simdata png/Animation_omega
% mkdir C:\Users\student\Documents\students\komatsu\MCMPC\simdata video
% Outputdir = 'C:\Users\student\Documents\students\komatsu\MCMPC\simdata';
% % PlotMov_v2       % 2次元プロット
% toc
% PlotMovXYZ  % 3次元プロット
% save()
%%
% save('Data\20230118_P2P_constraints_yaw.mat', '-v7.3')

%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
agent(1).animation(logger,"target",1);

%%
% logger.save();