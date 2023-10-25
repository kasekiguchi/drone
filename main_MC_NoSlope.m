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
fKP = 1;
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

%%
flag = [0;0];

totalT = 0;
idx = 0;
pre_pos = 0;
fG = zeros(3, 1);
fRemove = 0;
fFinish = 0;
%-- 初期設定 controller.mと同期させる
data.param = agent.controller.(agent.controller.name).param;
% data.param = agent.controller.(agent.controller.name);
Params.H = data.param.H;   %Params.H
Params.dt = data.param.dt;  %Params.dt
Params.dT = dt;
%-- 配列サイズの定義
Params.ur = data.param.ref_input;

% データ保存初期化
data.xr{idx+1} = 0;
data.path{idx+1} = 0;       % - 全サンプル全ホライズンの値
data.pathJ{idx+1} = 0;      % - 全サンプルの評価値
data.sigma(:,idx+1) = zeros(4,1);      % - 標準偏差 

if fHL == 1
    data.bestcost(:,idx+1) = zeros(5,1); 
else
    data.bestcost(:,idx+1) = zeros(4,1);
end   % - 評価値

data.removeF(idx+1) = 0;    % - 棄却されたサンプル数
data.removeX{idx+1} = 0;    % - 棄却されたサンプル番号
data.variable_particle_num(idx+1) = 0;  % - 可変サンプル数

dataNum = 11;
data.state           = zeros(round(te/dt + 1), dataNum);       
data.state(idx+1, 1) = idx * dt;        % - 現在時刻
data.bestx(idx+1, :) = repelem(initial.p(1), Params.H); % - もっともよい評価の軌道x成分
data.besty(idx+1, :) = repelem(initial.p(2), Params.H); % - もっともよい評価の軌道y成分
data.bestz(idx+1, :) = repelem(initial.p(3), Params.H); % - もっともよい評価の軌道z成分

xr = zeros(16, Params.H);
Acc_old = 0;

fh = @(tt)[3*tt, 2*tt^2, tt-2];
calT = 0;
phase = 1; % 着陸開始時間
Time.te = te;

gradient = 3/10;

%     load("Data/HL_input");
%     load("Data/HL_V");

% load("Data/Input_HL.mat", "Idata");
% Params.ur_array = Idata;
% InputVdata = load("Data/inputV_HLMPC.mat");
% InputVdata = cell2mat(InputVdata.data.inputv);
InputVdata = 0;
fprintf("Initial Position: %4.2f %4.2f %4.2f\n", initial.p);

%% reference 
close all;
teref = te; % かける時間
z0 = 1; % z初期値
ze = 1; % z収束値
v0 = 0; % 初期速度
ve = 0; % 終端速度 収束させるなら０；　速度持ったまま落下なら-1とか -0.5
t = 0:0.025:te;
Params.refZ = curve_interpolation_9order(t',teref,z0,v0,ze,ve);
x0 = 0; % -1
xe = 2;
v0 = 0;
ve = 0;
Params.refX = curve_interpolation_9order(t',teref,x0,v0,xe,ve);
y0 = 0;
ye = 0;
v0 = 0;
ve = 0;
Params.refY = curve_interpolation_9order(t',teref,y0,v0,ye,ve);
data.Zdis(1) = 0;
%
figure(1)
plot(t, Params.refX(round(t/dt)+1,1), t, Params.refY(round(t/dt)+1,1), t, Params.refZ(round(t/dt)+1,1));
legend("X", "Y", "Z")
figure(2)
plot(t, Params.refX(round(t/dt)+1,2), t, Params.refY(round(t/dt)+1,2), t, Params.refZ(round(t/dt)+1,2));
legend("Vx", "Vy", "Vz")

%%
now = datetime('now');
dateprint = datestr(now, 'yyyy / mm / dd HH:MM')

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
        
%         if time.t > 2
%             FH.CurrentCharacter = 'm';
%         end
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

            % timevarygin -> generated reference
%             [xr, fFirst, pre_pos] = Reference(Params, time.t, agent, FH, fFirst, pre_pos);
            % Goal Position
            
%             [xr, fG] = Reference(Params, time.t, agent, G, fG);

            Time.t = time.t; 
            if time.t < te 
                Time.ind = time.t/dt; 
            else 
                Time.ind = Time.ind; 
            end
            Gp = initial.p;
            Gq = [0; 0.2975; 0];
            [xr] = Reference(Params, Time, agent, Gq, Gp, phase, fRef, data.Zdis);    % 1:斜面 0:それ以外(TimeVarying)
            param(i).controller.(agent(i).controller.name) = {idx, xr, time.t, phase};
% 
            for j = 1:length(agent(i).controller.name)
                param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
            end
            agent(i).do_controller(param(i).controller.list);
        end

        %%
        % data.bestcostID(:,idx) =  agent.controller.result.bestcostID;
        % data.bestcost(:,idx)=     agent.controller.result.bestcost;
        % data.path{idx} =          agent.controller.result.path;
        % data.pathJ{idx} =         agent.controller.result.Evaluationtra; % - 全サンプルの評価値
        % data.sigma(:,idx) =       agent.controller.result.sigma;
        % data.removeF(idx) =       agent.controller.result.removeF;   % - 棄却されたサンプル数
        % data.removeX{idx} =       agent.controller.result.removeX;
        clear data.input_v
        data.input_v(:,idx) =     agent.controller.result.input_v;

        % data.eachcost(:, idx) =    agent.controller.result.eachcost;

        % data.xr{idx} = xr;
        % data.variable_particle_num(idx) = agent.controller.result.variable_N;
        % data.survive(idx) = agent.controller.result.survive;
        % 
        % if data.removeF(idx) ~= data.param.particle_num
        %     data.bestx(idx, :) = data.path{idx}(3, :, data.bestcostID(3,1)); % - もっともよい評価の軌道x成分
        %     data.besty(idx, :) = data.path{idx}(7, :, data.bestcostID(4,1)); % - もっともよい評価の軌道y成分
        %     data.bestz(idx, :) = data.path{idx}(1, :, data.bestcostID(2,1)); % - もっともよい評価の軌道z成分
        % else
        %     if idx == 1
        %         data.bestx(idx, :) = data.bestx(idx, :); % - 制約外は前の評価値を引き継ぐ
        %         data.besty(idx, :) = data.besty(idx, :); % - 制約外は前の評価値を引き継ぐ
        %         data.bestz(idx, :) = data.bestz(idx, :); % - 制約外は前の評価値を引き継ぐ
        %     else
        %         data.bestx(idx, :) = data.bestx(idx-1, :); % - 制約外は前の評価値を引き継ぐ
        %         data.besty(idx, :) = data.besty(idx-1, :); % - 制約外は前の評価値を引き継ぐ
        %         data.bestz(idx, :) = data.bestz(idx-1, :); % - 制約外は前の評価値を引き継ぐ
        %     end
        % end

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
        totalT = totalT + calT;   % 合計計算時間
        data.calT(idx, :) = calT; % 計算時間の保存

        fprintf("==================================================================\n");
        fprintf("t: %f\n", time.t);
        fprintf("==================================================================\n");
        
%         fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \n",...
%                 state_monte.p(1), state_monte.p(2), state_monte.p(3),...
%                 state_monte.v(1), state_monte.v(2), state_monte.v(3),...
%                 state_monte.q(1)*180/pi, state_monte.q(2)*180/pi, state_monte.q(3)*180/pi); % s:state 現在状態
%         fprintf("pr: %f %f %f \t vr: %f %f %f \t qr: %f %f %f \n", ...
%                 xr(1,1), xr(2,1), xr(3,1),...
%                 xr(7,1), xr(8,1), xr(9,1),...
%                 xr(4,1)*180/pi, xr(5,1)*180/pi, xr(6,1)*180/pi)                             % r:reference 目標状態
% %         fprintf("t: %6.3f \t calT: %f \t paritcle_num: %d \t slopeZ: %f \t sigma: %f \n", ...
% %             time.t, calT, data.variable_particle_num(idx), altitudeSlope,data.sigma{idx})
%         fprintf("t: %f calT: %f \t input: %f %f %f %f \t input_v: %f %f %f %f", ...
%             time.t, calT, agent.input(1), agent.input(2), agent.input(3), agent.input(4), data.input_v(1, idx),data.input_v(2, idx),data.input_v(3, idx),data.input_v(4, idx));
%         fprintf("\n");

        figure(5);
        hold on;
        plot(time.t, logger.Data.agent.estimator.result{idx}.state.p(1), '.', 'MarkerSize', 10, 'Color','blue'); 
        plot(time.t, logger.Data.agent.estimator.result{idx}.state.p(2), '.', 'MarkerSize', 10, 'Color','red');
        plot(time.t, logger.Data.agent.estimator.result{idx}.state.p(3), '.', 'MarkerSize', 10, 'Color','#F0E68C');
        plot(time.t, logger.Data.agent.reference.result{idx}.state.p(1), '.', 'MarkerSize', 10, 'Color','#00FFFF');
        plot(time.t, logger.Data.agent.reference.result{idx}.state.p(2), '.', 'MarkerSize', 10, 'Color','#FF8C00');
        plot(time.t, logger.Data.agent.reference.result{idx}.state.p(3), '.', 'MarkerSize', 10, 'Color','#FFFACD');
        xlim([0 te]);
        clear logger.Data.agent
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


%% figure.m
savefigure

%% save data
% data_now = datestr(datetime('now'), 'yyyymmdd');
% Title = strcat(['SlopeLanding-input4-eachSigma-normalWeight', '-N'], num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
% Outputdir = strcat('../../students/komatsu/simdata/', data_now, '/');
% if exist(Outputdir) ~= 7
%     mkdir ../../students/komatsu/simdata/20230801/
% end
% save(strcat('/home/student/Documents/students/komatsu/simdata/',data_now, '/', Title, ".mat"), "agent","data","initial","logger","Params","totalT", "time", "-v7.3")
% save(strcat('C:/Users/student/Documents/students/komatsu/simdata/',data_now, '/', Title, ".mat"), "agent","data","initial","logger","Params","totalT", "time", "-v7.3")
% Video Only
% save(strcat('C:/Users/student/Documents/students/komatsu/simdata/',data_now, '/', Title, "-forVIDEO", ".mat"), "logger", "-v7.3");

%% figure保存
% foldername = datestr(datetime('now'), 'YYYYmmdd');
% now = datetime('now'); datename = datestr(datetime('now'), 'HHMMSS');
% Outputdir = '../../students/komatsu/simdata/20230515/';
% saveas(1,strcat(Outputdir,datename, "_position"),'fig');
% saveas(2,strcat(Outputdir,datename, "_attitude"),'fig');
% saveas(3,strcat(Outputdir,datename, "_velocity"),'fig');
% saveas(4,strcat(Outputdir,datename, "_input"),'fig');
%% 動画生成
% tic
pathJ = data.pathJ;

% data.variable_particle_num = size(data.pathJ{1},2) * ones(size(data.pathJ{1},2), 1);
for m = 1:size(pathJ, 2)-1
    pathJN{m} = normalize(pathJ{m}(:,1),'range', [1, data.param.Maxparticle_num]); % 0 ~ サンプル数　までで正規化
    % pathJN{m} = normalize(pathJ{m},'range', [1, length(size(data.pathJ{1},2))]);
end

% % 全時刻
% for i = 1:te/dt
%     Jt = data.pathJ{i};% 1*N
%     pt = data.path{i}; % 12*10*N
% 
%     [Jtsort, Jindex] = sort(Jt, 'descend');
%     Jorder{i} = [Jtsort', Jindex'];
% end
% pathJN = data.pathJ;
% rmdir ('C:/Users/student/Documents/students/komatsu/simdata/20230818/Animation/','s'); % 直前のシミュレーションより短くする場合
mkdir C:/Users/student/Documents/students/komatsu/simdata/20231023/Animation/;
% mkdir C:/Users/student/Documents/students/komatsu/simdata/20230830/Animation/png/Animation1/Animation_1/;
Outputdir_mov = 'C:/Users/student/Documents/students/komatsu/simdata/20231023/Animation/';
Outputdir = 'C:/Users/student/Documents/students/komatsu/simdata/20231023/Animation/';
% PlotMov_sort
% toc
%% Home PC adress
% mkdir ../../students/komatsu/simdata/20230522/ png/Animation1
% mkdir ../../students/komatsu/simdata/20230522/ png/Animation_omega
% mkdir ../../students/komatsu/simdata/20230522/ video
% Outputdir = '../../students/komatsu/simdata/20230522';
% PlotMov       % 2次元プロット
% toc

% PlotMovXYZ  % 3次元プロット
% save()
%% 学校PC adress
Outputdir = '../../students/komatsu/simdata/20230614/';
% save('C:\Users\student\"OneDrive - 東京都市大学 Tokyo City University (1)"\研究室_2023\Data\20230427v1.mat', '-v7.3')
% save("C:/Users/student/Documents/students/komatsu/MCMPC/20230515v1.mat", '-v7.3')
% mkdir ../../students/komatsu/simdata/20230614/ % ここは毎日更新する
% Savefilename = Title;
% Savefigurename = strcat(Savefilename, '_position');
% save(strcat('C:/Users/student/Documents/students/komatsu/simdata/',datestr(datetime('now'), 'yyyymmdd'), '/', Savefilename, ".mat"), "agent","data","initial","logger","Params","totalT", "time", "-v7.3");
% saveas(1, strcat(Outputdir, Savefilename), "png");