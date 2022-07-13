%% 観測値の差分を出すためのプログラム
%% Initialize settings
% set path
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
[~,tmp]=regexp(genpath('.'),'\.\\\.git.*?;','match','split');
cellfun(@(xx) addpath(xx),tmp,'UniformOutput',false);
rmpath('.\experiment\');
close all hidden; clear all;clc;
userpath('clear');
warning('off', 'all');
%% initial State
id = 1;
particles = 50;
dt = 0.1;
ModelParam.K = 1;
Observes = cell(particles,particles);
RbotMovedStates = cell(particles,particles);
SubtractObserves =cell(particles,particles);
RobotState = [0;0;0];
MapState = [];
SetV = linspace(5,10,particles);
SetOmega1 = linspace(-pi/2,0,particles/2);
SetOmega2 = linspace(0,pi/2,particles/2);
SetOmega = [SetOmega1 SetOmega2];
% SetOmega = zeros(1,particles);
SetInput = [SetV' ,SetOmega'];
%% Environment
Env = FloorMap_sim(id,Env_FloorMap_sim(id));
%% Sensor
% LiDARParam = Sensor_LiDAR(id, struct('noise',realsqrt(1.0E-9) ));
% LiDAR = LiDAR_sim(id,LiDARParam.param);
%% Main loop
%robotをおく
RobotState;
%そこでの観測値を記録
Firstobserve = LiDAR_Do(RobotState,{Env});%初期の観測値
%---loop staert---%
% for v = 1:particles
for w = 1:particles
    %plantを動かす
    u = [SetInput(1,1),SetInput(w,2)];
    [t,Conc] = ode45(@(t,x) WheelChair_VW_model(x,u,ModelParam),[0 dt],RobotState);
    %そこでの観測値を記録
    Observes{1,w} = LiDAR_Do(Conc(end,:)',{Env});
    RbotMovedStates{1,w} = Conc(end,:);
    SubtractObserves{1,w} = Firstobserve.length - Observes{1,w}.length;
end
% end
%---loop end---%
%% Plot
figure(1)
ax = gca;
hold on;
grid on;
color = linspace(0,1,particles);
% for v = 1:particles
for w = 1:particles
    plot(0,0,'bo');
    plot(SetInput(w,2),SubtractObserves{1,w}(1),'o','Color',[color(w) color(end-w+1) color(w)]);
    plot(SetInput(w,2),SubtractObserves{1,w}(100),'o','Color',[color(w) color(end-w+1) color(w)]);
    plot(SetInput(w,2),SubtractObserves{1,w}(200),'o','Color',[color(w) color(end-w+1) color(w)]);
%     plot(SetInput(w,2),SubtractObserves{1,w}(end),'o','Color',[color(w) color(end-w+1) color(w)]);
%     plot(SetInput(w,2),max(SubtractObserves{1,w}),'o','Color',[color(w) color(end-w+1) color(w)]);
%     plot(SetInput(w,2),min(SubtractObserves{1,w}),'o','Color',[color(w) color(end-w+1) color(w)]);
%     plot(SetInput(w,2),SubtractObserves{1,w}(end),'o','Color',[color(w) color(end-w+1) color(w)]);
    %         plot3(SetInput(v,1),SetInput(w,2),SubtractObserves{v,w}(1),'ro');
    %         plot3(SetInput(v,1),SetInput(w,2),SubtractObserves{v,w}(end),'bo');
end
% end
xlabel('\omega rad/s');
ylabel('Difference between observed values');
ax.FontSize = 12;
hold off;
%%
figure(2)
hold on;
grid on;
ax = gca
Initial = plot(RobotState(1),RobotState(2),'bo');
for w = 1:particles
    Finals = plot(RbotMovedStates{1,w}(1),RbotMovedStates{1,w}(2),'o','Color',[color(w) color(end-w+1) color(w)]);
    plot([RobotState(1) RbotMovedStates{1,w}(1)],[RobotState(2) RbotMovedStates{1,w}(2)],'Color',[color(w) color(end-w+1) color(w)]);
end
xlabel('x [m]');ylabel('y [m]');
legend(Initial,'Initial State');
% legend(Finals,'Next State');
ax.FontSize = 12;
hold off
%% Local Function
function result = LiDAR_Do(PlantState,param)
% result=lidar.do(param)
%   result.region : センサー領域（センサー位置を原点とした）polyshape
%   result.length : [1 0]からの角度がangle,
%   angle_range で規定される方向の距離を並べたベクトル：単相LiDARの出力を模擬
% 【入力】param = {Env}        Plant ：制御対象， Env：環境真値
obj.radius = 40;
obj.angle_range = -pi:0.01:pi;
Plant=PlantState;
Env=param{1};
Env = Env.param;
tmp = obj.angle_range;
pos=Plant(1:2); % 実状態
circ=[obj.radius*cos(tmp);obj.radius*sin(tmp)]';
if tmp(end)-tmp(1) > pi
    %sensor_range=polyshape(circ(:,1)+pos(1),circ(:,2)+pos(2)); % エージェントの位置を中心とした円
    sensor_range=polyshape(circ(:,1),circ(:,2)); % エージェントの位置を中心とした円
else
    %sensor_range=polyshape([pos(1);circ(:,1)+pos(1)],[pos(2);circ(:,2)+pos(2)]); % エージェントの位置を中心とした円
    sensor_range=polyshape([0;circ(:,1)],[0;circ(:,2)]); % エージェントの位置を中心とした円
end
SOE = size(Env.param.Vertices,3);
%             tmpenv = zeros(1,SOE);
for ei = 1:SOE
    tmpenv(ei) = polyshape(Env.param.Vertices(:,:,ei)-pos(1:2)'); %相対的な環境
end
env = union(tmpenv(:));

result.region=intersect(sensor_range,env);
% 出力として整形
%result.region.Vertices=result.region.Vertices-pos(1:2)'; % 相対的な測距領域

%lineseg(1:2:size(circ,1)*2,:)=circ;
%in=intersect(result.region,[lineseg;0 0]);
%             index = zeros(length(circ),1);
result.angle = zeros(1,length(obj.angle_range));
for i = 1:length(circ)
    in=intersect(result.region,[circ(i,:);0 0]);
    if ~isempty(in)
        in=setdiff(in(~isnan(in(:,1)),:),[0 0],'rows'); % レーザーと領域の交点
        [~,mini]=min(vecnorm(in')');
        result.sensor_points(i,:)=in(mini,:);
        result.angle(i) = obj.angle_range(i);
        %                     index(i) = 1;
    else
        result.sensor_points(i,:) = [0 0];
    end
end
result.length=vecnorm(result.sensor_points'); % レーザー点までの距離
%             result.angle = obj.angle_range;%レーザー点の角度
%result.region=intersect(polyshape(result.sensor_points(:,1),result.sensor_points(:,2)),env); %
result.state = {};
obj.result=result;
end
%%

