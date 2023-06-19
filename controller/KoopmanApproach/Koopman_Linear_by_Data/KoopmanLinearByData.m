function KoopmanLinearByData(flg,F,loading_filename,targetpath)
% flg : flag struct 
%   .bilinear : 1 :on
%   .F        : Observables
% loading filename : 
% targetpath : save file name

%% load data
% 実験データから必要なものを抜き出す処理,↓状態,→データ番号(同一番号のデータが対応関係にある)
% Data.X 入力前の対象の状態
% Data.U 対象への入力
% Data.Y 入力後の対象の状態

disp('now loading data set')
if endsWith(loading_filename,'.mat')
    Dataset = ImportFromExpData(loading_filename);
    Data.X = [Dataset.X];
    Data.U = [Dataset.U];
    Data.Y = [Dataset.Y];  
    disp(append('loaded filename: ', loading_filename));
    disp(append('data count in this file:',num2str(Dataset.N),', total data count: ',num2str(size(Data.X,2))))
else
    fileList = dir(fullfile(loading_filename, '*.mat'));
    for i = 1 : numel(fileList)
        Dataset = ImportFromExpData(fullfile(loading_filename,fileList(i).name));
        if i == 1
            Data.X = [Dataset.X];
            Data.U = [Dataset.U];
            Data.Y = [Dataset.Y];        
        else
            Data.X = [Data.X, Dataset.X];
            Data.U = [Data.U, Dataset.U];
            Data.Y = [Data.Y, Dataset.Y];
        end
        disp(append('loaded filename: ', fileList(i).name));
        disp(append('data count in this file:',num2str(Dataset.N),', total data count: ',num2str(size(Data.X,2))))
    end
end
disp('loading finish')

% クォータニオンのノルムをチェック
% 閾値を下回った or 上回った場合注意文を提示
% attitude_norm 各時間におけるクォータニオンのノルム
if size(Data.X,1)==13
    thre = 0.01;
    attitude_norm = checkQuaternionNorm(Dataset.est.q',thre);
end

%% Koopman linear
disp('now estimating')
if flg.bilinear == 1
    est = KL_biLinear(Data.X,Data.U,Data.Y,F);
else
    est = KL(Data.X,Data.U,Data.Y,F);
end
est.observable = F;
disp('Estimating finish')

%% Simulation by Estimated model
simResult.reference = ImportFromExpData('TestData3.mat');

simResult.Z(:,1) = F(simResult.reference.X(:,1));
simResult.Xhat(:,1) = simResult.reference.X(:,1);
simResult.U = simResult.reference.U(:,1:end);
simResult.T = simResult.reference.T(1:end);

if flg.bilinear == 1     
    for i = 1:1:simResult.reference.N-2
        simResult.Z(:,i+1) = est.ABE'*[simResult.Z(:,i);simResult.U(:,i);reshape(kron(simResult.Z(:,i),simResult.U(:,i)),[],1)];
    end
else
    for i = 1:1:simResult.reference.N-2
        simResult.Z(:,i+1) = est.A * simResult.Z(:,i) + est.B * simResult.U(:,i);
    end
end
simResult.Xhat = est.C * simResult.Z;

%% Save Estimation Result
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
end