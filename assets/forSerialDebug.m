%% for serial debug
% How to use
% 1. Connect the drone with battery on betaflight configulator
% 2. Do "Initialize settings" on main.m
% 3. Execute this file
% 4. Check the transmitter signal on betaflight
% Function : send time varying message to transmitter system
% ch : time varying channel 
% Expected result : transmitter signal increase by time
COM = 8; % change to fit your system
initial = struct;
initial.p = [0;0;0];
initial.q = [1;0;0;0];
initial.v = [0;0;0];
initial.w = [0;0;0];
dt = 0.025;
agent = Drone(Model_Drone_Exp(dt, 'plant', [0;0;0], "serial", [COM])); % for exp % 機体番号（ArduinoのCOM番号）
ch = 1;
for i = 0:10:1000
   value = [500 500 0 500 500 0 0 0];
   value(ch) = i;
   agent.plant.connector.sendData(gen_msg(value))
   pause(0.1)
end