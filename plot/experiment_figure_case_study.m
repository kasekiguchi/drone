%%% 実機実験の結果をplotするファイル
if exist('logger') == 1 % modeファイルから実行した
    filename = strcat(string(datetime('now'), 'yyyy-MM-dd'));
    log = logger;
elseif exist('app') == 1 % guiあり：drawgraphから実行した
    filename = strcat(string(datetime('now'), 'yyyy-MM-dd'));
    log = app.logger;
elseif exist('gui') == 1 % gui実行時にguiを閉じてしまったとき
    filename = strcat(string(datetime('now'), 'yyyy-MM-dd'));
    log = gui.logger;
    % ココは実行できないかも
else % 読み込んだmatファイルからplotする
    %% path通す & 初期化
    clear;
    tmp = matlab.desktop.editor.getActive;
    cd(strcat(fileparts(tmp.Filename), '../../'));
    [~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
    cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);

    %%
    clear;
    disp("Loading data...");
    filename = 'experiment_9_5_saddle_estimatordata'; %
    log = LOGGER(strcat(filename, '.mat')); % loggerの形で収納できる
    
    %phaseの構成
    % 115:start
    % 97 :arming
    % 116:takeoff q no data
    % 102:flight
    % 108:landing
    % 0:stop or quit
    %~~ -> 文字コード 's'=115, 'f'=102
end
Fontsize = 15;  
set(0,'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);
%%
close all
clear Ref
flg.figtype = 0; % 0:subplot/1:figure
flg.timerange = 1; % 0:実際の時間/1:0から
flg.plotmode = 0; % 0:デフォルトの描画/1:innner_input, xy, xyzを追加
phase = 2; % 1:flight, 2:all

switch phase
    case 1
        start_idx = find(log.Data.phase==102,1,'first');
        finish_idx = find(log.Data.phase==102,1,'last')-1;
    case 2
        start_idx = 1;
        finish_idx = find(log.Data.phase==0,1,'first')-1;
        takeoff_idx.start = find(log.Data.phase==116,1,'first');
        takeoff_idx.finish = find(log.Data.phase==116,1,'last');
end

logt = log.data(0,"t",[],"ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])';
calt = logt;

% setting time-range. flg.timerange == 1なら 0 ~ flight時間に変更
if flg.timerange; logt = logt - logt(1); end
if flg.plotmode == 0; m=2; n=3; else; m=3; n=3; end

% 状態，目標値，入力の読み込み
disp('Storing data...');
Est = [log.data(1,"p","e","ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])';
        log.data(1,"q","e","ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])';
        log.data(1,"v","e","ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])';
        log.data(1,"w","e","ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])'];
Input = log.data(1,"input",[],"ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])';
Ref = [log.data(1,"p","r","ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])';
    zeros(size(Est(1:3,:)));
    log.data(1,"v","r","ranget",[log.Data.t(start_idx), log.Data.t(finish_idx)])'];
%%
disp('Plotting start...');
if flg.figtype; figure(1); else; subplot(m,n,1); sgtitle(strcat(strrep(filename,'_','-')));end
plot(logt, Est(1:3,:)); hold on; plot(logt, Ref(1:3, :), '--'); hold off;
background_color(phase, -0.1, gca, logt, log.Data.phase); 
xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","best");
grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);

if flg.figtype; figure(2); else; subplot(m,n,2); end
plot(logt, Est(4:6,:)); hold on; plot(logt, Ref(4:6, :), '--'); hold off;
background_color(phase, -0.1, gca, logt, log.Data.phase); 
xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","best");
grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);

if flg.figtype; figure(3); else; subplot(m,n,3); end
plot(logt, Est(7:9,:)); hold on; plot(logt, Ref(7:9, :), '--'); hold off;
background_color(phase, -0.1, gca, logt, log.Data.phase); 
xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.reference", "vy.reference", "vz.reference", "Location","best");
grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);

if flg.figtype; figure(4); else; subplot(m,n,4); end
plot(logt, Input(1,:), "LineWidth", 1.5);
background_color(phase, -0.1, gca, logt, log.Data.phase); 
xlabel("Time [s]"); ylabel("Input (Thrust)[N]"); legend("thrust.total","Location","best");
grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
ytickformat('%.1f');

if flg.figtype; figure(5); else; subplot(m,n,5); end
plot(logt, Input(2:4,:), "LineWidth", 1.5);
background_color(phase, -0.1, gca, logt, log.Data.phase); 
xlabel("Time [s]"); ylabel("Input (Torque)[N]"); legend("torque.roll", "torque.pitch", "torque.yaw","Location","best");
grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);
ytickformat('%.3f');

if flg.figtype; figure(6); else; subplot(m,n,6); end
% calculation time
plot(logt(1:end-1), diff(calt), 'LineWidth', 1.5);
background_color(phase, -0.1, gca, logt, log.Data.phase); 
yline(0.025, 'Color', 'red', 'LineWidth', 1.5); hold off;
ytickformat('%.1f');

if m*n > 6
plotrange = 2;
subplot(m,n,7);
InnerInput = cell2mat(arrayfun(@(N) log.Data.agent.inner_input{N}(:,1:4)',start_idx:finish_idx,'UniformOutput',false));
plot(logt, InnerInput); 
background_color(phase, -0.1, gca, logt, log.Data.phase); 
xlabel("Time [s]"); ylabel("Inner input"); legend("inner_input.roll", "inner_input.pitch", "inner_input.throttle", "inner_input.yaw","Location","best");
grid on; xlim([logt(1), logt(end)]); ylim([-inf inf]);

subplot(m,n,8);
plot(Est(1,:), Est(2,:)); hold on; plot(Est(1,1), Est(2,1), '*', 'MarkerSize', 10); plot(Est(1,end), Est(2,end), '*', 'MarkerSize', 10); hold off;
xlabel('$$x$$', 'Interpreter', 'latex'); ylabel('$$y$$', 'Interpreter', 'latex');
legend('trajectory', 'start.pos', 'finish.pos', 'Location', 'best');
grid on; xlim([-plotrange plotrange]); ylim([-plotrange plotrange]);

subplot(m,n,9);
plot3(Est(1,:), Est(2,:), Est(3,:)); hold on; plot3(Est(1,1), Est(2,1), Est(3,1), '*', 'MarkerSize', 10); plot3(Est(1,end), Est(2,end), Est(3,end), '*', 'MarkerSize', 10); hold off;
xlabel('$$x$$', 'Interpreter', 'latex'); ylabel('$$y$$', 'Interpreter', 'latex'); zlabel('$$z$$', 'Interpreter', 'latex');
legend('trajectory', 'start.pos', 'finish.pos', 'Location', 'best');
grid on; xlim([-plotrange plotrange]); ylim([-plotrange plotrange]); zlim([0 inf]);
end


%
if ~flg.figtype % subplotなら
    set(gcf, "WindowState", "maximized");
    set(gcf, "Position", [960 0 960 1000])
end

%% function 
function background_color(phase, yoffset, gca, logt, logphase)
    % phaseごとに色付けをする
    % LOGGER.plot：LOGGERクラスのメソッドであるplot()から抽出
    txt = {''};
    font_size = 10;
    % yoffset = -0.1;
    switch phase
        case 1 %flight
            % Square_coloring(log.Data.t([find(log.Data.phase == 102, 1), find(log.Data.phase == 102, 1, 'last')]), [0.9 1.0 1.0],[],[],gca); % flight phase
            Square_coloring([logt(1);logt(end)], [0.9 1.0 1.0],[],[],gca); % flight phase
            txt = [txt(:)', {'{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'}];
        case 2 %all time
            Square_coloring(logt([find(logphase == 116, 1), find(logphase == 116, 1, 'last')]),[],[],[],gca); 
            txt = [txt(:)', {'{\color[rgb]{1.0,1.0,0.9}■} :Take off phase'}]; % take off phase
            Square_coloring(logt([find(logphase == 102, 1), find(logphase == 102, 1, 'last')]), [0.9 1.0 1.0],[],[],gca);
            txt = [txt(:)', {'{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'}];   % flight phase
            Square_coloring(logt([find(logphase == 108, 1), find(logphase == 108, 1, 'last')]), [1.0 0.9 1.0],[],[],gca); 
            txt = [txt(:)', {'{\color[rgb]{1.0,0.9,1.0}■} :Landing phase'}];  % landing phase
        otherwise
    end
    text(gca().XLim(2) - (gca().XLim(2) - gca().XLim(1)) * 0.45, gca().YLim(2) + (gca().YLim(2) - gca().YLim(1)) * yoffset, txt, 'FontSize', font_size);
    xlabel("Time [s]"); ylabel("Calculation time [s]"); xlim([0 logt(end-1)])
end