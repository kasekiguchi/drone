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
SimBaseMode = ["SimHL","SimVoronoi","SimLiDAR","SimHL","SimVoronoi2D"];
ExpBaseMode = ["","ExpHL","ExpVoronoi2D"];
fExp = 0;
fDebug = 0; % 1: active : for debug function
PInterval = 1; % sec : poling interval for emergency stop
gui = SimExp(fExp,fDebug,PInterval);
