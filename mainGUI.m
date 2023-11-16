%% Initialize settings
% set path
if ~isfile('./mainGUI.m')
  tmp = matlab.desktop.editor.getActive; 
  cd(fileparts(tmp.Filename));
else
  cd(fileparts(mfilename('fullpath')));
end
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
close all hidden; clear all; clc;
%%
clc
SimBaseMode = ["SimVoronoi","SimHL","SimLiDAR","SimMPC","SimMPC_Koopman"];
ExpBaseMode = ["","ExpTestMotiveConnection","ExpHL","ExpMPC_Koopman"];
fExp = 1;
fDebug = 0; % 1: active : for debug function
PInterval = 0.6; % sec : poling interval for emergency stop
gui = SimExp(fExp,fDebug,PInterval);

