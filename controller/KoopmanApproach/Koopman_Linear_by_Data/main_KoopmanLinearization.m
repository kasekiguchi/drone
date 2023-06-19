%% main_KoopmanLinearization
% matファイルのデータからクープマン線形化を行う関数KoopmanLinearByDataを実行する

%% initialize
clear
clc
% Flag Bilinear
% 双線形システムとして出力するか
flg.bilinear = 1;

% Flag file save
% ファイルに保存するか
flg.fileSave = 0;

% Defining Koopman Operator
% クープマン作用素を定義
% F@(X) Xを与える関数ハンドルとして定義
% F = @(x) [x;1]; % 状態そのまま
% F = @quaternionParameter; % クォータニオンを含む13状態の観測量
% F = @eulerAngleParameter; % 姿勢角をオイラー角モデルの状態方程式からdq/dt部分を抜き出した観測量
% F = @eulerAngleParameter_withinConst; % eulerAngleParameter+慣性行列を含む部分(dvdt)を含む観測量
% F = @eulerAngleParameter_InputAndConst; % eulerAngleParameter_withinConst+入力にかかる係数行列の項を含む観測量
F = @quaternions; % 状態+クォータニオンの1乗2乗3乗 オイラー角パラメータ用
% F = @quaternions_13state; % 状態+クォータニオンの1乗2乗3乗 クォータニオンパラメータ用
% F = @eulerAngleParameter_withoutP;

% load file name
% 読み込むフォルダ or matファイルを選択
loadFile = 'Data/simData_Koopman_rndP2O4';
% loadFile = 'Data/simData_Koopman_rndP2O4/sim_rndP4_1.mat';
% save file name
saveFile = 'controller/KoopmanApproach/Koopman_Linear_by_Data/savetest.mat';

%% Run Koopman Linear By Data
output = {};
[output{1}.est, output{1}.simResult] = KoopmanLinearByData(flg,F,loadFile,saveFile);

%% Plot Simulation Result
pltflg = struct('calcFile1RMSE',0,'ylimHold',0,'xlimHold',1,'figureSave',0);
plot_KLResult(output,pltflg)


