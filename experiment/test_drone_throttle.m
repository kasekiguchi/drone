clear all  
agent = DRONE(Model_Drone_Exp(0.025,[0;0;0], "udp", [50,132]),DRONE_PARAM("DIATONE"));
pause(1);

agent.plant.connector.sendData(gen_msg([500,500,0,1000,0,0,0,0]));% arming

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