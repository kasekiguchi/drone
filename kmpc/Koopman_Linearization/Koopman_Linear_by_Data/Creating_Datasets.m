%-- データセットを作成 --%
%% 初期化&パスの設定
clc
tmp = matlab.desktop.editor.getActive;
cd(strcat(fileparts(tmp.Filename), '../../../'));
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);

clear all
clc
%% データセットとなるファイルの名前を統一
%データセットに使用するデータのフォルダ名
folderPath = 'datasets'; 
fileList = dir(fullfile(folderPath,'*.mat')); %対象のファイルを取得
fprintf('\n＜データセットに使用するファイル名の統一を行います＞\n')

% 例：exp_file_1, exp_file_2, exp_file_3, ....
% => loading_filename = 'exp_file';
loading_filename = input('\n統一するファイル名を入力してください(※ .matは含まない):','s');

for i = 1:length(fileList)
    oldFileName = fullfile(folderPath,fileList(i).name);
    newFileName = fullfile(folderPath,[append(loading_filename,'_',num2str(i),'.mat')]);
    movefile(oldFileName, newFileName); %名前の変更
end

Data.HowmanyDataset = numel(fileList); %読み込むデータ数
if Data.HowmanyDataset > 0
    fprintf('\n＜ファイル名の統一が完了しました＞\n')
    fprintf('\n読み込むファイル数：%d\n',Data.HowmanyDataset)
else
    error('データセットフォルダ内にファイルが存在しません') %データセットフォルダ内にファイルがない場合はエラー
end

%データ保存用,現在のファイルパスを取得,保存先を指定
% activeFile = matlab.desktop.editor.getActive;
% nowFolder = fileparts(activeFile.Filename);
% targetpath=append(nowFolder,'\',FileName);

%% データセットの結合
% Data.X 入力前の対象の状態
% Data.U 対象への入力
% Data.Y 入力後の対象の状態

filename = input('\n統合データのファイル名を入力してください(※ .matは含まない):','s');
FileName = strcat(filename, '.mat');
fprintf('\n＜データセットの結合を行います＞\n')
%
tic
if ~exist('FileName')
    loading_filename = 'Exp_Kato'; % 適当に
    Data.HowmanyDataset = 150;     % 適当に 
end% ここだけ実行時
for i = 1:Data.HowmanyDataset
    if contains(loading_filename,'.mat')
        Dataset = ImportFromExpData_tutorial(loading_filename); %ImportFromExpData_tutorial:データセットをくっつけるための関数
    else
        if i == 1 %66 ~ 78はコマンドウィンドウから入力するのに必要(クープマン線形化には関係ない)
            setting = 1;
            Dataset = ImportFromExpData_tutorial(append(loading_filename,'_',num2str(i),'.mat'),setting);
            datarange = Dataset.datarange;
            range = Dataset.range;
            IDX = Dataset.IDX;
            phase2 = Dataset.phase2;
            vxyz = Dataset.vxyz;
            fprintf('\n')
        else
            setting = 0;
            Dataset = ImportFromExpData_tutorial(append(loading_filename,'_',num2str(i),'.mat'),setting,datarange,range,IDX,phase2,vxyz);
        end
    end
    if i==1
        Data.X = [Dataset.X];
        Data.U = [Dataset.U];
        Data.Y = [Dataset.Y];        
    else
        Data.X = [Data.X, Dataset.X];
        Data.U = [Data.U, Dataset.U];
        Data.Y = [Data.Y, Dataset.Y];
    end
    disp(append('loading data number: ',num2str(i),', now data:',num2str(Dataset.N),', all data: ',num2str(size(Data.X,2))))
end
toc
fprintf('\n＜データセットの結合が完了しました＞\n')

%--
activeFile = matlab.desktop.editor.getActive;
nowFolder = fileparts(activeFile.Filename);
targetpath=append(nowFolder,'\..\Integration_Dataset\',FileName);
save(targetpath,'Data')

%% Integration datasetsの結合
% clear
% data1 = load('Koopman_Linearization\Integration_Dataset\Kiyama_Exp_Dataset.mat');
% data2 = load('Koopman_Linearization\Integration_Dataset\Kato_Exp_Dataset.mat');
% Data.HowmanyDataset = data1.Data.HowmanyDataset + data2.Data.HowmanyDataset;
% Data.X = [data1.Data.X, data2.Data.X];
% Data.Y = [data1.Data.Y, data2.Data.Y];
% Data.U = [data1.Data.U, data2.Data.U];