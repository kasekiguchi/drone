%% Drone 班用共通プログラム update sekiguchi
%% Initialize settings
% set path
activeFile = matlab.desktop.editor.getActive;
cd(fileparts(activeFile.Filename));
[~, activeFile] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), activeFile, 'UniformOutput', false);
close all hidden; clear all; clc;
userpath('clear');
fRef = 0;
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
fFirst = 0; % 一回のみ回す場合
fRemove = 0;    % 終了判定
sample = 1;    % 上手くいったとき：50のときもある
H = 20;
model_dt = 0.1;
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
            
            %-- drone model param
                param.mass = 0.269;% DIATONE
                param.Lx = 0.117;
                param.Ly = 0.0932;
                param.lx = 0.117/2;%0.05;
                param.ly = 0.0932/2;%0.05;
                param.jx = 0.02237568;
                param.jy = 0.02985236;
                param.jz = 0.0480374;
                param.gravity = 9.81;
                param.km1 = 0.0301; % ロータ定数
                param.km2 = 0.0301; % ロータ定数
                param.km3 = 0.0301; % ロータ定数
                param.km4 = 0.0301; % ロータ定数
            
run("main3_loop_setup.m");

%-- 予測モデルのシステム行列
        [MPC_Ad, MPC_Bd, MPC_Cd, MPC_Dd] = MassModel(Params.dt);
            Params.A = MPC_Ad;
            Params.B = MPC_Bd;
            Params.C = MPC_Cd;
            Params.D = MPC_Dd;

try
    while round(time.t, 5) <= te
        tic
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
            rr = [1., 0., 1.];
            if (time.t/2)^2+0.1 <= rr(3)  
                rz = (time.t/2)^2+0.1;
            else; rz = 1;
            end
            if (time.t/2)^2+0.1 <= rr(1)
                rx = (time.t/2)^2+0.1;
                ry = (time.t/2)^2+0.1;
            else; rx = 1.; ry = 1.;
            end
%             rx = 0.0; 
%             ry = 0.0; 
%             rz = 0.0;
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

            % controller 
            param(i).controller.hlc = {time.t, HLParam};    % 入力算出 / controller.name = hlc
            for j = 1:length(agent(i).controller.name)
                param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
            end
            agent(i).do_controller(param(i).controller.list);
            %if (fOffline); expudata.overwrite("input",time.t,agent,i);end
            % 強制的に入力を決定
            
                
            
            % MPC controller
            % ts探し
            ts = 0;
            state_monte = agent.model.state;
            ref_monte = agent.reference.result.state;
            %-- 速度の基準
                vref = 0.20;
            % 入力のサンプルから評価
            ref_input = [0.269 * 9.81 / 4 0.269 * 9.81 / 4 0.269 * 9.81 / 4 0.269 * 9.81 / 4]'; % ホバリングの目標入力
%             Q_monte_x = 10000; Q_monte_y = 10000; Q_monte_z = 10000;
%             VQ_monte_x = 10; VQ_monte_y = 10; VQ_monte_z = 1;

            % 重みを変化させる ref[1, 1, 1]用
            if fWeight == 1 
                % 重みの速度変化
                if min(abs(agent.model.state.v(1:2))) < 0.3
                    fV = 0;
                    PQ_monte  = diag([100, 100, 1]);
                    VQ_monte = diag([1, 1, 1]);
                    WQ_monte = diag([0.1, 0.1, 1]);
                    QQ_monte = diag([1, 1, 1]);
                else
                    if fVcount
                        fV_time = time.t;
                        fVcount = 0;
                    end
                    fV = 1;
                    PQ_monte  = diag([1, 1, 1]); % 1 1 100
                    VQ_monte = diag([1, 1, 1]); % 100 100 1
                    WQ_monte = diag([1, 1, 1]);
                    QQ_monte = diag([1, 1, 1]);
                end
            else
                PQ_monte  = 1000*diag([1, 1, 1]);  % 1 1 100
                VQ_monte = diag([1, 1, 1]);   % 1000 1000 1
                WQ_monte = diag([1, 1, 1]);
%                 QQ_q = -100*(norm(abs(state_monte.p(1:2) - ref_monte.p(1:2))))+100
                QQ_monte = 100*diag([1, 1, 1]);
                
                UdiffQ_monte = diag([1, 1, 1, 1]);
                R_monte = diag([1, 1, 1, 1]);  
            end
              
            
            %-- 評価関数
%             fun = @(p_monte, u_monte) (p_monte - agent.reference.result.state.p)'*Q_monte*(p_monte - agent.reference.result.state.p)+(u_monte - ref_input)'*R_monte*(u_monte - ref_input); 
%             funP = @(p_monte) (p_monte - ref_monte.p)'*PQ_monte*(p_monte - ref_monte.p); 
%             funV = @(v_monte) (v_monte'*VQ_monte*v_monte); 
%             fun = @(p_monte, v_monte) (p_monte - agent.reference.result.state.p)'*PQ_monte*(p_monte - agent.reference.result.state.p)+v_monte'*VQ_monte*v_monte;
%             fun = @(p_monte, v_monte, w_monte) (p_monte - agent.reference.result.state.p)'*PQ_monte*(p_monte - agent.reference.result.state.p)...
%                 +v_monte'*VQ_monte*v_monte...
%                 +w_monte'*WQ_monte*w_monte; 
%             fun = @(p_monte, q_monte, v_monte, w_monte) ...
%                 (p_monte - agent.reference.result.state.p)'*PQ_monte*(p_monte - agent.reference.result.state.p)...
%                 +v_monte'*VQ_monte*v_monte...
%                 +w_monte'*WQ_monte*w_monte...
%                 +q_monte'*QQ_monte*q_monte; 
%             fun = @(p_monte, q_monte, v_monte, w_monte, u_monte) ...
%                 (p_monte - agent.reference.result.state.p)'*PQ_monte*(p_monte - agent.reference.result.state.p)...
%                 +v_monte'*VQ_monte*v_monte...
%                 +w_monte'*WQ_monte*w_monte...
%                 +q_monte'*QQ_monte*q_monte...
%                 +u_monte'*R_monte*u_monte; 
            % 入力差
%             fun = @(p_monte, q_monte, v_monte, w_monte, udiff_monte) ...
%                 (p_monte - agent.reference.result.state.p)'*PQ_monte*(p_monte - agent.reference.result.state.p)...
%                 +v_monte'*VQ_monte*v_monte...
%                 +w_monte'*WQ_monte*w_monte...
%                 +q_monte'*QQ_monte*q_monte...
%                 +udiff_monte'*UdiffQ_monte*udiff_monte; 
            
            % 入力を含めた ref_input:ホバリング
%             fun = @(p_monte, q_monte, v_monte, w_monte, u_monte) ...
%                     (p_monte - ref_monte.p)'*PQ_monte*(p_monte - ref_monte.p)...
%                     +v_monte'*VQ_monte*v_monte...
%                     +w_monte'*WQ_monte*w_monte...
%                     +q_monte'*QQ_monte*q_monte...
%                     +(u_monte - ref_input)'*R_monte*(u_monte - ref_input);
            fun = @(p_monte, q_monte, v_monte, w_monte, u_monte) ...
                    (p_monte - ref_monte.p)'*PQ_monte*(p_monte - ref_monte.p)...
                    +(v_monte - vref)'*VQ_monte*(v_monte - vref)...
                    +w_monte'*WQ_monte*w_monte...
                    +q_monte'*QQ_monte*q_monte...
                    +(u_monte - ref_input)'*R_monte*(u_monte - ref_input);
            %-- 制約条件
                Fsub = @(sub_monte1) sub_monte1 > 0;
                subCheck = zeros(sample, 1);
            %-- 状態の表示
            fprintf("pos: %f %f %f \t vel: %f %f %f \t ref: %f %f %f fV: %d\n",...
                state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                state_monte.v(1), state_monte.v(2), state_monte.v(3),...
                ref_monte.p(1), ref_monte.p(2), ref_monte.p(3),...
                fV);
            %-- ホバリングから±sigma%の範囲
                rng('shuffle')
%                 positionN = (norm(abs(state_monte.p(1:2) - ref_monte.p(1:2))));
%                 if positionN > 1
%                     positionN = 0.99;
%                 elseif positionN < 0
%                     positionN = 0.001;
%                 end 
%                 sigma = positionN + 0.01;
                
%                 u = (b-a).*rand(sample,4*H) + a;
            
            %-- ランダムサンプリング　(4 * H * ParticleNum) リサンプリングなし
                sigma = 0.0;
                a = (1-sigma)*0.269*9.81/5;
                b = (1+sigma)*0.269*9.81/5;
                u1 = (b-a).*rand(H,sample) + a;
                u2 = (b-a).*rand(H,sample) + a;
                u3 = (b-a).*rand(H,sample) + a;
                u4 = (b-a).*rand(H,sample) + a;
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

            % --現在の状態
                previous_state = agent.estimator.result.state.get();% 前の状態の取得
            
            %-- 状態方程式による予測軌道計算
                for m = 1:u_size
                    x0 = previous_state;
                    state_data(:, 1, m) = x0;  
                    for h = 1:H-1
%                         [~,tmpx]=agent.model.solver(@(t,x) agent.model.method(x, u(:, h, m),agent.parameter.get()),[ts ts+0.1],x0);
                        % x[k+1] = Ax[k] + Bu[k]
                        tmpx = Params.A * previous_state + Params.B * u(:, h, m);
                        x0 = tmpx;
                        x0'
                        state_data(:, h+1, m) = x0;
                        if tmpx(3) < 0
                            subCheck(m) = 1;    % 制約外なら flag = 1
                            break;              % ホライズン途中でも制約外で終了
                        end
                    end
                end
            
            %-- 評価値計算
                Evaluationtra = zeros(1, u_size);
                for m = 1:u_size
                    if subCheck(m)
                        Evaluationtra(1, m) = NaN;  % 制約外
                    else
%                         Adata(1, m) = fun(tmpx(end, 1:3)', tmpx(end, 4:6)', tmpx(end, 7:9)', tmpx(end, 10:12)');    % p, v，ｑ, w;
                        Evaluationtra(1, m) = fun(state_data(1:3, end, m), ...
                            state_data(4:6, end, m), ...
                            state_data(7:9, end, m), ...
                            state_data(10:12, end, m),...
                            u(:, end, m));    % p, v，ｑ, w, u;
                    end
            
                end
                [Bestcost, BestcostID] = min(Evaluationtra);
            
            %-- 入力への代入
                agent.input = u(:, 1, BestcostID);     % 最適な入力の取得
        end
        if isnan(Evaluationtra)
            warning("ACSL : Emergency stop!");
            break;
        end
        
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
% fprintf("%f秒\n", time.t / 0.025 * calT)
% plot p:position, er:roll/pitch/yaw, 
% figure(1)
Fontsize = 15;
logger.plot({1,"p", "er"}, "fig_num",1); set(gca,'FontSize',Fontsize);  title("");
logger.plot({1,"v", "e"},"fig_num",2); set(gca,'FontSize',Fontsize);  title("");
logger.plot({1,"q", "e"},"fig_num",3); set(gca,'FontSize',Fontsize);  title("");
logger.plot({1,"w", "e"},"fig_num",4); set(gca,'FontSize',Fontsize);  title("");
logger.plot({1,"input", ""},"fig_num",5); set(gca,'FontSize',Fontsize);  title("");
% agent(1).reference.timeVarying.show(logger)
% saveas(gcf,'Data/20220622_no_horizon_re_1.png')

%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
agent(1).animation(logger,"target",1);
%%
% logger.save();

%% 制御モデル
function [Ad, Bd, Cd, Dd]  = MassModel(Td)
        %-- 連続系線形システム
%         Lx = params.Lx;
%         Ly = params.Ly;
%         lx = params.lx;%0.05;
%         ly = params.ly;%0.05;
%         xx = params.jx;
%         xy = params.jy;
%         xz = params.jz;
%         gravity = params.gravity;
%         km1 = params.km1; % ロータ定数
%         km2 = params.km2; % ロータ定数
%         km3 = params.km3; % ロータ定数
%         km4 = params.km4; % ロータ定数
        
        %-- DIATONE MODEL PARAM
            Lx = 0.117;
            Ly = 0.0932;
            lx = 0.117/2;%0.05;
            ly = 0.0932/2;%0.05;
            xx = 0.02237568;    % jx
            xy = 0.02985236;    % jy
            xz = 0.0480374;     % jz
            gravity = 9.81;     % gravity
            km1 = 0.0301; % ロータ定数
            km2 = 0.0301; % ロータ定数
            km3 = 0.0301; % ロータ定数
            km4 = 0.0301; % ロータ定数
            %-- 平衡点：原点
            Ac = [   0,     0,     0,     0,     0,     0,     1.,     0,     0,     0,     0,     0;
                     0,     0,     0,     0,     0,     0,     0,     1.,     0,     0,     0,     0;
                     0,     0,     0,     0,     0,     0,     0,     0,     1.,    0,     0,     0;
                     0,     0,     0,     0,     0,     0,     0,     0,     0,     1.,     0,     0;
                     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     1.,     0;
                     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     1.;
                     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0;
                     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,    0,     0;
                     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0;
                     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0;
                     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0;
                     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0];
              %-- 平衡点：　1m上空でホバリング [0 0 1 0 0 0 0 0 0 0 0 0 0 hover hover hover hover]
%             Ac = [   0,     0,     0,     0,     0,     0,     1.,     0,     0,     0,     0,     0;
%                      0,     0,     0,     0,     0,     0,     0,     1.,     0,     0,     0,     0;
%                      0,     0,     0,     0,     0,     0,     0,     0,     1.,    0,     0,     0;
%                      0,     0,     0,     0,     0,     0,     0,     0,     0,     1.,     0,     0;
%                      0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     1.,     0;
%                      0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     1.;
%                      0,     0,     0,     0,     gravity,     0,     0,     0,     0,     0,     0,     0;
%                      0,     0,     0,     -gravity,     0,     0,     0,     0,     0,     0,    0,     0;
%                      0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0;
%                      0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0;
%                      0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0;
%                      0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0];

            Bc = [    0,        0,        0,        0;
                      0,        0,        0,        0;
                      0,        0,        0,        0;
                      0,        0,        0,        0;
                      0,        0,        0,        0;
                      0,        0,        0,        0;
                      0,        0,        0,        0;
                      0,        0,        0,        0;
                      1000/269, 1000/269,   1000/269,   1000/269;
                      ly/xx,   -ly/xx,     (Ly-ly)/xx,   (Ly-ly)/xx;
                      lx/(xy),  -(Lx-lx)/xy,lx/xy,      -(Lx-lx)/xy;
                      km1/xz,   -km2/xz,    -km3/xz,    km4/xz];

            Cc = diag([1 1 1 1 1 1 1 1 1 1 1 1]);
            Dc = 0;
            sys = ss(Ac, Bc, Cc, Dc);

        %-- 離散系システム
                dsys = c2d(sys, Td); % - 連続系から離散系への変換
                [Ad, Bd, Cd, Dd] = ssdata(dsys);

    end
