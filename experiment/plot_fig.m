%%グラフ生成用のプログラム
close all
%%
ceilig_sensor = 1;%天井接地検知用のセンサーを用いているかどうか 0 or 1
T = logger.Data.t(1:logger.k);
time_ceiling_sensor = 0;
%% 12月実験用
for plot_i = 1:logger.k%グラフのプロット
        VL(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.VL_length;
end
%% 電圧，電流，回転数(234)
clear Y
T = logger.Data.t(1:logger.k);
name_class = ["voltage";"current";"rpm"];
name_legend = ["voltage [V]";"current [A]";"morter speed [rpm]"];
for name_i = 1:length(name_class)
    figure(name_i+1)
    hold on
    for plot_i = 1:logger.k%グラフのプロット
        Y(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.ros_t.(name_class(name_i));
    end
%     figure(2)
%     subplot(1,3,name_i);
    plot(T(1:logger.k),Y,'LineWidth',1)
    txt = {''};
%     if length([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]) == 2%フェーズのプロット
%         Square_coloring(logger.Data.t([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]),[1.00,1.00,0.00]); % take off phase
%         txt = {txt{:}, '{\color[rgb]{1.0,1.0,0.9}■} :Take off phase'};
%     end
%     if length([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]) == 2
%         Square_coloring(logger.Data.t([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]), [0.0,1.0,1.0]); % flight phase
%         txt = {txt{:}, '{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'};
%     end
%     if length([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]) == 2
%         Square_coloring(logger.Data.t([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]), [1.0,0.7,1.0]); % landing phase
%         txt = {txt{:}, '{\color[rgb]{1.0,0.9,1.0}■} :Landing phase'};
%     end

%     if length([find(VL > 60, 1), find(VL < 60, 1, 'last')]) == 2%12月実験用
%         Square_coloring(logger.Data.t([find(VL < 60, 1), find(VL < 60, 1, 'last')]), 'g'); % landing phase
%     end

%     if ceilig_sensor == 1 %接地時間の範囲のプロット
%         logger.Data.agent.sensor.result{1, 1}.switch
%         for plot_i = 1:logger.k
%             VL(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.switch;
%         end
%         if length([find( VL == 1, 1), find(VL == 1, 1, 'last')]) == 2
%             Square_coloring(logger.Data.t([find(VL < 60, 1), find(VL > 65, 1, 'last')]), 'y'); % landing phase
%         end
%     end
% if length([find(logger.Data.phase == 104, 1), find(logger.Data.phase == 104, 1, 'last')]) == 2%推力down用
%     Square_coloring(logger.Data.t([find(logger.Data.phase == 121, 1), find(logger.Data.phase == 121, 1, 'last')]), [0.65,0.65,0.65]); % landing phase
%     txt = {txt{:}, '{\color[rgb]{0.65,0.65,0.65}■} :down phase'};
% end
% 
for plot_i = 1:logger.k%天井センサスイッチ用
    sensor_switch(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.switch;
end
if length([find(sensor_switch == 1, 1), find(sensor_switch == 1, 1, 'last')]) == 2
    Square_coloring(logger.Data.t([find(sensor_switch == 1, 1), find(sensor_switch == 1, 1, 'last')]), [0.0,1.0,1.0]); % landing phase
    txt = {txt{:}, '{\color[rgb]{0.0,1.0,1.0}■} :down phase'};
end

    XLim = get(gca, 'XLim');
    YLim = get(gca, 'YLim');
%     text(XLim(2) - (XLim(2) - XLim(1)) * 0.25, YLim(2) + (YLim(2) - YLim(1)) * -0.1, txt(2));
    legend('morter 1','morter 2','morter 3','morter 4')
    xlabel('time [s]')
    ylabel(name_legend(name_i))
    legend('Location','best')
    ax = gca;
    ax.FontSize = 15;
    hold off
end
%回転数の二乗
sum = 0;
% for plot_i = find(logger.Data.phase == 102, 1):1:find(logger.Data.phase == 108, 1)-1
%  sum = logger.Data.agent.sensor.result{1, plot_i}.ros_t.rpm.^2+sum;
% end    
% for plot_i = find(logger.Data.phase == 109, 1):1:find(logger.Data.phase == 114, 1)-1
%  sum = logger.Data.agent.sensor.result{1, plot_i}.ros_t.rpm.^2+sum;
% end    
for plot_i = find(logger.Data.phase == 117, 1):1:find(logger.Data.phase == 122, 1)-1
 sum = logger.Data.agent.sensor.result{1, plot_i}.ros_t.rpm.^2+sum;
end    

%%回転数rmseを算出by安西
sum = 0;
for plot_i = find(logger.Data.phase == 117, 1):1:find(logger.Data.phase == 122, 1)-1
 tmp = logger.Data.agent.sensor.result{1,1300}.ros_t.rpm - logger.Data.agent.sensor.result{1, plot_i}.ros_t.rpm;
 tid = tmp.^2;
 sum = tid + sum;
end    
average = sum/numel(logger.Data.phase(find(logger.Data.phase == 117, 1):1:find(logger.Data.phase == 122, 1)-1));
RMSE = sqrt(average)
%%
%% 電力(5)
figure(5)
clear T Y
T = logger.Data.t(1:logger.k);
hold on
for plot_i = 1:logger.k%グラフのプロット
    Y(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.ros_t.voltage.*logger.Data.agent.sensor.result{1, plot_i}.ros_t.current;
    Y(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.ros_t.voltage.*logger.Data.agent.sensor.result{1, plot_i}.ros_t.current;
end
plot(T(1:logger.k),Y/10000,'LineWidth',1)
txt = {''};
% if length([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]) == 2%フェーズのプロット
%     Square_coloring(logger.Data.t([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]),[1.00,1.00,0.00]); % take off phase
%     txt = {txt{:}, '{\color[rgb]{1.0,1.0,0.9}■} :Take off phase'};
% end
% if length([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]) == 2
%     Square_coloring(logger.Data.t([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]), [0.0,1.0,1.0]); % flight phase
%     txt = {txt{:}, '{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'};
% end
% if length([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]) == 2
%     Square_coloring(logger.Data.t([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]), [1.0,0.7,1.0]); % landing phase
%     txt = {txt{:}, '{\color[rgb]{1.0,0.9,1.0}■} :Landing phase'};
% end
% if length([find(VL > 60, 1), find(VL < 60, 1, 'last')]) == 2%12月実験用
%     Square_coloring(logger.Data.t([find(VL < 60, 1), find(VL < 60, 1, 'last')]), 'g'); % landing phase
% end
% if length([find(logger.Data.phase == 104, 1), find(logger.Data.phase == 104, 1, 'last')]) == 2%推力down用
%     Square_coloring(logger.Data.t([find(logger.Data.phase == 121, 1), find(logger.Data.phase == 121, 1, 'last')]), [0.65,0.65,0.65]); % landing phase
%     txt = {txt{:}, '{\color[rgb]{0.65,0.65,0.65}■} :down phase'};
% end

% for plot_i = 1:logger.k%天井センサスイッチ用
%     sensor_switch(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.switch;
% end
% if length([find(sensor_switch == 1, 1), find(sensor_switch == 1, 1, 'last')]) == 2
%     Square_coloring(logger.Data.t([find(sensor_switch == 1, 1), find(sensor_switch == 1, 1, 'last')]), [0.0,1.0,1.0]); % landing phase
%     txt = {txt{:}, '{\color[rgb]{0.0,1.0,1.0}■} :down phase'};
% end


XLim = get(gca, 'XLim');
YLim = get(gca, 'YLim');
text(XLim(2) - (XLim(2) - XLim(1)) * 0.25, YLim(2) + (YLim(2) - YLim(1)) * -0.1, txt(2));


legend('morter 1','morter 2','morter 3','morter 4')
xlabel('time [s]')
ylabel('power [W]')
ax = gca;
ax.FontSize = 15;
hold off
%% z throttle　sr(6)
clear T Y VL
T = logger.Data.t(1:logger.k);
figure(6)
name_class = ["ceiling";"reference";"sensor";"throttle"];
%name_class = ["ceiling";"sensor";"throttle";"VL53L1X"];
hold on
plot([0 350],[3 3],"LineStyle","--",'LineWidth',1.5,'Color',[0.15,0.15,0.15])
Y=[];
for plot_i = 1:logger.k%グラフのプロット
    Y(plot_i,1) = logger.Data.agent.reference.result{1, plot_i}.state.p(2); 
    Y(plot_i,2) = logger.Data.agent.sensor.result{1, plot_i}.state.p(3);
    Y(plot_i,3) = logger.Data.agent.sensor.result{1, plot_i}.state.q(3);
%     Y(plot_i,3) = logger.Data.agent.inner_input{1, plot_i}(3);
%     VL(plot_i) = logger.Data.agent.sensor.result{1, plot_i}.distance(1);
end
plot(T(1:logger.k),Y(:,1),'LineWidth',4,'Color',[0.39,0.83,0.07])
plot(T(1:logger.k),Y(:,2),'LineWidth',2.5,'Color',[0.85,0.33,0.10])
% plot(T(1:logger.k),VL/1000,'LineWidth',2,'Color',[0.93,0.69,0.13])
% plot([0 60],[3 3],"LineStyle","--",'LineWidth',1.5,'Color',[0.15,0.15,0.15])
xlim([0 60])
ylim([0 3.1])
xlabel('time [s]')
ylabel('z [m]')
clear txt
txt = {''};
% if length([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]) == 2%フェーズのプロット
%     Square_coloring(logger.Data.t([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]),[1.00,1.00,0.00]); % take off phase
%     txt = {txt{:}, '{\color[rgb]{1.00,1.00,0.00}■} :Take off phase'};
% end
% if length([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]) == 2
%     Square_coloring(logger.Data.t([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]), [0.0,1.0,1.0]); % flight phase
%     txt = {txt{:}, '{\color[rgb]{0.0,1.0,1.0}■} :Flight phase'};
% % end
% if length([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]) == 2
%     Square_coloring(logger.Data.t([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]), [1.0,0.7,1.0]); % landing phase
%     txt = {txt{:}, '{\color[rgb]{1.0,0.7,1.0}■} :Landing phase'};
% end
% if length([find(logger.Data.phase == 104, 1), find(logger.Data.phase == 104, 1, 'last')]) == 2%推力down用
%     Square_coloring(logger.Data.t([find(logger.Data.phase == 121, 1), find(logger.Data.phase == 121, 1, 'last')]), [0.65,0.65,0.65]); % landing phase
%     txt = {txt{:}, '{\color[rgb]{0.65,0.65,0.65}■} :down phase'};
% end
% 
% if length([find(Y(:,2) >= 2.95, 1), find(Y(:,2) >= 2.95, 1, 'last')]) == 2%天井接地状態用
%     Square_coloring(logger.Data.t([find(Y(:,2) >= 2.95, 1), find(Y(:,2) >= 2.95, 1, 'last')]), [0.30,0.75,0.93]); % landing phase
%     txt = {txt{:}, '{\color[rgb]{0.30,0.75,0.93}■} :On ceiling phase'};
% end

% if length([find(logger.Data.phase == 121, 1), find(logger.Data.phase == 121, 1, 'last')]) == 2%推力ダウン
%     Square_coloring(logger.Data.t([find(logger.Data.phase == 121, 1), find(logger.Data.phase == 121, 1, 'last')]), [0.0,1.0,1.0]); % landing phase
%     txt = {txt{:}, '{\color[rgb]{0.0,1.0,1.0}■} :Landing phase'};
% end
% 
% for plot_i = 1:logger.k%天井センサスイッチ用
%     sensor_VL(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.distance(1);
%     sensor_VL_e(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.distance(3);
% end
% if length([find(VL <= 55, 1), find(VL <= 55, 1, 'last')]) == 2
%     Square_coloring(logger.Data.t([find(VL <= 55, 1), find(VL <= 55, 1, 'last')]), [0.0,1.0,1.0]); % landing phase
%     txt = {txt{:}, '{\color[rgb]{0.0,1.0,1.0}■} :On ceiling phase'};
% end

for plot_i = 1:logger.k%天井センサスイッチ用
    sensor_switch(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.switch;
end
if length([find(sensor_switch == 1, 1), find(sensor_switch == 1, 1, 'last')]) == 2
    Square_coloring(logger.Data.t([find(sensor_switch == 1, 1), find(sensor_switch == 1, 1, 'last')]), [0.0,1.0,1.0]); % landing phase
    txt = {txt{:}, '{\color[rgb]{0.0,1.0,1.0}■} :down phase'};
end

% 
% if length([find(Y(:,2) > 2.93, 1), find(Y(:,2) > 2.93, 1, 'last')]) == 2%12月実験用
%     margin = 0.002*(YLim(2)-YLim(1));
%     Square_coloring(logger.Data.t([find(Y(:,2) > 2.93, 1), find(Y(:,2) > 2.93, 1, 'last')]), '1.00,0.70,1.00'); % landing phase
% %     rectangle('Position',[T(find(Y(:,2) > 2.93, 1)) margin T(find(Y(:,2)>2.93,1,'last'))-T(find(Y(:,2)>2.93,1)) ylimit(2)-2*margin],'EdgeColor','r')
%     txt = {txt{:}, '{\color[rgb]{1.00,0.70,1.00}■} : on ceiling phase'};
% end
% text(XLim(2),YLim(2), txt)
XLim = get(gca, 'XLim');
YLim = get(gca, 'YLim');
text(XLim(2) - (XLim(2) - XLim(1)) * 0.25, YLim(2) + (YLim(2) - YLim(1)) * -0.1, txt(2));
yyaxis right
plot(T(1:logger.k),Y(:,3),'LineWidth',1.5,'Color',[0.00,0.45,0.74])
ylabel('inner input')
% ylim([0 700])
legend(name_class)
legend('Location','best')
ax = gca;
ax.FontSize = 15;
hold off
%% 事例研用(7)
clear T
name_class = ["wall";"reference";"estimator";"target orbit"];%名前
T = logger.Data.t(1:logger.k);%時間
obs_pos = agent.sensor.motive.result.rigid;%壁の端点
x_wide = 0.1;%壁の厚さ
obs_x =(obs_pos(2).p(1)+obs_pos(3).p(1))/2;%壁のx座標

figure(7)
hold on

% room_edge = polyshape([-2.2,-2.2,7.2,7.2],[-3.2,3.7,3.7,-3.2]);%部屋の外枠の座標設定
% plot_room_edge = plot(room_edge);%部屋の外枠をプロット
% hAnnotation = get(plot_room_edge,'Annotation');%凡例の削除
% hLegendEntry = get(hAnnotation,'LegendInformation');
% set(hLegendEntry,'IconDisplayStyle','off')
 
% room = polyshape([-2,-2,7,7],[-3,3.5,3.5,-3]);%部屋の座標設定
% plot_room = plot(room,'FaceColor','w','FaceAlpha',1);%部屋のプロット
% hAnnotation = get(plot_room,'Annotation');
% hLegendEntry = get(hAnnotation,'LegendInformation');
% set(hLegendEntry,'IconDisplayStyle','off')

PX = [obs_x-x_wide,obs_x-x_wide,obs_x+x_wide,obs_x+x_wide];%壁の端点のx座標
PY = [obs_pos(3).p(2),obs_pos(2).p(2),obs_pos(2).p(2),obs_pos(3).p(2)];%壁の端点のy座標
obs = polyshape(PX,PY); %壁の角の座標を設定
plot(obs,'FaceColor',[0.30,0.75,0.93])%壁をプロット

for plot_i = 1:logger.k%変数を格納
    p_reference(plot_i,:) = logger.Data.agent.reference.result{1, plot_i}.state.p(1:3); 
    p_sensor(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.state.p(1:3);
    p_estimator(plot_i,:) = logger.Data.agent.estimator.result{1, plot_i}.state.p(1:3);
end

f_phase = find(logger.Data.phase == 102, 1);%フライトが始まる番号
l_phase = find(logger.Data.phase == 108, 1);%ランディングが始まる番号

%%フライトフェーズで色を変えるプロット↓
% plot(p_estimator(1:f_phase,1),p_estimator(1:f_phase,2),'LineWidth',2)%estimatorをプロット(フライト前)
% plot(p_reference(f_phase:plot_i,1),p_reference(f_phase:plot_i,2),'LineWidth',3,'Color',[0.39,0.83,0.07])%referenceをプロット(フライト後)
% plot(p_estimator(f_phase:plot_i,1),p_estimator(f_phase:plot_i,2),'LineWidth',2,'Color',[0.85,0.33,0.10])%estimatorをプロット(フライト後)
%普通の奴↓
plot(p_reference(:,1),p_reference(:,2),'LineWidth',3,'Color',[0.39,0.83,0.07])%referenceをプロット
plot(p_estimator(:,1),p_estimator(:,2),'LineWidth',2,'Color',[0.85,0.33,0.10])%estimatorをプロット
plot([0 7],[0 0],"marker",">","LineStyle","--",'LineWidth',1,'Color',[0.15,0.15,0.15])%目標の軌道をプロット

xlim([-2 7])%グラフの範囲の設定
ylim([-3 3.5])
xlabel('x [m]')
ylabel('y [m]')
legend(name_class)%凡例の表示
legend('Location','best')
ax = gca;
ax.FontSize = 12;
hold off

% 事例研用 3次元プロット (8)
figure(8)
hold on

%線のプロット↓
plot3(p_estimator(1:f_phase,1),p_estimator(1:f_phase,2),p_estimator(1:f_phase,3),'LineWidth',1.5,'Color',[0.39,0.83,0.07])%テイクオフ
plot3(p_estimator(f_phase:l_phase,1),p_estimator(f_phase:l_phase,2),p_estimator(f_phase:l_phase,3),'LineWidth',1.5,'Color',[0.30,0.75,0.93])%フライト
plot3(p_estimator(l_phase:plot_i,1),p_estimator(l_phase:plot_i,2),p_estimator(l_phase:plot_i,3),'LineWidth',1.5,'Color',[0.85,0.33,0.10])%ランディング
% plot3(p_estimator(:,1),p_estimator(:,2),p_estimator(:,3),'LineWidth',1,'Color',[0.85,0.33,0.10])
plot3([0 7],[0 0],[1 1],"LineStyle","--","marker",">")

%図形の定義↓
wall_3D=OBJECT3D("cube",struct("cog",[obs_x,(obs_pos(2).p(2)+obs_pos(3).p(2))/2,obs_pos(3).p(3)/2],"length",[0.2,abs(obs_pos(2).p(2)-obs_pos(3).p(2)),obs_pos(3).p(2)]));
room_3D=OBJECT3D("cube",struct("cog",[2.5,0.25,1.5],"length",[9,6.5,3]));
%図形のプロット
fill3(wall_3D.X,wall_3D.Y,wall_3D.Z,wall_3D.C,'FaceAlpha',0.5);
plot_room_3D = fill3(room_3D.X,room_3D.Y,room_3D.Z,room_3D.C,'FaceAlpha',0);
%ラベルの設定↓
xlabel('x [m]')
ylabel('y [m]')
zlabel('z [m]')

name_class = ["takeoff";"flight";"landing";"target orbit";"wall"];%名前
legend(name_class)
legend('Location','best')
ax = gca;
ax.FontSize = 12;%フォントの設定

hold off

% 事例研用　物体との距離(9)
figure(9)
hold on
for plot_i = 1:logger.k%変数を格納
    if obs_pos(2).p(2)>logger.Data.agent.estimator.result{1, plot_i}.state.p(2)&&logger.Data.agent.estimator.result{1, plot_i}.state.p(2)<obs_pos(3).p(2)
        distance_wall(plot_i,1) = norm(obs_x-logger.Data.agent.estimator.result{1, plot_i}.state.p(1));%壁との垂直の距離
    else
        distance_a(1) = norm(obs_pos(2).p(1:2)-logger.Data.agent.estimator.result{1, plot_i}.state.p(1:2));%端点aとの距離
        distance_a(2) = norm(obs_pos(3).p(1:2)-logger.Data.agent.estimator.result{1, plot_i}.state.p(1:2));%端点bとの距離
        distance_wall(plot_i,1) = min(distance_a);%a or b　近いほうを選出
    end
    distance_sensor(plot_i,1) = logger.Data.agent.sensor.result{1, plot_i}.distance.teraranger;%テラレンジャーの距離
end

plot(T,distance_wall,'LineWidth',1)
plot(T,distance_sensor,'LineWidth',1)

xlabel('time [s]')
ylabel('distance [m]')
name_class = ["distance wall";"teraranger"];%名前
legend(name_class)
legend('Location','best')
ax = gca;
ax.FontSize = 12;
hold off

% 事例研　速度x,y,z(10)
figure(10)
hold on
for plot_i = 1:logger.k%変数を格納
    velocity(plot_i,:) = logger.Data.agent.estimator.result{1, plot_i}.state.v;%速度を代入
end

plot(T,velocity,'LineWidth',1)%速度のプロット

%グラフの書式設定↓
xlabel('time [s]')
ylabel('velocity [m/s]')
name_class = ["Vx";"Vy";"Vz"];%名前
legend(name_class)
legend('Location','best')
ax = gca;
ax.FontSize = 12;
hold off

% 速度とセンサの距離のグラフ(11)
hold on
%左軸に速度のプロット
figure(11)
plot(T,velocity(:,1:2),'LineWidth',1)%速度のプロット
xlabel('time [s]')
ylabel('velocity [m/s]')


%右軸にセンサの測定値をプロット
yyaxis right
plot(T,distance_sensor,'LineWidth',1)
ylabel('distance [m]')
name_class = ["Vx";"Vy";"Vz";"teraranger"];%名前
legend(name_class)
legend('Location','best')
ax = gca;
ax.FontSize = 12;

hold off

%% 三次元　ポテンシャル場(12)(13)
%clear all
clear x y Py Pxm
d=0.25;%刻み幅[m]
x = -2:d:7;%実際の環境のx座標幅
y = -3:d:3.5;%実際の環境のy座標幅
i=1;
for dx = -4.5:d:4.5%刻み幅[m]ごとのpotential高さを計算
    j=1;
    for dy = -3:d:3.5
        if dy>-1.2&&dy<0.8&&dx<0%壁面前
            P_x = -0.5*dx;%xの引力P_x
            P_xm = -0.5/dx;%xの斥力P_x
            P_y = 0.25*(dy+0.2)^2;%yの引力P_x
            P_ym = -sqrt(dx^2+(dy+0.2)^2)+2;%yの斥力P_x
        else%壁面から外れた場合(上と式は同じ)
            P_x = -0.5*dx;
            P_xm = 0.5/(4.5-dx);
            P_y = 0.25*(dy+0.2)^2;
            P_ym = -sqrt(dx^2+(dy+0.2)^2)+2;
        end
        %potentialの格納
        Px(j,i)= P_x+P_xm;  %x軸のpotential = xの引力P_x + xの斥力P_xm
        Py(j,i)= P_y+P_ym;  %y軸のpotential = yの引力P_x + yの斥力P_xm
        P(j,i)= P_ym+P_xm+P_y+P_x; %全部合わせたのpotential
        Pm(j,i)= P_xm+P_ym; %斥力のみ合わせたのpotential
        Pxm(j,i)=P_xm; %x斥力のみのpotential
        Pym(j,i)=P_ym; %y斥力のみのpotential
        j=j+1;
    end
    i=i+1;
end


potential_name=[Px;Py;P;Pm;Pxm;Pym];%potentialを一つの配列に格納
title_name= ["x potential";"y potential";"all potential";"obs potential";"x obs potential";"y obs potential"];%図のタイトル

figure(12)%タイトル参照
for sub_i= 1:6%6つで1つのfigureに出力
    subplot(2,3,sub_i);
    mesh(x,y,potential_name(1+27*(sub_i-1):27*sub_i,1:37))
    xlabel('x [m]')
    ylabel('y [m]')
    zlabel('potential')
    title(title_name(sub_i))
end


figure(13)%yのpotentialとxの斥力potentialを描画した三次元graph

hold on
% mesh(x,y,Pxm,"FaceAlpha",0.05,"FaceColor","r","EdgeColor","r")%xの斥力potentialのみ描画
% %mesh(x,y,Px,"FaceAlpha",0.05,"FaceColor","r","EdgeColor","r")%xのpotentialの描画(これ付けたい場合は上をコメントアウト)
% mesh(x,y,Py,"FaceAlpha",0.05,"FaceColor","b","EdgeColor","b")%yのpotentialの描画

plot3(p_estimator(:,1),p_estimator(:,2),p_estimator(:,3),'LineWidth',1.5,'Color',[0.1,0.1,0.1])%軌道の描画

wall_3D=OBJECT3D("cube",struct("cog",[2.5,-0.2,0.6],"length",[0.2,2,1.2]));%障害物の定義
room_3D=OBJECT3D("cube",struct("cog",[2.5,0.25,1.5],"length",[9,6.5,3]));%実験環境の空間の定義
fill3(wall_3D.X,wall_3D.Y,wall_3D.Z,wall_3D.C,'FaceAlpha',1);%障害物の描画
plot_room_3D = fill3(room_3D.X,room_3D.Y,room_3D.Z,room_3D.C,'FaceAlpha',0);%空間の描画


xlabel('x [m]')
ylabel('y [m]')
zlabel('potential')
name_class = ["x potential";"y potential"];%凡例
% name_class = ["x potential";"y potential";"orbit"];
legend(name_class)
hold off
%% 赤外線センサ2_4用(14)
figure(14)
clear Y
name_class = ["VL53L1X";"estimator"];
hold on
for plot_i = 1:logger.k%天井センサスイッチ用
    sensor_VL(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.distance(1);
    sensor_VL_e(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.distance(3);
end
plot(logger.Data.t(1:logger.k),sensor_VL,'LineWidth',1.5,'Color',[0.00,0.45,0.74])

if length([find(sensor_VL_e <= 55, 1), find(sensor_VL_e <= 55, 1, 'last')]) == 2
    Square_coloring(logger.Data.t([find(sensor_VL_e <= 55, 1), find(sensor_VL_e <= 55, 1, 'last')]), [1.0,0.7,1.0]); % landing phase
end
xlabel('time [s]')
ylabel('distance [mm]')
legend(name_class)
legend('Location','best')
ax = gca;
ax.FontSize = 15;
hold off
%% 電力，回転数，throttle，平均
clear T
T=[200 250];
Y=0;
W=0;
throttle=0;
length_t = find(logger.Data.t >= T(2) ,1) - find(logger.Data.t >= T(1), 1);
for plot_i = find(logger.Data.t >= T(1), 1):find(logger.Data.t >= T(2) ,1)
    Y = logger.Data.agent.sensor.result{1, plot_i}.ros_t.rpm + Y;
    W = logger.Data.agent.sensor.result{1, plot_i}.ros_t.voltage.*logger.Data.agent.sensor.result{1, plot_i}.ros_t.current + W;
    throttle = logger.Data.agent.inner_input{1, plot_i}(3)+throttle;
end
rpm_average = Y/length_t
W_average = W/length_t/10000
throttle_average = throttle/length_t
mean(rpm_average)
mean(W_average)
%% (15)電力合計
figure(15)
clear T Y
T = logger.Data.t(1:logger.k);
hold on
for plot_i = 1:logger.k%グラフのプロット
    Y(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.ros_t.voltage.*logger.Data.agent.sensor.result{1, plot_i}.ros_t.current;
end
% Y_all=mean(Y,2);
Y_all=sum(Y,2);
% plot(T(1:logger.k),Y/10000,'LineWidth',1)
plot(T(1:logger.k),Y_all/10000,'LineWidth',1)
txt = {''};
if length([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]) == 2%フェーズのプロット
    Square_coloring(logger.Data.t([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]),[1.00,1.00,0.00]); % take off phase
    txt = {txt{:}, '{\color[rgb]{1.0,1.0,0.9}■} :Take off phase'};
end
if length([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]) == 2
    Square_coloring(logger.Data.t([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]), [0.0,1.0,1.0]); % flight phase
    txt = {txt{:}, '{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'};
end
if length([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]) == 2
    Square_coloring(logger.Data.t([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]), [1.0,0.7,1.0]); % landing phase
    txt = {txt{:}, '{\color[rgb]{1.0,0.9,1.0}■} :Landing phase'};
end
% if length([find(VL > 60, 1), find(VL < 60, 1, 'last')]) == 2  %VL
%     Square_coloring(logger.Data.t([find(VL < 60, 1), find(VL < 60, 1, 'last')]), 'g'); % landing phase
% end
% if length([find(logger.Data.phase == 121, 1), find(logger.Data.phase == 121, 1, 'last')]) == 2%推力ダウン
%     Square_coloring(logger.Data.t([find(logger.Data.phase == 121, 1), find(logger.Data.phase == 121, 1, 'last')]), [0.0,1.0,1.0]); % landing phase
%     txt = {txt{:}, '{\color[rgb]{0.0,1.0,1.0}■} :Landing phase'};
% end
% legend('morter 1','morter 2','morter 3','morter 4')
xlabel('time [s]')
ylabel('power [W]')
ax = gca;
ax.FontSize = 15;
hold off
%% figure(16)(17)
clear T Y
figure(16)
hold on
T = logger.Data.t(1:logger.k);
lamda = 0.99;
Y(1,:) = logger.Data.agent.sensor.result{1, 1}.ros_t.voltage;
for plot_i = 2:logger.k%グラフのプロット
    Y(plot_i,:) = lamda*Y(plot_i-1,:) + (1-lamda)*logger.Data.agent.sensor.result{1, plot_i}.ros_t.voltage.';
end
Y_ave = mean(Y,2)/100;
yyaxis right
plot(T,Y_ave,'LineWidth',2.5)
xlabel('time [s]')
ylabel('voltage [V]')

clear Y
for plot_i = 2:logger.k%グラフのプロット
    Y(plot_i) = logger.Data.agent.sensor.result{1, plot_i}.state.p(3)-logger.Data.agent.reference.result{1, plot_i}.state.p(3);
end
yyaxis left
plot(T,Y,'LineWidth',2.5)
ylabel('z [m]')

txt = {''};
if length([find(logger.Data.phase == 104, 1), find(logger.Data.phase == 104, 1, 'last')]) == 2%推力down用
    Square_coloring(logger.Data.t([find(logger.Data.phase == 104, 1), find(logger.Data.phase == 104, 1, 'last')]), [0,1.0,1.0]); % landing phase
    txt = {txt{:}, '{\color[rgb]{0,1.0,1.0}■} :down phase'};
end
XLim = get(gca, 'XLim');
YLim = get(gca, 'YLim');
text(XLim(2) - (XLim(2) - XLim(1)) * 0.25, YLim(2) + (YLim(2) - YLim(1)) * -0.1, txt);

ax = gca;
ax.FontSize = 15;
hold off

clear Y
figure(17)
for plot_i = 1:logger.k%グラフのプロット
    Y(plot_i,1) = logger.Data.agent.reference.result{1, plot_i}.state.p(3); 
    Y(plot_i,2) = logger.Data.agent.sensor.result{1, plot_i}.state.p(3);
%     V(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.ros_t.voltage_average.';
end
hold on
k = find(Y(:,1) == 1.5, 1):100:find(T < 300, 1, 'last');
% k = find(Y_ave > 19, 1):find(Y_ave > 19, 1, 'last');
% plot(T(k),Y(k,1),'LineWidth',4,'Color',[0.39,0.83,0.07])
% plot(T(k),Y(k,2),'LineWidth',2.5,'Color',[0.85,0.33,0.10])
% plot(T(k),Y(k,3),'LineWidth',2.5,'Color',[0.85,0.33,0.10])
plot(Y_ave(k),Y(k,2)-Y(k,1),'*')%,'LineWidth',2,'Color',[0.93,0.69,0.13])
polyfit(Y_ave,Y(:,1)-Y(:,2),1)
lsline
ax = gca;
ax.FontSize = 15;
xlabel('V_L [V]')
ylabel('Δz [m]')
hold off
%% (18)
clear T Y
T = logger.Data.t(1:logger.k);
figure(18)
name_class = ["roll";"pitch";"yaw"];
name_para = ["q","[rad/s]" ];
hold on
Y=[];
for plot_i = 1:logger.k%グラフpプロット
    Y(plot_i,1) = logger.Data.agent.estimator.result{1, plot_i}.state.(name_para(1))(1); 
    Y(plot_i,2) = logger.Data.agent.estimator.result{1, plot_i}.state.(name_para(1))(2);
    Y(plot_i,3) = logger.Data.agent.estimator.result{1, plot_i}.state.(name_para(1))(3);
end
plot(T(1:logger.k),Y(:,1),'LineWidth',2.5,'Color',[0.39,0.83,0.07])
plot(T(1:logger.k),Y(:,2),'LineWidth',2.5,'Color',[0.85,0.33,0.10])
plot(T(1:logger.k),Y(:,3),'LineWidth',2.5,'Color',[0.00,0.45,0.74])
% xlim([0 60])
% ylim([0 3.1])
xlabel('time [s]')
ylabel((name_para))
clear txt
txt = {''};

for plot_i = 1:logger.k%天井センサスイッチ用
    sensor_switch(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.switch;
end
if length([find(sensor_switch == 1, 1), find(sensor_switch == 1, 1, 'last')]) == 2
    Square_coloring(logger.Data.t([find(sensor_switch == 1, 1), find(sensor_switch == 1, 1, 'last')]), [0.0,1.0,1.0]); % landing phase
    txt = {txt{:}, '{\color[rgb]{0.0,1.0,1.0}■} :down phase'};
end

XLim = get(gca, 'XLim');
YLim = get(gca, 'YLim');
text(XLim(2) - (XLim(2) - XLim(1)) * 0.25, YLim(2) + (YLim(2) - YLim(1)) * -0.1, txt(2));
% yyaxis right
% plot(T(1:logger.k),Y(:,3),'LineWidth',1.5,'Color',[0.00,0.45,0.74])
% ylabel('inner input')
% % ylim([0 700])
legend(name_class)
legend('Location','best')
ax = gca;
ax.FontSize = 15;
hold off
