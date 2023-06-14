%% Initialize settings
% set path
cd(fileparts(mfilename('fullpath')));
if isfile('./mainGUI.m') == 0
    tmp = matlab.desktop.editor.getActive; 
    cd(fileparts(tmp.Filename));
end
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
close all hidden; clear all; clc;
userpath('clear');
%%
clc
SimBaseMode = ["SimVoronoi_yamak","SimHL","SimLiDAR"];
ExpBaseMode = ["","ExpTestMotiveConnection","ExpHL"];
fExp = 0;
fDebug = 1; % 1: active : for debug function
PInterval = 0.1; % sec : poling interval for emergency stop
gui = SimExp(fExp,fDebug,PInterval);