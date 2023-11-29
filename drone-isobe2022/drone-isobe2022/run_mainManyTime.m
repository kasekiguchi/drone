%% run_mainManyTime.m
%  指定した回数だけ共通プログラムのmainをブン回す
% !!! 実行する前に共通プログラムmain.m 内の Initialize setting に含まれている clear all をコメントアウトすること !!!

clear;clc;

%% 初期設定
% 実行する回数を指定
HowManyRun = 1;

% rand シード値
seed = double('T');
% seed = double('C');
% seed = double('U');
% seed = double('G');
rng(seed);

% データ保存先フォルダ名
% rmdir Data\simData_KoopmanApproach_2023_7_20_circle s;%フォルダの削除 フォルダ名を変更せずに回す場合はコメントイン 
mkdir Data\simData_KoopmanApproach_2023_11_29_GUIsim; %新規フォルダの作成(以下のフォルダ名と一致させるように)
Foldername = 'Data\simData_KoopmanApproach_2023_7_28_straight'; %ここの名前を変えないとフォルダがどんどん上書きされてしまう
% データ保存先ファイル
% "ファイル名"_[番号].mat で保存される
FileName = 'sim_7_28_circle'; %線形化で読み込むファイルはこれで判別してる

%データ保存用,現在のファイルパスを取得,保存先を指定
activeFile = matlab.desktop.editor.getActive;
nowFolder = fileparts(activeFile.Filename);
targetpath = append(nowFolder,'\',Foldername,'\',FileName);

%必要な構造体を一旦定義
agent = struct; logger = struct;
% appendLogger = 0;

%% mainを複数回実行(matファイルの作成部分)
for runCount = 1:HowManyRun
    clearvars -except appendLogger HowManyRun targetpath FileName Foldername seed runCount nowFolder % 変数 A 以外の変数を削除  
    
    run('main.m')

    targetFileNumber = append(targetpath,'_',num2str(runCount),'.mat');
    save(targetFileNumber,'logger');    % 実行結果を記録
end

