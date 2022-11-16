dt = 0.5;
agent1 = DRONE(Model_Drone_Exp(0.025,[0;0;0], "udp", [50,131]),DRONE_PARAM("DIATONE"));
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
    agent1.plant.connector.sendData(uint8(i));
    while i == 40
        drawnow        
        cha = get(FH, 'currentcharacter');
        if (cha == 'q')
            error("ASCL : stop signal");
        end
    end
end
catch ME
    agent1.plant.connector.sendData(uint8(0));
    rethrow(ME);
end
