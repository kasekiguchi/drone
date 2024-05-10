[~, tmp] = regexp(genpath('..'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
close all hidden; clear; clc;
%%
dt = 0.025;
fExp = 1;
agent = DRONE;
agent.parameter = DRONE_PARAM("DIATONE");
initial_state.p = [0; 0; 0];
initial_state.q = [1;0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];
initial_state.Trs = [agent.parameter.mass*agent.parameter.gravity+0.1; 0];%重力を打ち消すため最初はTr=m*g

agent.plant = DRONE_EXP_MODEL(agent,Model_Drone_Exp(dt, initial_state, "serial","COM3"));
	% COM：機体番号（ArduinoのCOM番号）
msg=gen_msg([500,500,0,500,0,0,0,0]);
agent.plant.connector.sendData(msg);

