function yasui_fig_human(agent,Nh)
%% 位置の描画，第二引数には区間を指定，なければ０
figure(2)
N = length(agent);
%%定点
Feald = agent(1).env.huma_load.param.poly.Vertices;
xmin = min(Feald(:,1))-1;
ymin = min(Feald(:,2))-1;
xmax = max(Feald(:,1))+1;
ymax = max(Feald(:,2))+1;

%群れを追う
plot(agent(1).env.huma_load.param.poly,'FaceAlpha',0);

hold on;
for i=1:length(agent)
    num = num2str(i);
    %                if i>N/2
    plot(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),'x:m')
    text(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),num,'Fontsize',14)
    if i<=Nh
        plot(agent(i).reference.result.ref_point(1),agent(i).reference.result.ref_point(2),'O:k')
        text(agent(i).reference.result.ref_point(1),agent(i).reference.result.ref_point(2),num,'Fontsize',14)
%                            plot(agent(i).reference.result.View_range,'FaceAlpha',0.2)

    end
    %                else
    %                    plot(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),'^:m')
    %                    text(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),num,'Fontsize',14)
    %                   plot(agent(i).reference.result.ref_point(1),agent(i).reference.result.ref_point(2),'O:k')
    %                    text(agent(i).reference.result.ref_point(1),agent(i).reference.result.ref_point(2),num,'Fontsize',14)
    %
    %
    %                end
    
end
xlim([xmin xmax]);ylim([ymin ymax]);
ax = gca;
ax.FontSize = 18;
xlabel('x [m]','FontName','Times New Roman','FontSize',24)
ylabel('y  [m]','FontName','Times New Roman','FontSize',24)
grid on;hold off;
%            pause(0.5)
end

