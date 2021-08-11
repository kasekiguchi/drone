%plot V
close all;clc;
i =1;
Col = ['k','r','m','b','g','c'];
span = 5;%秒数\
Time = length(yasui.save.agent{i}.v);
dt = yasui.dt;
figure(1);
plot(yasui.save.agent{i}.v(1,:))
hold on
plot(yasui.save.agent{i}.v(2,:))
hold off;
for t =1:Time
    V_norm(t) = norm(yasui.save.agent{i}.v(:,t));
end
figure(2);
plot(V_norm,'linewidth',2,'color','k','displayname','Velocity')
hold on
plot(yasui.save.agent{i}.optimalV(:),'linewidth',2,'color','r','displayname','Optimal Velocity')  
xlim([1 Time])
ylim([0 max(V_norm)+.1])
xticks([span:span*10:Time]);
xticklabels(0:span:Time*dt);
grid on
xlabel('{\it T} [s]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')
ylabel('Verocity','FontName','Times New Roman','FontSize',18)
ax = gca;
ax.FontSize = 24;
leg = legend;
leg.FontSize = 18;
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg
cd 'C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\論文用\fig'

