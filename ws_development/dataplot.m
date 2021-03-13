%% Save directry
close all;
save_date = datetime('now');
save_date_str= datestr(save_date,'yyyy_mm_dd_HH_MM_SS');
tmpfolder = pwd;
tmpfolder = strcat(tmpfolder,'\Saves_W');
mkdir(tmpfolder,save_date_str);
dataFilePath = genpath(strcat(tmpfolder,'\',save_date_str));
addpath(dataFilePath);
%% plot x y z
labelstr = ['x','y','z'];
%plant
tmp_pli = regexp(logger.items,'plant.state.p');
tmp_pli = cellfun(@(c) ~isempty(c),tmp_pli);
pli = find(tmp_pli);
pld = size(logger.Data.agent{1,pli},1);
plant_data = zeros(pld,size(logger.Data.t,1));
for pI = 1:pld
    plant_data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,pli}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
end
%model
tmp_mli = regexp(logger.items,'estimator.result.state.p');
tmp_mli = cellfun(@(c) ~isempty(c),tmp_mli);
mli = find(tmp_mli);
mld = size(logger.Data.agent{1,mli},1);
model_data =  zeros(mld,size(logger.Data.t,1));
for pI = 1:mld
    model_data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,mli}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
end
Time = cell2mat(arrayfun(@(N) logger.Data.t(N),1:size(logger.Data.t,1),'UniformOutput',false));
for pI = 1:pld
    figure(pI)
    figxyz = gcf;
    hold on;
    ax = gca;
    grid on
    axis equal
    plot(Time,plant_data(pI,:),'Linewidth',5);
    plot(Time,model_data(pI,:),'Linewidth',3);
    grid on;
    axis equal;
    xlabel('t [s]');ylabel(strcat(labelstr(pI),'[m]'));
    legend('plant','estimate')
    ax.FontSize = 15;
    hold off
    saveas(figxyz,strcat('fig',labelstr(pI)),'pdf');
    movefile(strcat('fig',labelstr(pI),'.pdf'),strcat('Saves_W\',save_date_str));
end
%% plot theta
tmp_pqli = regexp(logger.items,'plant.state.q');
tmp_pqli = cellfun(@(c) ~isempty(c),tmp_pqli);
pqli = find(tmp_pqli);
pqld = size(logger.Data.agent{1,pqli},1);
plantq_data = zeros(pqld,size(logger.Data.t,1));
for pI = 1:pqld
    plantq_data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,pqli}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
end
%model
tmp_mqli = regexp(logger.items,'estimator.result.state.q');
tmp_mqli = cellfun(@(c) ~isempty(c),tmp_mqli);
mqli = find(tmp_mqli);
mqld = size(logger.Data.agent{1,mqli},1);
modelq_data =  zeros(mqld,size(logger.Data.t,1));
for pI = 1:mqld
    modelq_data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,mqli}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
end
Time = cell2mat(arrayfun(@(N) logger.Data.t(N),1:size(logger.Data.t,1),'UniformOutput',false));
for pI = 1:pqld
    figure(4)
    hold on;
    ax = gca;
    figtheta = gcf;
    grid on
    axis equal
    plot(Time,plantq_data(pI,:),'Linewidth',5);
    plot(Time,modelq_data(pI,:),'Linewidth',3);
    grid on;
    axis equal;
    % xlim([-50 200]);ylim([-20 20]);
    % xlim([0 30])
    xlabel('t [s]');ylabel('\theta [rad]');
    legend('plant','estimate')
    % xticks([-50:20:200]);yticks([-20:20:20])
    ax.FontSize = 15;
    hold off
    saveas(figtheta,strcat('figtheta','.pdf'));
    movefile(strcat('figtheta','.pdf'),strcat('Saves_W\',save_date_str));
end
%% map_plot
x_s = agent.estimator.ukfslam_WC.map_param.x(:,1);
x_e = agent.estimator.ukfslam_WC.map_param.x(:,2);
y_s = agent.estimator.ukfslam_WC.map_param.y(:,1);
y_e = agent.estimator.ukfslam_WC.map_param.y(:,2);
s_xy = [x_s,y_s];
e_xy = [x_e,y_e];
si = size(x_s,1);
figure(5)
hold on;
ax = gca;
SOE = size(Env.param.Vertices,3);
for ei = 1:SOE
    tmpenv(ei) = polyshape(Env.param.Vertices(:,:,ei));
end
p_Area = union(tmpenv(:));
% p_Area = polyshape(Env.param.Vertices());
plot(p_Area);

for i=1:si
    plot([x_s(i),x_e(i)],[y_s(i),y_e(i)],'LineWidth',5,'Color','r');
end
plot(model_data(1,end),model_data(2,end),'b>');
plot(plant_data(1,end),plant_data(2,end),'g>');
grid on;
axis equal;
% xlim([-50 200]);ylim([-20 20]);
xlabel('x [m]');ylabel('y [m]');
xticks([-50:20:200]);yticks([-20:20:20])
ax.FontSize = 15;
hold off
%% map_movie
% map_param_x
tmp_mxli = regexp(logger.items,'estimator.ekfslam_WC.map_param.x');
tmp_mxli = cellfun(@(c) ~isempty(c),tmp_mxli);
mxli = find(tmp_mxli);
mxld = size(logger.Data.agent{1,mxli},1);
mx_data = zeros(mxld,size(logger.Data.t,1));
for pI = 1:mxld
    mx_data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,mxli}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
end
%map_param_y
tmp_myli = regexp(logger.items,'estimator.ekfslam_WC.map_param.y');
tmp_myli = cellfun(@(c) ~isempty(c),tmp_myli);
myli = find(tmp_myli);
myld = size(logger.Data.agent{1,myli},1);
my_data = zeros(myld,size(logger.Data.t,1));
for pI = 1:myld
    my_data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,myli}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
end
%laser_ranges
% tmp_laser_ranges = regexp(logger.items,'estimator.ekfslam_WC.result.laser.ranges');
% tmp_laser_ranges = cellfun(@(c) ~isempty(c),tmp_laser_ranges);
% laser_ranges = find(tmp_laser_ranges);
% %laser_angles
% tmp_laser_angles = regexp(logger.items,'estimator.ekfslam_WC.result.laser.ranges');
% laser_angles = find(cellfun(@(c) ~isempty(c),tmp_laser_angles));
%Error Elipse%
tmp_Error_Elipse = regexp(logger.items,'estimator.ekfslam_WC.result.ErEl_Round');
EE = find(cellfun(@(c) ~isempty(c),tmp_Error_Elipse));
msi = size(logger.Data.t,1);
%Map plot start
figure(6)
hold on;
ax = gca;
SOE = size(Env.param.Vertices,3);
for ei = 1:SOE
    tmpenv(ei) = polyshape(Env.param.Vertices(:,:,ei));
end
p_Area = union(tmpenv(:));
% Animation Loop
mo_t = 1;
tmp_max = max(Env.param.Vertices);
tmp_min = min(Env.param.Vertices);
xmin = min(tmp_min(:,1,:));
dx = 10;
xmax = max(tmp_max(:,1,:));
ymin = min(tmp_min(:,2,:));
dy = 10;
ymax = max(tmp_max(:,2,:));

v = VideoWriter(strcat('SLAM_MAPplot',save_date_str,'.avi'));
open(v);
while mo_t <= msi
    clf(figure(6));
%     xlim([xmin xmax]);ylim([ymin ymax]);
%     xticks([xmin:dx:xmax]);yticks([ymin:dy:ymax])
%     set(gca,'FontSize',20);
    xlabel('\sl x \rm [m]','FontSize', 15);
    ylabel('\sl y \rm [m]','FontSize',15);
    hold on
    grid on;
    box on
    pbaspect([250 50 1]);
%     axis equal
    %plot
%     logger.Data.agent{mot,4}(:,1)
%%%%%estimation map plot%%%%%
    for mni = 1:size(logger.Data.agent{mo_t,mxli}(:,1),1)
        fig6(1) = plot([logger.Data.agent{mo_t,mxli}(mni,1),logger.Data.agent{mo_t,mxli}(mni,2)],[logger.Data.agent{mo_t,myli}(mni,1),logger.Data.agent{mo_t,myli}(mni,2)],'LineWidth',2,'Color','r');
    end
%--------------------------------------%
%plant plot%
    tmp_plant_square = plant_data(:,mo_t) + [1,1.5,1,-1,-1;1,0,-1,-1,1];
    plant_square =  polyshape( tmp_plant_square');
    plant_square =  rotate(plant_square,180 * plantq_data(mo_t) / pi, plant_data(:,mo_t)');
    fig6(2) = plot(plant_square);
%-------------%

%model plot%
    tmp_model_square = model_data(:,mo_t) + [1,1.5,1,-1,-1;1,0,-1,-1,1];
    model_square =  polyshape( tmp_model_square');
    model_square =  rotate(model_square,180 * modelq_data(mo_t) / pi, model_data(:,mo_t)');
    fig6(3) = plot(model_square);
%-------------%

%     fig6(2) = plot(model_data(1,mo_t),model_data(2,mo_t),'b>');%plant plot
%     fig6(3) = plot(plant_data(1,mo_t),plant_data(2,mo_t),'g>');%robot plot
    fig6(4) = plot(p_Area,'FaceColor','red','FaceAlpha',0.1);% true map plot
    fig6(5) = plot(polybuffer([plant_data(1,mo_t),plant_data(2,mo_t)],'points',40),'FaceColor','blue','FaceAlpha',0.1);
    fig6(6) = plot( logger.Data.agent{mo_t,EE}(1,:)+model_data(1,mo_t),logger.Data.agent{mo_t,EE}(2,:)+model_data(2,mo_t),'k');
%     if ~isempty(logger.Data.agent{mo_t,laser_ranges})
% %         tmp_lasersize = size(logger.Data.agent{mo_t,laser_ranges},2);
% %         plot([model_data(1,mo_t),model_data(1,mo_t)+logger.Data.agent{mo_t,laser_ranges}(1)*cos(logger.Data.agent{mo_t,laser_angles}(1) - modelq_data(1,mo_t))],[model_data(2,mo_t) ,model_data(2,mo_t)+logger.Data.agent{mo_t,laser_ranges}(1)*sin(logger.Data.agent{mo_t,laser_angles}(1) - modelq_data(1,mo_t))]);
% %         plot([model_data(1,mo_t),model_data(1,mo_t)+logger.Data.agent{mo_t,laser_ranges}(end)*cos(logger.Data.agent{mo_t,laser_angles}(end) - modelq_data(1,mo_t))],[model_data(2,mo_t) ,model_data(2,mo_t)+logger.Data.agent{mo_t,laser_ranges}(end)*sin(logger.Data.agent{mo_t,laser_angles}(end) - modelq_data(1,mo_t))]);
% 
% %         for pI = 1:tmp_lasersize
% %             plot([model_data(1,mo_t),model_data(1,mo_t)+logger.Data.agent{mo_t,laser_ranges}(pI)*cos(logger.Data.agent{mo_t,laser_angles}(pI) - modelq_data(1,mo_t))],[model_data(2,mo_t) ,model_data(2,mo_t)+logger.Data.agent{mo_t,laser_ranges}(pI)*sin(logger.Data.agent{mo_t,laser_angles}(pI) - modelq_data(1,mo_t))]);
% %         end
%     end
%     plot([model_data(1,mo_t),model_data(1,mo_t)+laser_data(1,mo_t)*cos(angle_data(1,mo_t))],[model_data(2,mo_t) ,laser_data(1,mo_t)*cos(angle_data(1,mo_t)) ])
%     legend(fig6,'estimate map','estimate position','plant position','map','sensor renge');
    hold off
    pause(16 * 1e-2);
    mo_t = mo_t+5;
    frame = getframe(figure(6));
    writeVideo(v,frame);
end
close(v);
movefile(strcat('SLAM_MAPplot',save_date_str,'.avi'),strcat('Saves_W\',save_date_str));
disp('simulation ended')
%% RMSE
rmse = zeros(pld,1);
for ri = 1:pld
    rmse(ri) = sqrt(sum((model_data(ri,:) - plant_data(ri,:)).^2)/length(model_data(ri,:)));
end
qrmse = zeros(pqld,1);
for ri = 1:pqld
    qrmse(ri) = sqrt(sum((modelq_data(ri,:) - plantq_data(ri,:)).^2)/length(modelq_data(ri,:)));
end
figure(7)
hold on;
yyaxis left
bxy = bar(1:2,[rmse(1),rmse(2)],'r');
yyaxis right
bq = bar(3,[qrmse],'b');
hold off
%% Covariance
% tmp_pqli = regexp(logger.items,'estimator.ekfslam_WC.result.P');
% tmp_pqli = cellfun(@(c) ~isempty(c),tmp_pqli);
% pqli = find(tmp_pqli);% logger row number
% pqld = size(logger.Data.agent{1,pqli},1);
% plantq_data = zeros(pqld,size(logger.Data.t,1));
% for pI = 1:pqld
%     plantq_data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,pqli}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
% end
% Time = cell2mat(arrayfun(@(N) logger.Data.t(N),1:size(logger.Data.t,1),'UniformOutput',false));
% for pI = 1:3
%     figure(4)
%     hold on;
%     ax = gca;
%     grid on
%     axis equal
%     plot(Time,plantq_data(pI,:),'Linewidth',5);
%     grid on;
%     axis equal;
%     % xlim([-50 200]);ylim([-20 20]);
%     % xlim([0 30])
%     xlabel('t [s]');ylabel('\theta [rad]');
%     % xticks([-50:20:200]);yticks([-20:20:20])
%     ax.FontSize = 15;
%     hold off
% end
%% Entoropy
tmp_ent = regexp(logger.items,'estimator.ekfslam_WC.result.Entropy');
tmp_ent = cellfun(@(c) ~isempty(c),tmp_ent);
pent = find(tmp_ent );
if isempty(pent)
    disp('we dont culculate entropy');
else
    pentd = size(logger.Data.agent{1,pent},1);
    ent_data = zeros(pentd,size(logger.Data.t,1));
    for pI = 1:pentd
        ent_data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,pent}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
    end
    Time = cell2mat(arrayfun(@(N) logger.Data.t(N),1:size(logger.Data.t,1),'UniformOutput',false));
    for pI = 1:pentd
        figure(8)
        hold on;
        ax = gca;
        grid on
        axis equal
        plot(Time,ent_data(pI,:),'Linewidth',2);
        grid on;
        axis equal;
        % xlim([-50 200]);ylim([-20 20]);
        % xlim([0 30])
        xlabel('t [s]');ylabel('Entropy');
        %     ylabel('\theta [rad]');
        %     legend('plant','estimate')
        % xticks([-50:20:200]);yticks([-20:20:20])
        ax.FontSize = 15;
        hold off
        exportgraphics(ax,'Entropy.pdf');
        movefile('Entropy.pdf',strcat('Saves_W\',save_date_str));
    end
end
%% SingEntropy
tmp_ent = regexp(logger.items,'estimator.ekfslam_WC.result.SingP');
tmp_ent = cellfun(@(c) ~isempty(c),tmp_ent);
pent = find(tmp_ent );
if isempty(pent)
    disp('we dont culculate entropy');
else
    pentd = size(logger.Data.agent{1,pent},2);
    ent_data = zeros(pentd,size(logger.Data.t,1));
    for pI = 1:pentd
        ent_data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,pent}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
    end
    Time = cell2mat(arrayfun(@(N) logger.Data.t(N),1:size(logger.Data.t,1),'UniformOutput',false));

        figure(9)
        hold on;
        ax = gca;
        grid on
%         axis equal
        for pI = 1:5
            plot(Time,ent_data(pI,:),'Linewidth',2);
        end
        grid on;
%         axis equal;
        % xlim([-50 200]);ylim([-20 20]);
        % xlim([0 30])
        xlabel('t [s]');
        %     ylabel('\theta [rad]');
        %     legend('plant','estimate')
        % xticks([-50:20:200]);yticks([-20:20:20])
        legend('x','y','theta','v','w');
        ax.FontSize = 15;
        saveas(gcf,'SingEnt','pdf');
        movefile('SingEnt.pdf',strcat('Saves_W\',save_date_str));
        hold off
end
%% MtoKFKL
tmp_MtoKFKL = regexp(logger.items,'estimator.ekfslam_WC.result.MtoKF_KL');
tmp_MtoKFKL = cellfun(@(c) ~isempty(c),tmp_MtoKFKL);
pMtoKFKL = find(tmp_MtoKFKL );
if isempty(pMtoKFKL)
    disp('we dont culculate KL');
else
pMtoKFKLd = size(logger.Data.agent{1,pMtoKFKL},1);
MtoKFKL_data = zeros(pMtoKFKLd,size(logger.Data.t,1));
for pI = 1:pMtoKFKLd
    MtoKFKL_data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,pMtoKFKL}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
end
Time = cell2mat(arrayfun(@(N) logger.Data.t(N),1:size(logger.Data.t,1),'UniformOutput',false));
for pI = 1:pMtoKFKLd
    figure(9)
    hold on;
    ax = gca;
    grid on
    plot(Time,MtoKFKL_data(pI,:),'Linewidth',2);
    grid on;
    % xlim([-50 200]);ylim([-20 20]);
    % xlim([0 30])
    xlabel('t [s]');ylabel('KL');
    legend('plant','estimate')
    % xticks([-50:20:200]);yticks([-20:20:20])
    ax.FontSize = 15;
    hold off
    exportgraphics(ax,'KL.pdf')
    movefile('KL.pdf',strcat('Saves_W\',save_date_str));
end
end
%% Eig
tmp_ent = regexp(logger.items,'estimator.ekfslam_WC.result.Eig');
tmp_ent = cellfun(@(c) ~isempty(c),tmp_ent);
pent = find(tmp_ent );
if isempty(pent)
    disp('we dont culculate Eig');
else
    pentd = size(logger.Data.agent{1,pent},2);
    ent_data = zeros(pentd,size(logger.Data.t,1));
    for pI = 1:pentd
        ent_data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,pent}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
    end
    Time = cell2mat(arrayfun(@(N) logger.Data.t(N),1:size(logger.Data.t,1),'UniformOutput',false));

        figure(10)
        hold on;
        ax = gca;
        grid on
%         axis equal
        for pI = 1:pentd
            plot(Time,ent_data(pI,:),'Linewidth',2);
        end
        grid on;
%         axis equal;
        % xlim([-50 200]);ylim([-20 20]);
        % xlim([0 30])
        xlabel('t [s]');
        %     ylabel('\theta [rad]');
        %     legend('plant','estimate')
        % xticks([-50:20:200]);yticks([-20:20:20])
        legend('x','y','theta','v','w');
        ax.FontSize = 15;
        exportgraphics(ax,'Eig.pdf')
        movefile('Eig.pdf',strcat('Saves_W\',save_date_str));
        hold off
end
%%
tmp_ent = regexp(logger.items,'estimator.ekfslam_WC.result.GramVec');
tmp_ent = cellfun(@(c) ~isempty(c),tmp_ent);
pent = find(tmp_ent );
if isempty(pent)
    disp('we dont culculate Eig');
else
    pentd = size(logger.Data.agent{1,pent},2);
    ent_data = zeros(pentd,size(logger.Data.t,1));
    for pI = 1:pentd
        ent_data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,pent}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
    end
    Time = cell2mat(arrayfun(@(N) logger.Data.t(N),1:size(logger.Data.t,1),'UniformOutput',false));

        figure(10)
        hold on;
        ax = gca;
        grid on
%         axis equal
        for pI = 1:pentd
            plot(Time,ent_data(pI,:),'Linewidth',2);
        end
        grid on;
%         axis equal;
        % xlim([-50 200]);ylim([-20 20]);
        % xlim([0 30])
        xlabel('t [s]');
        %     ylabel('\theta [rad]');
        %     legend('plant','estimate')
        % xticks([-50:20:200]);yticks([-20:20:20])
        legend('x','y','theta','v','w');
        ax.FontSize = 15;
        exportgraphics(ax,'GramVec.pdf')
        movefile('GramVec.pdf',strcat('Saves_W\',save_date_str));
        hold off
end
%% Diff output
tmp_ent = regexp(logger.items,'estimator.ekfslam_WC.result.diffy');
tmp_ent = cellfun(@(c) ~isempty(c),tmp_ent);
pent = find(tmp_ent );
if isempty(pent)
    disp('we dont culculate entropy');
else
    pentd = size(logger.Data.agent{1,pent},1);
    ent_data = zeros(pentd,size(logger.Data.t,1));
    for pI = 1:pentd
        ent_data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,pent}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
    end
    Time = cell2mat(arrayfun(@(N) logger.Data.t(N),1:size(logger.Data.t,1),'UniformOutput',false));
    
        figure(8)
        hold on;
        ax = gca;
        grid on
%         axis equal
for pI = 1:3
    plot(Time,ent_data(pI,:),'Linewidth',2);
end
        grid on;
%         axis equal;
        % xlim([-50 200]);ylim([-20 20]);
        % xlim([0 30])
        xlabel('t [s]');
        %     ylabel('\theta [rad]');
        %     legend('plant','estimate')
        % xticks([-50:20:200]);yticks([-20:20:20])
        legend('x','y','theta','v','w','d1','alpha1','d2','alpha2');
        ax.FontSize = 15;
        hold off
end
%%
tmp_ent = regexp(logger.items,'estimator.ekfslam_WC.result.InFo');
tmp_ent = cellfun(@(c) ~isempty(c),tmp_ent);
pent = find(tmp_ent );
if isempty(pent)
    disp('we dont culculate entropy');
else
    pentd = size(logger.Data.agent{1,pent},1);
    ent_data = zeros(pentd,size(logger.Data.t,1));
    for pI = 1:pentd
        ent_data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,pent}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
    end
    Time = cell2mat(arrayfun(@(N) logger.Data.t(N),1:size(logger.Data.t,1),'UniformOutput',false));
    
        figure(15)
        hold on;
        ax = gca;
        grid on
%         axis equal
for pI = 1:pentd
    plot(Time,ent_data(pI,:),'Linewidth',2);
end
        grid on;
%         axis equal;
        xlim([0 20]);
%         ylim([-20 20]);
        % xlim([0 30])
            xlabel('t [s]');ylabel('mutual information');
        %     ylabel('\theta [rad]');
        %     legend('plant','estimate')
        % xticks([-50:20:200]);yticks([-20:20:20])
%         legend('x','y','theta','v','w','d1','alpha1','d2','alpha2');
        ax.FontSize = 15;
        hold off
        exportgraphics(ax,'MutualInfo.pdf')
        movefile('MutualInfo.pdf',strcat('Saves_W\',save_date_str));
end