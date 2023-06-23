%% 
clf
clc
clear
close all
%% シミュレーションのパラメータを設定


dt = 0.05;
maxt =50;
t = 0:dt:maxt;
sensor_num = 2; % センサの本数([1 0 0]から反時計回り)
mode = 1; %1でdirect
verification = 0; % 交差検証するかどうかのフラグ
record = 0; % データ生成どーがのフラグ
lidar_noize = 0;
zusi = 0;
if mode == 0
    % システム行列
    A = eye(6);
    B = [eye(3)*dt ,zeros(3);
         zeros(3), eye(3)*dt]; 
    C = eye(6);
    D = zeros(6,3);
else
    A = zeros(6);
    B = eye(6); 
    C = eye(6);
    D = zeros(6,3);
end
% 初期状態やノイズ, オフセット
x = [0;0;0;0;0;0]; % x,y,z,roll,pitch,yaw
offset = [0.5;0.1;0.2];  % オフセット
offset_att = [0;0;10]*pi/180;
wk = 0.05 * eye(length(A)); % システムノイズ
att=1; %センサ間の角度°
dir = zeros(3,sensor_num);% レーザセンサの方向ベクトル
R_sens = zeros(3,3,sensor_num);
for len=1:sensor_num
    % R_num = rot3(0,0,(att*len-att)*pi/180);
    R_num = RodriguesQuaternion(Eul2Quat([0,0,(att*len-att)*pi/180]'));
    dir(:,len) = R_num * [1;0;0];
    % R_sens(:,:,len) = rot3(offset_att(1)*pi/180,offset_att(2)*pi/180,(offset_att(3)+(att*len-att))*pi/180);
    % R_sens(:,:,len) = R_num * rot3(offset_att(1)*pi/180,offset_att(2)*pi/180,offset_att(3)*pi/180);
    R_sens(:,:,len) = R_num * RodriguesQuaternion(Eul2Quat(offset_att'));
end
% ノイズの共分散
% sigma_p = 0.1; % SD of process noise for v
% sigma_a = 0.4; % SD of process noise for dw/dt
% sigma_x = 1; % SD of observation noise for x
% sigma_y = 1; % SD of observation noise for y
% Qk = diag([sigma_p,sigma_a].^2); % Process noise  covariance matrix
% Rk = diag([sigma_x, sigma_y].^2); % Observatio noise covariance matrix


% 壁面パラメータ
wall_param =[1,0.04,0.01,-20;
             0.01,1,0.01,-15;
            1,0.03,0.01,12;
            0.01,1,0.001,13];
             
            %  0,1,0,10];
% 回転
% R2 = rot3(0,0,att*pi/180);
R2 = RodriguesQuaternion(Eul2Quat([0,0,att*pi/180]'));
% R3 = rot3(0,0,2*att*pi/180);
R3 = RodriguesQuaternion(Eul2Quat([0,0,2*att*pi/180]'));
% データを保存する変数
robot_pos = zeros(3,length(t));
robot_attitude = zeros(3,length(t));
laser_pos = zeros(3,length(t));
sensor_data = zeros(1,length(t),sensor_num);
laser_dir = zeros(3,length(t),sensor_num);
intersec = zeros(3,length(t),sensor_num);
angle = zeros(1,length(t),sensor_num);
pr = zeros(3,length(t));
attr = zeros(3,length(t));

i=1;
%% ここからシミュレーション
for i2 = 0:dt:maxt
    % 入力
%     upose = [6*cos(i);3*sin(i);3*sin(i)];
    % pr(1,i) = 0;
    % pr(2,i) = 0;
    % pr(3,i) =0;
    T = 30;
    w = 2*pi/T;
    % if i2<maxt/2
    pr(1,i) = 8*cos(w*i2 -pi);
    pr(2,i) = 8*sin(w*i2-pi);
    pr(3,i) =5*sin(2*w*i2-pi/2)+7;
    attr(1,i) = 0;
    attr(2,i) = 0;
    attr(3,i) =0;
    % attr(1,i) = 10*sin(w/2*i2-pi);
    % attr(2,i) = 15*sin(w*i2);
    % attr(3,i) =20*cos(w*i2-pi);
    upose =[pr(1,i) ;pr(2,i);pr(3,i)];
    uatt = [attr(1,i);attr(2,i);attr(3,i)];
    % uatt = [0;0;1.5*sin(i)];
    u = [upose;uatt];
%     u = input();
       
%     upose =[];
%     uatt = [];
%     u = [upose;uatt];
    % ロボットの状態を更新
    
    x = A * x + B * u  + wk * randn(length(A),1);
    % ロボットの位置と姿勢を保存
    robot_pos(:,i) = x(1:3);
    robot_attitude(:,i) = x(4:6);
    % ロボット座標系への回転行列
    % R = rot3(x(4)*pi/180,x(5)*pi/180,x(6)*pi/180);
    R = RodriguesQuaternion(Eul2Quat(pi/180*x(4:6)'));
    % センサノイズ
    if lidar_noize == 1
        rk = 0.05 ;
    else
        rk = 0 ;
    end

    Storage = zeros(9,size(wall_param,1),sensor_num);% 交点たちを保存する格納
    for l=1:sensor_num
        % レーザの方向を姿勢行列から計算
        laser_dir(:,i,l) = R * R_sens(:,:,l) *  dir(:,1);
        for k = 1:size(wall_param,1)
            [intersection, dist, pos_lidar, ang,flag] = calc_intersection(x(1:3), laser_dir(:,i,l), offset, R, wall_param(k,:));
            len_robot_int = norm(intersection-robot_pos(:,i));
            Storage(:,k,l)=[intersection;dist; pos_lidar; ang;flag];
        end
        [sensor_data(:,i,l),I] = min(Storage(4,:,l)) ; 
        sensor_data(:,i,l) = sensor_data(:,i,l)+rk*rand(1);
        intersec(:,i,l) = Storage(1:3,I,l);
        angle(:,i,l)= Storage(8,I,l);
    end
    laser_pos(:,i) = pos_lidar;
    i=i+1;
end

%% 回帰分析
[known,X,X_r,A_s,X_s] = param_outputeq(robot_pos, robot_attitude, sensor_data(:,:,1),NaN); 
AA = estps([robot_pos',robot_attitude'*(pi/180),sensor_data(:,:,1)']);
XX = pinv(AA)*(-1*ones(size(AA,1),1));
% sensor_data_s = smoothdata(sensor_data(:,:,1));
% pos_s = [sgolayfilt(robot_pos(1,:),5,31);sgolayfilt(robot_pos(2,:),5,31);sgolayfilt(robot_pos(3,:),5,31)];
% att_s = [sgolayfilt(robot_attitude(1,:),5,31);sgolayfilt(robot_attitude(2,:),5,31);sgolayfilt(robot_attitude(3,:),5,31)];
% sensor_data_s = sgolayfilt(sensor_data(:,:,1),5,31);
% [knownS,XS,XS_r,A_sr,X_sr] = param_outputeq(pos_s, att_s, sensor_data_s,NaN); 

[known2,X2,X2_r,A_s2,X_s2] = param_outputeq(robot_pos, robot_attitude, sensor_data(:,:,2),R2);
% [known3,X3,X3_r,A_s3,X_s3] = param_outputeq(robot_pos, robot_attitude, sensor_data(:,:,3),R3);
%% 未知パラメータの数値解と2ベクトル間の類似度
X_true=[wall_param(1,1)/wall_param(1,4), wall_param(1,2)/wall_param(1,4), wall_param(1,3)/wall_param(1,4), (wall_param(1,1)*offset(1))/wall_param(1,4), (wall_param(1,1)*offset(2))/wall_param(1,4), (wall_param(1,1)*offset(3))/wall_param(1,4), (wall_param(1,2)*offset(1))/wall_param(1,4), (wall_param(1,2)*offset(2))/wall_param(1,4), (wall_param(1,2)*offset(3))/wall_param(1,4), (wall_param(1,3)*offset(1))/wall_param(1,4), (wall_param(1,3)*offset(2))/wall_param(1,4), (wall_param(1,3)*offset(3))/wall_param(1,4), (R_sens(1,1)*wall_param(1,1))/wall_param(1,4), (R_sens(2,1)*wall_param(1,1))/wall_param(1,4), (R_sens(3,1)*wall_param(1,1))/wall_param(1,4), (R_sens(1,1)*wall_param(1,2))/wall_param(1,4), (R_sens(2,1)*wall_param(1,2))/wall_param(1,4), (R_sens(3,1)*wall_param(1,2))/wall_param(1,4), (R_sens(1,1)*wall_param(1,3))/wall_param(1,4), (R_sens(2,1)*wall_param(1,3))/wall_param(1,4), (R_sens(3,1)*wall_param(1,3))/wall_param(1,4)]';
[MSE,CC,COS] = computeErrorMetrics(X, X_true);
answer = [rank(known),MSE,CC,COS];
% [MSES,CCS,COSS] = computeErrorMetrics(XS, X_true);
% answerS = [rank(knownS),MSES,CCS,COSS];
offset_esta = [X(4)/X(1);X(5)/X(1);X(6)/X(1);];
offset_estb = [X(7)/X(2);X(8)/X(2);X(9)/X(2);];
offset_estc = [X(10)/X(3);X(11)/X(3);X(12)/X(3);];
offset_est = pinv([X(1)*eye(3);X(2)*eye(3);X(3)*eye(3)])*[X(4:6);X(7:9);X(10:12)];
% offset_estS = pinv([XS(1)*eye(3);XS(2)*eye(3);XS(3)*eye(3)])*[XS(4:6);XS(7:9);XS(10:12)];
R_sens_est1a = [X(13)/X(1),X(14)/X(1),X(15)/X(1)];
R_sens_est1b = [X(16)/X(2),X(17)/X(2),X(18)/X(2)];
R_sens_est1c = [X(19)/X(3),X(20)/X(3),X(21)/X(3)];
R_sens_est1 = [R_sens_est1a;R_sens_est1b;R_sens_est1c];
% X1315=[X(13:15),X2(13:15),X3(13:15)];
% X13=[X(1:3),R2'*X2(1:3),R3'*X3(1:3)];
% R_sens_est = (X1315*inv(X13))';
% R_sens_est = X(1:3)*pinv(X(13:15));
% computeErrorMetrics(R_sens_est,R_sens(:,:,1))
%% 図示
if zusi ==1
    fig1=figure(1);
    fig1.Color = 'white';
    plot3(robot_pos(1,:),robot_pos(2,:),robot_pos(3,:) ,'LineWidth', 2);
    xlabel('\it{x} [m]');
    ylabel('\it{y} [m]');
    zlabel('\it{z} [m]');
    grid on;
    % 結果をプロット
    % fig2=figure(2);
    % fig2.Color = 'white';
    % plot_wall(wall_param);
    % xlim([-10 10])
    % ylim([-10 10])
    % zlim([-10 10])
    % grid on;
    fig3=figure(3);
    fig3.Color = 'white';
    plot_sensor_data(t,sensor_data(:,:,1));
    hold on;
    plot_sensor_data(t,sensor_data(:,:,2));
    % plot_sensor_data(t,sensor_data(:,:,3));
    hold off;
    xlim([0 maxt]);
    xlabel('time [sec]','FontSize', 14);
    ylabel('Distance of the lidar [m]','FontSize', 14);
    legend('Sensor data1','Sensor data2');
    grid on;
    fig4=figure(4);
    fig4.Color = 'white';
    plot(t,pr(1,:),'LineWidth', 2)
    hold on;
    plot(t,pr(2,:),'LineWidth', 2);
    plot(t,pr(3,:),'LineWidth', 2);
    legend('\it{x}','\it{y}','\it{z}','FontSize', 18);
    xlim([0 10])
    grid on;
    xlabel('time [sec]','FontSize', 14);
    ylabel('Reference values of position [m]','FontSize', 14);
    hold off;
    fig5=figure(5);
    fig5.Color = 'white';
    plot(t,attr(1,:),'LineWidth', 2);
    hold on;
    plot(t,attr(2,:),'LineWidth', 2);
    plot(t,attr(3,:),'LineWidth', 2);
    legend('\it{\phi}','\it{\theta}','\it{\psi}','FontSize', 18);
    xlim([0 10])
    grid on;
    xlabel('time [sec]','FontSize', 14);
    ylabel('Reference values of attitude angle [deg]','FontSize', 14);
    hold off;
    fig6=figure(6);
    fig6.Color = 'white';
    plot(t,robot_pos(1,:),'LineWidth', 2)
    hold on;
    plot(t,robot_pos(2,:),'LineWidth', 2);
    plot(t,robot_pos(3,:),'LineWidth', 2);
    % plot(t,sgf(1,:),'LineWidth', 2);
    % plot(t,sgf(2,:),'LineWidth', 2);
    % plot(t,sgf(3,:),'LineWidth', 2);
    legend('\it{px}','\it{py}','\it{pz}','FontSize', 18);
    xlim([0 30])
    grid on;
    xlabel('time [sec]','FontSize', 14);
    ylabel('Position [m]','FontSize', 14);
    hold off;
    fig7=figure(7);
    fig7.Color = 'white';
    plot(t,robot_attitude(1,:),'LineWidth', 2);
    hold on;
    plot(t,robot_attitude(2,:),'LineWidth', 2);
    plot(t,robot_attitude(3,:),'LineWidth', 2);
    legend('\it{w}_{\it{\phi}}','\it{w}_{\it{\theta}}','\it{w}_{\it{\psi}}','FontSize', 18);
    xlim([0 30])
    grid on;
    xlabel('time [sec]','FontSize', 14);
    ylabel('Attitude angle [deg]','FontSize', 14);
    hold off;

end
fig2=figure(2);
fig2.Color = 'white';
plot_wall(wall_param(1,:));
hold on;
plot_wall(wall_param(2,:));
plot_wall(wall_param(3,:));
plot3(robot_pos(1,:),robot_pos(2,:),robot_pos(3,:) ,'LineWidth', 2);
xlim([-15 18])
ylim([-15 18])
zlim([-15 18])
xlabel('\it{x} [m]','FontSize', 14);
ylabel('\it{y} [m]','FontSize', 14);
zlabel('\it{z} [m]','FontSize', 14);
grid on;
%% 動画
if record ==1
    v = VideoWriter('sensordata','MPEG-4');
    v.Quality = 100;
    v.FrameRate = 10;
    open(v)
    for vn = 1:length(t)
        figure(2);
        xlabel('\it{x} [m]','FontSize', 14);
        ylabel('\it{y} [m]','FontSize', 14);
        zlabel('\it{z} [m]','FontSize', 14);
        % fig6.Color = 'white';
        hold on;
        % plot_wall(wall_param);
        for j = 1:size(wall_param,1)
            plot_wall(wall_param(j,:));
        end
        % plot_wall(wall_param);
        xlim([-3 12])
        ylim([-5 4])
        zlim([-5 4])
        plot_robot_position(robot_pos(:,vn));
%         plot_lidar(laser_pos(:,vn), intersec(:,vn))
        line = plot3([robot_pos(1,vn), intersec(1,vn)], [robot_pos(2,vn), intersec(2,vn)], [robot_pos(3,vn), intersec(3,vn)], 'r', 'LineWidth', 2);
        plot3(intersec(1,vn),intersec(2,vn),intersec(3,vn),'r*');
        % title('Acquisition of wall surface data by LiDAR')
        frame = getframe(gcf);
        writeVideo(v,frame);
        delete(line)
    end
    hold off;
    close(v)
end

%% クロスバリデーション
if verification == 1
    disp('Cross-validate parameter functions')
    % データを保存する変数
    x2 = [0;0;0;0;0;0]; % x,y,z,roll,pitch,yaw
    robot_pos2 = zeros(3,length(t));
    robot_attitude2 = zeros(3,length(t));
    sensor_data2 = zeros(1,length(t));
    laser_pos2 = zeros(3,length(t));
    laser_dir2 = zeros(3,length(t));
    inteR_sensec2 = zeros(3,length(t));
    angle2 = zeros(1,length(t));
    for i = 1:length(t)
        % 入力
        upose2 = [3*cos(i);3*sin(i);cos(i)];
        uatt2 = [0;0;0];
        u2 = [upose2;uatt2];
    %     u = input();

    %     upose =[];
    %     uatt = [];
    %     u = [upose;uatt];
        % ロボットの状態を更新
        x2 = A * x2 + B * u2;

        % ロボットの位置と姿勢を保存
        robot_pos2(:,i) = x2(1:3);
        robot_attitude2(:,i) = x2(4:6);

        % レーザの方向を姿勢行列から計算
        R = rot3(x(4)*pi/180,x(5)*pi/180,x(6)*pi/180);
        laser_dir2(:,i) = R * dir;

        % レーザと壁面の交点を計算
        Storage2 = zeros(9,size(wall_param,1));% 交点たちを保存する格納
        for k = 1:size(wall_param,1)
        [intersection, dist, pos_lidar, ang] = calc_intersection(x2(1:3), laser_dir2(:,i), offset, R, a, b, c, d);
        Storage2(:,k) = [intersection, dist, pos_lidar, ang];
        end
        % 交点とセンサデータを保存
        laser_dir2(:,i) = R * dir;
        sensor_data2(i) = dist;
        inteR_sensec2(:,i) = intersection;
        laser_pos2(:,i) = pos_lidar;
        angle2(i)= ang;
    end
    [known2,X2] = param_outputeq(robot_pos2, robot_attitude2, sensor_data2);
%     known2*X
%     known*X2
else
     disp('Passed cross-validate parameter functions')
end
%% 関数たち
% 壁をプロットする関数 よくわからん未完成
function plot_wall(wall_param)
    for k = 1 : size(wall_param,1)
        a = wall_param(k,1);
        b = wall_param(k,2);
        c = wall_param(k,3);
        d = wall_param(k,4);
        % a,b,c,dを引数とする平面方程式のプロット
        % a,b,c,dは実数とする
        if (a~=0) || (c~=0)
        % x,yの値を生成する
            [x,z] = meshgrid(-10000:1000:10000);

            % 分母が0になる場合に備えて、分母が非ゼロの場合にのみ計算を行う
        
            y = -(a*x + c*z + d) / b;

            % 平面を描画する
            surf(x, y, z);
            xlabel('x');
            ylabel('y');
            zlabel('z');
            hold on;
        end
        if (b==0) || (c==0)
        % x,yの値を生成する
            [y,z] = meshgrid(-10000:1000:10000);

            % 分母が0になる場合に備えて、分母が非ゼロの場合にのみ計算を行う
            if a ~= 0
                 x = -(c*z + b*y + d) / a;

                % 平面を描画する
                surf(x, y, z);
                xlabel('x');
                ylabel('y');
                zlabel('z');
                hold on;
            end
        end
    end
end
% センサデータをプロットする関数
function plot_sensor_data(t,sensor_data)
    plot(t,sensor_data);
end

% ロボットをプロットする関数
function plot_robot_position(robot_pos)
    x = robot_pos(1);
    y = robot_pos(2);
    z = robot_pos(3);
    plot3(x,y,z,'-bo')
end

function plot_lidar(robot_pos, intersection)
    % point1とpoint2は、それぞれ[x1, y1, z1]と[x2, y2, z2]の形式で与えられる、二点の座標ベクトル
    % x,y,z座標を抽出する
    x = [robot_pos(1), intersection(1)];
    y = [robot_pos(2), intersection(2)];
    z = [robot_pos(3), intersection(3)];
    % 線
    plot3(x, y, z, 'r', 'LineWidth', 2);
    plot3(intersection(1),intersection(2),intersection(3),'r*');
end
% 姿勢
function R  = rot3(roll,pitch,yaw)
    
    Rz = [cos(yaw) -sin(yaw) 0; sin(yaw) cos(yaw) 0; 0 0 1];
    Ry = [cos(pitch) 0 -sin(pitch); 0 1 0; sin(pitch) 0 cos(pitch)];
    Rx = [1 0 0; 0 cos(roll) -sin(roll); 0 sin(roll) cos(roll)];
    R = Rz * Ry * Rx;
    
end

% レーザと壁の交点と距離もとめｒ関数
function [intersection, dist, pos_lidar, ang, flag] = calc_intersection(pos, laser_dir, offset, R, wall_param)
%     arguments
%         flag1
%     end
    clear intersection;
    a = wall_param(1);
    b = wall_param(2);
    c = wall_param(3);
    d = wall_param(4);
    n = [a;b;c]; % 平面の法線ベクトル
    ang = acos((dot(laser_dir,n))/norm(laser_dir)*norm(n)); % 二つのベクトルの(lidarと壁)なす角の計算
    flag = dot(laser_dir,n);
    pos_lidar = pos + R * offset;
    % 当たり判定によってけいさんするかどうか
    x0 = pos_lidar(1);
    y0 = pos_lidar(2);
    z0 = pos_lidar(3);
    % レーザ線の式: r = pos + t * laser_dir
    % 壁面の式: ax + by + cz + d = 0
    % 両式を等しくすると、tを解くことで交点を求めru
    t = - (a*x0 + b*y0 + c*z0 + d) / (a*laser_dir(1) + b*laser_dir(2) + c*laser_dir(3));
    intersection = pos_lidar + t*laser_dir;
    dist = norm(intersection - pos_lidar); % 距離=センサ情報もとめてら
    vector = (intersection - pos_lidar);
    flag  =  dot(vector,laser_dir);
    ang = acos((dot(vector ,n))/norm(vector )*norm(n));
    % if (ang < pi/2) | (ang > 1.5*pi)
    % if flag > 0
    %     intersection = intersection;
    %     dist = dist % 距離=センサ情報もとめてら
    %     % レーザが壁面に当たっていない場合は、距離を無限大として返す
    %     if (dist > 1.0e10) | (flag < 0)
    %         dist = inf;
    %      end
     if (flag <= 0) | (dist>40)
        x0 = pos_lidar(1);
        y0 = pos_lidar(2);
        z0 = pos_lidar(3);
        % レーザ線の式: r = pos + t * laser_dir
        % 壁面の式: ax + by + cz + d = 0
        % 両式を等しくすると、tを解くことで交点を求めru

        t = - (a*x0 + b*y0 + c*z0 + d) / (a*laser_dir(1) + b*laser_dir(2) + c*laser_dir(3));
        intersection = pos_lidar + t*laser_dir;
        dist = norm(intersection - pos_lidar); % 距離=センサ情報もとめてら
        vector = (intersection - pos_lidar);
        flag  =  dot(vector,laser_dir);
        ang = acos((dot(vector,n))/norm(vector)*norm(n));
        intersection= [inf;inf;inf];
        dist = inf;
        flag=inf;
    end
end

% パラメータ行列求める関数
function [A,X,X_r,Cf,var] = param_outputeq(robot_pos, robot_attitude, sensor_data,R_num)
    syms p [3 1] real
    syms Rb [3 3] real
    syms y real 
    
    syms R_sens [3 3] real
    syms psb [3 1] real
    syms a b c d real
    if isnan(R_num)
        % R_num = rot3(0,0,0);
        R_num = RodriguesQuaternion(Eul2Quat([0,0,0]'));
    end
    A = [a b c];
    X = p +Rb*psb + y*Rb*R_sens*R_num*[1;0;0];
    %%
    eq = [A d]*[X;1];
    clear Cf
    var=[a.*psb',b.*psb',c.*psb',reshape(a*R_sens,1,numel(R_sens)),reshape(b*R_sens,1,numel(R_sens)),reshape(c*R_sens,1,numel(R_sens))];
    for j = 1:length(var)
        Cf(j) = subs(simplify(eq-subs(expand(eq),var(j),0)),var(j),1);
    end
    Cf = [p1,p2,p3,Cf];
    ds=find(Cf==0);
    Cf(ds)=[];
    var = [a,b,c,var]/d;
    var(ds)=[];
    A = zeros(size(robot_pos,2),size(Cf,2));
    B = zeros(size(robot_pos,2),1);
    for i =1:size(robot_pos,2)
            % clear Cfc 
            % Cfc = Cf
            % subs(p,robot_pos(:,i));
            % q = robot_attitude(:,i);
            % subs(y,sensor_data(i));
            % subs(Rb,rot3(q(1),q(2),q(3)));
            pb=robot_pos(:,i);
            q = robot_attitude(:,i);
            r = sensor_data(i);
            % R = rot3(q(1)*pi/180,q(2)*pi/180,q(3)*pi/180);
            R = RodriguesQuaternion(Eul2Quat((pi/180)*q'));
            % [pb(1),pb(2),pb(3),R(1,1),R(1,2),R(1,3),R(2,1),R(2,2),R(2,3),R(3,1),R(3,2),R(3,3),r]
            Cfc = subs(Cf,{p1, p2, p3, Rb1_1, Rb1_2, Rb1_3, Rb2_1, Rb2_2, Rb2_3, Rb3_1, Rb3_2, Rb3_3, y},{pb(1),pb(2),pb(3),R(1,1),R(1,2),R(1,3),R(2,1),R(2,2),R(2,3),R(3,1),R(3,2),R(3,3),r});
            % Cfc = [p1, p2, p3, Rb1_1, Rb1_2, Rb1_3, Rb2_1, Rb2_2, Rb2_3, Rb3_1, Rb3_2, Rb3_3, Rb1_1*y, Rb1_2*y, Rb1_3*y, Rb2_1*y, Rb2_2*y, Rb2_3*y, Rb3_1*y, Rb3_2*y, Rb3_3*y]
            %とりあえずz軸回転だけ
            A(i,:) = Cfc;
            B(i,:) = -1;
    end
    % % var(ds)=[];
    X = pinv(A)*B;%疑似逆行列の計算
    alpha= 12;
    X_r = inv((A'*A + alpha*eye(length(A'*A))))*A'*B;
    % syms XL [15 1] real
    % X_l = min((A*XL-B)^2+alpha2*sumabs(XL));
end

% 二つのベクトルの類似度を計算する関数
function [mse, correlation,cosine_similarity] = computeErrorMetrics(estimated, actual)
    % 平均二乗誤差（Mean Squared Error）
    squaredError = (estimated - actual).^2;
    mse = mean(squaredError);

    % 相関係数（Correlation Coefficient）
    correlation = corrcoef(estimated, actual);
    correlation = correlation(1, 2);

    % コサイン類似度の計算
    cosine_similarity = dot(estimated, actual) / (norm(estimated) * norm(actual));

    % ピアソン相関係数の計算
    % peaR_senson_correlation = corrcoef(estimated, actual);
    % peaR_senson_correlation = peaR_senson_correlation(1, 2); % 行列から相関係数の値を取得
end

%var = [a/d, b/d, c/d, (a*psb1)/d, (a*psb2)/d, (a*psb3)/d, (b*psb1)/d, (b*psb2)/d, (b*psb3)/d, (c*psb1)/d, (c*psb2)/d, (c*psb3)/d, (R_sens1_1*a)/d, (R_sens2_1*a)/d, (R_sens3_1*a)/d, (R_sens1_1*b)/d, (R_sens2_1*b)/d, (R_sens3_1*b)/d, (R_sens1_1*c)/d, (R_sens2_1*c)/d, (R_sens3_1*c)/d]