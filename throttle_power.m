%%　%設定
clear all
close all
agent = DRONE(Model_Drone_Exp(0.025,[0;0;0], "udp", [100,252]),DRONE_PARAM("DIATONE"));%ドローンの定義
pause(1);
agent.plant.connector.sendData(gen_msg([500,500,0,500,0,0,0,0]));% arming
agent.set_property("sensor",Sensor_Flightcontroller(struct('DomainID',40)));%センサー定義
% agent.set_property("sensor",Sensor_vl53l1x(1));
%% %パラメータ
dt = 0.75;%throttleの上昇の刻み時間
dt_rpm = 0.01;%rpm取得の刻み時間
time_end = 1000;%最大実行時間
throttle = 210;%throttleの最大値
d_throttle = 10;%throttle刻み幅
%% %初期値設定
s = 0;i = 0;frag_Ts = 0;
%% %ボタン設定
FH = figure('position', [0 0 eps eps], 'menubar', 'none');%キー入力
disp("Press Enter");%表示
w = waitforbuttonpress;
disp("start");
disp("arming");
%% %throttle調整+回転数を取得
agent.plant.connector.sendData(gen_msg([500,500,0,500,1000,0,0,0]));% arming入力
pause(5);
try
    Timer_sensor = tic;%時間
    while toc(Timer_sensor) < time_end
        t = 0;
        Timer = tic;
        while t < dt
            while t < dt_rpm
                figure(FH)
                drawnow
                cha = get(FH, 'currentcharacter');
                if (cha == 'q')%"q"を押したら緊急停止
                    close(1)
                    error("stop signal");
                end
                if(cha == 's')%"s"を押したらセンサーの測定開始
                    if frag_Ts == 0
                        Timer_sensor_rpm = tic; 
                        Ts = toc(Timer_sensor);
                        frag_Ts =1;
                    end
                end
                t = toc(Timer);
            end
            if(cha == 's')
                if frag_Ts == 0
                    Timer_sensor_rpm = tic;
                    Ts = toc(Timer_sensor);
                    frag_Ts =1;
                end
            end
            if(cha == 's')
                T(s+1) = toc(Timer_sensor_rpm);
%                 agent.sensor.VL.result = agent.sensor.VL.do;
                agent.sensor.flightcontroller.result = agent.sensor.flightcontroller.do;
                if isempty(agent.sensor.flightcontroller.result.ros2.rpm)==1
                    current(s+1,:) = current(s,:);
                    voltage(s+1,:) = voltage(s,:);
                    rpm(s+1,:) = rpm(s,:);
                    power(s+1,:) = power(s,:);
                else
                    current(s+1,:) = agent.sensor.flightcontroller.result.ros2.current/100;
                    voltage(s+1,:) = agent.sensor.flightcontroller.result.ros2.voltage/100;
                    rpm(s+1,:) = agent.sensor.flightcontroller.result.ros2.rpm;
                    power(s+1,:) = current(s+1,:).*voltage(s+1,:);
                end
                if(power(s+1,:)>880)
                    close(1)
                    error("over power");
                end
%                 if isempty(agent.sensor.VL.result.VL_length)==1
%                     X4(s+1,:) = X4(s,:);
%                 else
%                     X4(s+1,:) = agent.sensor.VL.result.VL_length;
%                 end
                s=s+1;
            end
            figure(FH)
            drawnow
            cha = get(FH, 'currentcharacter');
            if (cha == 'q')
                error("ASCL : stop signal");
            end
            t = toc(Timer);
        end
        disp(i)
        if i == throttle%throttleが設定に達しているか判別
            agent.plant.connector.sender(gen_msg([500,500,i,500,1000,0,0,0]));%一定のthrottleを入力
        else
            agent.plant.connector.sender(gen_msg([500,500,i,500,1000,0,0,0]));%throttleを入力
            i = i + d_throttle;
        end        
    end
catch ME %停止コマンドを押したときに実行
    Ts_end = toc(Timer_sensor);
    agent.plant.connector.sender(gen_msg([500,500,0,500,0,0,0,0]));
    rethrow(ME);
end

%% %figure出力
figure(2)
hold on
plot(T,current)%グラフのプロット
% ymax = ylim;
% area([Ts Ts_end],[ymax(2) ymax(2)],FaceColor = "red",LineStyle = "none",Facealpha = 0.1);
legend('morter 1','morter 2','morter 3','morter 4')
legend('Location','best')
xlabel('time [s]')
ylabel('current')
hold off

figure(3)
hold on
plot(T,voltage)%グラフのプロット
% ymax = ylim;
% area([Ts Ts_end],[3000 3000],FaceColor = "red",LineStyle = "none",Facealpha = 0.1);
legend('morter 1','morter 2','morter 3','morter 4')
legend('Location','best')
xlabel('time [s]')
ylabel('voltage')
hold off

figure(4)
hold on
plot(T,rpm,'LineWidth',1)%グラフのプロット
% plot(T,X4,'LineWidth',1)%グラフのプロット
%plot(T,X3Ave,'LineWidth',1)
% ymax = ylim;
% area([Ts Ts_end],[ymax(2) ymax(2)],FaceColor = "red",LineStyle = "none",Facealpha = 0.1);
legend('morter 1','morter 2','morter 3','morter 4','distance ceiling')%,'average')
legend('Location','best')
xlabel('time [s]')
ylabel('morter speed [rpm]')
hold off

figure(5)
hold on
plot(T,power)%グラフのプロット
legend('morter 1','morter 2','morter 3','morter 4')
legend('Location','best')
xlabel('time [s]')
ylabel('power')
hold off