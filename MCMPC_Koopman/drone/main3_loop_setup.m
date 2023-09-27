%% set timer
time = TIME();
time.t = ts;

% 引数に取れるのは以下のみ
% time, motive, FH　や定数　などグローバル情報
% agent 自体はagentの各プロパティ内でselfとしてhandleを保持しているのでdo methodに引数として渡す必要は無い．

% % for simulation
% mparam.occlusion.cond=["time.t >=1.5 && time.t<1.6","agent(1).model.state.p(1) > 2"];
% mparam.occlusion.target={[1],[1]};
% mparam.marker_num = 20;
mparam = [];    % without occulusion

%profile on
disp("while ============================")
close all;

if fExp && ~fMotive
    fprintf(2, "Warning : input will send to drone\n");
end

disp('Press Enter key to start.');
FH = figure('position', [0 0 eps eps], 'menubar', 'none');

% w = waitforbuttonpress; %キーボードを押すと開始する

if (fOffline)
    expdata.overwrite("model", time.t, agent, i);
    te = expdata.te;
    offline_time = 1;
end
