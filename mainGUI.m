%% Initialize settings
% set path
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
close all hidden; clear all; clc;
userpath('clear');
%%
SimBaseMode = ["","SimHL","SimVoronoi2D"];
ExpBaseMode = ["","ExpHL","ExpVoronoi2D"];
gui = SimExp;
%%
gui.PlantLabel.Text = ["Plant ",""];
gui.Lamp.Color = [1 0 0];
gui.LampLabel.Text = "Arming";
gui.RunmodeListBox.Value = "Simulation";

%%
hoge = readcell("test.csv");