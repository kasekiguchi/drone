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
%%
% each method's arguments : app.time,app.cha,app.logger,app.env,app.agent,i
clc
SimBaseMode = ["","SimHL","SimPointMass", "SimVehicle", "SimSuspendedLoad", "SimVoronoi", "SimFHL", "SimFHL_Servo", "SimLiDAR", "SimFT", "SimEL","SimMPC","SimMPC_Koopman","SimMPC_HL","SimMPC_HLMC"];
ExpBaseMode = ["","ExpTestMotiveConnection", "ExpHL", "ExpFHL","ExpMPC_Koopman","ExpMPC_HL"];
% comment out :  "ExpFHL_Servo", "ExpFT", "ExpEL",
fExp = 1;
fDebug = 0; % 1: active : for debug function
PInterval = 0.6; % sec : poling interval for emergency stop
gui = SimExp(fExp, fDebug, PInterval);