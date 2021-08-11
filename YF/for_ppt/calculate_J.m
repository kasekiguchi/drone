% calculate Evaluation function
clear agent_state
clear evo
cd 'C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\work\video\data\success'
addpath 'C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\work\YF\Cov'
close all
fp = yasui.fp;
Nb = yasui.Nb;
Na = yasui.Na;
dt = yasui.dt;
for i =1:Nb
    sheep_state{i} = yasui.save.agent{i}.state;
end

%%
for k = 1:Na
    
    
    for f = 1:Na
        agent_state{f} =yasui.save.agent{Nb+f}.state;
    end
    state.p = agent_state{k};
    agent_state{k} = [];
    other_agent = cell2mat(agent_state');
    for i = 1:yasui.main_roop_count-1
        for j = 1:Nb
            
            for q =1:Na-1
                tmp(q,:) = Cov_distance(fp,sheep_state{j}(1:2,i),2)+Cov_distance(state.p(1:2,i),sheep_state{j}(1:2,i),2)-Cov_distance(other_agent(3*q-2:3*q,i),sheep_state{j}(1:2,i),2);
                
                QQ(q) = Cov_distance(fp,sheep_state{j}(1:2,i),2);
                WW(q) = Cov_distance(state.p(1:2,i),sheep_state{j}(1:2,i),2);
                
                EE(q) = -Cov_distance(other_agent(3*q-2:3*q,i),sheep_state{j}(1:2,i),2);
            end
            evo{k}(i,j) = sum(tmp);
            
            evo3{k}(i,j) = sum(EE);
            evo2{k}(i,j) = sum(WW);
            evo1{k}(i,j) = sum(QQ);
            
            
        end
    end
end
%%
close all
figure(4)
for k = 1:Na
    if k==Na
for j=1:Nb
    if j == 9
        plot(evo1{k}(:,j),'LineWidth',2,'Color',[(210/255),(105/255),(30/255)])
        hold on
    elseif j == 11
        plot(evo1{k}(:,j),'LineWidth',2,'Color',[(0/255),(255/255),(0/255)])
    end
    
end
    end
end
% xline(360,'LineWidth',3,'Displayname','Time')
span = 5;%秒数
xlim([1 yasui.main_roop_count])
[a,~] = max(evo{Na});
[c,~] = max(a);
[p,~] = min(evo{Na});
[o,~] = min(p);
ylim([o-1 c+1])


xticks([span:span*10:yasui.main_roop_count]);
xticklabels(0:span:yasui.main_roop_count*dt);

xlabel('{\it T} [s]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')


ax = gca;
ax.FontSize = 24;
ylabel('Evaluation','FontName','Times New Roman','FontSize',18)
grid on;
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg


figure(5)
for k = 1:Na
    if k ==Na
for j=1:Nb
    if j == 9
        plot(evo2{k}(:,j),'LineWidth',2,'Color',[(210/255),(105/255),(30/255)])
        hold on
    elseif j == 11
        plot(evo2{1}(:,j),'LineWidth',2,'Color',[(0/255),(255/255),(0/255)])
    end
    
end
    end
end
% xline(360,'LineWidth',3,'Displayname','Time')
span = 5;%秒数
xlim([1 yasui.main_roop_count])
[a,~] = max(evo{Na});
[c,~] = max(a);
[p,~] = min(evo{Na});
[o,~] = min(p);
ylim([o-1 c+1])


xticks([span:span*10:yasui.main_roop_count]);
xticklabels(0:span:yasui.main_roop_count*dt);

xlabel('{\it T} [s]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')


ax = gca;
ax.FontSize = 24;
ylabel('Evaluation','FontName','Times New Roman','FontSize',18)
grid on;
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg

figure(6)
for k = 1:Na
    if k == Na
for j=1:Nb
    if j == 9
        plot(evo3{k}(:,j),'LineWidth',2,'Color',[(210/255),(105/255),(30/255)])
        hold on
    elseif j == 11
        plot(evo3{k}(:,j),'LineWidth',2,'Color',[(0/255),(255/255),(0/255)])
    end
    
end
    end
end
% xline(360,'LineWidth',3,'Displayname','Time')

span = 5;%秒数
xlim([1 yasui.main_roop_count])
[a,~] = max(evo{Na});
[c,~] = max(a);
[p,~] = min(evo{Na});
[o,~] = min(p);
ylim([-c-1 -o+1])


xticks([span:span*10:yasui.main_roop_count]);
xticklabels(0:span:yasui.main_roop_count*dt);

xlabel('{\it T} [s]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')


ax = gca;
ax.FontSize = 24;
ylabel('Evaluation','FontName','Times New Roman','FontSize',18)
grid on;
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg

%%
figure(7)
clear sum_all
for k = 1:Na
    sum_all{k} = evo1{k}+evo2{k}+evo3{k};
if k ==Na
for j=1:Nb
    if j == 9
        plot(sum_all{k}(:,j),'LineWidth',2,'Color',[(210/255),(105/255),(30/255)])
        hold on
    elseif j == 11
        plot(sum_all{1}(:,j),'LineWidth',2,'Color',[(0/255),(255/255),(0/255)])
    end
    
end
end
end
% xline(360,'LineWidth',3,'Displayname','Time')

span = 5;%秒数
xlim([1 yasui.main_roop_count])
[a,~] = max(sum_all{Na});
[c,~] = max(a);
[p,~] = min(sum_all{Na});
[o,~] = min(p);
ylim([o+1 c-1])


xticks([span:span*10:yasui.main_roop_count]);
xticklabels(0:span:yasui.main_roop_count*dt);

xlabel('{\it T} [s]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')


ax = gca;
ax.FontSize = 24;
ylabel('Evaluation','FontName','Times New Roman','FontSize',18)
grid on;
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
exportsetupdlg

%%
% figure1   = figure(3);
% axes1     = axes('Parent',figure1);
% 
% FileName  = 'evoluate';
% %     FileName  = strrep(strrep(strcat('Movie(',datestr(datetime('now')),').avi'),':','_'),' ','_');
% v         = VideoWriter(FileName);
% v.Quality = 100;
% v.FrameRate = 50;
% open(v);
% for i=1:yasui.main_roop_count-1
%     plot(evo{Na}(:,1))
%     hold on
%     for j=1:Nb
%         plot(evo{Na}(:,j))
%     end
%     xline(i,'LineWidth',3,'Displayname','Time')
%     hold off
%     span = 5;%秒数
%     xlim([1 yasui.main_roop_count])
%     [a,~] = max(evo{Na});
%     [c,~] = max(a);
%     [p,~] = min(evo{Na});
%     [o,~] = min(p);
%     ylim([o-1 c+1])
%     
%     
%     xticks([span:span*10:yasui.main_roop_count]);
%     xticklabels(0:span:yasui.main_roop_count*dt);
%     ax = gca;
%     ax.FontSize = 20;
%     ylabel('Evaluation','FontName','Times New Roman','FontSize',24)
%     xlabel('{\it T} [s]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')
%     grid on
%     
%     frame=getframe(gcf);
%     writeVideo(v,frame);
%     axis square;
%     hold off;
%     v;
% end
% close(v);







cd 'C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\論文用\fig'
