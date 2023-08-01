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
fRef = 1; %% 斜面着陸かどうか 1:斜面 2:逆時間 3:HL 0:TimeVarying
fHL = 0; % HL はトルク入力の変換の部分作らないと動かない
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
flag = [0;0];

totalT = 0;
idx = 0;
pre_pos = 0;
fG = zeros(3, 1);
fRemove = 0;
fFinish = 0;
%-- 初期設定 controller.mと同期させる
data.param = agent.controller.mcmpc;
Params.H = data.param.param.H;   %Params.H
Params.dt = data.param.param.dt;  %Params.dt
Params.dT = dt;
%-- 配列サイズの定義
Params.state_size = 12;
Params.input_size = 4;
Params.total_size = 16;
Params.soft_time = data.param.param.soft_time;
Params.soft_z = data.param.param.soft_z;
% Reference.mを使えるようにする
% Params.ur = 0.269 * 9.81 / 4 * ones(Params.input_size, 1);
Params.ur = data.param.param.ref_input;
xr0 = zeros(Params.state_size, Params.H);

% データ保存初期化
data.xr{idx+1} = 0;
data.path{idx+1} = 0;       % - 全サンプル全ホライズンの値
data.pathJ{idx+1} = 0;      % - 全サンプルの評価値
data.sigma(:,idx+1) = zeros(4,1);      % - 標準偏差 
data.bestcost(:,idx+1) = 0;   % - 評価値
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
teref = 2; % かける時間
z0 = 2; % z初期値
ze = 0.1; % z収束値
v0 = 0; % 初期速度
ve = 0; % 終端速度 収束させるなら０；　速度持ったまま落下なら-1とか -0.5
t = 0:0.025:3;
Params.refZ = curve_interpolation_9order(t',teref,z0,v0,ze,ve);
x0 = -1; % -1
xe = 0;
ve = 0;
% teref = 1.5;
delay = 0;
Params.refX = curve_interpolation_9order(t'-delay,teref,x0,v0,xe,ve);
% y0 = 0;
% ye = 0;
% Params.refY = curve_interpolation_9order(t',teref,y0,v0,ye,ve);
data.Zdis(1) = 0;
    %%

run("main3_loop_setup.m");

try
    while round(time.t, 5) <= te
        tic;
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
            %% 次の目標値の設定

            % 斜面の垂直方向の速度を目標に与える．
            % -> そういう関数
            % -> 初期速度必要
            % ある程度速度が落ちたら入力切る．

%             Gp = initial.p;
%             if agent.estimator.result.state.p(3) < 0.3
%                 Gq = [0; 0.2915; 0];
%             else
%                 Gq = [0; 0; 0];
%             end


            %% 斜面着陸　入力切断条件
%             if abs(agent.estimator.result.state.v(3)) < 0.03
%                 flag(1) = 1;
%             end
                    % 加速度で増減見る
%                             AA_old = ACC;
%                             AA = Ref(11);
%                             if AA_old/AA_old * AA/AA == -1
%             [xr] = Reference(Params, time.t, agent, Gp, Gq, Cp, ToTime, StartT);
            Time.t = time.t; 
            if time.t < te 
                Time.ind = time.t/dt; 
            else 
                Time.ind = Time.ind; 
            end
            Gp = initial.p;
            Gq = [0; 0.2975; 0];
            [xr] = Reference(Params, Time, agent, Gq, Gp, phase, fRef, data.Zdis);    % 1:斜面 0:それ以外(TimeVarying)
            param(i).controller.mcmpc = {idx, xr, time.t, phase, InputVdata, gradient};    % 入力算出 / controller.name = hlc
            for j = 1:length(agent(i).controller.name)
                param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
            end

            agent(i).do_controller(param(i).controller.list);

%             if time.t < 0.4
            if fRef==0 && 2.5 < time.t && time.t < 2.575  %fRef==1
                agent.input = [0;0;0;0];
                % agent(i).do_controller(param(i).controller.list);
            elseif fRemove == 2
                agent.input = [0;0;0;0];    % 入力切っているときはコントローラー計算しない
            else
                agent(i).do_controller(param(i).controller.list);
            end

            %% 自由落下:入力切る
%             if fRef == 0 && time.t < 0.4 && fHL == 0
%                 agent.input = [0;0;0;0];
% %             elseif fRef == 1 && 2.5 < time.t && time.t < 2.6
% %                 agent.input = [0;0;0;0];
%             end

            if flag(1) == 1
                agent.input = [0; 0; 0; 0];
            end
        end

        %-- データ保存
        if idx == 1
            data.param = agent.controller.result.contParam;
        end
%         state_data =            agent.controller.result.path;
        BestcostID =              agent.controller.result.BestcostID;
        data.path{idx} =          agent.controller.result.path;
        data.pathJ{idx} =         agent.controller.result.Evaluationtra; % - 全サンプルの評価値
        data.pathJN{idx} =        agent.controller.result.Evaluationtra_norm;
        data.sigma(:,idx) =       agent.controller.result.sigma;
        data.bestcost(:,idx)=     agent.controller.result.bestcost;
        data.removeF(idx) =       agent.controller.result.removeF;   % - 棄却されたサンプル数
        data.removeX{idx} =     agent.controller.result.removeX;
        data.input_v(:,idx) =     agent.controller.result.input_v;
        data.Zdis(idx) =          agent.controller.result.Zdis;
        data.Zsoft(idx) =         agent.controller.result.Zsoft;
        if fHL == 0;    data.eachcost(:, idx) =    agent.controller.result.eachcost; end

        data.xr{idx} = xr;
        data.variable_particle_num(idx) = agent.controller.result.variable_N;
        data.survive{idx} = agent.controller.result.survive;
%         COG = agent.controller.result.COG;
%         data.cog.g{idx} = COG.g;
%         data.cog.gc{idx} = COG.gc;

        if data.removeF(idx) ~= data.param.particle_num
            data.bestx(idx, :) = data.path{idx}(1, :, BestcostID(1)); % - もっともよい評価の軌道x成分
            data.besty(idx, :) = data.path{idx}(2, :, BestcostID(1)); % - もっともよい評価の軌道y成分
            data.bestz(idx, :) = data.path{idx}(3, :, BestcostID(1)); % - もっともよい評価の軌道z成分
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
        totalT = totalT + calT;   % 合計計算時間
        data.calT(idx, :) = calT; % 計算時間の保存

%         fRemove = agent.controller.result.fRemove;
        % flag:: 1:終了, 2:入力切るタイミング

        %% 斜面着陸　終了条件
        % fRemove = 2から入力切って地面についたら終了
        if agent.estimator.result.state.p(3) < (gradient * agent.estimator.result.state.p(1)+0.1)   % 斜面: gradient * x + 0.1
            fRemove = 1;
        end
%         終了条件に傾きを導入
%         drone_1X = agent.estimator.result.state.p(1)+agent.parameter.lx*cos(agent.estimator.result.state.q(3));
%         drone_2X = agent.estimator.result.state.p(1)-agent.parameter.lx*cos(agent.estimator.result.state.q(3));
%         drone_1Y = agent.estimator.result.state.p(3)+

        %% 斜面に対する高度が0.2m以下かつ速度が0.1m/s以下，0.1975rad - Q - 0.3975rad以内なら終了
        altitudeSlope = (agent.estimator.result.state.p(3) - (gradient * (agent.estimator.result.state.p(1) + 0.1))) * cos(atan(gradient)); % 斜面に対する高度, 
        vSlope = agent.estimator.result.state.v(3);

        if altitudeSlope < 0.25 && abs(agent.estimator.result.state.v(3)) < 0.05 && agent.estimator.result.state.q(2) < -0.1 %&& abs(agent.estimator.result.state.q(2)) < 0.3975 
            fRemove = 2;
            fFinish = 1;
            data.FinishState = [agent.estimator.result.state.p; agent.estimator.result.state.q(2); altitudeSlope; vSlope];
%         elseif fRemove == 2
%             agent.input = zeros(4,1);
        end

        fprintf("==================================================================\n")
        fprintf("==================================================================\n")
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
        fprintf("t: %f \t input: %f %f %f %f \t input_v: %f %f %f %f", ...
            time.t, agent.input(1), agent.input(2), agent.input(3), agent.input(4), data.input_v(1, idx),data.input_v(2, idx),data.input_v(3, idx),data.input_v(4, idx));
        fprintf("\n");

        if fRemove == 1   % 1:本物 10:墜落で終了させない
            fFinish
            if fFinish == 1
                disp('Conguraturation')
            end
            warning("Z<0 Emergency Stop!!!")
            break;
        elseif fRemove == 2
            fRemove
%             warning("Landing complete")
%             break;
        elseif fRemove == 3 % 多分ない⇒制約なし
            warning("all remove")
            break;
        end
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


%%
SigmaData = zeros(4, te/dt);
close all
fprintf("%f秒\n", totalT)
Fontsize = 15;  xmax = 4;
set(0, 'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);

% size_best = size(data.bestcost, 2);
Edata = logger.data(1, "p", "e")';
% Rdata = logger.data(1, "p", "r")';

Vdata = logger.data(1, "v", "e")';
Qdata = logger.data(1, "q", "e")';
Idata = logger.data(1,"input",[])';
logt = logger.data('t',[],[]);
Rdata = zeros(12, size(logt, 1));
IV = zeros(4, size(logt, 1));
for R = 1:size(logt, 1)
    Rdata(:, R) = data.xr{R}(1:12, 1); % cell2matにはできない　ホライズンがあるからcellオンリー
end
Diff = Edata - Rdata(1:3, :);
close all

% x-y
% figure(5); plot(Edata(1,:), Edata(2,:)); xlabel("X [m]"); ylabel("Y [m]");
m = 3; n = 2;
% x-z
% Et = -0.5:0.1:0.5; Ez = 3/10 * Et; Er = -10/3 * Et;
% figure(6); plot(Edata(1,1:round(xmax/dt)-1), Edata(3,1:round(xmax/dt-1))); hold on; % 軌跡
% plot(Rdata(1,1:round(xmax/dt)-1), Rdata(3, 1:round(xmax/dt)-1));
% % plot(0, 0.15, '*'); plot(0.1, 0.15, '.'); plot(0.1, 0.1, '.');
% plot(Edata(1,1), Edata(3,1), 'h');  % initial
% plot(Et, Er)
% plot(Et, Ez); 
% hold off; % 斜面
% xlabel("X [m]"); ylabel("Z [m]"); 
% position
% 1:リファレンス, 

% figure(1)
% Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
% sgtitle(Title);
% subplot(m,n,1); plot(logt, Edata); hold on; plot(logt, Rdata(1:3, :), '--'); hold off;
% xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference");
% grid on; xlim([0 xmax]); ylim([-inf inf]);
% % title("Time change of Position"); 
% % atiitude 0.2915 rad = 16.69 deg
% subplot(m,n,2); plot(logt, Qdata); hold on; plot(logt, Rdata(4:6, :), '--'); hold off;
% xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference");
% grid on; xlim([0 xmax]); ylim([-0.5 0.5]);
% % title("Time change of Atiitude");
% % velocity
% subplot(m,n,3); plot(logt, Vdata); hold on; plot(logt, Rdata(7:9, :), '--'); hold off;
% xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref");
% grid on; xlim([0 xmax]); ylim([-inf inf]);
% % title("Time change of Velocity"); 
% % input
% subplot(m,n,6); 
% % plot(logt, Idata); 
% plot(logt, Idata, "--", "LineWidth", 1); 
% xlabel("Time [s]"); ylabel("Input"); legend("input1", "input2", "input3", "input4");
% grid on; xlim([0 xmax]); ylim([-inf inf]);
% % % title("Time change of Input");
% subplot(m,n,5); % 仮想入力
% plot(logt, IV); legend("Z", "X", "Y", "YAW");
% xlabel("Time [s]"); ylabel("input.V");
% grid on; xlim([0 xmax]); ylim([-inf inf]);
% % calculation time
% subplot(m, n, 4);
% plot(logt, data.calT(1:size(logger.data('t',[],[]),1))); hold on;
% plot(logt, totalT/(te/dt)*ones(size(logt,1),1), '--', 'LineWidth', 2); hold off;
% 
% xlim([0 te])
% set(gca,'FontSize',Fontsize);  grid on; title("");
% xlabel("Time [s]");
% ylabel("Calculation time [s]");
% 
% set(gcf, "WindowState", "maximized");
% set(gcf, "Position", [960 0 960 1000])
Zpos = Edata(3,:) - (3/10 .* Edata(1,:) + 0.1) ;

figure(20);
subplot(3,2,1)
plot(logt, data.eachcost(1,1:end-1)); grid on;%hold on; plot(logt, data.eachcost(4,end-1)); hold off; 
yyaxis right
plot(logt, Edata, 'Color', 'green'); hold on; plot(logt, Rdata(1:3, :), '--');  hold off; ylabel("ref pos"); 
title('position eval'); xlim([0.25 xmax]); ylim([-inf, inf]);
legend("Peval","Ex","Ey","Ez","Rx","Ry","Rz")
subplot(3,2,3)
plot(logt, data.eachcost(2,1:end-1)); %hold on; plot(logt, data.eachcost(4,end-1)); hold off;
yyaxis right
plot(logt, Vdata, 'Color', 'green'); hold on; plot(logt, Rdata(7:9, :), '--');  hold off; ylabel("ref vel"); grid on;
title('velocity eval'); xlim([0.25 xmax]); ylim([-inf, inf]);
legend("Veval","Ex","Ey","Ez","Rx","Ry","Rz", 'Location', 'northwest')
subplot(3,2,2)
plot(logt, data.eachcost(3,1:end-1)); grid on;%hold on; plot(logt, data.eachcost(4,end-1)); hold off; ylim([-inf inf])
yyaxis right
plot(logt, Qdata, 'Color', 'magenta'); hold on; plot(logt, Rdata(4:6, :), '--');  hold off; ylabel("ref atti"); grid on;
title('angular eval'); xlim([0.25 xmax]); ylim([-inf inf])
legend("QWeval","Eroll","Epitch","Eyaw","Rroll","Rpitch","Ryaw")
subplot(3,2,4);
plot(logt, data.eachcost(:, 1:end-1)); grid on;
% yyaxis right
% plot(logt, data.Zsoft(1:end-1));
legend("Peval", "Veval", "Qeval", "Terminal");
% legend("Zweight");
subplot(3,2,5);
plot(logt, Zpos); grid on; xlabel("Time [s]"); ylabel("slope alt"); xlim([0 xmax])

set(gcf, "WindowState", "maximized");
% plot(logt, Idata); ylabel("ref input")
% title('velocity eval'); xlim([0.25 xmax]); ylim([-inf, inf]);
% legend("input1", "input2", "input3", "input4")
% strP = ['$$P$$= ','[',num2str(data.param.P(1,1),'%d'), ' ',num2str(data.param.P(2,2),'%d'), ' ',num2str(data.param.P(3,3),'%d'),']'];
% strV = ['$$V$$= ','[',num2str(data.param.V(1,1),'%d'), ' ',num2str(data.param.V(2,2),'%d'), ' ',num2str(data.param.V(3,3),'%d'),']'];
% strQ = ['$$Q$$= ','[',num2str(data.param.QW(1,1),'%d'), ' ',num2str(data.param.QW(2,2),'%d'), ' ',num2str(data.param.QW(3,3),'%d'),']'];
% strW = ['$$W$$= ','[',num2str(data.param.QW(4,4),'%d'), ' ',num2str(data.param.QW(5,5),'%d'), ' ',num2str(data.param.QW(6,6),'%d'),']'];
% text(0.1,0.9,strP,'FontSize',15,'Interpreter', 'Latex')
% text(0.1,0.7,strV,'FontSize',15,'Interpreter', 'Latex')
% text(0.1,0.5,strQ,'FontSize',15,'Interpreter', 'Latex')
% text(0.1,0.3,strW,'FontSize',15,'Interpreter', 'Latex')
% set(gcf, "Position", [1000 0 960 1000])
%% 
close all;
agent(1).animation(logger,"target",1); 
%% 各評価値

%%
% figure(5); 
% ref_t = agent.reference.timeVarying.func;
% ref_time = 0:0.025:te;
% for i = 1:te/dt
%     ref_t_value(i,:) = ref_t(ref_time(i));
% endf
% plot(logt, ref_t_value(:,11));
% xlim([0 te]); ylim([-inf inf]); xlabel("Time [s]"); ylabel("Acc.Z [m/s^2]");
%%
% syms t_plot real
% z = 1/2 * sin(2*t_plot)+1;
% ddz = diff(z, t_plot, 2);
% plot(logt, subs(ddz, t_plot, logt));
% xlim([0 te]); ylim([-inf inf]);
%%
% 仮想入力
% if ~isempty(data.input_v)
% figure(7); plot(logt, IV); legend("input1", "input2", "input3", "input4");
% xlabel("Time [s]"); ylabel("input.V");
% grid on; xlim([0 xmax]); ylim([-inf inf]);
% % saveas(5, "../../Komatsu/MCMPC/InputV", "png");
% end

%% save data
data_now = datestr(datetime('now'), 'yyyymmdd');
Title = strcat(['SlopeLanding-posWeight-sigma-each', '-N'], num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
Outputdir = strcat('../../students/komatsu/simdata/', data_now, '/');
if exist(Outputdir) ~= 7
    mkdir ../../students/komatsu/simdata/20230731/
end
% save(strcat('/home/student/Documents/students/komatsu/simdata/',data_now, '/', Title, ".mat"), "agent","data","initial","logger","Params","totalT", "time", "-v7.3")
% save(strcat('C:/Users/student/Documents/students/komatsu/simdata/',data_now, '/', Title, ".mat"), "agent","data","initial","logger","Params","totalT", "time", "-v7.3")
% Video Only
% save(strcat('C:/Users/student/Documents/students/komatsu/simdata/',data_now, '/', Title, "-forVIDEO", ".mat"), "logger", "-v7.3");
%% 加速度
% figure(21)
% V1 = Rdata(9, 1:end-1);
% V2 = Rdata(9, 2:end);
% A1 = Edata(3, 1:end-1);
% A2 = Edata(3, 2:end);
% for i = 1:length(V1)
%     accR(i) = (V2(i)-V1(i))/0.025;
%     accE(i) = (A2(i)-A1(i))/0.025;
% end
% plot(logt(1:end-1,1), accR, "--"); hold on
% plot(logt(1:end-1,1), accE); hold off; title("Accelaration"); ylim([-inf inf]); xlim([0 time.t])
% 
% E = round(time.t/dt)-1;
% V1 = Rdata(9, 1:E-1);
% V2 = Rdata(9, 2:E);
% A1 = Edata(3, 1:E-1);
% A2 = Edata(3, 2:E);
% for i = 1:length(V1)
%     accR(i) = (V2(i)-V1(i))/0.025;
%     accE(i) = (A2(i)-A1(i))/0.025;
% end
% plot(logt(1:E-1,1), accR, "--"); hold on
% plot(logt(1:E-1,1), accE); hold off; title("Accelaration"); ylim([-inf inf]); xlim([0 time.t])

%%
% figure(20)
% IHL = load("Data/HL_input");
% plot(logt(1:end), IHL(1, :))
%% Difference of Pos
% figure(7);
% plot(logger.data('t', [], [])', Diff, 'LineWidth', 2);
% legend("$$x_\mathrm{diff}$$", "$$y_\mathrm{diff}$$", "$$z_\mathrm{diff}$$", 'Interpreter', 'latex', 'Location', 'southeast');
% set(gca,'FontSize',15);  grid on; title(""); ylabel("Difference of Pos [m]"); xlabel("time [s]"); xlim([0 10])

%% Remove sample and Sigma
% logt = logger.data('t',[],[]);
% figure(10)
% plot(logger.data('t',[],[]), SigmaData(:,1:size(logger.data('t',[],[]),1))); ylabel("sigma");
% % plot(logger.data('t',[],[]), Bestcost(1,1:size(logt,1))); ylabel("Bestcost");
% % yyaxis right
% % plot(logger.data('t',[],[]), data.removeF(1:size(logger.data('t',[],[]),1))); ylabel("rejected")
% xlim([0 xmax]); ylim([0 max(agent.controller.mcmpc.param.input.Maxsigma)]);
% legend("Z", "X", "Y", "YAW")
% set(gca,'FontSize',Fontsize);  grid on; title("");

%% particle_num
% figure(12)
% plot(logt, data.variable_particle_num(1:size(logt,1)), 'LineWidth', 1.5);
% xlim([0 te])
% xlabel("Time [s]"); ylabel("Number of Sample");
% set(gca,'FontSize',Fontsize);  grid on; title("");
% ylim([0 data.param.Maxparticle_num])
%%
% figure(13)
% SF = data.param.particle_num - data.removeF(1:size(logger.data('t',[],[]),1));
% F = [data.removeF(1:size(logger.data('t',[],[]),1))'; SF'];
% area(F)
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
% pathJ = data.pathJ;
% for m = 1:size(pathJ, 2)
%     pathJN{m} = normalize(pathJ{m},'range', [1, data.variable_particle_num(m)]);
% end
% rmdir ('C:/Users/student/Documents/students/komatsu/simdata/20230524/Animation/','s'); % 直前のシミュレーションより短くする場合
% mkdir C:/Users/student/Documents/students/komatsu/simdata/20230524/Animation/;
% Outputdir_mov = 'C:/Users/student/Documents/students/komatsu/simdata/20230524/Animation/';
% PlotMov
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

%% animation
% pause();

%%
% logger.save();