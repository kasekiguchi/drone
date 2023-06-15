%% Initialize settings
% set path
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
close all hidden; clear all; clc;
userpath('clear');
%%
clc

SimBaseMode = ["SimHL","SimVoronoi","SimLiDAR","Sim_cooperative_Load"];
% SimBaseMode = ["SimHL","SimVoronoi","SimLiDAR"];
ExpBaseMode = ["ExpTestMotiveConnection","ExpHL"];
fExp = 0;
fDebug = 0; % 1: active : for debug function
PInterval = 0.6; % sec : poling interval for emergency stop
gui = SimExp(fExp,fDebug,PInterval);


