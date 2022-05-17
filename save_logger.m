%% make folder 
%変更しない
ExportFolder='C:\Users\81809\OneDrive\デスクトップ\ACSL\卒業研究\results';
DataFig='Data';%データかグラフか

%変更
subfolder='exp';%sim or exp
ExpSimName="remasui2";%実験,シミュレーション名
date='0518';%日付
contents="HL_hovering";%実験,シミュレーション内容
SaveTitle=strcat(ExpSimName,'_',date,'_',contents);%ファイルの名前作成
FolderName=fullfile(ExportFolder,subfolder,ExpSimName,DataFig);%保存先のpath
%フォルダ作ってないとき
mkdir(FolderName);
addpath(genpath(folder));

%% save
remasui2_0518_HL_hovering=logger;%変更
save(fullfile(FolderName, SaveTitle),'remasui2_0518_HL_hovering');%変更