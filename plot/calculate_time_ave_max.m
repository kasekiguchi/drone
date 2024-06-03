ave=mean(gui.time.keisoku_Time(4:end));
saidai=max(gui.time.keisoku_Time(4:end));
[max_value, max_index] = max(gui.time.keisoku_Time(4:end));

% 最大値の位置を計算
[row, col] = ind2sub(size(gui.time.keisoku_Time), max_index);
col=col+3;
fprintf("平均=%f",ave)
fprintf("最大=%f",saidai)
fprintf("最大位置=%d",col)