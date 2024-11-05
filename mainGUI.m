%% Initialize settings
% set path
% ここでプログラムを動かしている
%パスの準備--このセッションの実行によってパスが通る
clear all %全ての変数をワークスペースから削除する
cf = pwd; %cfにpwdを代入 pwd=現在のフォルダを返すmain.mがあるフォルダをcfに

if contains(mfilename('fullpath'), "mainGUI") %mfilename("fullpath")-呼び出されるファイルの名前と絶対パスを返す 呼び出されたファイルにmain.GUIがあるか
    cd(fileparts(mfilename('fullpath'))); %cd-現在のファイル名の変更 fileparts(filename)-指定されたファイルのパス名,ファイル名,および拡張子を返す
else %mainGUIがなかった場合
    tmp = matlab.desktop.editor.getActive; %% 現在表示しているファイルのパス
    cd(fileparts(tmp.Filename)); % 現在のファイル名を変更
end

[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
%[out1,...,outN] = regexp(str,expression,outkey1,...,outkeyN)-複数の出力キーワードで指定された出力を,指定された順番に返す
% 'match'regexp は式全体と一致する部分文字列，'split'はdelimiter で指定した区切り記号で str の各要素を分割する
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
close all hidden; clear; clc;
userpath('clear');
%%
% each method's arguments : app.time,app.cha,app.logger,app.env,app.agent,i
clc %コマンドウィンドウのクリア
SimBaseMode = ["SimHL","SimPointMass", "SimVehicle", "SimSuspendedLoad", "SimVoronoi", "SimFHL", "SimFHL_Servo", "SimLiDAR", "SimFT", "SimEL", "SimMPC_Koopman"];
%シミュレーションのモード　追加したいのならここにファイル名を追加
ExpBaseMode = ["ExpTestMotiveConnection", "ExpHL", "ExpFHL", "ExpFHL_Servo", "ExpFT", "ExpEL", "ExpMPC_Koopman"];
%実機実験のモード　同じくモードを追加したいならここにファイル名を追加
fExp = 0; %SimExp.mlappで使用　1:実機 0:シミュレーション　guiの画面で変更可能なのでいじる必要なし
fDebug = 1; % 1: active : for debug function 
%普段は無効？if app.fDebug && app.time.t > app.time.dt % app.in_prog(app) end;
% dt:最終時間 t:現在時間
%スタートからの時間とfDebugが最終時間を超えたら,何かをする？in_progはExpHL内でestimator
PInterval = 0.6; % sec : poling interval for emergency stop %
% 緊急停止の時のポーリング間隔　基本変えなくてよさそう
gui = SimExp(fExp, fDebug, PInterval);
% SimExp.mlappで上3つの関数を使用する為に定義