function fig_plot_state(agent,fp,N,Nb)
%%
           figure(2)
%            point = dist_plot(agent(N).reference.result.CoG,cog_state.P,fp);
            baffa = 50;
            farea = 5;
            farmx = fp(1);
            farmy = fp(2);
             %%定点
            xmin = fp(1)-baffa;
            ymin = fp(2)-baffa;
            xmax = fp(1)+baffa;
            ymax = fp(2)+baffa;
            %群れを追う
%             xmin = agent(length(agent)).reference.result.CoG(1)-5;
%             ymin = agent(length(agent)).reference.result.CoG(2)-5;
%             xmax = agent(length(agent)).reference.result.CoG(1)+5;
%             ymax = agent(length(agent)).reference.result.CoG(2)+5;
            x = [farmx+farea farmx+farea farmx-farea farmx-farea];
            y = [farmy-farea farmy+farea farmy+farea farmy-farea];
%             contour(point');
%             hold on
            fill(x,y,'r','FaceAlpha',.2,'EdgeAlpha',.2)
            hold on;  
%             agent(N).reference.result.tmp3
           for i=1:length(agent)
               num = num2str(i);
               if i>Nb
                   plot(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),'x:k')
                   plot(agent(i).reference.result.state.p(1),agent(i).reference.result.state.p(2),'o:k')
                   
%                    quiver(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),agent(i).reference.result.state.u(1)*2,agent(i).reference.result.state.u(2)*2,'LineWidth',2,'MarkerSize',10)
               else
                   if agent(N).reference.result.tmp1(i)==1
                        plot(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),'^:m')
                   elseif agent(N).reference.result.tmp1(i)==2
                        plot(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),'^:b')
                   else
                       plot(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),'^:r')
                   end

%                    quiver(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),agent(i).reference.result.state.u(1)*2,agent(i).reference.result.state.u(2)*2,'LineWidth',2,'MarkerSize',10)

               end
%                if i == Nb
%                   plot(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),'x:r')
% 
%                end
                   text(agent(i).estimator.result.state.p(1),agent(i).estimator.result.state.p(2),num,'Fontsize',14)

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

