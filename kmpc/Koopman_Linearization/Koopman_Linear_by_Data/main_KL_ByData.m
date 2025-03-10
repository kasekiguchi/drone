% %-- Koopman Linearization by Dataset --%
% %% 初期化&パスの設定
% clc
% tmp = matlab.desktop.editor.getActive;
% cd(strcat(fileparts(tmp.Filename), '../../../'));
% [~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
% cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
% 
% clear all
% clc
% %---------------------------------------------
% flg.bilinear = 0; %1:双線形モデルへの切り替え 木山は実機のデータではうまくいかなかった
% flg.normalize = 0;
% setting = 0; %この値はいじらない
% 
% %% 
% %データ保存先ファイル名(逐次変更しないと，上書きされる)
% FileName = input('保存するファイル名を入力してください(※ ～.matを付ける): ', 's');
% 
% folderPath = 'データセット'; %データセットに使用するデータはデータセットフォルダにいれておく main.mの階層
% fileList = dir(fullfile(folderPath,'*.mat')); %対象のファイルを取得
% fprintf('\n＜データセットに使用するファイル名の統一を行います＞\n')
% 
% % 読み込むデータファイル名は同じにする必要がある：学習データ
% % loading_filename_1 みたいな感じになる
% loading_filename = input('\n統一するファイル名を入力してください(※ .matは含まない):','s');
% 
% for i = 1:length(fileList)
%     oldFileName = fullfile(folderPath,fileList(i).name);
%     newFileName = fullfile(folderPath,[append(loading_filename,'_',num2str(i),'.mat')]);
%     movefile(oldFileName, newFileName); %名前の変更
% end
% 
% Data.HowmanyDataset = numel(fileList); %読み込むデータ数
% if Data.HowmanyDataset > 0
%     fprintf('\n＜ファイル名の統一が完了しました＞\n')
%     fprintf('\n読み込むファイル数：%d\n',Data.HowmanyDataset)
% else
%     error('データセットフォルダ内にファイルが存在しません') %データセットフォルダ内にファイルがない場合はエラー
% end
% 
% %データ保存用,現在のファイルパスを取得,保存先を指定
% activeFile = matlab.desktop.editor.getActive;
% nowFolder = fileparts(activeFile.Filename);
% targetpath=append(nowFolder,'\',FileName);
% 
% %% Defining Koopman Operator
% %<使用している観測量>
% % F = @(x) [x;1]; % 状態変数+定数項1
% % F = @quaternions; % 状態+クォータニオンの1乗2乗3乗 オイラー角パラメータ用
% F = @quaternions_all; 
% fprintf('\n選択されている観測量：%s\n',func2str(F))
% 
% % load data
% % 実験データから必要なものを抜き出す処理,↓状態,→データ番号(同一番号のデータが対応関係にある)
% % Data.X 入力前の対象の状態
% % Data.U 対象への入力
% % Data.Y 入力後の対象の状態
% 
% fprintf('\n＜データセットの結合を行います＞\n')
% %
% tic
% if ~exist('FileName')
%     loading_filename = 'Exp_Kato'; 
%     Data.HowmanyDataset = 150;
% end% ここだけ実行時
% for i = 1:Data.HowmanyDataset
%     if contains(loading_filename,'.mat')
%         Dataset = ImportFromExpData_tutorial(loading_filename); %ImportFromExpData_tutorial:データセットをくっつけるための関数
%     else
%         if i == 1 %66 ~ 78はコマンドウィンドウから入力するのに必要(クープマン線形化には関係ない)
%             setting = 1;
%             Dataset = ImportFromExpData_tutorial(append(loading_filename,'_',num2str(i),'.mat'),setting);
%             datarange = Dataset.datarange;
%             range = Dataset.range;
%             IDX = Dataset.IDX;
%             phase2 = Dataset.phase2;
%             vxyz = Dataset.vxyz;
%             fprintf('\n')
%         else
%             setting = 0;
%             Dataset = ImportFromExpData_tutorial(append(loading_filename,'_',num2str(i),'.mat'),setting,datarange,range,IDX,phase2,vxyz);
%         end
%     end
%     if i==1
%         Data.X = [Dataset.X];
%         Data.U = [Dataset.U];
%         Data.Y = [Dataset.Y];        
%     else
%         Data.X = [Data.X, Dataset.X];
%         Data.U = [Data.U, Dataset.U];
%         Data.Y = [Data.Y, Dataset.Y];
%     end
%     disp(append('loading data number: ',num2str(i),', now data:',num2str(Dataset.N),', all data: ',num2str(size(Data.X,2))))
% end
% toc
% fprintf('\n＜データセットの結合が完了しました＞\n')

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
flg.bilinear = 0; % 双線形モデル
flg.normalize = 0; % 正規化
flg.without_pos = 0; % 位置無観測量
flg.weight = 0 % 重み付き最小二乗法

FileName_common = strcat(string(datetime('now'), 'yyyy-MM-dd'), '_'); 
Exp_tra = 'saddle'; % リファレンスデータを特定するための変数
exp_data = 'Exp_Kiyama';    %zのみ速度から
FileName = strcat(FileName_common, exp_data, '_', 'code00_', Exp_tra, '_increased_3'); % 保存先
activeFile = matlab.desktop.editor.getActive;
nowFolder = fileparts(activeFile.Filename);
targetpath=append(nowFolder,'\..\EstimationResult\',FileName);
load('Koopman_Linearization\Integration_Dataset\Kiyama_Exp_Dataset.mat'); %2023年度

if isfile(strcat('Koopman_Linearization\EstimationResult\', FileName, '.mat'))
    error('Exist file. Require change filename');
end

%-- 観測量は固まったら分けた方が快速
F = @quaternions_all_00; % 個別用
% F = @quaternions_all; % 2024 全観測量

% データのかさまし
flg.increased = 1; % このフラグがあるときは生成データ保存時にデータセットを含ませない
% if flg.increased
%     Data = data_increased(Data, [0.0001, 0.0001, 0], 10);
% end

% 正規化
if flg.normalize == 1 %正規化を行うか(正規化については自分で調べて！)
    Ndata = Normalization(Data);
    Data.X = Ndata.x;
    Data.Y = Ndata.y;
    Data.U = Ndata.u;
    disp('Normalization is complete')
end

% disp(FileName); 
% fprintf('pause: '); for i = 1:5; pause(1); fprintf('%d, ', i); end; fprintf('\n'); % 5秒待機タイマー

%% Koopman linearization
fprintf('\n＜クープマン線形化を実行＞\n')
tic
if flg.bilinear == 1
    est = KL_biLinear(Data.X,Data.U,Data.Y,F);
else
    if flg.without_pos
        est = KL(Data.X(4:end,:),Data.U,Data.Y(4:end,:),F,flg); % 位置を観測量に入れないときのKL
    else 
        % est = KL(Data.X,Data.U,Data.Y,F,flg); 
        est = KL_optimization(Data.X,Data.U,Data.Y,F,flg);
    end%クープマン線形化の具体的な計算をしてる部分
end

est.observable = F;
fprintf('\n＜クープマン線形化が完了しました＞\n')

%% Simulation by Estimated model(構築したモデルでシミュレーション)
%file名を自動で分別
fprintf('\n＜推定精度検証用データを設定しました＞\n')
fileName = WhichLoadFile(Exp_tra);

verification_data = fileName;
simResult.reference = ImportFromExpData_verification(verification_data); %検証用データを格納
f_data = [simResult.reference.X(:,1); simResult.reference.U(:,1)];
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

simResult.Z(:,1) = F(f_data); %検証用データの初期値を観測量に通して次元を合わせてる
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

%方程式を用いて計算を行う部分  変更中 9/11 完成次第結合
if flg.bilinear == 1  %　flg.bilinear == 1:双線形
    for i = 1:1:simResult.reference.N-2
        simResult.Z(:,i+1) = est.ABE'*[simResult.Z(:,i);simResult.U(:,i);reshape(kron(simResult.Z(:,i),simResult.U(:,i)),[],1)];
    end
    simResult.Xhat = est.C * simResult.Z;
elseif flg.bilinear ~= 1 && ~flg.without_pos
    for i = 1:1:simResult.reference.N-2
        simResult.Z(:,i+1) = est.A * simResult.Z(:,i) + est.B * simResult.U(:,i); %状態方程式 z[k+1] = Az[k]+BU
    end
    simResult.Xhat = est.C * simResult.Z;
elseif flg.bilinear ~= 1 && flg.without_pos % 観測量に位置を含んでいないとき
    for i = 1:1:simResult.reference.N-2
        dt = simResult.reference.T(i+1) - simResult.reference.T(i); % 刻み時間＝速度から位置算出用
        simResult.Z(:,i+1) = est.A * simResult.Z(:,i) + est.B * simResult.U(:,i); %状態方程式 z[k+1] = Az[k]+BU
        simResult.Xhat(4:end,i+1) = est.C * simResult.Z(:,i+1); % 姿勢角，速度～
        simReulst.Xhat(1:3,i+1) = simResult.Xhat(1:3,i) + dt * simResult.Xhat(7:9,i+1);
    end
end
% simResult.Xhat = est.C * simResult.Z; %出力方程式 x[k] = Cz[k]，次元を元の12状態に戻してる

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

if strcmp(exp_data, 'Exp_Kato')
    save(targetpath,'est')
else
    if flg.increased
        save(targetpath,'est')
    else
        save(targetpath,'est','Data','simResult','F')
    end
end
disp('Saved to')
disp(targetpath)
toc
