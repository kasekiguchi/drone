%% for serial debug
disp("How to use");
disp("1. Connect the drone with battery on betaflight configulator");
disp("2. Do 'Initialize settings' on main.m");
disp("3. Execute this file");
disp("4. Check the transmitter signal on betaflight");
disp("Function : send time varying message to transmitter system");
disp("ch : time varying channel ");
disp("Expected result : transmitter signal increase by time");
clear all
%%
COM = [26]; % change to fit your system
if ~exist('agent')
for i = 1:length(COM)
    agent = Drone(Model_Drone_Exp(1, 'plant', [0;0;0], "serial", [COM(i)])); % for exp % 機体番号（ArduinoのCOM番号）
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