%% Initialize settings
% set path 共通プログラムのパスを通す
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
SimBaseMode = ["SimHL","SimFHL","SimFHL_Servo","SimLiDAR","SimFT","SimEL","SimVoronoi"]; %シミュレーションの種類
ExpBaseMode = ["ExpTestMotiveConnection","ExpHL","ExpFHL","ExpFHL_Servo","ExpFT","ExpEL"]; %実機実験の種類
fExp = 0; %fEXpとは何？
fDebug = 0; % 1: active : for debug function　デバッグファンクションとは何？
PInterval = 0.6; % sec : poling interval for emergency stop　緊急停止の間隔？
gui = SimExp(fExp,fDebug,PInterval); %上の3つを考慮する　