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
run("main2_agent_setup.m");
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
% sample = 100;    % 上手くいったとき：50のときもある
% H = 20;
% model_dt = 0.1;


            % --配列定義
%                 Adata = zeros(sample, H);   % 評価値
%                 Udiff_monte = zeros(4, sample);
%                 fZpos = zeros(sample, 1);
%                 fSubIndex = zeros(sample, 1);

            %-- MPC関連 変数定義 
                Params.Particle_num = 200;  %200
                Params.H = 10;  % 10
                Params.dt = 0.1;
                idx = 0;
                totalT = 0;
                Initsigma = 0.01;   % num <= 500 くらいまでは 0.1 では大きすぎる

                HL_x = zeros(12, Params.H-1);
                HL_input = zeros(4, Params.H-1);
                
            %-- 重み
%                 PQ_monte  = 1000*diag([1, 1, 1]);  % 1 1 100
%                 VQ_monte = diag([1, 1, 1]);   % 1000 1000 1
%                 WQ_monte = diag([1, 1, 1]);
% %                 QQ_q = -100*(norm(abs(state_monte.p(1:2) - ref_monte.p(1:2))))+100
%                 QQ_monte = diag([1, 1, 1]);
% 
%                 UdiffQ_monte = diag([1, 1, 1, 1]);
%                 R_monte = diag([1, 1, 1, 1]);  
                
                Params.Weight.P = diag([1000.0; 1000.0; 100.0]);    % 座標   1000 1000 100
                Params.Weight.V = diag([1.0; 1.0; 1.0]);    % 速度
%                 Params.Weight.Q = diag([1.0; 1.0; 1.0]);    % 姿勢角
%                 Params.Weight.W = diag([1.0; 1.0; 1.0]);    % 角速度
                Params.Weight.R = diag([1.0,; 1.0; 1.0; 1.0]); % 入力
                Params.Weight.RP = diag([1.0,; 1.0; 1.0; 1.0]);  % 1ステップ前の入力との差
                Params.Weight.QW = diag([1.0,; 1.0; 1.0; 1.0; 1.0; 1000.0]);  % 姿勢角、角速度
                
            %-- data
                data.bestcost(idx+1) = 0;           % - もっともよい評価値
                data.pathJ{idx+1} = 0;              % - 全サンプルの評価値
                data.sigma(idx+1) = 0;
                data.state{idx+1} = 0;
                data.input{idx+1} = 0;

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
%             rx = 0; 
%             ry = 0; 
%             rz = 1.0;

%TODO

            rz = 0; rx = 0; ry = 1;
            if time.t >= 10
                FH.CurrentCharacter = 'f';
            end
%             if time.t >= 20
%                 FH.CurrentCharacter = 'l';
%             end
%             if time.t >= 10
%                 FH.CurrentCharacter = 'l';
%             end
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

                % controller 
%-- HL controller
%                 param(i).controller.hlc = {time.t, HLParam};    % 入力算出 / controller.name = hlc
%                 for j = 1:length(agent(i).controller.name)
%                     param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
%                 end
%                 agent(i).do_controller(param(i).controller.list);
%-- HL controller
                %if (fOffline); expudata.overwrite("input",time.t,agent,i);end

                %-- MCMPC controller
                % ts探し
                    ts = 0;
                    state_monte = agent.model.state;
                    ref_monte = agent.reference.result.state;
                %-- 速度の基準
                    vref = [0; 0; 0.50];
                    ref_input = [0.269 * 9.81 / 4 0.269 * 9.81 / 4 0.269 * 9.81 / 4 0.269 * 9.81 / 4]'; % ホバリングの目標入力
                    previous_input = agent.input;
                %-- 評価関数
                % 入力差 ：　状態＋入力差＋ホバリング入力との差
%                     fun = @(p_monte, q_monte, v_monte, w_monte, u_monte) ...
%                         (p_monte - agent.reference.result.state.p)'*Params.Weight.P*(p_monte - agent.reference.result.state.p)...
%                         +(v_monte-vref)'*Params.Weight.V*(v_monte-vref)...
%                         +w_monte'*Params.Weight.W*w_monte...
%                         +q_monte'*Params.Weight.Q*q_monte...
%                         +(u_monte - ref_input)'*Params.Weight.R*(u_monte - ref_input)...
%                         +(u_monte - previous_input)'*Params.Weight.RP*(u_monte - previous_input); 
                %-- 制約条件
                    Fsub = @(sub_monte1) sub_monte1 > 0;
                    subCheck = zeros(Params.Particle_num, 1);
                %-- 状態の表示
                    fprintf("pos: %f %f %f \t vel: %f %f %f \t q: %f %f %f \t ref: %f %f %f \n",...
                        state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                        state_monte.v(1), state_monte.v(2), state_monte.v(3),...
                        state_monte.q(1)*180/pi, state_monte.q(2)*180/pi, state_monte.q(3)*180/pi,...
                        ref_monte.p(1), ref_monte.p(2), ref_monte.p(3));
                %-- 正規分布によるサンプリング
                    % 平均　＋　標準偏差を変更する
                    if fFirst
                        ave1 = 0.269*9.81/4;      % average
                        ave2 = ave1;
                        ave3 = ave1;
                        ave4 = ave1;
                        sigma = Initsigma;
                        fFirst = 0;
                    else
                        ave1 = agent.input(1);    % リサンプリングとして前の入力を平均値とする
                        ave2 = agent.input(2);
                        ave3 = agent.input(3);
                        ave4 = agent.input(4);
                        if sigmanext > 0.5
                            sigmanext = 0.5;    % 上限
                        elseif sigmanext < 0.005
                            sigmanext = 0.005;  % 下限
                        end
                        sigma = sigmanext;
                    end
%                     ave = 0.269*9.81/4;
%                     RandN = randn(Params.H, Params.Particle_num);
                    umax = 0.269 * 9.81 / 2;
                    u1 = sigma.*randn(Params.H, Params.Particle_num) + ave1;
                    u2 = sigma.*randn(Params.H, Params.Particle_num) + ave2;
                    u3 = sigma.*randn(Params.H, Params.Particle_num) + ave3;
                    u4 = sigma.*randn(Params.H, Params.Particle_num) + ave4;
                    u1(u1<0) = 0;             u2(u2<0) = 0;              u3(u3<0) = 0;             u4(u4<0) = 0;% 負の入力=0
                    u1(u1>umax) = umax; u2(u2>umax) = umax; u3(u3>umax) = umax; u4(u4>umax) = umax;% 入力最大値
                    u(4, 1:Params.H, 1:Params.Particle_num) = u4;   % reshape
                    u(3, :, :) = u3;   
                    u(2, :, :) = u2;
                    u(1, :, :) = u1;
                    u_size = size(u, 3);    % Params.Particle_num
                %-- 全予測軌道のパラメータの格納変数を定義 repmat で短縮できるかも
                    p_data = zeros(Params.H, Params.Particle_num);
                    p_data = repmat(reshape(p_data, [1, size(p_data)]), 3, 1);
                    v_data = zeros(Params.H, Params.Particle_num);
                    v_data = repmat(reshape(v_data, [1, size(v_data)]), 3, 1);
                    q_data = zeros(Params.H, Params.Particle_num);
                    q_data = repmat(reshape(q_data, [1, size(q_data)]), 3, 1);
                    w_data = zeros(Params.H, Params.Particle_num);
                    w_data = repmat(reshape(w_data, [1, size(w_data)]), 3, 1);
                    state_data = [p_data; q_data; v_data; w_data];

                %-- 現在の状態
                    previous_state = agent.estimator.result.state.get();% 前の状態の取得

                %-- 微分方程式による予測軌道計算
                    for m = 1:u_size
                        x0 = previous_state;
                        state_data(:, 1, m) = previous_state;
                        for h = 1:Params.H-1
                            FigTime = time.t;
                            [~,tmpx]=agent.model.solver(@(t,x) agent.model.method(x, u(:, h, m),agent.parameter.get()),[ts ts+Params.dt],x0);
    %                         tmpx = Params.A * previous_state + Params.B * u(:, h, m);
                            x0 = tmpx(end, :);
                            state_data(:, h+1, m) = x0;
                            %-- 地面に沈んで終わらないように
                            if state_data(3, 1, m) < -0.05 %tmpx(3)
                                subCheck(m) = 1;    % 制約外なら flag = 1
                                break;              % ホライズン途中でも制約外で終了
                            end
                        end
%                         if state_data(3, 1, m) < 0.0
%                             subCheck(m) = 1;    % 制約外なら flag = 1
%                             break;              % ホライズン途中でも制約外で終了
%                         end
                    end

                %-- 評価値計算
                    Evaluationtra = zeros(1, u_size);
                    for m = 1:u_size
                        if subCheck(m)
                            Evaluationtra(1, m) = NaN;  % 制約外
                        else
                            eve = EvaluationFunction_MC(state_data(:, :, m), u(:, :, m), Params, agent, HL_x, HL_input);
                            Evaluationtra(1, m) = eve;
                        end
                    end

                    [Bestcost, BestcostID] = min(Evaluationtra);

                %-- 入力への代入
                    agent.input = u(:, 1, BestcostID);     % 最適な入力の取得
                %-- 評価値のソート
%                     sortEval = sort(Evaluationtra);
%                     sortEval(length(Evaluationtra)-10:length(Evaluationtra))
        
        end
        %-- 全てのサンプルが棄却されたら終了
            if isnan(Evaluationtra)
                warning("ACSL : Emergency stop!");
                fRemove = 1;
                break;
            end
            
        %-- 前時刻と現時刻の評価値を比較して，評価が悪くなったら標準偏差を広げて，評価が良くなったら標準偏差を狭めるようにしている
            if idx == 0 || idx == 1 % - 最初は全時刻の評価値がないから現時刻/現時刻にしてる
                Bestcost_pre = Bestcost;
                Bestcost_now = Bestcost;
            else
                Bestcost_pre = Bestcost_now;
                Bestcost_now = Bestcost;
            end
            sigmanext = sigma * (Bestcost_now/Bestcost_pre);
        
        %-- データ保存
            data.bestcost(idx) = Bestcost; 
            data.pathJ{idx} = Evaluationtra; % - 全サンプルの評価値
            data.sigma(idx) = sigma;
            data.state{idx} = state_data(:, 1, BestcostID);
            data.input{idx} = u;

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

            %% logging
            %             calculation = toc;
            %             wait_time = 0.9999 * (sampling - calculation);
            %
            %             if wait_time < 0
            %                 wait_time
            %                 warning("ACSL : sampling time is too short.");
            %             end
            %            time.t = time.t + calculation;

            %            else
            %                pause(wait_time);  %　センサー情報取得から制御入力印加までを早く保ちつつ，周期をできるだけ一定に保つため
            % これをやるとpause中が不安定になる．どうしても一定時間にしたいならwhile でsamplingを越えるのを待つなどすればよいかも．
            % それよりは推定などで，calculationを意識した更新をしてあげた方がよい？
            %                time.t = time.t + sampling;
            %            end
        else
            logger.logging(time.t, FH, agent);

            if (fOffline)
                time.t
            else
                time.t = time.t + dt % for sim
            end

        end
        if fRemove == 1
            break
        end
        calT = toc % 1ステップ（25ms）にかかる計算時間
        totalT = totalT + calT;
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
% clc
% calculate time
fprintf("%f秒\n", totalT)
% plot p:position, e:estimate, r:reference, 
% figure(1)
Fontsize = 15;  timeMax = te;
logger.plot({1,"p", "er"},  "fig_num",1); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference");
logger.plot({1,"v", "e"},   "fig_num",2); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Velocity [m/s]"); legend("x.vel", "y.vel", "z.vel");
logger.plot({1,"q", "p"},   "fig_num",3); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw");
logger.plot({1,"w", "p"},   "fig_num",4); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Angular velocity [rad/s]"); legend("roll.vel", "pitch.vel", "yaw.vel");
logger.plot({1,"input", ""},"fig_num",5); %set(gca,'FontSize',Fontsize);  grid on; title("");
%% errorで終了したとき
Fontsize = 15;  timeMax = te;
size_best = length(data.bestcost);
figure(8); plot(logger.Data.t(1:size_best,:), data.bestcost, '.'); xlim([0 inf]);ylim([0 inf]);
% figure(9); plot(1:Params.Particle_num, data.pathJ{1, 1}, '*');
% axes プロパティから線の太さ，スタイルなど変更可能
figure(7)
plot(logger.Data.t(1:size_best,:), data.sigma, 'LineWidth', 2); xlim([0 inf]); xlabel("Time [s]"); ylabel("Sigma"); set(gca,'FontSize',Fontsize); grid on;
agent(1).reference.timeVarying.show(logger)
% saveas(gcf,'Data/20220622_no_horizon_re_1.png')

% 差分のグラフを描画
% logger.Data.agent.estimator.result{1,:}.state.p logger.Data.agent.reference.result{1,100}.state.p
for i= 1:size_best
    Edata(:, i) = logger.Data.agent.estimator.result{1,i}.state.p;
    Rdata(:, i) = logger.Data.agent.reference.result{1,i}.state.p;
    diff(:, i) = logger.Data.agent.estimator.result{1,i}.state.p - logger.Data.agent.reference.result{1,i}.state.p;
end
% difference of reference and estimator
figure(9)
plot(logger.Data.t(1:size_best,:), diff, 'LineWidth', 2); xlim([0 inf]); xlabel("Time [s]"); ylabel("Difference of position [m]"); set(gca,'FontSize',Fontsize);
legend("x.diff", "y.diff", "z.diff"); grid on;
% acceleration
% figure(10); plot(logger.Data.t(1:size_best,:), data.acc, 'LineWidth', 2); xlabel("Time[s]"); ylabel("acceleration [m/s^2]");set(gca,'FontSize',Fontsize); grid on;
% estimator and reference 
figure(11); plot(logger.Data.t(1:size_best,:), Edata, 'LineWidth', 2); xlabel("Time[s]"); ylabel("coodinates [m]");set(gca,'FontSize',Fontsize); grid on;
ylim([-inf, inf+1.0]); xlim([0 inf]); hold on;
plot(logger.Data.t(1:size_best,:), Rdata, '--', 'LineWidth', 2);
hold off;
%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
agent(1).animation(logger,"target",1);
% agent(1).animation(logger,"gif", 1);
%%
% logger.save();
