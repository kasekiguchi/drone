%% %figure出力
figure(2)
hold on
plot(T,current)%グラフのプロット
% ymax = ylim;
% area([Ts Ts_end],[ymax(2) ymax(2)],FaceColor = "red",LineStyle = "none",Facealpha = 0.1);
legend('morter 1','morter 2','morter 3','morter 4')
legend('Location','best')
xlabel('time [s]')
ylabel('current')
hold off

figure(3)
hold on
plot(T,voltage)%グラフのプロット
% ymax = ylim;
% area([Ts Ts_end],[3000 3000],FaceColor = "red",LineStyle = "none",Facealpha = 0.1);
legend('morter 1','morter 2','morter 3','morter 4')
legend('Location','best')
xlabel('time [s]')
ylabel('voltage')
hold off

figure(4)
hold on
plot(T,rpm,'LineWidth',1)%グラフのプロット
% plot(T,X4,'LineWidth',1)%グラフのプロット
%plot(T,X3Ave,'LineWidth',1)
% ymax = ylim;
% area([Ts Ts_end],[ymax(2) ymax(2)],FaceColor = "red",LineStyle = "none",Facealpha = 0.1);
legend('morter 1','morter 2','morter 3','morter 4','distance ceiling')%,'average')
legend('Location','best')
xlabel('time [s]')
ylabel('morter speed [rpm]')
hold off

figure(5)
hold on
plot(T,power)%グラフのプロット
legend('morter 1','morter 2','morter 3','morter 4')
legend('Location','best')
xlabel('time [s]')
ylabel('power')
hold off
