function data = ImportFromExpData(expData_Filename)
%INPORTFROMEXPDATA ドローンの実験データから入出力を抜き出す関数
%   expData_Filename : 実験データの保存場所
%   Data     : 出力変数をまとめる構造体
%   > Data.X : 入力前の状態
%   > Data.U : 対象への入力
%   > Data.Y : 入力後の状態
%   X, U, Y はデータ数が同じである必要がある
%   X, Y の状態(Eular Angle) [px py pz roll pitch yaw vx vy vz V_roll V_pitch V_yaw] 順番の確認


% 実験データ読み込み
logger = load(expData_Filename);
logger = logger.(string(fieldnames(logger)));
clear data % 読み込んだファイル内のdataと同名の変数を初期化

%データの個数をチェック
data.N = find(logger.Data.t,1,'last');
data.uN = 4; %入力の個数
data.fExp = logger.fExp;

%% Get data
% 状態毎に分割して保存
% XYに結合する際の都合で↓時系列,→状態
%drone_phase  115:stop  97:arming  116:take off  102:flight  108:landing

if logger.fExp==1 %fExp:1 実機データ
%--------------------time----------------------
    % data.est.p = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.p,1:data.N,'UniformOutput',false))'; 
%     data.startIndex = find(data.est.p(:,3)>0.5,1,'first'); %0.4m以上になった部分からデータの取得開始
    data.t = logger.Data.t;
    data.phase = logger.Data.phase;
    data.startIndex = find(data.phase==102,1,'first'); %flight部分のみをデータとして使用
    % data.startIndex = find(data.phase==102,1,'first') + 220; %完全に目標軌道になった部分のデータのみを使用
%     data.startIndex = find(data.phase==102,1,'first') + 200; %逆円旋回
%     data.startIndex = find(data.phase == 102, 1, 'first') + 150; %完全にサドル起動になった部分のデータのみを使用
%     data.phase = logger.Data.phase;
    data.endIndex = find(data.phase == 102,1,'last'); %ランディングする前にデータの取得をやめる
%     data.endIndex = find(data.phase == 108,1,'last'); %ランディングまで全部
    data.N = data.endIndex - data.startIndex + 1;
    data.t = logger.Data.t(data.startIndex:data.endIndex);
%-------------------estimator----------------------
    data.est.p = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.p,data.startIndex:data.endIndex,'UniformOutput',false))';
    data.est.q = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.q,data.startIndex:data.endIndex,'UniformOutput',false))';
    data.est.v = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.v,data.startIndex:data.endIndex,'UniformOutput',false))';
    data.est.w = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.w,data.startIndex:data.endIndex,'UniformOutput',false))';
%-----------------------input----------------------
    data.input = cell2mat(arrayfun(@(N)logger.Data.agent.input{N}(1:data.uN),data.startIndex:data.endIndex,'UniformOutput',false))';
    
    %総推力+トルク入力 → 各プロペラの推力に分解するときはコメントイン------------------------------
    % for i = 1:size(data.input,1) 
    %     data.input(i,:) = T2T(data.input(i,1),data.input(i,2),data.input(i,3),data.input(i,4));
    % end
    % plot(logger.Data.t(data.startIndex:data.endIndex),data.input) %入力の確認
    %---------------------------------------------------------------------------------------------

    data.est.z(1,1) = data.est.p(1,3);
    for i = 1:data.N-1
        data.est.z(1,i+1) = data.est.z(1,i) + data.est.v(i,3)*(data.t(i+1,:)-data.t(i,:));
    end

    data.est.vz(1,1) = data.est.v(1,3);
    for i = 1:data.N-1
        data.est.vz(1,i+1) = (data.est.p(i+1,3)-data.est.p(i,3))/(data.t(i+1,:)-data.t(i,:));
    end

    % size = figure;
    % size.WindowState = 'maximized'; %表示するグラフを最大化
    % figure(1)
    % plot(data.t',data.est.p(:,3)','LineWidth',1.2)
    % grid on
    % hold on
    % plot(data.t',data.est.z,'LineWidth',1.2)
    % hold off
    % xlabel('Time')
    % ylabel('position z')
    % legend('z','cal z')
    % 
    % size = figure;
    % size.WindowState = 'maximized'; %表示するグラフを最大化
    % figure(2)
    % plot(data.t',data.est.v(:,3)','LineWidth',1.2)
    % grid on
    % hold on
    % plot(data.t',data.est.vz,'LineWidth',1.2)
    % hold off
    % xlabel('Time')
    % ylabel('velocity vz')
    % legend('z','cal z')

    % figure(2)
    % subplot(1,2,1)
    % plot(data.t',data.est.v(:,3)')
    % grid on
    % xlabel('Time')
    % ylabel('velocity z')
    % subplot(1,2,2)
    % plot(data.t',data.input(:,1)')
    % grid on
    % xlabel('Time')
    % ylabel('input')
    pause(1)

else
    data.startIndex = 1;
    data.endIndex = data.N;
%--------------------time----------------------
    data.t = logger.Data.t(1:data.N);
%-------------------estimator----------------------
    data.est.p = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.p,data.startIndex:data.endIndex,'UniformOutput',false))';
    data.est.q = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.q,data.startIndex:data.endIndex,'UniformOutput',false))';
    data.est.v = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.v,data.startIndex:data.endIndex,'UniformOutput',false))';
    data.est.w = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.w,data.startIndex:data.endIndex,'UniformOutput',false))';
%-----------------------input----------------------
    data.input = cell2mat(arrayfun(@(N) logger.Data.agent.input{N}(1:data.uN),data.startIndex:data.endIndex,'UniformOutput',false))';
    
    %総推力+トルク入力 → 各プロペラの推力に分解するときはコメントイン------------------------------
    % for i = 1:size(data.input,1) 
    %     data.input(i,:) = T2T(data.input(i,1),data.input(i,2),data.input(i,3),data.input(i,4));
    % end
    % plot(logger.Data.t(data.startIndex:data.endIndex),data.input) %入力の確認
    %---------------------------------------------------------------------------------------------
end
%% Set Dataset and Input
% クープマン線形化のためのデータセットに結合
% ↓状態,→時系列
% for i=1:data.N-1
%     data.X(:,i) = [data.est.p(i,:)';data.est.q(i,:)';data.est.v(i,:)';data.est.w(i,:)'];
%     data.Y(:,i) = [data.est.p(i+1,:)';data.est.q(i+1,:)';data.est.v(i+1,:)';data.est.w(i+1,:)'];
%     data.U(:,i) = [data.input(i,:)'];
%     data.T(:,i) = [data.t(i,:)];
% end

% for i=1:data.N-1
%     data.X(:,i) = [data.est.p(i,1:2)';data.est.z(:,i);data.est.q(i,:)';data.est.v(i,:)';data.est.w(i,:)'];
%     data.Y(:,i) = [data.est.p(i+1,1:2)';data.est.z(:,i+1);data.est.q(i+1,:)';data.est.v(i+1,:)';data.est.w(i+1,:)'];
%     data.U(:,i) = [data.input(i,:)'];
%     data.T(:,i) = [data.t(i,:)];
% end

for i=1:data.N-1
    data.X(:,i) = [data.est.p(i,:)';data.est.q(i,:)';data.est.v(i,1:2)';data.est.vz(:,i);data.est.w(i,:)'];
    data.Y(:,i) = [data.est.p(i+1,:)';data.est.q(i+1,:)';data.est.v(i+1,1:2)';data.est.vz(:,i+1);data.est.w(i+1,:)'];
    data.U(:,i) = [data.input(i,:)'];
    data.T(:,i) = [data.t(i,:)];
end

end

