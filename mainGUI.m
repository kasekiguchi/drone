%% Initialize settings
% set path
cf = pwd;
if contains(mfilename('fullpath'),"mainGUI")
  cd(fileparts(mfilename('fullpath')));
else
  tmp = matlab.desktop.editor.getActive; 
  cd(fileparts(tmp.Filename));
end
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
cd(cf); close all hidden; clear all; userpath('clear');
%%
clc
SimBaseMode = ["SimVoronoi","SimHL","SimLiDAR","SimMCMPC","SimHLMCMPC","SimMPC","SimHLMPC"];
ExpBaseMode = ["","ExpTestMotiveConnection","ExpHL"];
fExp = 0;
fDebug = 0; % 1: active : for debug function
PInterval = 0.6; % sec : poling interval for emergency stop
gui = SimExp(fExp,fDebug,PInterval);