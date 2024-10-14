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
% SimBaseMode = ["SimVoronoi","SimHL","SimLiDAR","SimMCMPC","SimMPC","SimHLMCMPC","SimHLMPC"];
SimBaseMode = ["SimMCMPC"];
ExpBaseMode = [""];
fExp = 0;
fDebug = 0; % 1: active : for debug function
PInterval = 0.6; % sec : poling interval for emergency stop
gui = SimExp(fExp,fDebug,PInterval);

%% trajectory test
% syms t real
% x = cos(t/5) -1;
% y = sin(t/5);
% % z = cos(t/5) +1;
% z = cos(t) +1;
% az = diff(z, 2);
% tt = 0:0.1:100;
% plot(tt, subs(az, tt));
% max(subs(az, tt))