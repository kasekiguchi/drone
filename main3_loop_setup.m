%% set timer
time = TIME();
time.t = ts;

% 引数に取れるのは以下のみ
% time, motive, FH　や定数　などグローバル情報
% agent 自体はagentの各プロパティ内でselfとしてhandleを保持しているのでdo methodに引数として渡す必要は無い．

%profile on
disp("while ============================")
close all;

if fExp && ~fMotive
    fprintf(2, "Warning : input will send to drone\n");
end

disp('Press Enter key to start.');
if ~fDebug | fExp
    FH = figure('position', [0 0 eps eps], 'menubar', 'none');
else
    FH = figure('WindowState','maximized');
end

w = waitforbuttonpress;

if (fOffline)
    logger.overwrite("model", time.t, agent, i);
    te = logger.Data.t(logger.k);
    offline_time = 1;
end
