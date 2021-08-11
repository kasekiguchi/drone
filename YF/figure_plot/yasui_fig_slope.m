function yasui_fig_slope(agent)
%% 位置の描画，第二引数には区間を指定，なければ０
           figure(2)
           N = length(agent);
             %%定点
            xmin = -1;
            ymin = -5;
            xmax = 10;
            ymax = 15;
            %群れを追う
            plot(agent(1).env.huma_load.param.spone_area,'FaceAlpha',0);

            hold on;
           for i=1:length(agent)
               num = num2str(i);
               if i>N/2
                   plot(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),'x:m')
                   text(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),num,'Fontsize',14)
                  plot(agent(i).reference.result.ref_point(1),agent(i).reference.result.ref_point(2),'O:k')
                   text(agent(i).reference.result.ref_point(1),agent(i).reference.result.ref_point(2),num,'Fontsize',14)

%                    quiver(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),agent(1, i).reference.result.state.u(1)*10,agent(1, i).reference.result.state.u(2)*10,'LineWidth',2,'MarkerSize',10)
               else
                   plot(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),'^:m')
                   text(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),num,'Fontsize',14)
                  plot(agent(i).reference.result.ref_point(1),agent(i).reference.result.ref_point(2),'O:k')
                   text(agent(i).reference.result.ref_point(1),agent(i).reference.result.ref_point(2),num,'Fontsize',14)

%                    quiver(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),agent(1, i).reference.result.state.u(1)*10,agent(1, i).reference.result.state.u(2)*10,'LineWidth',2,'MarkerSize',10)

               end
           end
           xlim([xmin xmax]);ylim([ymin ymax]);
% xlim([-15 15]);ylim([-15 15]);
           ax = gca;
           ax.FontSize = 18;
            xlabel('x [m]','FontName','Times New Roman','FontSize',24)
            ylabel('y  [m]','FontName','Times New Roman','FontSize',24)
           grid on;hold off;
%            pause(0.5)
end

