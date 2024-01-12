function flying_fire_statistic(Logger)
% 飛び火の数を計測
% Logger(i).UFで(飛び火したグリッド,何ステップ目)が分かる
% [Q,R] = quorem(sym(7589),sym(130)) でQに商，Rに余り  座標(x, y) = (Q + 1, R)
% InitExting 初期消火が成功した場合の足切り
clear i xi flyP flyP1 flyP2
xi = 1; InitExting = 20;
for i = 1:kn
    flyP(i) = nnz(Logger(i).UF);
    flyP1(i,1) = flyP(i);
    if size(Logger(i).R,2) >= InitExting
        flyP2(xi,1) = flyP(i);
        flyP2(xi,2) = i;
        xi = xi + 1;
    end
end
flyPave = mean(flyP2(:,1))

figure('Position', [0 -500 1100 1000]);
hold on
% yline(flyPave,'-r','LineWidth',3)
bar(damage_all,'FaceColor',"#EDB120");
colororder({'k'})
yyaxis right
plot(flyP,"red",'LineWidth',1.5);
hold off
end