function dataplot_PtoP(logger)
grid on
hold on
heart = cell2mat(logger.Data.agent(:,3)'); % reference.result.state.p
fig1 = plot(heart(1,:),heart(2,:)); % xy平面の軌道を描く
heart_result = cell2mat(logger.Data.agent(:,8)'); % reference.result.state.p
fig2 = plot(heart_result(1,:),heart_result(2,:)); % xy平面の軌道を描く
xlabel('{\itx} [m]')
ylabel('{\ity} [m]')
set(gca,'FontName','Times New Roman')
set(gca,'FontSize',18)
set(fig1,'LineWidth',3)
set(fig2,'LineWidth',3)
legend({'Reference','UAV'})
end

