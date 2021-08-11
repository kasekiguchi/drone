



xlabel('{\it x} [m]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')
ylabel('{\it y} [m]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')
all = 0;
ax = gca;
ax.FontSize = 24;



fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg

cd 'C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\論文用\fig'