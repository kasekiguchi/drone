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
close all hidden; clear ; clc;
userpath('clear');
%%
clc
SimBaseMode = ["SimVoronoi","SimHL","SimFHL","SimFHL_Servo","SimLiDAR","SimFT","SimEL"];
ExpBaseMode = ["ExpTestMotiveConnection","ExpHL","ExpFHL","ExpFHL_Servo","ExpFT","ExpEL"];
fExp = 1;
fDebug = 0; % 1: active : for debug function
PInterval = 0.6; % sec : poling interval for emergency stop
gui = SimExp(fExp,fDebug,PInterval);