%% make folder 'char "string　runでmainから回すのもあり
%変更しない
ExportFolder='C:\Users\81809\OneDrive\デスクトップ\results';
DataFig='Data';%データかグラフか
date=string(datetime('now','Format','yyyy_MMdd_HHmm'));%日付

%変更
subfolder='exp';%sim or exp
% subfolder='sim';
ExpSimName='remasui2';%実験,シミュレーション名
contents='agent_HL_hovering_15_2nd';%実験,シミュレーション内容

SaveTitle=strcat(date,'_',ExpSimName,'_',contents);%ファイルの名前作成
FolderName=fullfile(ExportFolder,ExpSimName,subfolder,DataFig);%保存先のpath%順番考える
%フォルダ作ってないとき
% mkdir(FolderName);
% addpath(genpath(ExportFolder));

%% save
eval([contents '= logger']);%loggerの名前をcontentsに変更
save(fullfile(FolderName, SaveTitle),contents);

agent_contents=strcat('agent_',contents);
eval([agent_contents 'agent']);
save(fullfile(FolderName, SaveTitle),agent_contents);