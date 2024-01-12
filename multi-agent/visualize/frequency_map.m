function frequency_map(Logger)
% 
% 重み合計
% 事前必用準備：plot 2の実行
clear xi kre
InitExting = 20;    % 初期消火が成功した場合の足切り
BurnResult = 0; BurnResult2 = 0; BurnResultw = 0; BurnResult2w = 0;
for xi = 1:kn
    clear Rsigma
    Rsigma = Logger(xi).R;
    for sumW = 1:final_step(xi)-1
        Rsigma(:,1) = [];
    end
    if size(Logger(xi).R,2) >= InitExting
        BurnResultw =  BurnResultw + reshape((Rsigma),[nx,ny]);
    end
    BurnResult =  BurnResult + reshape((Rsigma),[nx,ny]);
end

clear xi kre i j
for xi = 1:kn
    clear Isigma Isigma2
    Isigma = logical(Logger(xi).I);
    for sumW = 1:final_step(xi)-1
        Isigma(:,1) = [];
    end
    if size(Logger(xi).I,2) >= InitExting
        BurnResult2w =  BurnResult2w + reshape((Isigma),[nx,ny]);
    end
    BurnResult2 =  BurnResult2 + reshape((Isigma),[nx,ny]);
end

BR0 = BurnResult + BurnResult2;
for i = 1:size(BR0,1)
    for j = 1:size(BR0,2)
        if BR0(i,j) == 0
                BR0(i,j) = BR0(i,j) - kn/5;
        end
    end
end

BR = BurnResultw + BurnResult2w;
max(BR,[],"all")
for i = 1:size(BR,1)
    for j = 1:size(BR,2)
        if BR(i,j) == 0
            BR(i,j) = BR(i,j) - kn/5;
        elseif BR(i,j) <= 0    % 特定の頻度以下を省く場合にON
            BR(i,j) = 0 - kn/5;
        end
    end
end

% figure('Position', [0 -500 1100 1000]);
% map.draw_state(nx,ny,BurnResult)
% figure('Position', [0 -500 1100 1000]);
% map.draw_state(nx,ny,BR0)
figure('Position', [0 -500 1100 1000]);
hold on
map.draw_state(nx,ny,BR)

c = colorbar;
c.TicksMode = "manual";
w = c.Ticks;
k = 10;
c.Ticks(1,1) = 1;
for i = 2:kn/k
    c.Ticks(1,i) = k * (i-1);
end

hold off

end