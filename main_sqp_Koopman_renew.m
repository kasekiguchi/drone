%% Drone 班用共通プログラム update sekiguchi
%-- 連続時間モデル　リサンプリングつき これを基に変更
%% Initialize settings
% set path
activeFile = matlab.desktop.editor.getActive;
cd(fileparts(activeFile.Filename));
[~, activeFile] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), activeFile, 'UniformOutput', false);
close all hidden; %clear all; clc;
% 
fHL = 0;
if fHL == 1
    Wi = 1;
    if Wi == 1; run('main.m'); end
end
clear initial logger data logHL param
%%
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
    Params.dt = 0.0525; %MPCステップ幅 0.07
    idx = 0; %プログラムの周回数
    totalT = 0;
    Params.flag = 0; %1：PtoPでのリファレンスの入れ替え
    Params.PtoP = 0; %1：PtoP制御

    %% 重みの設定


    max_input = 2;
    min_input = 0;

    % if ~exist('WeightV')
    %     WeightP = [10 10 150];
    %     WeightV = [50 50 50];
    % end
    % Params.Weight.P = diag(WeightP); %diag([10; 10; 150]);
    % Params.Weight.V = diag(WeightV); %diag([50; 50; 50]);  
    % Params.Weight.R = 1e1 * diag([20; 20; 20; 20]);
    % Params.Weight.RP = 1e0 * diag([1; 1; 1; 1]);
    % Params.Weight.QW = 1e3 * diag([1e1; 1e1; 1e1; 1; 1; 150]);
    % % Params.Weight.Pf = diag([1e4; 1e4; 1e2]);
    % % Params.Weight.Vf = diag([1e2; 1e2; 1e3]);
    % % Params.Weight.QWf = diag([1e1; 1e1; 1; 1; 1; 1]);
    % Params.Weight.Pf = Params.Weight.P;
    % Params.Weight.Vf = Params.Weight.V;
    % Params.Weight.QWf = Params.Weight.QW;
    % 
    % Params.Weight.P = diag([90.0; 90.0; 1.0]);    % 座標   1000 10
    % Params.Weight.V = diag([90.0; 90.0; 110.0]);    % 速度
    % Params.Weight.R = diag([1.0; 1.0; 1.0; 1.0]); % 入力
    % Params.Weight.RP = diag([0; 0; 0; 0]);  % 1ステップ前の入力との差    0*(無効化)
    % Params.Weight.QW = diag([2000; 2200; 1700; 1; 1; 1]);  % 姿勢角、角速度
    % Params.Weight.Pf = diag([300; 300; 1]);
    % Params.Weight.Vf = diag([170; 170; 200]);
    % Params.Weight.QWf = diag([4500; 5000; 2000; 1; 1; 1]);

    DecideWeight
        
%-- data
    data.bestcost(idx+1) = 0;           % - もっともよい評価値

%-- 配列サイズ
    Params.state_size = 12; %12状態
    Params.input_size = 4;  %4つの入力
    Params.total_size = Params.state_size + Params.input_size;

%-- 目標値等
    % InputHL = load("Data/InputHL.mat", "InputHL");
    % Params.ur = InputHL.InputHL';
    Params.ur = 0.5884*9.81/4 * ones(4, 1);
    % Params.ur = 0.5884*9.81 * [1;0;0;0];

%-- fmincon 設定
    options = optimoptions('fmincon');
%     options = optimoptions(options,'Diagnostics','off');
%     options = optimoptions(options,'MaxFunctionEvaluations',1.e+12);     % 評価関数の最大値
    options = optimoptions(options,'MaxIterations',      1.e+9);     % 最大反復回数
    options = optimoptions(options,'ConstraintTolerance',1.e-4);%制約違反に対する許容誤差
%     options = optimoptions(options,'ConstraintTolerance',1.e-6);%制約違反に対する許容誤差
    
    %-- fmincon設定
    options.Algorithm = 'sqp';  % 逐次二次計画法
    options.Display = 'none';   % 計算結果の表示
    %Koopman
    % load('')
    % load('drone\koopman_data\EstimationResult_12state_10_30_data=cirandrevsadP2Pxy_cir=cir_est=cir_Inputandconst.mat','est') %円(順逆)+サドル+P2P(x,y),観測量：状態+非線形項
    % load('drone\Koopman_data\EstimationResult_12state_11_29_GUIsimdata.mat')
    load('drone\Koopman_data\case5.mat');
    Params.A = est.A;
    Params.B = est.B;
    Params.C = est.C;
    
    previous_state  = repmat(Params.ur(:,1), 1, Params.H);

    xr = zeros(Params.state_size+Params.input_size, Params.H);
    initial_input = Params.ur;
    
    if fHL == 1
        load('drone\Data\HL_log.mat'); % estimator, inputの読み込み
        Params.logHL = logHL;
    end

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
            
            %PtoPの場合はコメントオフ
            if exist('logHL', 'var')
                xr = Reference(Params, time.t, te, agent, logHL); %TimeVarying
            else
                xr = Reference(Params, time.t, te, agent, []);
            end
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

        %-- MPCパラメータを構造体に格納
            Params.xr = xr;
            Params.X0= agent.estimator.result.state.get();   % 現在状態の記録
            
        %-- 状態の表示
            state_monte = agent.model.state;
            ref_monte = agent.reference.result.state;
            
        %-- 初期値の設定
            % x0 = repmat(Params.ur, 1, Params.H);% 初期値 目標入力固定
            
            %% MPC設定
            x0 = previous_state; % 初期値（fminconで算出された入力）
            A = [];
            b = [];
            Aeq = [];
            beq = [];
            lb = min_input * ones(4, Params.H); % min
            ub = max_input * ones(4, Params.H); % max
            nonlcon = [];
            fun = @(x) Objective_renew(x,Params,agent.input);

            [var, fval, exitflag, output, lambda, grad, hessian] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options); %最適化計算
            data.exitflag(idx) = exitflag;

            % 制御入力の決定
            previous_state = var;   % 初期値の書き換え(最適化計算で求めたホライズン数分の値)

            agent.input = var(:, 1);
            initial_input = agent.input;
        end   
        %-- データ保存
            data.bestcost(idx) = fval; %もっともよい評価値を保存
            data.xr(:,idx) = xr(:,1);

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
        elseif find(var(:,:) > 5)
            error('入力が正しくありません');
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
                time.t = time.t + dt; % for sim 時刻の更新
            end

        end
        calT = toc; % 1ステップ（25ms）にかかる計算時間
        totalT = totalT + calT; %すべての計算を終えるまでにかかった時間

        fprintf("==================================================================\n");
        fprintf("==================================================================\n");
        fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \n",...
                state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                state_monte.v(1), state_monte.v(2), state_monte.v(3),...
                state_monte.q(1)*180/pi, state_monte.q(2)*180/pi, state_monte.q(3)*180/pi); % s:state 現在状態
        fprintf("pr: %f %f %f \t vr: %f %f %f \t qr: %f %f %f \n", ...
                xr(1,1), xr(2,1), xr(3,1),...
                xr(7,1), xr(8,1), xr(9,1),...
                xr(4,1)*180/pi, xr(5,1)*180/pi, xr(6,1)*180/pi)     
        fprintf("t: %f calT: %f \t fval: %f \n", ...
        time.t, calT, fval);
        fprintf("input: %f %f %f %f\n", agent.input(1), agent.input(2), agent.input(3), agent.input(4));
        %        profile viewer;
    end

catch ME % for error
    % with FH
    for i = 1:N
        agent(i).do_plant(struct('FH', FH), "emergency");
    end
    % logger.plot({1,"p","er"},{1,"v","e"},{1,"q","e"},{1,"w","e"},{1,"input",""},{1, "p1-p2", "e"}, "fig_num",1,"row_col",[2,3]);
    warning('ACSL : Emergency stop! Check the connection.');
    rethrow(ME);
end
%% グラフの描画
%profile viewer
close all

fprintf("%f秒\n", totalT)
Fontsize = 15;  timeMax = 100;
set(0, 'defaultAxesFontSize', Fontsize);
set(0, 'defaultTextFontSize', Fontsize);
logger.plot({1,"p","er"},{1,"v","e"},{1,"q","e"},{1,"w","e"},{1,"input",""},{1, "p1-p2", "e"}, "fig_num",1,"row_col",[2,3]);
set(gca, "Position", [960 0 960 1000])

Est = [logger.data(1, "p", "e")'; logger.data(1, "q", "e")'; logger.data(1, "v" ,"e")'];
Ref = data.xr(1:9, 1:end-1);
dataRMSE = '    x,        y,        z,        roll,     pitch,    yaw,      vx,       vy,       vz';
disp(dataRMSE);
endidx = round(time.t/0.025) - 1;
dataRMSE = rmse(Est(:, 1:endidx), Ref(:, size(Est, 2)), 2)';
disp(dataRMSE);
disp(i);

%%
close all
Fontsize = 15;  xmax = time.t;
set(0, 'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);

Edata = logger.data(1, "p", "e")';
% Rdata = logger.data(1, "p", "r")';

Vdata = logger.data(1, "v", "e")';
Qdata = logger.data(1, "q", "e")';
Idata = logger.data(1,"input",[])';
logt = logger.data('t',[],[]);
Rdata = logger.data(1, "p", "r")';
Rdata = zeros(12, size(logt, 1));
Rdata = data.xr(:,1:end-1);
% IV = zeros(4, size(logt, 1));
% for R = 1:size(logt, 1)
%     Rdata(:, R) = xr{R}(1:12, 1); % cell2matにはできない　ホライズンがあるからcellオンリー
% end
% Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
figure(1); plot(logt, Edata); hold on; plot(logt, Rdata(1:3, :), '--'); hold off;
ylabel("Position /m")
legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference", "Location","southeast");
% yyaxis right
% plot(logt, Eachcost(8,:)); 
% plot(logt, data.survive(1,end-1)', '.', 'MarkerSize', 2)
xlabel("Time /s");  
grid on; xlim([0 xmax]); %ylim([0 5000]);

% atiitude 0.2915 rad = 16.69 deg
figure(2); plot(logt, Qdata); hold on; plot(logt, Rdata(4:6, :), '--'); hold off;
xlabel("Time /s"); ylabel("Attitude /rad"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","southeast");
grid on; xlim([0 xmax]); ylim([-inf inf]);

% figure(2); plot(Edata(1,:), Edata(2,:)); hold on; plot(Rdata(1,:), Rdata(2,:), '--'); hold off;
% xlim([0 10])
% daspect([1 1 1]);
% legend("Estimate", "Reference");
% xlabel("$$X$$", "Interpreter", "latex"); ylabel("$$Y$$", "Interpreter", "latex")

% velocity
figure(3); plot(logt, Vdata); hold on; plot(logt, Rdata(7:9, :), '--'); hold off;
xlabel("Time /s"); ylabel("Velocity / m/s"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref",  "Location","southeast");
grid on; xlim([0 xmax]); ylim([-inf inf]);
% input
figure(4); 
plot(logt, Idata, "LineWidth", 1.5); hold on; hold off;
xlabel("Time /s"); ylabel("Input /N"); legend("rotor1", "rotor2", "rotor3", "rotor4","Location","southeast");
grid on; xlim([0 xmax]); ylim([-inf inf]);
ytickformat('%.4f')

figure(5);
plot(Edata(1,:), Edata(2,:), "LineWidth", 1.5);
xlabel("x /m"); ylabel("y /m");
grid on; xlim([-inf inf]); ylim([-inf inf]);
daspect([1,1,1])

%% error
% figure(10)
error = Edata - Rdata(1:3,:);
% plot(logt, error);
% legend("x-xd", "y-yd", "z-zd", "Location","southeast");
err_abs = abs(error);
[max_x] = max(err_abs(1,:))
max_y = max(err_abs(2,:))
max_z = max(err_abs(3,:))

%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
% agent(1).animation(logger,"target",1);
% agent(1).animation(logger,"mp4",1);
% agent(1).animation(logger,"gif", 1);
%% SAVE
% save(strcat('C:/Users/student/Documents/students/komatsu/NMPC/NMPC_hovering_input_1e5.mat'), "data", "logger", "Params", "-v7.3")
