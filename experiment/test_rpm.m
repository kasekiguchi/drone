clear all
close all
agent = DRONE(Model_Drone_Exp(0.025,[0;0;0], "udp", [50,132]),DRONE_PARAM("DIATONE"));
pause(1);
agent.set_property("sensor",Sensor_tokyu(struct('DomainID',30)));
FH = figure('position', [0 0 eps eps], 'menubar', 'none');
type receiver
dt = 0.01;%刻み時間
end_time = 100;%終了時間
frag_Ts = 0;
%%
disp("Press Enter");
w = waitforbuttonpress;
disp("start");
try
    Timer_sensor = tic;%時間の定義
    s=0;
    while toc(Timer_sensor) < end_time%刻み時間分の
        t = 0;
        Timer = tic;
        while t < dt
            figure(FH)
            drawnow
            cha = get(FH, 'currentcharacter');
            if (cha == 'q')
                close(1)
                error("stop signal");
            end
            if(cha == 's')
                if frag_Ts ~= 1
                    Ts = toc(Timer_sensor);
                    frag_Ts =1;
                end
            end
            t = toc(Timer);
        end
        T(s+1) = toc(Timer_sensor);%時間
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
        %disp(X3(s+1,:));
        s=s+1;
    end
catch ME
    agent.plant.connector.sender(gen_msg([500,500,0,500,0,0,0,0]));
    rethrow(ME);
end
%%
% % plot
figure(2)
hold on
plot(T,X1)%グラフのプロット
ymax = ylim;
area([Ts Ts+5],[ymax(2) ymax(2)],FaceColor = "red",LineStyle = "none",Facealpha = 0.1);
legend('morter 1','morter 2','morter 3','morter 4')
xlabel('time [s]')
ylabel('current')
hold off

figure(3)
hold on
plot(T,X2)%グラフのプロット
ymax = ylim;
area([Ts Ts+5],[3000 3000],FaceColor = "red",LineStyle = "none",Facealpha = 0.1);
legend('morter 1','morter 2','morter 3','morter 4')
xlabel('time [s]')
ylabel('voltage')
hold off

figure(4)
hold on
plot(T,X3)%グラフのプロット
ymax = ylim;
area([Ts Ts+5],[ymax(2) ymax(2)],FaceColor = "red",LineStyle = "none",Facealpha = 0.1);
legend('morter 1','morter 2','morter 3','morter 4')
xlabel('time [s]')
ylabel('morter speed [rpm]')
hold off
%%
X1A=X1(A,:);
X2A=X2(A,:);
X3A=X3(A,:);
TA=T(:,A);
mean(X1A)
mean(X2A)
mean(X3A)