%%ここでは位置から速度の推定を行う．
close all;
clear v;
%%
N= length(yasui.save.agent);
v = cell(N,1);
for hh = 1:N-2
    for i = 2:yasui.main_roop_count-1  
        vvv = norm((yasui.save.agent{1, hh}.state(1:2,i-1)-yasui.save.agent{1, hh}.state(1:2,i))/yasui.dt)
%         if vvv>10
%             vvv = 0;
%         end
        v{hh}(:,i) = [vvv;yasui.save.agent{1, hh}.state(1:2,i-1)-yasui.save.agent{1, hh}.state(1:2,i)];
    end
end


hold on;
for i=1:1
    plot(v{i,1}(1,:))
end
grid on
    span = 5;%秒数
    % temp =dis_birds.YData;
    xlim([1 length(v{i,1}(1,:))])

    ylim([0 max(v{i,1}(1,:))+.5])

    xticks([span:span*10:length(v{i,1}(1,:))]);
    xticklabels(0:span:length(v{i,1}(1,:))*dt);
    
    xlabel('{\it T} [s]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')
        ylabel('Verocity','FontName','Times New Roman','FontSize',18)


    ax = gca;
    ax.FontSize = 24;
    grid on;
