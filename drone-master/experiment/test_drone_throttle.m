clear all  
agent = DRONE(Model_Drone_Exp(0.025,[0;0;0], "udp", [50,132]),DRONE_PARAM("DIATONE"));
%%
agent.plant.connector.sendData(gen_msg([500,500,0,500,0,0,0,0]));% arming
%%
% disp("roll")
% for i = 0:10:500
% agent.plant.connector.sendData(gen_msg([i,500,0,500,0,0,0,0]));% 
% pause(0.1);
% end
% disp("pitch")
% for i = 0:10:500
% agent.plant.connector.sendData(gen_msg([500,i,0,500,0,0,0,0]));% 
% pause(0.1);
% end
% disp("yaw")
% for i = 0:10:500
% agent.plant.connector.sendData(gen_msg([500,500,0,i,0,0,0,0]));% 
% pause(0.1);
% end
% disp("throttle")
% for i = 0:10:500
% agent.plant.connector.sendData(gen_msg([500,500,i,500,0,0,0,0]));% 
% pause(0.1);
% end
% agent.plant.connector.sendData(gen_msg([500,500,0,500,0,0,0,0]));% stop

%%
FH = figure('position', [0 0 eps eps], 'menubar', 'none');
disp("Press Enter");
dt = 1;
w = waitforbuttonpress;
disp("start");
disp("arming");
agent.plant.connector.sendData(gen_msg([500,500,0,500,1000,0,0,0]));% arming
pause(5);
%%
try
for i = 0:1:200
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
end
catch ME
    agent.plant.connector.sender(gen_msg([500,500,0,500,0,0,0,0]));
    rethrow(ME);
end