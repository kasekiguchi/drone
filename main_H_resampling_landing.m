%% Drone 班用共通プログラム update sekiguchi
%-- 連続時間で着陸するモデル
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
fLanding = 1;   % 着陸かどうか
fLanding_comp = 0;
fCount_landing = 0;
fc = 0;     % 着陸したときだけx，y座標を取得
sample = 50;    % 上手くいったとき：50のときもある
H = 20;
model_dt = 0.1;
idx = 0;
totalT = 0;
Initsigma = 0.1;
            % --配列定義
                Adata = zeros(sample, H);   % 評価値
    %             P_monte = zeros(sample, 3); % ある入力での位置
    %             V_monte = zeros(sample, 3); % ある入力での速度
    %             W_monte = zeros(sample, 3); % ある入力での姿勢角
    %             Q_monte = zeros(sample, 3);
                Udiff_monte = zeros(4, sample);
                fZpos = zeros(sample, 1);
    %             fSubIndex = zeros(sample, 1);
    %             fSubIndex = (1:sample)';
                fSubIndex = zeros(sample, 1);
                Params.dt = model_dt;
            %-- data
                data.bestcost(idx+1) = 0;           % - もっともよい評価値
                data.pathJ{idx+1} = 0;              % - 全サンプルの評価値
                data.sigma(idx+1) = 0;
            %-- 重み
                PQ_monte  = 1000*diag([1, 1, 1]);  % 1 1 100
                VQ_monte = diag([1, 1, 1]);   % 1000 1000 1
                WQ_monte = diag([1, 1, 1]);
%                 QQ_q = -100*(norm(abs(state_monte.p(1:2) - ref_monte.p(1:2))))+100
                QQ_monte = diag([1, 1, 1]);

                UdiffQ_monte = diag([1, 1, 1, 1]);
                R_monte = diag([1, 1, 1, 1]);  

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
            if fLanding == 0
                rr = [1., 1., 1.];
                if (time.t/2)^2+0.1 <= rr(3)  
                    rz = (time.t/2)^2+0.1;
                else; rz = 1;
                end
                if (time.t/2)^2+0.1 <= rr(1)
                    rx = (time.t/2)^2+0.1;
                    ry = (time.t/2)^2+0.1;
                else; rx = 1.; ry = 1.;
                end
            else% 着陸するやつ
                % 4 == 0.3m/sほどになる
                rr = [0., 0., 0.];
                if 0 < time.t && time.t < 0.1
                    rz = 1;
                elseif 0.1 <= time.t && time.t < 4
                    rz = (((time.t - 0.1)/4)-1)^2;
                else; rz = rr(3);
                end
%                 if -(time.t/2)^2+1 >= rr(1)
%                     rx = -(time.t/2)^2;
%                     ry = -(time.t/2)^2;
%                 else; rx = rr(1); ry = rr(2);
%                 end
            end
            rx = 0; 
            ry = 0; 
%             rz = 0.0;
            
            %-- 着陸後コントローラー変える:目標位置も変更
                if fLanding_comp == 1
                    rx = currentX; ry = currentY; rz = 0;
                end
            %--
            param(i).reference.covering = [];
            param(i).reference.point = {FH, [rx; ry; rz], time.t};  % 目標値[x, y, z]
            param(i).reference.timeVarying = {time};
            param(i).reference.tvLoad = {time};
            param(i).reference.wall = {1};
            param(i).reference.agreement = {logger, N, time.t};
            for j = 1:length(agent(i).reference.name)
                param(i).reference.list{j} = param(i).reference.(agent(i).reference.name(j));
            end
            agent(i).do_reference(param(i).reference.list);
            %if (fOffline);exprdata.overwrite("reference",time.t,agent,i);end
            
            if fLanding_comp == 1   % 着陸したら従来のコントローラー
                % controller 
                param(i).controller.hlc = {time.t, HLParam};    % 入力算出 / controller.name = hlc
                for j = 1:length(agent(i).controller.name)
                    param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
                end
                agent(i).do_controller(param(i).controller.list);
                %if (fOffline); expudata.overwrite("input",time.t,agent,i);end
            else
                %-- MCMPC controller
                % ts探し
                    ts = 0;
                    state_monte = agent.model.state;
                    ref_monte = agent.reference.result.state;
                %-- 速度の基準
%                     if time.t < 4
%                         vref = [0;0;time.t/8 - 1/2];
%                     else
%                         vref = [0; 0; 0];
%                     end
                    vref = [0;0;0];
       
                ref_input = [0.269 * 9.81 / 4 0.269 * 9.81 / 4 0.269 * 9.81 / 4 0.269 * 9.81 / 4]'; % ホバリングの目標入力
                previous_input = agent.input;
                %-- 評価関数
                % 入力差 ：　状態＋入力差＋ホバリング入力との差
                    fun = @(p_monte, q_monte, v_monte, w_monte, u_monte) ...
                        (p_monte - agent.reference.result.state.p)'*PQ_monte*(p_monte - agent.reference.result.state.p)...
                        +(v_monte-vref)'*VQ_monte*(v_monte-vref)...
                        +w_monte'*WQ_monte*w_monte...
                        +q_monte'*QQ_monte*q_monte...
                        +(u_monte - ref_input)'*R_monte*(u_monte - ref_input)...
                        +(u_monte - previous_input)'*UdiffQ_monte*(u_monte - previous_input); 
                %-- 制約条件
                    Fsub = @(sub_monte1) sub_monte1 > 0;
                    subCheck = zeros(sample, 1);
                %-- 状態の表示
                    fprintf("pos: %f %f %f \t vel: %f %f %f \t ref: %f %f %f fV: %d\n",...
                        state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                        state_monte.v(1), state_monte.v(2), state_monte.v(3),...
                        ref_monte.p(1), ref_monte.p(2), ref_monte.p(3),...
                        fV);
                %-- 正規分布によるサンプリング
                    if fFirst
                        sigma = Initsigma;
                        fFirst = 0;
                    else
                        if sigmanext > 0.5
                            sigmanext = 0.5;
                        elseif sigmanext < 0.005
                            sigmanext = 0.005;
                        end
                        sigma = sigmanext;
                    end
                    ave = 0.269*9.81/4;
    %                 sigmaData(idx, 1) = sigma;
                    %-- 
    %                 ave = 0.269*9.81/4;
                    u1 = sigma.*randn(H, sample) + ave;
                    u2 = sigma.*randn(H, sample) + ave;
                    u3 = sigma.*randn(H, sample) + ave;
                    u4 = sigma.*randn(H, sample) + ave;
                    u1 = reshape(u1, [1, size(u1)]);
                    u2 = reshape(u2, [1, size(u2)]);
                    u3 = reshape(u3, [1, size(u3)]);
                    u4 = reshape(u4, [1, size(u4)]);
                    u = [u1; u2; u3; u4];
                    u_size = size(u, 3);    % sample
                %-- 全予測軌道のパラメータの格納変数を定義 repmat で短縮できるかも
                    p_data = zeros(H, sample);
                    p_data = repmat(reshape(p_data, [1, size(p_data)]), 3, 1);
                    v_data = zeros(H, sample);
                    v_data = repmat(reshape(v_data, [1, size(v_data)]), 3, 1);
                    q_data = zeros(H, sample);
                    q_data = repmat(reshape(q_data, [1, size(q_data)]), 3, 1);
                    w_data = zeros(H, sample);
                    w_data = repmat(reshape(w_data, [1, size(w_data)]), 3, 1);
                    state_data = [p_data; q_data; v_data; w_data];

                %-- 現在の状態
                    previous_state = agent.estimator.result.state.get();% 前の状態の取得

                %-- 着陸(z < 0.05)したら入力なくして(シミュレーション上は入力＝ホバリング)地面にいる．
                    if agent.model.state.p(3) < 0.05
                        if fCount_landing > 10
                            if fc ~= 1
                                currentX = agent.model.state.p(1);
                                currentY = agent.model.state.p(2);
                                fc = 1;
                            end
                            fLanding_comp = 1;
                            break;
                        else
                            fCount_lnading = fCount_landing + 1;
                        end
                    end

                %-- 微分方程式による予測軌道計算
                    for m = 1:u_size
                        x0 = previous_state;
                        state_data(:, 1, m) = previous_state;
                        for h = 1:H-1
                            [~,tmpx]=agent.model.solver(@(t,x) agent.model.method(x, u(:, h, m),agent.parameter.get()),[ts ts+model_dt],x0);
    %                         tmpx = Params.A * previous_state + Params.B * u(:, h, m);
                            x0 = tmpx(end, :);
                            state_data(:, h+1, m) = x0;
                            %-- 地面に沈んで終わらないように
    %                         if tmpx(3) < 0.
    %                             subCheck(m) = 1;    % 制約外なら flag = 1
    %                             break;              % ホライズン途中でも制約外で終了
    %                         end
                        end
                    end

                %-- 評価値計算
                    Evaluationtra = zeros(1, u_size);
                    for m = 1:u_size
    %                     if subCheck(m)
    %                         Evaluationtra(1, m) = NaN;  % 制約外
    %                     else
    %                         Adata(1, m) = fun(tmpx(end, 1:3)', tmpx(end, 4:6)', tmpx(end, 7:9)', tmpx(end, 10:12)');    % p, v，ｑ, w;
                            Evaluationtra(1, m) = fun(state_data(1:3, end, m), ...
                                state_data(4:6, end, m), ...
                                state_data(7:9, end, m), ...
                                state_data(10:12, end, m),...
                                u(:, end, m));    % p, v，ｑ, w, u;
    %                     end
                    end


                    [Bestcost, BestcostID] = min(Evaluationtra);

                %-- 入力への代入
                    agent.input = u(:, 1, BestcostID);     % 最適な入力の取得
            end
                
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
Fontsize = 15;
logger.plot({1,"p", "er"},  "fig_num",1); set(gca,'FontSize',Fontsize);  title("");
logger.plot({1,"v", "e"},   "fig_num",2); set(gca,'FontSize',Fontsize);  title("");
logger.plot({1,"q", "e"},   "fig_num",3); set(gca,'FontSize',Fontsize);  title("");
logger.plot({1,"w", "e"},   "fig_num",4); set(gca,'FontSize',Fontsize);  title("");
logger.plot({1,"input", ""},"fig_num",5); set(gca,'FontSize',Fontsize);  title("");
% size_best = length(data.bestcost);
% figure(8); plot(logger.Data.t(1:size_best,:), data.bestcost, '*'); xlim([0 inf]);ylim([0 100]);
% figure(9); plot(1:sample, data.pathJ{1, 1}, '*');

% agent(1).reference.timeVarying.show(logger)
% saveas(gcf,'Data/20220622_no_horizon_re_1.png')

%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
agent(1).animation(logger,"target",1);
%%
% logger.save();
