%% Drone 班用共通プログラム update sekiguchi
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
%-- パラメータ
%         dt = 0.05;          % - 離散時間幅（チューニング必要かも）
%         Te = 5;	            % - シミュレーション時間
        x0 = [0.0; 0.0; 0.0];    % - 初期状態
        u0 = [0.0; 0.0; 0.0; 0.0];    % - 初期状態
%         ur = [0.0; 0.0];    % - 目標速度
        Particle_num = 10; % - 粒子数（要チューニング）
%         Csigma = 0.001;     % - 予測ステップごとに変化する分散値の上昇定数(未来は先に行くほど不確定だから予測ステップが進む度に標準偏差を大きくしていく、工夫だからやらなくても問題ないと思う)
        Count_sigma = 0;
        Initu1 = 0.269 * 9.81 / 4;      % - 初期推定解 ホバリングとする
        Initu2 = 0.269 * 9.81 / 4;      % - 初期推定解
        Initu3 = 0.269 * 9.81 / 4;      % - 初期推定解 
        Initu4 = 0.269 * 9.81 / 4;      % - 初期推定解
        umax = 1.0;         % - 入力の最大値、入力制約と最大入力の抑制項のときに使う
%-- 構造体へ格納
        Params.x0 = x0;
        Params.sample = Particle_num;
        Params.Csigma = Csigma;
        Params.reset_flag = 0;
        Params.PredStep = repmat(dt*3, Params.H, 1); % - ホライズンの半分後半の予測ステップ幅を大きく(未来は先に行くほど不確定だから予測ステップ幅を大きくしていく、工夫だからやらなくても問題ないと思う)
        Params.PredStep(1:Params.H/2, 1) = dt;
        Params.umax = umax;
        Params.H = 1;
        
run("main3_loop_setup.m");

try
    while round(time.t, 5) <= te
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
        % 20220627 追記部分/////////////////////////
        
%         u1 = (b-a).*rand(Params.H,Params.sample) + a;
%         u2 = (b-a).*rand(Params.H,Params.sample) + a;
%         u3 = (b-a).*rand(Params.H,Params.sample) + a;
%         u4 = (b-a).*rand(Params.H,Params.sample) + a;
%         u1 = reshape(u1, [1, size(u1)]);
%         u2 = reshape(u2, [1, size(u2)]);
%         u3 = reshape(u3, [1, size(u3)]);
%         u4 = reshape(u4, [1, size(u4)]);
%         u = [u1; u2; u3; u4];
    %-- 準最適化入力を格納
%         rng('shuffle')
%         sigma = 0.15;
%         a = 0.269 * 9.81 / 4 - 0.269 * 9.81 / 4 * sigma;           b = 0.269 * 9.81 / 4 + 0.269 * 9.81 / 4 * sigma;
%         Initu = (b-a).*rand(Params.H,Params.sample) + a;
%         Initu = 0.269 * 9.81 / 4;
        if Count_sigma == 0 
%             u1_ten = repmat(Initu, Params.H, Params.sample);
%             u2_ten = repmat(Initu, Params.H, Params.sample);
%             u3_ten = repmat(Initu, Params.H, Params.sample);
%             u4_ten = repmat(Initu, Params.H, Params.sample);
            u1_ten = Initu;
            u2_ten = Initu;
            u3_ten = Initu;
            u4_ten = Initu;
            %-- fminconで算出した値を代入、初期推定解だけ勾配法を用いて算出するパターンもある
            %-- こういう一例があることを知って欲しいから残しておいた
                % ux_ten = repmat(u_previous_opt(1,:)', 1, Particle_num);
                % uy_ten = repmat(u_previous_opt(1,:)', 1, Particle_num);
            Count_sugma = Count_sigma + 1;
        else
            u1_ten = reshape(u_1, Params.H, Params.sample); % - 初期時刻以降，準最適化入力を格納
            u2_ten = reshape(u_2, Params.H, Params.sample);
            u3_ten = reshape(u_3, Params.H, Params.sample); % - 初期時刻以降，準最適化入力を格納
            u4_ten = reshape(u_4, Params.H, Params.sample);
        end
    %-- 分散によるノイズを格納，入力の広がりを決定
        n1 = normrnd(zeros(Params.H,Params.sample), sigma1);
        n2 = normrnd(zeros(Params.H,Params.sample), sigma2);
        n3 = normrnd(zeros(Params.H,Params.sample), sigma3);
        n4 = normrnd(zeros(Params.H,Params.sample), sigma4);
        

    %-- 各方向の入力列を格納
        u1 = u1_ten;
        u2 = u2_ten;
        u3 = u3_ten;
        u4 = u4_ten;
        u1 = reshape(u1, [1, size(u1)]);
        u2 = reshape(u2, [1, size(u2)]);
        u3 = reshape(u3, [1, size(u3)]);
        u4 = reshape(u4, [1, size(u4)]);
        u = [u1; u2; u3; u4];
        
        % /////////////////////////////////////////////
        
        for i = 1:N
            % estimator
            agent(i).do_estimator(cell(1, 10));
            %if (fOffline);exprdata.overwrite("estimator",time.t,agent,i);end
            % reference
            if time.t <= 5 &&  (time.t/2)^2+0.1 <= 1
                ry = (time.t/2)^2+0.1;
            else
                ry = 1.;
            end
%             ry = 1.0;
            param(i).reference.covering = [];
            param(i).reference.point = {FH, [0; 0; ry], time.t};  % 目標値[x, y, z]
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
            param(i).controller.hlc = {time.t, HLParam};    % 入力算出 / controller.name = hlc
            for j = 1:length(agent(i).controller.name)
                param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
            end
            agent(i).do_controller(param(i).controller.list);
            %if (fOffline); expudata.overwrite("input",time.t,agent,i);end
            
            
            % 強制的に入力を決定
            fprintf("%f %f %f \t %f %f %f\n", agent.model.state.p(1), agent.model.state.p(2), agent.model.state.p(3),...
                agent.reference.result.state.p(1), agent.reference.result.state.p(2), agent.reference.result.state.p(3))
%             tic
            % MPC controller
            % ts探し
            ts = 0;
            
            PQ_monte = diag([100, 1, 100]);
            VQ_monte = diag([1, 1, 1]);
            WQ_monte = diag([10, 10, 1]);
            QQ_monte = diag([1, 1, 1]);
            R_monte = 1;    
            % 評価関数
            fun = @(p_monte, q_monte, v_monte, w_monte) (p_monte - agent.reference.result.state.p)'*PQ_monte*(p_monte - agent.reference.result.state.p)...
                +v_monte'*VQ_monte*v_monte...
                +w_monte'*WQ_monte*w_monte...
                +q_monte'*QQ_monte*q_monte; 
            % 制約条件
            Fsub = @(sub_monte1) sub_monte1 > 0;
            % ホバリングから±sigma%の範囲
            Evaluationtra = zeros(1, Params.sample);
   
            % 配列定義
            Adata = zeros(Params.sample, 1);   % 評価値
%             P_monte = zeros(Params.sample, 3); % ある入力での位置
%             V_monte = zeros(Params.sample, 3); % ある入力での速度
%             W_monte = zeros(Params.sample, 3); % ある入力での姿勢角
            fZpos = zeros(Params.sample, 1);
            for monte = 1 : Params.sample
                [~,tmpx]=agent.model.solver(@(t,x) agent.model.method(x, u(:, :, monte),agent.parameter.get()),[ts ts+dt],agent.estimator.result.state.get());
%                 P_monte(monte, :) = tmpx(end, 1:3);     % ある入力での位置 x, y, z
%                 Q_monte(monte, :) = tmpx(end, 4:6);     % 姿勢角
%                 V_monte(monte, :) = tmpx(end, 7:9);     % ある入力での速度 vx, vy, vz
%                 W_monte(monte, :) = tmpx(end, 10:12);   % ある入力での姿勢の角速度
                if Fsub(tmpx(end, 1:3)') == 1
                    Adata(monte, 1) = fun(tmpx(end, 1:3)', tmpx(end, 4:6)', tmpx(end, 7:9)', tmpx(end, 10:12)');    % p, v，ｑ, w;
                else
                    Adata(monte, 1) = 10^2;
                    fZpos(monte, 1) = 1;
                end
            end
%             toc

            [~,min_index] = min(Adata(:, 1));   % 評価値の合計の最小値インデックス算出
            agent.input = u(:, :, min_index);     % 最適な入力の取得
%             agent.input = [u(min_index, 2) u(min_index, 2) u(min_index, 2) u(min_index, 2)]';   % 挙動確認用
            if fZpos(min_index, 1) == 1
                printf("Stop!!");               % エラーを吐かせて終了させる fprintfが本物
            end
        end
        
        % リサンプリング
%         Adata = Adata'    %
        [~, L_norm] = Normalize(Params, Adata');
        [u_1, u_2, u_3, u_4, ~] = Resampling(Params, u, L_norm);

        
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
clc
% plot p:position, er:roll/pitch/yaw, 
figure(1)
logger.plot({1,"p", "er"});
% logger.plot({1,"v", "e"});
% logger.plot({1,"q", "e"});
% logger.plot({1,"w", "e"});
% logger.plot({1,"input", ""});
% agent(1).reference.timeVarying.show(logger)
% saveas(gcf,'Data/20220622_no_horizon_re_1.png')

%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
agent(1).animation(logger,"target",1);
%%
% logger.save();
