function result = statistic_summary(Logger)
% 消失セル数の算出
clear xi
for xi = 1:length(Logger)
    kre = size(Logger(xi).I);
    kre = kre(1,2);  %シミュレーションの最終ステップ数
    tmpS2 = 0;
    tmpI2 = 0;
    tmpR2 = 0;
    I2.I = logical (Logger(xi).I);
    for i = 1:kre
%         if kre > 200
%             kre = 200;
%         end
        tmpS2(i)=sum(Logger(xi).S(:,i)); %logger(i)内にあるRの200s時(ke)の値の合計
        tmpI2(i)=sum(I2.I(:,i)); %logger(i)内にあるRの200s時(ke)の値の合計
        tmpR2(i)=sum(Logger(xi).R(:,i)); %logger(i)内にあるRの200s時(ke)の値の合計
    end
    final_step(xi,1) = kre;
    damage_all(xi,1) = tmpR2(kre)+tmpI2(kre);
%     figure('Position', [0 -500 1100 1000]);
%     md = map.draw_state(nx,ny,map.loggerk(Logger(xi),final_step(xi)));
end
damage_ave = round(mean(damage_all))
result.damage_ave = damage_ave;
result.damage_all = damage_all;
end