%%
%正常に保存できた時 
ave=mean(gui.time.keisoku_Time(4:end));

saidai=max(gui.time.keisoku_Time(4:end));
[max_value, max_index] = max(gui.time.keisoku_Time(4:end));
%%
% %GUI落ちたとき
% fads=diff(log.Data.t(1000:3600))
% ave=mean(fads);
% 
% saidai=max(diff(log.Data.t(1000:3600)));
% [max_value, max_index] = max(diff(log.Data.t(1000:3600)));
%%
% 最大値の位置を計算
[row, col] = ind2sub(size(diff(log.Data.t(4:end))), max_index);
col=col+3;
fprintf("平均=%f",ave)
fprintf("最大=%f",saidai)
fprintf("最大位置=%d",col)