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
    %pause(1.45) 当たりを境に信号が送信できなくなる
    %msg=gen_msg([500,500,0,500,0,0,0,0]); %([Roll,Pitch,Throttle,Yaw,arming])
    % msg=gen_msg([0,0,1000,0,1000,1000,1000,1000]);
    % msg=gen_msg([1000,1000,500,1000,500,500,500,500]);
    % msg=gen_msg([0,800,0,0,130,0,0,0]);
    msg=gen_msg([500,500,551,500,70,50,0,0]);
    agent.plant.connector.sendData(msg)

    % Command = 0;
    % while Command <= 1000
    %     pause(1.45)
    %     msg=gen_msg([Command,Command,Command,Command,Command,Command,Command,Command]); %([Roll,Pitch,Throttle,Yaw,arming])
    %     agent.plant.connector.sendData(msg)
    %     Command = Command + 1;
    % end