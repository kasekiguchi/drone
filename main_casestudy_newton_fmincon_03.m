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
run("main1_setting_casestudy.m");
run("main2_agent_setup_casestudy.m");
%agent.set_model_error("ly",0.02);
%% set logger
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
LogData = [     % agentのメンバー関係以外のデータ
        ];
LogAgentData = [% 下のLOGGER コンストラクタで設定している対象agentに共通するdefault以外のデータ
            ];
logger = LOGGER(1:N, size(ts:dt:te, 2), fExp, LogData, LogAgentData);

%-- MPC関連 変数定義 
    Params.Particle_num = 200;  %200
    Params.H = 5;  % 10
    Params.dt = 0.1;
    idx = 0;
    totalT = 0;
%     Initsigma = 0.01;   % num <= 500 くらいまでは 0.1 では大きすぎる
    
%-- 重み
    Params.Weight.P = diag([1.0; 1.0; 1.0]);    % 座標   1000 1000 100
    Params.Weight.V = diag([1.0; 1.0; 1000.0]);    % 速度
    Params.Weight.Q = diag([1.0; 1.0; 1.0]);    % 姿勢角
    Params.Weight.W = diag([1.0; 1.0; 1.0]);    % 角速度
    Params.Weight.R = diag([1.0,; 1.0; 1.0; 1.0]); % 入力
    Params.Weight.RP = diag([1.0,; 1.0; 1.0; 1.0]);  % 1ステップ前の入力との差
    Params.Weight.QW = diag([1.0,; 1.0; 1.0; 1.0; 1.0; 1000.0]);  % 姿勢角、角速度
    
%-- data
    data.bestcost(idx+1) = 0;           % - もっともよい評価値
%     data.pathJ{idx+1} = 0;              % - 全サンプルの評価値
%     data.sigma(idx+1) = 0;
    data.state{idx+1} = 0;
%     data.input{idx+1} = 0;

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

%-- 配列サイズ
    Params.state_size = size(state_data,1);
    Params.input_size = size(agent.input,1);
    Params.total_size = Params.state_size + Params.input_size;

%-- 目標値等
    ur = 0.269*9.81/4 * ones(4, 1);
    Params.ref_v = [0; 0; 0.50];
%     previous_state  = zeros(16, Params.H);

%-- fmincon 設定 
    options.Algorithm = 'sqp';
    options.Display = 'none';
    problem.solver = 'fmincon';
    problem.options = options;
    previous_state  = zeros(Params.state_size + Params.input_size, Params.H);
%-- 制約
%     A = [0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0];
    b = 0;

    A = repmat([0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0], 1, Params.H);
%     A = repmat([0;0;1;0;0;0;0;0;0;0;0;0;0;0;0;0], Params.H, 1);

    Aeq = [];
    beq = [];
    
    lb = [];
    ub = [];
    nonlcon = [];
    initial_state = agent.estimator.result.state.get();
    x = initial_state;

%-- 予測モデルのシステム行列
    [MPC_Ad, MPC_Bd, MPC_Cd, MPC_Dd] = MassModel(Params.dt);
        Params.A = MPC_Ad;
        Params.B = MPC_Bd;
        Params.C = MPC_Cd;
        Params.D = MPC_Dd;
    

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
            %-- generate reference
            xr = Reference(Params, time);
            Params.xr = xr;
            param(i).reference.covering = [];
            param(i).reference.point = {FH, [xr(1:3, end)], time.t};  % 目標値[x, y, z]
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
            % ts探し
                ts = 0;
                state_monte = agent.model.state;
                ref_monte = agent.reference.result.state;
            %-- 入力の基準
                previous_input = agent.input;
                Params.ur = ur;
%                 Params.xr = xr;
                Params.X0= x;
            %-- 状態の表示
                fprintf("pos: %f %f %f \t vel: %f %f %f \t u: %f %f %f %f \t ref: %f %f %f",...
                    state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                    state_monte.v(1), state_monte.v(2), state_monte.v(3),...
                    agent.input(1), agent.input(2), agent.input(3), agent.input(4),...
                    ref_monte.p(1), ref_monte.p(2), ref_monte.p(3));
            %-- 初期値の設定
                if idx == 1
                    initial_u1 = 0.269 * 9.81 / 4;   % 初期値
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
%                 previous_state = repmat([agent.estimator.result.state.get(); x0], 1, Params.H);
                % previous_state の1行目
                
                problem.x0		  = previous_state;                         % 状態，入力を初期値とする            
                problem.objective = @(x) Objective(x, Params, agent);       % 評価関数
                problem.nonlcon   = @(x) Constraints(x, Params);            % 制約条件

                [var, fval, exitflag, output, lambda, grad, hessian] = fmincon(problem);
                % A, b : 線形不等式,   previous_state : 初期値, 
%                 [var, fval, exitflag, output, lambda, grad, hessian] = fmincon(fun, previous_state, A, b, [], [], [], [], [], options);
                previous_state = var;   % 初期値の書き換え
                fprintf("\tfval : %f\n", fval)
%                 fprintf("var : %f %f %f %f %f %f %f %f %f %f %f %f %f\n", var(1:12), output.bestfeasible.fval)
            %-- 入力への代入
                agent.input = var(Params.state_size+1:Params.total_size, 1);
        
        end   
        %-- データ保存
            data.bestcast = fval;
%             data.bestcost(idx) = output.bestfeasible.fval; 
%             data.pathJ{idx} = output.bestfeasible.fval; % - 全サンプルの評価値
%             data.sigma(idx) = sigma;
%             data.state{idx} = state_data(:, 1, BestcostID);
%             data.input{idx} = u;

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
logger.plot({1,"p", "er"},  "fig_num",1); set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference");
% logger.plot({1,"v", "e"},   "fig_num",2); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Velocity [m/s]"); legend("x.vel", "y.vel", "z.vel");
% logger.plot({1,"q", "p"},   "fig_num",3); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw");
% logger.plot({1,"w", "p"},   "fig_num",4); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Angular velocity [rad/s]"); legend("roll.vel", "pitch.vel", "yaw.vel");
logger.plot({1,"input", ""},"fig_num",5); ylim([0 1.0]); %set(gca,'FontSize',Fontsize);  grid on; title(""); 
figure(8); plot(logger.Data.t, data.bestcost, '.'); xlim([0 inf]);ylim([0 inf]); xlabel("Time [s]"); ylabel("Evaluation"); set(gca,'FontSize',Fontsize);  grid on;
%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
agent(1).animation(logger,"target",1);
% agent(1).animation(logger,"gif", 1);
%%
% logger.save();
function xr = Reference(params, time)
    xr = zeros(params.state_size, params.H);
    rz = 1; % 目標
    rz0 = 0;% スタート
    T = 10; % かける時間
    StartT = 0;
    a = -2/T^3 * (rz-rz0);
    b = 3/T^2 * (rz-rz0);
%     z = a*(t-StartT)^3+b*(t-StartT)^2+rz0;
%     X = subs(z, t, Tv);
    %-- ホライゾンごとのreference
    if time.t <= 10
        for h = 1:params.H
            xr(1:3, h) = [0;0;a*((time.t-StartT)+params.dt*h)^3+b*((time.t-StartT)+params.dt*h)^2+rz0];
            xr(4:12,h) = [0;0;0;0;0;0.5;0;0;0];
        end
    else
        for h = 1:params.H
            xr(1:3, h) = [0;0;1];   % 位置
            xr(4:12,h) = [0;0;0;0;0;0.5;0;0;0];   % 位置以外 
        end
    end
end

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
    tildeUref = U - params.ur;
    
%-- 状態及び入力のステージコストを計算 長くなるから分割
    stageStateP  = arrayfun(@(L) tildeXp(:, L)'   * params.Weight.P         * tildeXp(:, L),   1:params.H-1);
    stageStateV  = arrayfun(@(L) tildeXv(:, L)'   * params.Weight.V         * tildeXv(:, L),   1:params.H-1);
    stageStateQW = arrayfun(@(L) tildeXqw(:, L)'  * params.Weight.QW  * tildeXqw(:, L),  1:params.H-1);
    stageInputP  = arrayfun(@(L) tildeUpre(:, L)' * params.Weight.RP      * tildeUpre(:, L), 1:params.H-1);
    stageInputR  = arrayfun(@(L) tildeUref(:, L)' * params.Weight.R        * tildeUref(:, L), 1:params.H-1);
    stageState = stageStateP + stageStateV +  stageStateQW + stageInputP + stageInputR; % ステージコスト
    
%-- 状態の終端コストを計算
    terminalState = tildeXp(:, end)' * params.Weight.P * tildeXp(:, end)...
                    +tildeXv(:, end)'   * params.Weight.V   * tildeXv(:, end)...
                    +tildeXqw(:, end)'  * params.Weight.QW  * tildeXqw(:, end);

%-- 評価値計算
    eval = sum(stageState + terminalState) + terminalState;
end

function [c, ceq] = Constraints(x, params)
% モデル予測制御の制約条件を計算するプログラム
    c  = zeros(params.state_size, 1*params.H);
%     ceq_ode = zeros(params.state_size, params.H);

%-- MPCで用いる予測状態 Xと予測入力 Uを設定
    X = x(1:params.state_size, :);          % 12 * Params.H 
    U = x(params.state_size+1:params.total_size, :);   % 4 * Params.H

%- ダイナミクス拘束
%-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定　非線形等式を計算します．
% [~,tmpx]=Agent.model.solver(@(t,X(:,L) agent.model.method(X(:,L), U(:,L),Agent.parameter.get()),[ts ts+params.dt],params.X0);
%     ceq = [X(:, 1) - params.X0, cell2mat(arrayfun(@(L) )]
    ceq = [X(:, 1) - params.X0, cell2mat(arrayfun(@(L) X(:, L)  - (params.A * X(:, L-1) + params.B * U(:, L-1)), 2:params.H, 'UniformOutput', false))];
    c(:, 1) = [];
%     c = -x(3, :);

%-- 連続の式を使う方
%     for L = 2:params.H
%         [~,tmpx]=Agent.model.solver(@(t,X) Agent.model.method(X(:,L), U(:,L), Agent.parameter.get()), [0 0+params.dt],params.X0);
%         ceq_ode(:, L) = tmpx;   % tmpx : 縦ベクトル？ 
%     end
%     ceq = [X(:, 1) - params.X0, ceq_ode];
    
end

function [Ad, Bd, Cd, Dd]  = MassModel(Td)
        
%-- DIATONE MODEL PARAM
    Lx = 0.117;
    Ly = 0.0932;
    lx = 0.117/2;       %0.05;
    ly = 0.0932/2;      %0.05;
    xx = 0.02237568;    % jx
    xy = 0.02985236;    % jy
%             xx = 100 * 0.02237568;    % jx
%             xy = 100 * 0.02985236;    % jy
    xz = 0.0480374;     % jz
    gravity = 9.81;     % gravity
    km1 = 0.0301;       % ロータ定数
    km2 = 0.0301;       % ロータ定数
    km3 = 0.0301;       % ロータ定数
    km4 = 0.0301;       % ロータ定数
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
%     Ac = [   0,     0,     0,     0,     0,     0,     1.,     0,     0,     0,     0,     0;
%              0,     0,     0,     0,     0,     0,     0,     1.,     0,     0,     0,     0;
%              0,     0,     0,     0,     0,     0,     0,     0,     1.,    0,     0,     0;
%              0,     0,     0,     0,     0,     0,     0,     0,     0,     1.,     0,     0;
%              0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     1.,     0;
%              0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     1.;
%              0,     0,     0,     0,     gravity,     0,     0,     0,     0,     0,     0,     0;
%              0,     0,     0,     -gravity,     0,     0,     0,     0,     0,     0,    0,     0;
%              0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0;
%              0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0;
%              0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0;
%              0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0];

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
    % 可制御性，可観測
%     Uc = [Bc Ac*Bc Ac^2*Bc Ac^3*Bc Ac^4*Bc Ac^5*Bc Ac^6*Bc Ac^7*Bc Ac^8*Bc Ac^9*Bc Ac^10*Bc Ac^11*Bc];
%     Uo = [Cc;Cc*Ac;Cc*Ac^2;Cc*Ac^3;Cc*Ac^4;Cc*Ac^5;Cc*Ac^6;Cc*Ac^7;Cc*Ac^8;Cc*Ac^9;Cc*Ac^10;Cc*Ac^11];
    sys = ss(Ac, Bc, Cc, Dc);

%-- 離散系システム
        dsys = c2d(sys, Td); % - 連続系から離散系への変換
        [Ad, Bd, Cd, Dd] = ssdata(dsys);

end