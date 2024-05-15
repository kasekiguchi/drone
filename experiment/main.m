[~, tmp] = regexp(genpath('..'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
close all hidden; clear; clc;
%%
dt = 0.025;
fExp = 1;

initial_state.p = [0; 0; 0];
initial_state.q = [1;0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];
agent = DRONE;
agent.plant = DRONE_EXP_MODEL(agent,Model_Drone_Exp(dt, initial_state, "serial", "COM4"));
% COM：機体番号（ArduinoのCOM番号）
    pause(0.75)
    %途中で一時停止しないとArduinoが信号を送信しない，原因不明
    msg=gen_msg([1000,500,0,1000,0,500,500,1000]); %([Roll,Pitch,Throttle,Yaw,arming])
    pause(0.75)
    %途中で一時停止しないとArduinoが信号を送信しない，原因不明
    agent.plant.connector.sendData(msg)