%% Koopman Linear by Data %%
% 先に main.m の Initialize settings を実行すること
% initialize
clc
clear
close all
% フラグ管理
flg.bilinear = 0; %1:双線形モデルへの切り替え

%% 
%データ保存先ファイル名(逐次変更する)
% delete controller\KoopmanApproach\Koopman_Linear_by_Data\EstimationResult_12state_6_26_circle=circle_estimation=circle.mat; %同じファイル名を使うときはコメントイン
% FileName = 'EstimationResult_12state_10_12_data=revcirandcirandsaddle_circle=circle_estimation=circle_Inputandconst.mat';  %plotResultの方も変更するように，変更しないとどんどん上書きされる
FileName = 'test.mat'; %お試し用

% 読み込むデータファイル名(run_mainManyTime.mのファイル名と一致させる,ここで読み込むデータファイル名を識別してる)
% loading_filename = 'experiment_10_9_revcircle';  
loading_filename = 'experiment_10_10_reverseandorder_circle';  %matは含まないように注意！
% loading_filename = 'experiment_6_20_circle';
% loading_filename = 'experiment_10_11_test';

%データ保存用,現在のファイルパスを取得,保存先を指定
activeFile = matlab.desktop.editor.getActive;
nowFolder = fileparts(activeFile.Filename);
targetpath=append(nowFolder,'\',FileName);

%% Defining Koopman Operator

%<使用している観測量>
% F = @(x) [x;1]; % 状態変数+定数項1
F = @quaternions; % 状態+クォータニオンの1乗2乗3乗 オイラー角パラメータ用

% load data
% 実験データから必要なものを抜き出す処理,↓状態,→データ番号(同一番号のデータが対応関係にある)
% Data.X 入力前の対象の状態
% Data.U 対象への入力
% Data.Y 入力後の対象の状態

% 使用するデータセットの数を指定
% 23/01/26 run_mainManyTime.m で得たデータを合成
disp('now loading data set')
Data.HowmanyDataset = 20; %読み込むデータ数に応じて変更

for i= 1: Data.HowmanyDataset
    if contains(loading_filename,'.mat')
        Dataset = ImportFromExpData(loading_filename);
    else
        Dataset = ImportFromExpData(append(loading_filename,'_',num2str(i),'.mat'));
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
disp('loaded')

%% 正規化(平均:0,標準偏差:1)

%         %平均値の算出
%         meanValue.px(1,:) = mean(Data.X(1,:));
%         meanValue.px(2,:) = mean(Data.X(2,:));
%         meanValue.px(3,:) = mean(Data.X(3,:));
%         meanValue.qx(1,:) = mean(Data.X(4,:));
%         meanValue.qx(2,:) = mean(Data.X(5,:));
%         meanValue.qx(3,:) = mean(Data.X(6,:));
%         meanValue.vx(1,:) = mean(Data.X(7,:));
%         meanValue.vx(2,:) = mean(Data.X(8,:));
%         meanValue.vx(3,:) = mean(Data.X(9,:));
%         meanValue.wx(1,:) = mean(Data.X(10,:));
%         meanValue.wx(2,:) = mean(Data.X(11,:));
%         meanValue.wx(3,:) = mean(Data.X(12,:));
% 
%         meanValue.py(1,:) = mean(Data.Y(1,:));
%         meanValue.py(2,:) = mean(Data.Y(2,:));
%         meanValue.py(3,:) = mean(Data.Y(3,:));
%         meanValue.qy(1,:) = mean(Data.Y(4,:));
%         meanValue.qy(2,:) = mean(Data.Y(5,:));
%         meanValue.qy(3,:) = mean(Data.Y(6,:));
%         meanValue.vy(1,:) = mean(Data.Y(7,:));
%         meanValue.vy(2,:) = mean(Data.Y(8,:));
%         meanValue.vy(3,:) = mean(Data.Y(9,:));
%         meanValue.wy(1,:) = mean(Data.Y(10,:));
%         meanValue.wy(2,:) = mean(Data.Y(11,:));
%         meanValue.wy(3,:) = mean(Data.Y(12,:));
%         %標準偏差の算出
%         stdValue.px(1,:) = std(Data.X(1,:));
%         stdValue.px(2,:) = std(Data.X(2,:));
%         stdValue.px(3,:) = std(Data.X(3,:));
%         stdValue.qx(1,:) = std(Data.X(1,:));
%         stdValue.qx(2,:) = std(Data.X(2,:));
%         stdValue.qx(3,:) = std(Data.X(3,:));
%         stdValue.vx(1,:) = std(Data.X(1,:));
%         stdValue.vx(2,:) = std(Data.X(2,:));
%         stdValue.vx(3,:) = std(Data.X(3,:));
%         stdValue.wx(1,:) = std(Data.X(1,:));
%         stdValue.wx(2,:) = std(Data.X(2,:));
%         stdValue.wx(3,:) = std(Data.X(3,:));
% 
%         stdValue.py(1,:) = std(Data.Y(1,:));
%         stdValue.py(2,:) = std(Data.Y(2,:));
%         stdValue.py(3,:) = std(Data.Y(3,:));
%         stdValue.qy(1,:) = std(Data.Y(1,:));
%         stdValue.qy(2,:) = std(Data.Y(2,:));
%         stdValue.qy(3,:) = std(Data.Y(3,:));
%         stdValue.vy(1,:) = std(Data.Y(1,:));
%         stdValue.vy(2,:) = std(Data.Y(2,:));
%         stdValue.vy(3,:) = std(Data.Y(3,:));
%         stdValue.wy(1,:) = std(Data.Y(1,:));
%         stdValue.wy(2,:) = std(Data.Y(2,:));
%         stdValue.wy(3,:) = std(Data.Y(3,:));
% 
%     sizeA = size(Data.X,2);
%     meanValue.px = repmat(meanValue.px,1,sizeA);
%     meanValue.qx = repmat(meanValue.qx,1,sizeA);
%     meanValue.vx = repmat(meanValue.vx,1,sizeA);
%     meanValue.wx = repmat(meanValue.wx,1,sizeA);
% 
%     sizeB = size(Data.Y,2);
%     meanValue.py = repmat(meanValue.py,1,sizeB);
%     meanValue.qy = repmat(meanValue.qy,1,sizeB);
%     meanValue.vy = repmat(meanValue.vy,1,sizeB);
%     meanValue.wy = repmat(meanValue.wy,1,sizeB);
%     
%     %データの正規化
%     normalizedData.px(1,:) = (Data.X(1,:) - meanValue.px(1,:));
%     normalizedData.px(2,:) = (Data.X(2,:) - meanValue.px(2,:));
%     normalizedData.px(3,:) = (Data.X(3,:) - meanValue.px(3,:));
%     normalizedData.qx(1,:) = (Data.X(4,:) - meanValue.qx(1,:));
%     normalizedData.qx(2,:) = (Data.X(5,:) - meanValue.qx(2,:));
%     normalizedData.qx(3,:) = (Data.X(6,:) - meanValue.qx(3,:));
%     normalizedData.vx(1,:) = (Data.X(7,:) - meanValue.vx(1,:));
%     normalizedData.vx(2,:) = (Data.X(8,:) - meanValue.vx(2,:));
%     normalizedData.vx(3,:) = (Data.X(9,:) - meanValue.vx(3,:));
%     normalizedData.wx(1,:) = (Data.X(10,:) - meanValue.wx(1,:));
%     normalizedData.wx(2,:) = (Data.X(11,:) - meanValue.wx(2,:));
%     normalizedData.wx(3,:) = (Data.X(12,:) - meanValue.wx(3,:));
% 
%     normalizedData.py(1,:) = (Data.Y(1,:) - meanValue.py(1,:));
%     normalizedData.py(2,:) = (Data.Y(2,:) - meanValue.py(2,:));
%     normalizedData.py(3,:) = (Data.Y(3,:) - meanValue.py(3,:));
%     normalizedData.qy(1,:) = (Data.Y(4,:) - meanValue.qy(1,:));
%     normalizedData.qy(2,:) = (Data.Y(5,:) - meanValue.qy(2,:));
%     normalizedData.qy(3,:) = (Data.Y(6,:) - meanValue.qy(3,:));
%     normalizedData.vy(1,:) = (Data.Y(7,:) - meanValue.vy(1,:));
%     normalizedData.vy(2,:) = (Data.Y(8,:) - meanValue.vy(2,:));
%     normalizedData.vy(3,:) = (Data.Y(9,:) - meanValue.vy(3,:));
%     normalizedData.wy(1,:) = (Data.Y(10,:) - meanValue.wy(1,:));
%     normalizedData.wy(2,:) = (Data.Y(11,:) - meanValue.wy(2,:));
%     normalizedData.wy(3,:) = (Data.Y(12,:) - meanValue.wy(3,:));
% 
%     Data.X(1,:) = (1/stdValue.px(1,:))*normalizedData.px(1,:);
%     Data.X(2,:) = (1/stdValue.px(2,:))*normalizedData.px(2,:);
%     Data.X(3,:) = (1/stdValue.px(3,:))*normalizedData.px(3,:);
%     Data.X(4,:) = (1/stdValue.qx(1,:))*normalizedData.qx(1,:);
%     Data.X(5,:) = (1/stdValue.qx(2,:))*normalizedData.qx(2,:);
%     Data.X(6,:) = (1/stdValue.qx(3,:))*normalizedData.qx(3,:);
%     Data.X(7,:) = (1/stdValue.vx(1,:))*normalizedData.vx(1,:);
%     Data.X(8,:) = (1/stdValue.vx(2,:))*normalizedData.vx(2,:);
%     Data.X(9,:) = (1/stdValue.vx(3,:))*normalizedData.vx(3,:);
%     Data.X(10,:) = (1/stdValue.wx(1,:))*normalizedData.wx(1,:);
%     Data.X(11,:) = (1/stdValue.wx(2,:))*normalizedData.wx(2,:);
%     Data.X(12,:) = (1/stdValue.wx(3,:))*normalizedData.wx(3,:);
% 
%     Data.Y(1,:) = (1/stdValue.py(1,:))*normalizedData.py(1,:);
%     Data.Y(2,:) = (1/stdValue.py(2,:))*normalizedData.py(2,:);
%     Data.Y(3,:) = (1/stdValue.py(3,:))*normalizedData.py(3,:);
%     Data.Y(4,:) = (1/stdValue.qy(1,:))*normalizedData.qy(1,:);
%     Data.Y(5,:) = (1/stdValue.qy(2,:))*normalizedData.qy(2,:);
%     Data.Y(6,:) = (1/stdValue.qy(3,:))*normalizedData.qy(3,:);
%     Data.Y(7,:) = (1/stdValue.vy(1,:))*normalizedData.vy(1,:);
%     Data.Y(8,:) = (1/stdValue.vy(2,:))*normalizedData.vy(2,:);
%     Data.Y(9,:) = (1/stdValue.vy(3,:))*normalizedData.vy(3,:);
%     Data.Y(10,:) = (1/stdValue.wy(1,:))*normalizedData.wy(1,:);
%     Data.Y(11,:) = (1/stdValue.wy(2,:))*normalizedData.wy(2,:);
%     Data.Y(12,:) = (1/stdValue.wy(3,:))*normalizedData.wy(3,:);

%     for i = 1:3
%         data.p(i,:) = (1/stdValue.p(i))*normalizedData.p(i,:);
%         data.q(i,:) = (1/stdValue.q(i))*normalizedData.p(i,:);
%         data.v(i,:) = (1/stdValue.v(i))*normalizedData.p(i,:);
%         data.w(i,:) = (1/stdValue.w(i))*normalizedData.p(i,:);
%     end

%% クォータニオンのノルムをチェック(クォータニオンのノルムは1にならなければいけないという制約がある)
% 閾値を下回った or 上回った場合注意文を提示
% attitude_norm 各時間におけるクォータニオンのノルム
if size(Data.X,1)==13
    thre = 0.01;
    attitude_norm = checkQuaternionNorm(Dataset.est.q',thre);
end

%% Koopman linear
% 12/12 関数化(双線形であるかどかの切り替え，flg.bilinear==1:双線形)
disp('now estimating')
if flg.bilinear == 1
    est = KL_biLinear(Data.X,Data.U,Data.Y,F);
else
    est = KL(Data.X,Data.U,Data.Y,F);
end

est.observable = F;
disp('Estimated')

%% Simulation by Estimated model(構築したモデルでシミュレーション)
%推定精度検証シミュレーション
% simResult.reference = ImportFromExpData('TestData3.mat');
simResult.reference = ImportFromExpData_estimation('experiment_6_20_circle_estimaterdata'); %推定精度検証用データの設定
% simResult.reference = ImportFromExpData_estimation('experiment_10_9_revcircle_estimatordata');
% simResult.reference = ImportFromExpData_estimation('experiment_9_5_saddle_estimatordata');


% 2023/06/12 アーミングphaseの実験データがうまく取れていないのを強引に解消
takeoff_idx = find(simResult.reference.T,1,'first');
simResult.reference.X = simResult.reference.X(:,takeoff_idx:end);
simResult.reference.Y = simResult.reference.Y(:,takeoff_idx:end);
simResult.reference.U = simResult.reference.U(:,takeoff_idx:end);
simResult.reference.T = simResult.reference.T(takeoff_idx:end);
simResult.reference.T = simResult.reference.T - simResult.reference.T(1);
simResult.reference.N = simResult.reference.N - takeoff_idx;

simResult.Z(:,1) = F(simResult.reference.X(:,1));
simResult.Xhat(:,1) = simResult.reference.X(:,1);
simResult.U = simResult.reference.U(:,1:end);
simResult.T = simResult.reference.T(1:end);

if flg.bilinear == 1  %　flg.bilinear == 1:双線形
    for i = 1:1:simResult.reference.N-2
        simResult.Z(:,i+1) = est.ABE'*[simResult.Z(:,i);simResult.U(:,i);reshape(kron(simResult.Z(:,i),simResult.U(:,i)),[],1)];
    end
else
    for i = 1:1:simResult.reference.N-2
        simResult.Z(:,i+1) = est.A * simResult.Z(:,i) + est.B * simResult.U(:,i); %状態方程式 z[k+1] = Az[k]+BU
    end
end
simResult.Xhat = est.C * simResult.Z; %出力方程式 x[k] = Cz[k]

%% Save Estimation Result(結果保存場所)
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

save(targetpath,'est','Data','simResult')
disp('Saved to')
disp(targetpath)

%% 先輩が今まで作られた観測量

% F = @(x) [x;1]; % 状態そのまま
% F = @quaternionParameter; % クォータニオンを含む13状態の観測量
% F = @eulerAngleParameter; % 姿勢角をオイラー角モデルの状態方程式からdq/dt部分を抜き出した観測量
% F = @eulerAngleParameter_withinConst; % eulerAngleParameter+慣性行列を含む部分(dvdt)を含む観測量
% F = @eulerAngleParameter_InputAndConst; % eulerAngleParameter_withinConst+入力にかかる係数行列の項を含む観測量
% F = @quaternions; % 状態+クォータニオンの1乗2乗3乗 オイラー角パラメータ用(動作確認済み) <こちらが最新の観測量>
% F = @quaternions_13state; % 状態+クォータニオンの1乗2乗3乗 クォータニオンパラメータ用
% F = @eulerAngleParameter_withoutP;

