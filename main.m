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
%%
% for mob1
tmp = [0 0;0 10;10 10;10 0]-[5 5];
Env.param.Vertices = [tmp;NaN NaN;0.6*tmp];
initial.p = [1,1,0]'-[5,5,0]';
rs = STATE_CLASS(struct('state_list',["p","v","q"],'num_list',[3,3,3]));
run("main2_agent_setup.m");
%agent.set_model_error("ly",0.02);
plot(polyshape(Env.param.Vertices))
%% set logger
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
LogData = [     % agentのメンバー関係以外のデータ
        ];
LogAgentData = [% 下のLOGGER コンストラクタで設定している対象agentに共通するdefault以外のデータ
            ];

logger = LOGGER(1:N, size(ts:dt:te, 2), fExp, LogData, LogAgentData);
%% main loop
run("main3_loop_setup.m");
PFH=figure();
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
        figure(PFH);
        hold off
        agent.sensor.lrf.show();
        %% estimator, reference generator, controller
        for i = 1:N
            % estimator
            agent(i).do_estimator(cell(1, 10));
            %if (fOffline);exprdata.overwrite("estimator",time.t,agent,i);end
            
            
            % reference
            rp=[4;0;0];     % 目標座標

            state = agent.estimator.result.state.p; % 自己位置 列ベクトル
            sensor = agent.sensor.result; % センサ情報
            sensor.sensor_points = sensor.sensor_points+state(1:2)';%グローバル座標系に直す
            Xd = rp - state;%配列の列ベクトルと行ベクトルになっていたので転置して直した
%             d = norm(Xd);               % 目標との距離
            theta = atan2(Xd(2), Xd(1));  % 目標方向 [rad]
            for k=2:length(sensor.angle)
                dtheta1 = theta - sensor.angle(k-1);   % 現状使うほう 目標方向との差の角度
%                 dtheta2 = theta - sensor.angle(k);   % 追々使うかも
                if abs(dtheta1) < 0.1    % 閾値はセンサ分解能 0.1より決定
%                     rtheta = sensor.angle(k-1);      % 目標角
                    l = sensor.length(k-1);          % 目標方向の測距距離
                    index = k - 1;
                   
                    break
                end
            end
            
            anchor_R = index;%右
            anchor_L = index;%左
            if( l < 2.)% 障害物あり T-bug 右
                while(1)
                    sensorP_R       = sensor.sensor_points(anchor_R-1,:)';   % indexの右の点の座標%グローバル座標系に直す
                    sensorP_index   = sensor.sensor_points(anchor_R,:)';     % 目標方向の点の座標  
                    
                    dLen_right = norm(sensorP_index- sensorP_R)     %正面とその右隣の端点距離
                    % 同一物体として認識
                    if dLen_right < 0.5     % 閾値が小さくて回っていないのかも 0.15 -> 0.5
                        anchor_R = anchor_R - 1;  % 右にずらす
                    else
                        break;
                    end
%                     if anchor_R == 1
%                         anchor_R = 63;
%                     end
                end

                while(1)
                    sensorP_index   = sensor.sensor_points(anchor_L,:)';%グローバル座標系に直す     
                    sensorP_L       = sensor.sensor_points(anchor_L+1,:)';   
                    
                    dLen_left = norm(sensorP_L- sensorP_index);      %正面とその左隣の端点距離
                    
                    % 同一物体として認識
                    if dLen_left < 0.5 
                        anchor_L = anchor_L + 1;  % 左にずらす
                    else
                        break;
                    end
                end
            
    % 
    %             sensorP_R; % anchor_R 座標
    %             sensorP_L; % anchor_L 座標
                dS_AnchorR = norm(state(1:2)-sensorP_R); % 現在位置-anchor_R 距離
                dS_AnchorL = norm(state(1:2)-sensorP_L); % 現在位置-anchor_L 距離
                dR_AnchorR = norm(rp(1:2)-sensorP_R);
                dR_AnchorL = norm(rp(1:2)-sensorP_R);
                route_R = dS_AnchorR+dR_AnchorR;
                route_L = dS_AnchorL+dR_AnchorL;
                [~,I] = min(sensor.length);
                a=sensor.sensor_points(I,:);
                b=a - state(1:2);
                sensor_r = 0.5;
                if route_R < route_L %右の方が短い
                    ref_tbug = sensorP_R'+(b/norm(b)*(norm(sensor_r) - norm(b)))';%ドローン自体にマージンをとる
                else
                    ref_tbug = sensorP_L'+(b/norm(b)*(norm(sensor_r) - norm(b)))';
                end
            else
                [~,I] = min(sensor.length); % センサ値の最小値
                a=sensor.sensor_points(I,:);
                b=a - state(1:2);
                sensor_r = 0.5;
                ref_tbug = rp(1:2)+(b/norm(b)*(norm(sensor_r) - norm(b)))';
            end
            
            % todo 座標変換

            rs.p = [ref_tbug;0]; % 目標位置
            rs.q = [0;0;0]; % 目標姿勢
            rs.v = [0;0;0]; % 目標速度

            param(i).reference.covering = [];
            param(i).reference.point = {FH, rs, time.t};
            param(i).reference.timeVarying = {time,FH};
            param(i).reference.tvLoad = {time};
            param(i).reference.tbug = {};
            param(i).reference.wall = {1};
            param(i).reference.agreement = {logger, N, time.t};
            for j = 1:length(agent(i).reference.name)
                param(i).reference.list{j} = param(i).reference.(agent(i).reference.name(j));
            end
            agent(i).do_reference(param(i).reference.list);
            %if (fOffline);exprdata.overwrite("reference",time.t,agent,i);end

            % controller
            param(i).controller.hlc = {time.t, HLParam};
            param(i).controller.pd = {};
            for j = 1:length(agent(i).controller.name)
                param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
            end
            agent(i).do_controller(param(i).controller.list);
            %if (fOffline); expudata.overwrite("input",time.t,agent,i);end
        end

        %% update state
        % with FH
        figure(FH)
        drawnow

        for i = 1:N                         % 状態更新
            model_param.param = agent(i).model.param;
            model_param.FH = FH;
            agent(i).do_model(model_param); % 算出した入力と推定した状態を元に状態の1ステップ予測を計算

            model_param.param = agent(i).plant.param;
            agent(i).do_plant(model_param);
        end
        %drawnow
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
% plot 
logger.plot({1,"p","er"});
% agent(1).reference.timeVarying.show(logger)

%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
%agent(1).animation(logger,"target",1:N);
%%
%logger.save();
