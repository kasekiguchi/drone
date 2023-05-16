%% run_mainManyTime.m
%  指定した回数だけ共通プログラムのmainをブン回す
% !!! 実行する前に共通プログラムmain.m 内の Initialize setting に含まれている clear all をコメントアウトすること !!!

clear;clc;

%% 初期設定
% 実行する回数を指定
HowManyRun = 100;

% rand シード値
seed = double('T');
% seed = double('C');
% seed = double('U');
% seed = double('G');
rng(seed);

% データ保存先フォルダ名

mkdir Data\otamesi; %データ生成お試しフォルダ
Foldername = 'Data\otamesi';

% mkdir Data\simData_KoopmanApproach_2023_5_15_newdata2_isobeparameter; %新規ファイルの作成(以下のファイル名と一致させるように)
% Foldername = 'Data\simData_KoopmanApproach_2023_5_15_newdata2_isobeparameter'; %ここの名前を変えないとフォルダがどんどん上書きされてしまう
% データ保存先ファイル名
% "ファイル名"_[番号].mat で保存される
FileName = 'simtest';

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

