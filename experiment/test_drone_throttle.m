clear all  
agent = DRONE(Model_Drone_Exp(0.025,[0;0;0], "udp", [25]),DRONE_PARAM("DIATONE"));
 disp("arming");
pause(1);
 agent.plant.connector.sendData(uint8([1100,1100,0,1100,0,0,0,0]));
 
 %%
 FH = figure('position', [0 0 eps eps], 'menubar', 'none');
dt = 1;
w = waitforbuttonpress;
disp("start");
try
for i = 0:10:500
    t = 0;
    Timer = tic;
    
    while t < dt
        drawnow        
        cha = get(FH, 'currentcharacter');
        if (cha == 'q')
            error("ASCL : stop signal");
        end
        %pause(0.01);
        t = toc(Timer);
    end
%   agent.plant.connector.sender(uint8([1500,1500,i+1000,1500,1000,0,0,0]));
end
catch ME
     agent.plant.connector.sender(uint8([1100,1100,0,1100,0,0,0,0]));
    rethrow(ME);
end