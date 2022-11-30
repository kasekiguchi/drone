clear all
close all
dt = 0.75;
throttle = 150;
agent = DRONE(Model_Drone_Exp(0.025,[0;0;0], "udp", [50,132]),DRONE_PARAM("DIATONE"));
agent1 = DRONE(Model_Drone_Exp(0.025,[0;0;0], "udp", [50,131]),DRONE_PARAM("DIATONE"));
%%
pause(1);
agent.plant.connector.sendData(gen_msg([500,500,0,500,0,0,0,0]));% 0入力
FH = figure('position', [0 0 eps eps], 'menubar', 'none');
disp("Press Enter");
w = waitforbuttonpress;
disp("start");
disp("arming");
agent.plant.connector.sendData(gen_msg([500,500,0,500,1000,0,0,0]));% arming
pause(5);
%%
try
    for i = 0:10:throttle
        t = 0;
        Timer = tic;

        while t < dt
            drawnow
            cha = get(FH, 'currentcharacter');
            if (cha == 'q')
                error("ASCL : stop signal");
            end
            t = toc(Timer);
        end
        disp(i)
        agent.plant.connector.sender(gen_msg([500,500,i,500,1000,0,0,0]));
        while i == throttle
            agent.plant.connector.sender(gen_msg([500,500,i,500,1000,0,0,0]));
            drownow
            figure(FH)
            w = waitforbuttonpress;
            cha = get(FH, 'currentcharacter');
            if (cha == 'q')
                    error("ASCL : stop signal");
            elseif (cha == '1')
                agent1.plant.connector.sendData(uint8(10));
                disp(cha);
            elseif (cha == '2')
                agent1.plant.connector.sendData(uint8(20));
                disp(cha);
            elseif (cha == '3')
                agent1.plant.connector.sendData(uint8(30));
                disp(cha);
            elseif (cha == '4')
                agent1.plant.connector.sendData(uint8(40));
                disp(cha);
            elseif (cha == '5')
                agent1.plant.connector.sendData(uint8(50));
                disp(cha);
            elseif (cha == '6')
                agent1.plant.connector.sendData(uint8(60));
                disp(cha);
            elseif (cha == '7')
                agent1.plant.connector.sendData(uint8(70));
                disp(cha);
            end
        end
    end
catch ME
    agent.plant.connector.sender(gen_msg([500,500,0,500,0,0,0,0]));
    agent1.plant.connector.sendData(uint8(0));
    rethrow(ME);
end