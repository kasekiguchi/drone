figure(1)
subplot(2,1,1);
p1 = plot(simResult.T , simResult.Xhat(1:3,:),'LineWidth',2);
hold on
grid on
ylabel('Estimated Data','FontSize',12);
legend('x','y','z','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off
subplot(2,1,2);
p2 = plot(Data.T,Data.X(1:3,:),'LineWidth',2);
hold on
grid on
xlabel('time [sec]','FontSize',12);
ylabel('Original Data','FontSize',12);
legend('x','y','z','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off

figure(2)
subplot(2,1,1);
p1 = plot(simResult.T(1:200) , simResult.Xhat(1:3,1:200),'LineWidth',2);
hold on
grid on
ylabel('Estimated Data','FontSize',12);
legend('x','y','z','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off
subplot(2,1,2);
p2 = plot(Data.T(1:200),Data.X(1:3,1:200),'LineWidth',2);
hold on
grid on
xlabel('time [sec]','FontSize',12);
ylabel('Original Data','FontSize',12);
legend('x','y','z','FontSize',18,'Location','bestoutside');
set(gca,'FontSize',14);
hold off