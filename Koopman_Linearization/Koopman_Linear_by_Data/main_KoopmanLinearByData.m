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
%---------------------------------------------

%% 
%データ保存先ファイル名(逐次変更する)
% FileName = 'EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data.mat';  %plotResultの方も変更するように，変更しないとどんどん上書きされる
FileName = 'test_0503.mat'; %お試し用

% 読み込むデータファイル名(データセットに使うファイルをまとめたフォルダを作るとよい，ファイル名は統一)
% ※name_change.m使うと簡単に統一できるよ
loading_filename = 'Exp_2_4';

Data.HowmanyDataset =150; %読み込むデータ数に応じて変更

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

% データの結合を行う部分
disp('now loading data set')

for i= 1: Data.HowmanyDataset
    if contains(loading_filename,'.mat')
        Dataset = ImportFromExpData(loading_filename); %ImportFromExpData:読み込むデータ範囲の設定や配列の変形を行う関数
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
    est = KL(Data.X,Data.U,Data.Y,F); %KL:クープマン線形化の計算を行う関数
end

est.observable = F;
disp('Estimated')

%% Simulation by Estimated model(構築したモデルでシミュレーション)
%推定精度検証シミュレーション
simResult.reference = ImportFromExpData_verification('experiment_9_5_saddle_estimatordata'); %推定精度検証用データの設定

% アーミングphaseの実験データがうまく取れていないのを強引に解消
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

if Normalize == 1 %推定精度検証用データの正規化
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

%% 作成済みモデルで，推定する軌道を変更(全時刻に対する推定検証を行う)
%推定する領域をずらしながら推定検証を行う．
clc
clear
% num = input('＜全時刻の推定を行いますか＞\n 1:行う 0:行わない：','s');
change_reference = 1; %str2double(num);
only_rmse = 1;
% saddle
% P2Px, P2Py
% hovering
Exp_tra = 'P2Py';
fileName = WhichLoadFile(Exp_tra, 2);

if change_reference == 1
    % clear all
    close all
    opengl software
   
    % experiment_10_25_P2Py_estimator
    % experiment_9_5_saddle_estimatordata
    simResult.reference = ImportFromExpData_verification(fileName); %推定精度検証用データの設定

    model = load("EstimationResult_2024-06-04_Exp_KiyamaX_20data_code00_saddle.mat",'est'); % 推定したモデル
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
    while(N2 <= simResult.reference.N)
        clc
        for i = N1:N2-1
            simResult.Z(:,i-N1+2) = est.A * simResult.Z(:,i-N1+1) + est.B * simResult.U(:,i); %状態方程式 z[k+1] = Az[k]+BU
        end
        simResult.Xhat = est.C * simResult.Z; %出力方程式 x[k] = Cz[k]
        fprintf('\n%d～%dstep間の推定結果を表示します\n', N1, N2)
        size_f = figure;
        size_f.WindowState = 'maximized'; %表示するグラフを最大化
        for i = 1:3
            % RMSEのみならコメントアウト-----------------------------------
            if ~only_rmse
                subplot(2,3,i)
                plot(simResult.T(:,N1:N2),simResult.Xhat(i,:),'LineWidth',1.2)
                hold on
                grid on
                plot(simResult.T(:,N1:N2),simResult.reference.X(i,N1:N2),'LineWidth',1.2,'LineStyle','--','Color','red')
                legend('estimator','reference','Location','best')
            end
            % -------------------------------------------------------------
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
        % RMSEのみならコメントアウト---------------------------------------
        if ~only_rmse
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
        end
        % -----------------------------------------------------------------
%         

        N1 = N1 + 55;
        N2 = N2 + 55;
        simResult.Z(:,1) = F(simResult.reference.X(:,N1));
        simResult.Xhat(:,1) = simResult.reference.X(:,N1);
        j = j + 1;
        
%         pause(6)
    end

    fprintf('各方向のRMSEの変位，最大誤差を表示します\n')
    size_f = figure;
    size_f.WindowState = 'maximized'; %表示するグラフを最大化
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

    %--------------------------
    fprintf('SUM RMSE : x = %.4f, y = %.4f, z = %.4f \n', sum(x), sum(y), sum(z));
    fprintf('SUM ERROR: x = %.4f, y = %.4f, z = %.4f \n', sum(xerror_max), sum(yerror_max), sum(zerror_max));
    if only_rmse; close([1:j-1]); end
end

