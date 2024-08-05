%% Koopman Linear by Data %%
%--------------------------------------------------------------------------------
%初心者用のクープマン線形化プログラム
%コマンドウィンドウの案内に従えばできるようになっているはず．．．
%慣れてきたら，main_KoopmanLinearByDataのほうでやるといいかも(設定を自分でできる)
%--------------------------------------------------------------------------------
clc
tmp = matlab.desktop.editor.getActive;
cd(strcat(fileparts(tmp.Filename), '../../../'));
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
%--------------------------------------------------------------
% 先に main.m の Initialize settings を実行すること(※必ず行う)
%--------------------------------------------------------------
% initialize = input('＜main.mのInitialize settingsを実行しましたか？＞\n はい:1，いいえ:0：','s');
% initialize = str2double(initialize);
% if initialize == 0
%     error('main.m の Initialize settings を実行してください')
% end
clear all
clc
%---------------------------------------------
flg.bilinear = 0; %1:双線形モデルへの切り替え 木山は実機のデータではうまくいかなかった
flg.normalize = 0;
setting = 0; %この値はいじらない
%---------------------------------------------

%% 
%データ保存先ファイル名(逐次変更しないと，上書きされる)
FileName = input('保存するファイル名を入力してください(※ ～.matを付ける): ', 's');

folderPath = 'データセット'; %データセットに使用するデータはデータセットフォルダにいれておく main.mの階層
fileList = dir(fullfile(folderPath,'*.mat')); %対象のファイルを取得
fprintf('\n＜データセットに使用するファイル名の統一を行います＞\n')

% 読み込むデータファイル名は同じにする必要がある：学習データ
% loading_filename_1 みたいな感じになる
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
activeFile = matlab.desktop.editor.getActive;
nowFolder = fileparts(activeFile.Filename);
targetpath=append(nowFolder,'\',FileName);

%% Defining Koopman Operator
%<使用している観測量>
% F = @(x) [x;1]; % 状態変数+定数項1
% F = @quaternions; % 状態+クォータニオンの1乗2乗3乗 オイラー角パラメータ用
F = @quaternions_all; 
fprintf('\n選択されている観測量：%s\n',func2str(F))

% load data
% 実験データから必要なものを抜き出す処理,↓状態,→データ番号(同一番号のデータが対応関係にある)
% Data.X 入力前の対象の状態
% Data.U 対象への入力
% Data.Y 入力後の対象の状態

fprintf('\n＜データセットの結合を行います＞\n')
%
if ~exist('FileName')
    loading_filename = '0805_HL_spline_y'; 
    Data.HowmanyDataset = 20;
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

fprintf('\n＜データセットの結合が完了しました＞\n')

%% クォータニオンのノルムをチェック(クォータニオンのノルムは1にならなければいけないという制約がある)
% 閾値を下回った or 上回った場合注意文を提示
% attitude_norm 各時間におけるクォータニオンのノルム
if size(Data.X,1)==13 %特に気にしなくていい
    thre = 0.01;
    attitude_norm = checkQuaternionNorm(Dataset.est.q',thre);
end

%% ここから始めるとき ====================================================================
% =========================================================================================
clear; clc;
clc
tmp = matlab.desktop.editor.getActive;
cd(strcat(fileparts(tmp.Filename), '../../../'));
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
%%
clear; clc;
flg.bilinear = 0;
flg.normalize = 0;
F = @quaternions_all; % 改造用
FileName_common = strcat(string(datetime('now'), 'yyyy-MM-dd'), '_'); 
Exp_tra = 'saddle'; % リファレンスデータを特定するための変数
% exp_data = 'Exp_KiyamaX20'; %20データ増やしたzのみ速度から
exp_data = 'Exp_Kiyama';    %既存データzのみ速度から
% exp_data = 'Exp_Kiyama_fromVel'; %20データ増やしたxyz速度から
% exp_data = 'Exp_Kiyama_fromVel_normalize'; %20データ増やしたxyz速度から＋正規化
FileName = strcat(FileName_common, exp_data, '_', 'code00_opt_1_', Exp_tra); % 保存先
activeFile = matlab.desktop.editor.getActive;
nowFolder = fileparts(activeFile.Filename);
% targetpath=append(nowFolder,'\',FileName);
targetpath=append(nowFolder,'\..\EstimationResult\',FileName);

load('Koopman_Linearization\Integration_Dataset\Kiyama_Exp_Dataset.mat'); % 以前のもの
% load('Koopman_Linearization\Integration_Dataset\Kiyama_Exp_Dataset_fromVel_true.mat'); % 以前+xyz速度から
% load('Koopman_Linearization\Integration_Dataset\Kiyama_Exp_Dataset_45k_Zdecreased.mat'); % z方向45000データ減少
% load('Koopman_Linearization\Integration_Dataset\Kiyama_Exp_Dataset_AddX_fromVel.mat'); % x方向追加+xyも速度から算出
% load('Koopman_Linearization\Integration_Dataset\Kiyama_Exp_Dataset_AddX_fromZvel.mat'); % x方向増加
% load('Koopman_Linearization\Integration_Dataset\Kiyama_Exp_Dataset_fromZvel.mat');
% load('Koopman_Linearization\Integration_Dataset\Kiyama_Exp_Dataset_fromVel.mat');
% load('Koopman_Linearization\Integration_Dataset\Kiyama_Exp_Dataset_fromVel_normalize.mat');

if isfile(strcat('Koopman_Linearization\EstimationResult\', FileName, '.mat'))
    error('Exist file. Require change filename');
end

% データのかさまし
% Data = data_increased(Data, 0.001, 20);

% 正規化
% flg.normalize = input('\n＜正規化を行いますか＞\n はい:1，いいえ:0：','s');
if flg.normalize == 1 %正規化を行うか(正規化については自分で調べて！)
    Ndata = Normalization(Data);
    Data.X = Ndata.x;
    Data.Y = Ndata.y;
    Data.U = Ndata.u;
    disp('Normalization is complete')
end

if size(Data.X,1)==13 %特に気にしなくていい
    thre = 0.01;
    attitude_norm = checkQuaternionNorm(Dataset.est.q',thre);
end

disp(FileName);

%% Koopman linearization
% 12/12 関数化(双線形であるかどかの切り替え，flg.bilinear==1:双線形)
fprintf('\n＜クープマン線形化を実行＞\n')
if flg.bilinear == 1
    est = KL_biLinear(Data.X,Data.U,Data.Y,F);
else
    % est = KL(Data.X,Data.U,Data.Y,F); %クープマン線形化の具体的な計算をしてる部分
    est = KL_opt(Data.X,Data.U,Data.Y,F,900000); % 最適化による計算
    % est = KL_opt_MC(Data.X,Data.U,Data.Y,F,900000);
end

est.observable = F;
fprintf('\n＜クープマン線形化が完了しました＞\n')

% Simulation by Estimated model(構築したモデルでシミュレーション)
%推定精度検証シミュレーション
%構築したクープマンモデルがどの程度正確かを確認する部分
% fprintf('\n＜推定精度検証用データに設定するファイル名を選択してください＞\n')
% [fileName, filePath] = uigetfile('*.mat');

%file名を自動で分別
fprintf('\n＜推定精度検証用データを設定しました＞\n')
fileName = WhichLoadFile(Exp_tra, 2, []);

verification_data = fileName;
simResult.reference = ImportFromExpData_verification(verification_data); %検証用データを格納

%arming時の実験データがうまく取れていないのを強引に解消
if simResult.reference.fExp == 1
    takeoff_idx = find(simResult.reference.T,1,'first');
    simResult.reference.X = simResult.reference.X(:,takeoff_idx:end);
    simResult.reference.Y = simResult.reference.Y(:,takeoff_idx:end);
    simResult.reference.U = simResult.reference.U(:,takeoff_idx:end);
    simResult.reference.T = simResult.reference.T(takeoff_idx:end);
    simResult.reference.T = simResult.reference.T - simResult.reference.T(1);
    simResult.reference.N = simResult.reference.N - takeoff_idx;
end

simResult.Z(:,1) = F(simResult.reference.X(:,1)); %検証用データの初期値を観測量に通して次元を合わせてる
simResult.Xhat(:,1) = simResult.reference.X(:,1);
simResult.U = simResult.reference.U(:,1:end);
simResult.T = simResult.reference.T(1:end);

if flg.normalize == 1 %推定精度検証用データの正規化
    for i  = 1:12
        simResult.Z(i,1) = (simResult.Z(i,1)-Ndata.meanValue.x(i))/Ndata.stdValue.x(i); %状態の正規化
    end
    for i = 1:4
        simResult.U(i,:) = (simResult.U(i,:)-Ndata.meanValue.u(i))/Ndata.stdValue.u(i); %入力の正規化
    end
end

%方程式を用いて計算を行う部分
if flg.bilinear == 1  %　flg.bilinear == 1:双線形
    for i = 1:1:simResult.reference.N-2
        simResult.Z(:,i+1) = est.ABE'*[simResult.Z(:,i);simResult.U(:,i);reshape(kron(simResult.Z(:,i),simResult.U(:,i)),[],1)];
    end
else
    for i = 1:1:simResult.reference.N-2
        simResult.Z(:,i+1) = est.A * simResult.Z(:,i) + est.B * simResult.U(:,i); %状態方程式 z[k+1] = Az[k]+BU
    end
end
simResult.Xhat = est.C * simResult.Z; %出力方程式 x[k] = Cz[k]，次元を元の12状態に戻してる

%正規化した場合には逆変換を行う必要がある
if flg.normalize == 1 %逆変換
    for i = 1:size(simResult.Xhat,1)
        simResult.Xhat(i,:) = (simResult.Xhat(i,:) * Ndata.stdValue.x(i)) + Ndata.meanValue.x(i);
    end
    simResult.Xhat = cat(2,simResult.reference.X(:,1),simResult.Xhat);
end

fprintf('\n＜推定精度検証が完了しました(推定したA,B,C行列を用いた状態推定)＞\n')

% Save Estimation Result(結果保存場所)
if size(Data.X,1)==13
    simResult.state.p = simResult.Xhat(1:3,:);
    simResult.state.q = simResult.Xhat(4:7,:);
    simResult.state.v = simResult.Xhat(8:10,:);
    simResult.state.w = simResult.Xhat(11:13,:);
else
    simResult.state.p = simResult.Xhat(1:3,:);
    simResult.state.q = simResult.Xhat(4:6,:);
    simResult.state.v = simResult.Xhat(7:9,:);
    simResult.state.w = simResult.Xhat(10:12,:);
end
simResult.state.N = simResult.reference.N-1;

save(targetpath,'est','Data','simResult','F')
disp('Saved to')
disp(targetpath)

%% データセット内のファイルの移動 Dataの中のなんというフォルダに入るか
% parentFolderPath = 'Data';
% newFolderName = input('データセットフォルダ内のファイルを移動します．\n移動先のフォルダ名を入力してください：','s');
% newFolderPath = fullfile(parentFolderPath,newFolderName);
% mkdir(newFolderPath)
% 
% sourceFolderPath = 'データセット';
% destinationFolderPath = newFolderPath;
% files = dir(fullfile(sourceFolderPath,'*.mat'));
% for i = 1:length(files)
%     filePath = fullfile(sourceFolderPath,files(i).name);
%     movefile(filePath,destinationFolderPath);
% end
% 
% fprintf('\n＜ファイルの移動が完了しました＞\n')
%% 磯部先輩が作られた観測量

% F = @(x) [x;1]; % 状態そのまま
% F = @quaternionParameter; % クォータニオンを含む13状態の観測量
% F = @eulerAngleParameter; % 姿勢角をオイラー角モデルの状態方程式からdq/dt部分を抜き出した観測量
% F = @eulerAngleParameter_withinConst; % eulerAngleParameter+慣性行列を含む部分(dvdt)を含む観測量
% F = @eulerAngleParameter_InputAndConst; % eulerAngleParameter_withinConst+入力にかかる係数行列の項を含む観測量
% F = @quaternions; % 状態+クォータニオンの1乗2乗3乗 オイラー角パラメータ用(動作確認済み) <こちらが最新の観測量>
% F = @quaternions_13state; % 状態+クォータニオンの1乗2乗3乗 クォータニオンパラメータ用
% F = @eulerAngleParameter_withoutP;

