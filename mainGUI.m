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
SimBaseMode = ["SimHL","SimFT"];
ExpBaseMode = ["ExpHL","ExpFT"];
fExp = 1;
fDebug = 0; % 1: active : for debug function
PInterval = 0.6; % sec : poling interval for emergency stop
gui = SimExp(fExp,fDebug,PInterval);

%FTCデモ用2023
%ドローンにおもりを付けて重心と質量にモデル誤差を与える
%FTCとHLで比較するがあまり差がわからないのでデモではFTCのみを行い比較はパワポの動画を見せるのがよい
%グラフ描画したいときはDataPlotのファイルを使うとよい。mainGUIがある場所と同様の階層にある（SaveDataのプログラムでデータ保存すると名前を変えられるので複数のデータを描画できる）
