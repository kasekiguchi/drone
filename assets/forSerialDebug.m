%% for serial debug
% How to use
% 1. Connect the drone with battery on betaflight configulator
% 2. Do "Initialize settings" on main.m
% 3. Execute this file
% 4. Check the transmitter signal on betaflight
% Function : send time varying message to transmitter system
% ch : time varying channel 
% Expected result : transmitter signal increase by time

% clear all
COM = [3]; % change to fit your system
initial = struct;
initial.p = [0;0;0];
initial.q = [1;0;0;0];
initial.v = [0;0;0];
initial.w = [0;0;0];
dt = 0.025;
if ~exist('agent')
for i = COM
    agent = Drone(Model_Drone_Exp(dt, 'plant', [0;0;0], "serial", [COM(i)])); % for exp % 機体番号（ArduinoのCOM番号）
end
end
%% 各チャンネルの動作チェック用
% 10s かけて指定したチャンネル値を0 から1000に変化させる
% PPM信号が適切に出力されているか確認する用
ch = 1;
for i = 0:10:1000
   value = [500 500 0 500 500 0 0 0];
   value(ch) = i;
   agent.plant.connector.sendData(gen_msg(value))
   pause(0.1)
end
%% シリアル通信で流れてくる情報を取得
% Start, Emergency, Reset available, Reset などの情報が流れてくる。
% 緊急停止が機能しているか確認する用
while 1
    value = [500 500 0 500 1000 0 0 0];
    agent.plant.connector.sendData(gen_msg(value))
       agent.plant.connector.getData()
end