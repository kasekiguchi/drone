clear
agent = DRONE(Model_Drone_Exp(0.025,[0;0;0], "serial", "COM19"),DRONE_PARAM("DIATONE"));
%%
%agent.plant.connector.sendData([1 0 0 0 0 0 0 0 0 2 3 4 0 0 0 0])
agent.plant.connector.sendData(gen_msg([500 500 0 500 0 0 0 0]))
%write(agent.plant.connector.serial,[1 0 0 0 0 0 0 0 0 2 3 4 0 0 0 0],"uint8");%[1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8],"uint8")

%%
clear