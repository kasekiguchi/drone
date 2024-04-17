% for simulation on Simulink
%% Initialize settings
% set path
clear all
cf = pwd;

if contains(mfilename('fullpath'), "mainGUI")
    cd(fileparts(mfilename('fullpath')));
else
    tmp = matlab.desktop.editor.getActive;
    cd(fileparts(tmp.Filename));
end

[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
close all hidden; clear; clc;
userpath('clear');
%% Base setting
Flag.Exe.Mode = "Sim";

%%
ts = 0; % initial time
dt = 0.025; % sampling period
te = 300; % terminal time
time = TIME(ts,dt,te); % instance of time class

motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging

initial_state.p = arranged_position([0, 0], 1, 1, 0);
initial_state.q = [1; 0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

initial_state.p = [0;0;-1];

agent = DRONE;
agent.parameter = DRONE_PARAM("DIATONE","row");
agent.plant = MODEL_CLASS(agent,Model_Quat13(dt, initial_state, 1));

parameter.values = agent.parameter.parameter;
parameter.raw = agent.parameter.parameter_raw;

x0 = agent.plant.state.get();
save("plant_setting.mat","x0","dt","parameter");

%% estimator
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
eparam.n = agent.estimator.n;
eparam.B = agent.estimator.B;
eparam.Q = agent.estimator.Q;
eparam.R = agent.estimator.R;
eparam.type = "euler_angle_pqvw";
eparam.result = struct("state",agent.estimator.model.state.get(),"P",eye(eparam.n));
%% reference
agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.5]},"HL"});
syms t x f dummy real % 将来的な拡張用に 時間、状態、その他を引数にできるようにしておく。
matlabFunction(@(t,x,f) agent.reference.func(t),"File","@REFERENCE_SYSTEM/gen_reference.m","Vars",[dummy,t,x,f]);% dummy はクラスメソッドにするため
rparam.type = "HL";
%% controller
agent.controller = HLC(agent,Controller_HL(dt));
cparam.F1 = lqrd([0,1;0,0],[0;1],diag([100,1]),0.1,dt);
cparam.F2 = lqrd(diag([1,1,1],1),[0;0;0;1],eye(4),1,dt);
cparam.F3 = cparam.F2;
cparam.F4 = lqrd([0,1;0,0],[0;1],eye(2),1,dt);
cparam.P = agent.parameter.parameter;
cparam.type = "euler_parameter_qpvw";
u0 = [cparam.P(1)*9.81;0;0;0]; %  [mg;0;0;0]
gen_controller_entity_func();
%% Bus
myOutBus= Simulink.Bus;
el1=Simulink.BusElement; 
el1.Name = 'rresult';
el1.DataType = 'Bus: rresult';
el2=Simulink.BusElement; 
el2.Name = 'eresult';
el2.DataType = 'Bus: eresult';
el3 = Simulink.BusElement; 
el3.Name = 'cresult';
el3.DataType = 'Bus: cresult';

eresult = Simulink.Bus;
eel1 = Simulink.BusElement;
eel1.Name = 'state';
eel1.Dimensions = [12 1];
eel2 = Simulink.BusElement;
eel2.Name = 'P';
eel2.Dimensions = [12 12];
% eel3 = Simulink.BusElement;
% eel3.Name = 'G';
% eel3.Dimensions = [12 6];
eresult.Elements = [eel1 eel2];% eel3];

cresult = Simulink.Bus;
cel0 = Simulink.BusElement;
cel0.Name = 'input';
cel0.Dimensions = [4 1];
cresult.Elements = cel0;

rresult = Simulink.Bus;
rel0 = Simulink.BusElement;
rel0.Name = 'state';
rel0.DataType = 'Bus: rstate';
rresult.Elements = rel0;

rstate = Simulink.Bus;
rsel0 = Simulink.BusElement;
rsel0.Name = 'xd';
rsel0.Dimensions = [20 1];
rsel1 = Simulink.BusElement;
rsel1.Name = 'p';
rsel1.Dimensions = [3 1];
rsel2 = Simulink.BusElement;
rsel2.Name = 'v';
rsel2.Dimensions = [3 1];
rsel3 = Simulink.BusElement;
rsel3.Name = 'q';
rsel3.Dimensions = [3 1];

rstate.Elements = [rsel0 rsel1 rsel2 rsel3];

myOutBus.Elements = [el1 el2 el3];
%% まとめ
save("setting.mat","x0","u0","dt","eparam","rparam","cparam","parameter");

%% 
open_system("MS_test.slx");
out = sim("MS_test.slx");