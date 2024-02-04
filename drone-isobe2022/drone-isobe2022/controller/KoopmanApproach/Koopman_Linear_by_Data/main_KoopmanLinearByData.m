%% Koopman Linear by Data %%
% 先に main.m の Initialize settings を実行すること
% initialize
% フラグ管理
clear all
close all
clc
%---------------------------------------------
flg.bilinear = 0; %1:双線形モデルへの切り替え
Normalize = 0; %1：正規化
%---------------------------------------------u

%% 
%データ保存先ファイル名(逐次変更する)
FileName = 'EstimationResult_12state_2_4_Exp_sprine+zsprine+P2Pz_torque_incon.mat';  %plotResultの方も変更するように，変更しないとどんどん上書きされる
% FileName = 'test.mat'; %お試し用

% 読み込むデータファイル名
% loading_filename = 'Exp_alldata_2_1';  
% loading_filename = 'experiment_10_11_test';  %matは含まないように注意！
% loading_filename = 'experiment_6_20_circle';
% loading_filename = 'Exp_cirrevsaddata_12_19';
% loading_filename = 'Exp_sprine100_2_1';
% loading_filename = 'GUIsim_11_29';
loading_filename = 'Exp_2_3';

Data.HowmanyDataset =139; %読み込むデータ数に応じて変更

%データ保存用,現在のファイルパスを取得,保存先を指定
activeFile = matlab.desktop.editor.getActive;
nowFolder = fileparts(activeFile.Filename);
targetpath=append(nowFolder,'\',FileName);

%% Defining Koopman Operator

%<使用している観測量>
% F = @(x) [x;1]; % 状態変数+定数項1
F = @quaternions; % 状態+クォータニオンの1乗2乗3乗 オイラー角パラメータ用

% load data h 
% 実験データから必要なものを抜き出す処理,↓状態,→データ番号(同一番号のデータが対応関係にある)
% Data.X 入力前の対象の状態
% Data.U 対象への入力
% Data.Y 入力後の対象の状態

% 使用するデータセットの数を指定
% 23/01/26 run_mainManyTime.m で得たデータを合成
disp('now loading data set')

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

if Normalize == 1 %正規化
    Ndata = Normalization(Data);
    Data.X = Ndata.x;
    Data.Y = Ndata.y;
    Data.U = Ndata.u;
    disp('Normalization is complete')
end


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
% simResult.reference = ImportFromExpData('GUIsim_saddle.mat');
simResult.reference = ImportFromExpData_estimation('experiment_6_20_circle_estimaterdata'); %推定精度検証用データの設定
% simResult.reference = ImportFromExpData_estimation('experiment_10_9_revcircle_estimatordata');
% simResult.reference = ImportFromExpData_estimation('experiment_9_5_saddle_estimatordata');
% simResult.reference = ImportFromExpData_estimation('experiment_10_25_P2Py_estimator');
% simResult.reference = ImportFromExpData_estimation('GUIsim_11_29_1'); %sim
% simResult.reference = ImportFromExpData_estimation('experiment_11_8_P2Pshape_estimator');

% 2023/06/12 アーミングphaseの実験データがうまく取れていないのを強引に解消
if simResult.reference.fExp == 1
    takeoff_idx = find(simResult.reference.T,1,'first');
    simResult.reference.X = simResult.reference.X(:,takeoff_idx:end);
    simResult.reference.Y = simResult.reference.Y(:,takeoff_idx:end);
    simResult.reference.U = simResult.reference.U(:,takeoff_idx:end);
    simResult.reference.T = simResult.reference.T(takeoff_idx:end);
    simResult.reference.T = simResult.reference.T - simResult.reference.T(1);
    simResult.reference.N = simResult.reference.N - takeoff_idx;
end
simResult.Z(:,1) = F(simResult.reference.X(:,1));
simResult.Xhat(:,1) = simResult.reference.X(:,1);
simResult.U = simResult.reference.U(:,1:end);
simResult.T = simResult.reference.T(1:end);

if Normalize == 1 %推定精度検証用データの正規化(改善後)
    for i  = 1:12
        simResult.Z(i,1) = (simResult.Z(i,1)-Ndata.meanValue.x(i))/Ndata.stdValue.x(i);
    end
    for i = 1:4
        simResult.U(i,:) = (simResult.U(i,:)-Ndata.meanValue.u(i))/Ndata.stdValue.u(i);
    end
end

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

if Normalize == 1 %逆変換
    for i = 1:size(simResult.Xhat,1)
        simResult.Xhat(i,:) = (simResult.Xhat(i,:) * Ndata.stdValue.x(i)) + Ndata.meanValue.x(i);
    end
    simResult.Xhat = cat(2,simResult.reference.X(:,1),simResult.Xhat);
end

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

%% 作成済みモデルで，推定する軌道を変更
clc
num = input('＜全時刻の推定を行いますか＞\n 1:行う 0:行わない：','s');
change_reference = str2double(num);

if change_reference == 1
    clear all
    close all
    opengl software
    % simResult.reference = ImportFromExpData_estimation('GUIsim_11_29_5'); %sim

    % simResult.reference = ImportFromExpData_estimation('experiment_6_20_circle_estimaterdata'); %推定精度検証用データの設定
    % simResult.reference = ImportFromExpData_estimation('experiment_10_9_revcircle_estimatordata');
    simResult.reference = ImportFromExpData_estimation('experiment_9_5_saddle_estimatordata');
    % simResult.reference = ImportFromExpData_estimation('experiment_10_25_P2Py_estimator');
    % simResult.reference = ImportFromExpData_estimation('experiment_11_8_P2Pshape_estimator');
    % simResult.reference = ImportFromExpData_estimation('1_24_sprine_53');


    model = load("test.mat",'est');
    est.A = model.est.A;
    est.B = model.est.B;
    est.C = model.est.C;
    F = model.est.observable;

    if simResult.reference.fExp == 1
        takeoff_idx = find(simResult.reference.T,1,'first');
        simResult.reference.X = simResult.reference.X(:,takeoff_idx:end);
        simResult.reference.Y = simResult.reference.Y(:,takeoff_idx:end);
        simResult.reference.U = simResult.reference.U(:,takeoff_idx:end);
        simResult.reference.T = simResult.reference.T(takeoff_idx:end);
        simResult.reference.T = simResult.reference.T - simResult.reference.T(1);
        simResult.reference.N = simResult.reference.N - takeoff_idx;
    end
    simResult.Z(:,1) = F(simResult.reference.X(:,1));
    simResult.Xhat(:,1) = simResult.reference.X(:,1);
    simResult.U = simResult.reference.U(:,1:end);
    simResult.T = simResult.reference.T(1:end);
    N1 = 1;
    N2 = 56;
    length = N2 - N1;
    j = 1;
    while(1)
        clc
        if N2 > simResult.reference.N
            fprintf('各方向のRMSEの変位，最大誤差を表示します')
            size = figure;
            size.WindowState = 'maximized'; %表示するグラフを最大化
            for i = 1:3
                subplot(2,3,i)
                if i == 1
                    plot(1:j-1,x,'LineWidth',1.2,'Marker','o','MarkerFaceColor','red','LineStyle','--','Color',[0 0.4470 0.7410])
                    grid on
                    ylabel('RMSE x','FontSize',14)
                elseif i == 2
                    plot(1:j-1,y,'LineWidth',1.2,'Marker','o','MarkerFaceColor','red','LineStyle','--','Color',[0.4660 0.6740 0.1880])
                    grid on
                    ylabel('RMSE y','FontSize',14)
                else
                    plot(1:j-1,z,'LineWidth',1.2,'Marker','o','MarkerFaceColor','red','LineStyle','--','Color',[0.9290 0.6940 0.1250])
                    grid on
                    ylabel('RMSE z','FontSize',14)
                end
            end
            
            for i = 4:6
                subplot(2,3,i)
                if i == 4
                    plot(1:j-1,xerror_max,'LineWidth',1.2,'Marker','diamond','MarkerFaceColor','m','LineStyle','-.','Color',[0 0.4470 0.7410])
                    grid on
                    ylabel('Max error x','FontSize',14)
                elseif i == 5
                    plot(1:j-1,yerror_max,'LineWidth',1.2,'Marker','diamond','MarkerFaceColor','m','LineStyle','-.','Color',[0.4660 0.6740 0.1880])
                    grid on
                    ylabel('Max error y','FontSize',14)
                elseif i == 6
                    plot(1:j-1,zerror_max,'LineWidth',1.2,'Marker','diamond','MarkerFaceColor','m','LineStyle','-.','Color',[0.9290 0.6940 0.1250])
                    grid on
                    ylabel('Max error z','FontSize',14)
                end
            end
            % set(gcf, 'Position', [160, 200, 1200, 500]);
            
            break
        end
        for i = N1:N2-1
            simResult.Z(:,i-N1+2) = est.A * simResult.Z(:,i-N1+1) + est.B * simResult.U(:,i); %状態方程式 z[k+1] = Az[k]+BU
        end
        simResult.Xhat = est.C * simResult.Z; %出力方程式 x[k] = Cz[k]
        fprintf('\n%d～%dstep間の推定結果を表示します\n', N1, N2)
        size = figure;
        size.WindowState = 'maximized'; %表示するグラフを最大化
        for i = 1:3
            subplot(2,3,i)
            plot(simResult.T(:,N1:N2),simResult.Xhat(i,:),'LineWidth',1.2)
            hold on
            grid on
            plot(simResult.T(:,N1:N2),simResult.reference.X(i,N1:N2),'LineWidth',1.2,'LineStyle','--','Color','red')
            legend('estimator','reference','Location','best')
            if i == 1
                xlabel('Time [s]','FontSize',16);
                ylabel('x','FontSize',16);
            elseif i == 2
                xlabel('Time [s]','FontSize',16);
                ylabel('y','FontSize',16);
            else
                xlabel('Time [s]','FontSize',16);
                ylabel('z','FontSize',16);
            end
            hold off
            if i == 1
                x(1,j) = sqrt(sum((simResult.reference.X(i,N1:N2)-simResult.Xhat(i,:)).^2)/length);
                xerror = simResult.reference.X(i,N1:N2)-simResult.Xhat(i,:);
                xerror_max(1,j) = max(simResult.reference.X(i,N1:N2)-simResult.Xhat(i,:));
            elseif i == 2
                y(1,j) = sqrt(sum((simResult.reference.X(i,N1:N2)-simResult.Xhat(i,:)).^2)/length);
                yerror = simResult.reference.X(i,N1:N2)-simResult.Xhat(i,:);
                yerror_max(1,j) = max(simResult.reference.X(i,N1:N2)-simResult.Xhat(i,:));
            else
                z(1,j) = sqrt(sum((simResult.reference.X(i,N1:N2)-simResult.Xhat(i,:)).^2)/length);
                zerror = simResult.reference.X(i,N1:N2)-simResult.Xhat(i,:);
                zerror_max(1,j) = max(simResult.reference.X(i,N1:N2)-simResult.Xhat(i,:));
            end
        end
        error = [xerror;yerror;zerror];
        subplot(2,3,4)
        plot(simResult.T(:,N1:N2),simResult.reference.U(1,N1:N2),'LineWidth',1.2)
        yline(0.5884*9.81,'Color','r')
        grid on
        xlabel('Time [s]','FontSize',16);
        ylabel('thrust','FontSize',16);

        subplot(2,3,5)
        plot(simResult.T(:,N1:N2),simResult.reference.U(2:end,N1:N2),'LineWidth',1.2)
        grid on
        xlabel('Time [s]','FontSize',16);
        ylabel('torque','FontSize',16);
        legend('roll','pitch','yaw','Location','best')

        subplot(2,3,6)
        plot(simResult.T(:,N1:N2),error,'LineWidth',1.2)
        grid on
        xlabel('Time [s]','FontSize',16);
        ylabel('reference - estimator','FontSize',16);
        legend('error_x','error_y','error_z','Location','best')
        

        % set(gcf, 'Position', [160, 200, 1200, 500]);
        N1 = N1 + 55;
        N2 = N2 + 55;
        simResult.Z(:,1) = F(simResult.reference.X(:,N1));
        simResult.Xhat(:,1) = simResult.reference.X(:,N1);
        j = j + 1;
        
        pause(6)
    end
end

