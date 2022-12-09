%%　%設定
clear all
close all
agent = DRONE(Model_Drone_Exp(0.025,[0;0;0], "udp", [50,132]),DRONE_PARAM("DIATONE"));
pause(1);
agent.plant.connector.sendData(gen_msg([500,500,0,500,0,0,0,0]));% arming
agent.set_property("sensor",Sensor_tokyu(struct('DomainID',30)));
agent.set_property("sensor",Sensor_vl53l1x(1));
%% %パラメータ
dt = 0.75;%throttleの刻み時間
dt_rpm = 0.01;%rpm取得の刻み時間
time_end = 1000;%最大実行時間
throttle = 210;%最大throttle
d_throttle = 10;%throttle刻み幅
%% %初期値設定
s = 0;
i = 0;
frag_Ts = 0;
%% %ボタン設定
FH = figure('position', [0 0 eps eps], 'menubar', 'none');
disp("Press Enter");
w = waitforbuttonpress;
disp("start");
disp("arming");
%% %throttle調整+回転数を取得
agent.plant.connector.sendData(gen_msg([500,500,0,500,1000,0,0,0]));% arming
pause(5);
try
    Timer_sensor = tic;
    while toc(Timer_sensor) < time_end
        t = 0;
        Timer = tic;
        while t < dt
            while t < dt_rpm
                figure(FH)
                drawnow
                cha = get(FH, 'currentcharacter');
                if (cha == 'q')
                    close(1)
                    error("stop signal");
                end
                if(cha == 's')
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
                agent.sensor.VL.result = agent.sensor.VL.do;
                agent.sensor.tokyu.result = agent.sensor.tokyu.do;
                if isempty(agent.sensor.tokyu.result.ros2.rpm)==1
                    X1(s+1,:) = X1(s,:);
                    X2(s+1,:) = X2(s,:);
                    X3(s+1,:) = X3(s,:);
                else
                    X1(s+1,:) = agent.sensor.tokyu.result.ros2.current;
                    X2(s+1,:) = agent.sensor.tokyu.result.ros2.voltage;
                    X3(s+1,:) = agent.sensor.tokyu.result.ros2.rpm;
                end
                if isempty(agent.sensor.VL.result.VL_length)==1
                    X4(s+1,:) = X4(s,:);
                else
                    X4(s+1,:) = agent.sensor.VL.result.VL_length;
                end
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
        if i == throttle
            agent.plant.connector.sender(gen_msg([500,500,i,500,1000,0,0,0]));
        else
            agent.plant.connector.sender(gen_msg([500,500,i,500,1000,0,0,0]));
            i = i + d_throttle;
        end        
    end
catch ME
    Ts_end = toc(Timer_sensor);
    agent.plant.connector.sender(gen_msg([500,500,0,500,0,0,0,0]));
    rethrow(ME);
end

%% %figure出力
figure(2)
hold on
plot(T,X1)%グラフのプロット
% ymax = ylim;
% area([Ts Ts_end],[ymax(2) ymax(2)],FaceColor = "red",LineStyle = "none",Facealpha = 0.1);
legend('morter 1','morter 2','morter 3','morter 4')
legend('Location','best')
xlabel('time [s]')
ylabel('current')
hold off

figure(3)
hold on
plot(T,X2)%グラフのプロット
% ymax = ylim;
% area([Ts Ts_end],[3000 3000],FaceColor = "red",LineStyle = "none",Facealpha = 0.1);
legend('morter 1','morter 2','morter 3','morter 4')
legend('Location','best')
xlabel('time [s]')
ylabel('voltage')
hold off

figure(4)
hold on
plot(T,X3,'LineWidth',1)%グラフのプロット
plot(T,X4,'LineWidth',1)%グラフのプロット
%plot(T,X3Ave,'LineWidth',1)
% ymax = ylim;
% area([Ts Ts_end],[ymax(2) ymax(2)],FaceColor = "red",LineStyle = "none",Facealpha = 0.1);
legend('morter 1','morter 2','morter 3','morter 4','distance ceiling')%,'average')
legend('Location','best')
xlabel('time [s]')
ylabel('morter speed [rpm]')
hold off