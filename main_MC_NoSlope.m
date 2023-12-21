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
% run("main.m"); % 目標入力生成
% close all hidden; clear all; clc;
% userpath('clear');
fRef = 0; %% 斜面着陸かどうか 1:斜面 2:逆時間 3:HL 0:TimeVarying
fHL = 1;
fMC = 1;
% movie
fMovie = 10;
fSave = 10;
MovTime = 0;
% figure
fsave = 0;

%------------------------
% PC変更時初回はcontroller 途中で止めて
% Resampling_IS, Us_GUIのmex化
% codegen Resampling_IS -args {obj.N, obj.param.H, obj.input.EvalNorm, obj.input.u}
% のような感じで引数を代入してmexファイルを生成する
%------------------------

run("main1_setting.m");
run("main2_agent_setup_MC.m");
%agent.set_model_error("ly",0.02);
%% set logger
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
LogData = [     % agentのメンバー関係以外のデータ
        ];
LogAgentData = [% 下のLOGGER コンストラクタで設定している対象agentに共通するdefault以外のデータ
            ];

logger = LOGGER(1:N, size(ts:dt:te, 2), fExp, LogData, LogAgentData);

%% main loop
totalT = 0;
idx = 0;
%-- 初期設定 controller.mと同期させる
data.param = agent.controller.(agent.controller.name).param;

% データ保存初期化
if fMC == 1
    data.xr{idx+1} = 0;
    data.path{idx+1} = 0;       % - 全サンプル全ホライズンの値
    data.pathJ{idx+1} = 0;      % - 全サンプルの評価値
    data.sigma(:,idx+1) = zeros(4,1);      % - 標準偏差
    data.removeF(idx+1) = 0;    % - 棄却されたサンプル数
    data.removeX{idx+1} = 0;    % - 棄却されたサンプル番号
    data.variable_particle_num(idx+1) = 0;  % - 可変サンプル数
    
    data.bestx(idx+1, :) = repelem(initial.p(1), data.param.H); % - もっともよい評価の軌道x成分
    data.besty(idx+1, :) = repelem(initial.p(2), data.param.H); % - もっともよい評価の軌道y成分
    data.bestz(idx+1, :) = repelem(initial.p(3), data.param.H); % - もっともよい評価の軌道z成分
end

if fHL && fMC
    data.bestcost(:,idx+1) = zeros(5,1); 
elseif ~fHL && fMC
    data.bestcost(:,idx+1) = zeros(4,1);
end   % - 評価値

xr = zeros(16, data.param.H);

InputVdata = 0;
fprintf("Initial Position: %4.2f %4.2f %4.2f\n", initial.p);

%% reference 9th order polynomial
% teref = 2; % かける時間
% z0 = 2; % z初期値
% ze = 0.1; % z収束値
% v0 = 0; % 初期速度
% ve = 0; % 終端速度 収束させるなら０；　速度持ったまま落下なら-1とか -0.5
% t = 0:0.025:3;
% data.ref.refZ = curve_interpolation_9order(t',teref,z0,v0,ze,ve);
% x0 = -1; % -1
% xe = 0;
% ve = 0;
% delay = 0;
% data.ref.refX = curve_interpolation_9order(t'-delay,teref,x0,v0,xe,ve);

%%
datestr(datetime('now'), 'yyyy / mm / dd HH:MM')

if fSave == 1
    % data_now = datestr(datetime('now'), 'yyyymmdd');
    mkdir(strcat('../../students/komatsu/simdata/', datestr(datetime('now'), 'yyyymmdd'), '/video/'));
    Outputdir = strcat('C:/Users/student/Documents/students/komatsu/simdata/', datestr(datetime('now'), 'yyyymmdd'));
    writerObj=VideoWriter(strcat(Outputdir,'/video/',datestr(now, 'HHMMSS_FFF')));
    open(writerObj);
end
calT = 0;

run("main3_loop_setup.m");

try
    while round(time.t, 5) <= te
        tic;
        idx = idx + 1;
        %% sensor
           % tic
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

        %% estimator, reference generator, controller
        for i = 1:N
            % estimator
            agent(i).do_estimator(cell(1, 10));
            %if (fOffline);exprdata.overwrite("estimator",time.t,agent,i);end
            
            FH.CurrentCharacter = 'f';
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

            Time.t = time.t; 
            if time.t < te 
                Time.ind = time.t/dt; 
            else 
                Time.ind = Time.ind; 
            end
            Gp = initial.p;
            Gq = [0; 0.2975; 0];
            [xr] = Reference(data, Time, agent, Gq, Gp, 0, fRef, 2);    % 1:斜面 0:それ以外(TimeVarying)
            param(i).controller.(agent(i).controller.name) = {idx, xr, time.t, 0};
% 
            for j = 1:length(agent(i).controller.name)
                param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
            end
            agent(i).do_controller(param(i).controller.list);
        end

        %%
        if fMC == 1
            data.bestcostID(:,idx) =  agent.controller.result.bestcostID;
            data.bestcost(:,idx)=     agent.controller.result.bestcost;
            data.path{idx} =          agent.controller.result.path;
            data.pathJ{idx} =         agent.controller.result.Evaluationtra; % - 全サンプルの評価値
            data.sigma(:,idx) =       agent.controller.result.sigma;
            data.removeF(idx) =       agent.controller.result.removeF;   % - 棄却されたサンプル数
            data.removeX{idx} =       agent.controller.result.removeX;
            data.variable_particle_num(idx) = agent.controller.result.variable_N;
            data.survive(idx) = agent.controller.result.survive;
            % data.eachcost(:, idx) =    agent.controller.result.eachcost;

            if data.removeF(idx) ~= data.param.particle_num
                if fHL == 1
                    data.bestx(idx, :) = data.path{idx}(3, :, data.bestcostID(3,1)); % - もっともよい評価の軌道x成分
                    data.besty(idx, :) = data.path{idx}(7, :, data.bestcostID(4,1)); % - もっともよい評価の軌道y成分
                    data.bestz(idx, :) = data.path{idx}(1, :, data.bestcostID(2,1)); % - もっともよい評価の軌道z成分
                else
                    data.bestx(idx, :) = data.path{idx}(1, :, data.bestcostID(1,1)); % - もっともよい評価の軌道x成分
                    data.besty(idx, :) = data.path{idx}(2, :, data.bestcostID(1,1)); % - もっともよい評価の軌道y成分
                    data.bestz(idx, :) = data.path{idx}(3, :, data.bestcostID(1,1)); % - もっともよい評価の軌道z成分
                end
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
        end
        data.input_v(:,idx) =     agent.controller.result.input_v;
        data.xr{idx} = xr;

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
        
        % data.totalT = data.totalT + calT;

        fprintf("==================================================================\n");
        % fprintf("t: %f\n", time.t);
        fprintf("==================================================================\n");
        
        fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \n",...
                state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                state_monte.v(1), state_monte.v(2), state_monte.v(3),...
                state_monte.q(1)*180/pi, state_monte.q(2)*180/pi, state_monte.q(3)*180/pi); % s:state 現在状態
        fprintf("pr: %f %f %f \t vr: %f %f %f \t qr: %f %f %f \n", ...
                xr(1,1), xr(2,1), xr(3,1),...
                xr(7,1), xr(8,1), xr(9,1),...
                xr(4,1)*180/pi, xr(5,1)*180/pi, xr(6,1)*180/pi)                             % r:reference 目標状態
%         fprintf("t: %6.3f \t calT: %f \t paritcle_num: %d \t slopeZ: %f \t sigma: %f \n", ...
%             time.t, calT, data.variable_particle_num(idx), altitudeSlope,data.sigma{idx})
        fprintf("t: %f calT: %f \t input: %f %f %f %f \t input_v: %f %f %f %f \n", ...
            time.t, calT, agent.input(1), agent.input(2), agent.input(3), agent.input(4), data.input_v(1, idx),data.input_v(2, idx),data.input_v(3, idx),data.input_v(4, idx));
        if fMC == 1
            fprintf("J: %f, \t Jconst: %f", data.bestcost(1,idx), data.param.ConstEval);
        end
        
        fprintf("\n");

        % figure(5); 10000...00サンプルの時に描画だけやって確認する用
        % hold on;
        % plot(time.t, logger.Data.agent.estimator.result{idx}.state.p(1), '.', 'MarkerSize', 10, 'Color','blue'); 
        % plot(time.t, logger.Data.agent.estimator.result{idx}.state.p(2), '.', 'MarkerSize', 10, 'Color','red');
        % plot(time.t, logger.Data.agent.estimator.result{idx}.state.p(3), '.', 'MarkerSize', 10, 'Color','#F0E68C');
        % plot(time.t, logger.Data.agent.reference.result{idx}.state.p(1), '.', 'MarkerSize', 10, 'Color','#00FFFF');
        % plot(time.t, logger.Data.agent.reference.result{idx}.state.p(2), '.', 'MarkerSize', 10, 'Color','#FF8C00');
        % plot(time.t, logger.Data.agent.reference.result{idx}.state.p(3), '.', 'MarkerSize', 10, 'Color','#FFFACD');
        % xlim([0 te]);
        % legend("x.est", "y.est","z.est","x.ref","y.ref","z.ref");
        %%
        
        %% 毎時刻　軌跡描画
        if fMovie == 1 && fMC == 1
            if time.t > MovTime
                figure(idx+1)
                pathJN = normalize(data.pathJ{idx}(:,1),'range', [1, data.param.Maxparticle_num]);
                Color_map = (169/255)*ones(data.variable_particle_num(idx),3);                         % 灰色のカラーマップの作成
	            Color_map(1:data.variable_particle_num(idx),:) = jet(data.variable_particle_num(idx)); % 評価値の上からN個をカラーマップの色付け.
		        fig = gcf;
		        ax = gca;
                path_count = size(pathJN, 1); % N
                Color_array = zeros(path_count,3);
                Color_ceil = zeros(path_count,1);
                for j = 1:path_count % サンプルごとにホライズンはまとめて描画 サンプルのループ
                    %% 棄却
                    % if ~isnan(pathJN(j, 1))
			        %     plot(data.path{idx}(3,:,j),data.path{idx}(7,:,j),'Color',Color_map(ceil(pathJN(j, 1)),:), 'LineWidth',1); % HL
                    % else
                    %     plot(data.path{idx}(3,:,j),data.path{idx}(7,:,j),'Color', '#808080', 'LineWidth',1); % 棄却
                    % end
                    if data.pathJ{idx}(j, 1) >= data.param.ConstEval
                        plot(data.path{idx}(3,:,j),data.path{idx}(7,:,j),'Color', '#808080', 'LineWidth',1);
                    else
                        plot(data.path{idx}(3,:,j),data.path{idx}(7,:,j),'Color',Color_map(ceil(pathJN(j, 1)),:), 'LineWidth',1); % HL
                    end
                    hold on;
                end
                plot(state_monte.p(1), state_monte.p(2), '.', 'MarkerSize', 20, 'Color', 'red');    % 現在位置
		        plot(data.bestx(idx,:),data.besty(idx,:),'--','Color',[255,94,25]/255,'LineWidth',2);
                % 障害物
                % radius = 0.2;
                % pos = [data.param.obsX-radius, data.param.obsY-radius, 2*radius, 2*radius];
                % rectangle('Position',pos,'Curvature',[1 1]);
    
		        str = ['$$t$$= ',num2str(time.t,'%.3f'),' s'];
		        text(0.5,2,str,'FontSize',20,'Interpreter', 'Latex','BackgroundColor',[1 1 1],'EdgeColor',[0 0 0])
		        grid on
		        ax.YLim = [-2 2];
		        ax.XLim = [-3 1];
                % ax.YLim = [-1 1];
		        % ax.XLim = [2 te];
		        fig.Units = 'normalized';
		        set(gca,'FontSize',20,'FontName','Times');
		        xlabel('$$X$$[m]','Interpreter', 'Latex','FontSize',20);
		        ylabel('$$Y$$[m]','Interpreter', 'Latex','FontSize',20);
		        % filename = ['Animation_',num2str(idx)];
		        Xleng = ax.XLim(1,2) - ax.XLim(1,1);
		        Yleng = ax.YLim(1,2) - ax.YLim(1,1);
		        pbaspect([Xleng,Yleng,1]);
                if idx ~= 1; close(figure(idx)); end
                % drawnow
                if fSave == 1
                    frame = getframe(figure(idx+1));
                    writeVideo(writerObj, frame);
                end
            end
        end
        calT = toc; % 1ステップ（25ms）にかかる計算時間
        data.calT(idx, :) = calT; % 計算時間の保存
        totalT = totalT + calT;   % 合計計算時間
    end

catch ME % for error
    % with FH
    for i = 1:N
        agent(i).do_plant(struct('FH', FH), "emergency");
    end

    warning('ACSL : Emergency stop! Check the connection.');
    rethrow(ME);
end

if fSave == 1
    close(writerObj);
end

%% figure.m
savefigure

%% 動画生成
% tic
% pathJ = data.pathJ;
% for m = 1:size(pathJ, 2)-1
%     pathJN{m} = normalize(pathJ{m}(:,1),'range', [1, data.param.Maxparticle_num]); % 0 ~ サンプル数　までで正規化
%     % pathJN{m} = normalize(pathJ{m},'range', [1, length(size(data.pathJ{1},2))]);
% end

% % % 全時刻
% % % for i = 1:te/dt
% % %     Jt = data.pathJ{i};% 1*N
% % %     pt = data.path{i}; % 12*10*N
% % % 
% % %     [Jtsort, Jindex] = sort(Jt, 'descend');
% % %     Jorder{i} = [Jtsort', Jindex'];
% % % end
% % % pathJN = data.pathJ;
% % % rmdir ('C:/Users/student/Documents/students/komatsu/simdata/20230818/Animation/','s'); % 直前のシミュレーションより短くする場合