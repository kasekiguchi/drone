function R_response_MC(Logger,kn)
% R遷移の総数
figure('Position', [0 -500 1100 1000]);
hold on 
clear xi kre
for xi = 1:kn
    kre = size(Logger(xi).I);
    kre = kre(1,2);  %シミュレーションの最終ステップ数
    tmpR4 = 0;
    I2.I = logical (Logger(xi).I);
    for i = 1:kre
        tmpR4(i)=sum(Logger(xi).R(:,i)); %logger(i)内にあるRの200s時(ke)の値の合計
    end
    plot(1:kre,tmpR4,'-r','LineWidth',2);
%     md = map.draw_state(nx,ny,map.loggerk(Logger(xi),final_step(xi)));

end
Ftime = [10 25 35 70 85 100 120 200];
Fdame = [30 70 140 720 900 1105 1413 1841];
% Fpf = polyfit(Ftime,Fdame,4);
% x2 = 0:.1:200;
% y2 = polyval(Fpf,x2);
plot(Ftime,Fdame,'o','MarkerSize',10,'MarkerEdgeColor','b','LineWidth',2);
xlabel('\sl Time step k','FontSize',20);
ylabel('\sl Number','FontSize',20);
set(gca,'FontSize',10);
ax = gca;
ax.Box = 'on';
xlim([0 200]);
ylim([0 3000]);
hold off
end