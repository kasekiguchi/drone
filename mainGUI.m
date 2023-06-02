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
SimBaseMode = ["SimHL","SimVoronoi2D"];
ExpBaseMode = ["","ExpHL","ExpVoronoi2D"];
gui = SimExp(0);
