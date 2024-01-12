function total_damage(result)
% 総被害グリッド数を計測
clear i xi

figure('Position', [0 -500 1100 1000]);
hold on
yline(result.damage_ave,'-r','LineWidth',3)
bar(result.damage_all);
hold off
end