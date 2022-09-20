dt = 1;
agent = DRONE(Model_Drone_Exp(0.025,[0;0;0], "udp", [50,131]),DRONE_PARAM("DIATONE"));
%%
FH = figure('position', [0 0 eps eps], 'menubar', 'none');
disp("Press Enter");
w = waitforbuttonpress;
disp("start");
try
for i = 1:70
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
    i
    agent.plant.connector.sendData(uint8(i));
end
catch ME
    agent.plant.connector.sendData(uint8(0));
    rethrow(ME);
end
