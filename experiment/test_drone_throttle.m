clear all
close all
agent = DRONE(Model_Drone_Exp(0.025,[0;0;0], "udp", [50,132]),DRONE_PARAM("DIATONE"));
pause(1);
    agent.plant.connector.sendData(gen_msg([500,500,0,500,0,0,0,0]));% arming
%%
% while 1
%     agent.plant.connector.sendData(gen_msg([500,500,20,500,1000,0,0,0]));% arming
%     pause(0.025);
% end
%%
FH = figure('position', [0 0 eps eps], 'menubar', 'none');
disp("Press Enter");
dt = 0.75;
throttle = 200;
throttle_down = 180;
w = waitforbuttonpress;
disp("start");
disp("arming");
agent.plant.connector.sendData(gen_msg([500,500,0,500,1000,0,0,0]));% arming
pause(5);
%%
try
for i = 0:5:throttle
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
    i
   agent.plant.connector.sender(gen_msg([500,500,i,500,1000,0,0,0]));
   if i == throttle
       disp("Press Enter");
       w = waitforbuttonpress;
       disp("throttle down");
       for j = throttle:5:throttle_down
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
            j
           agent.plant.connector.sender(gen_msg([500,500,j,500,1000,0,0,0]));
       end
   end
    while i == throttle
        drawnow        
        cha = get(FH, 'currentcharacter');
        if (cha == 'q')
            error("ASCL : stop signal");
        end
    end
end
catch ME
    agent.plant.connector.sender(gen_msg([500,500,0,500,0,0,0,0]));
    rethrow(ME);
end