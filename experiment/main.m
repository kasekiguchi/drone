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
agent.plant = DRONE_EXP_MODEL(agent,Model_Drone_Exp(dt, initial_state, "serial", "COM8"));
% COM：機体番号（ArduinoのCOM番号）
    pause(1.45)
    %途中で一時停止しないとArduinoが信号を送信しない，原因:前の文章でCOMを指定しているので，それが読み込めないうちに進むと信号が送れない
    %pause(1.45)当たりを境に信号が送信できなくなる
    msg=gen_msg([1000,1000,0,1000,0,0,0,0]); %([Roll,Pitch,Throttle,Yaw,arming])
    agent.plant.connector.sendData(msg)