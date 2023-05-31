function data = InportFromExpData(expData_Filename)
%INPORTFROMEXPDATA ドローンの実験データから入出力を抜き出す関数
%   expData_Filename : 実験データの保存場所
%   Data     : 出力変数をまとめる構造体
%   > Data.X : 入力前の状態
%   > Data.U : 対象への入力
%   > Data.Y : 入力後の状態
%   X, U, Y はデータ数が同じである必要がある
%   X, Y の状態(Eular Angle) [px py pz roll pitch yaw vx vy vz V_roll V_pitch V_yaw] 順番の確認


% 実験データ読み込み
% 読み込むファイル名を指定
% expData_Filename = 'TestData1.mat'

load(expData_Filename);
% load('D:\workspace\GitHub\drone\drone-isobe2022\drone-isobe2022\Data\simData_KoopmanApproach_2023_5_30_experiment\simtest_1.mat');
clear data % 読み込んだファイル内のdataと同名の変数を初期化
%データの個数をチェック
data.N = find(logger.Data.t,1,'last');
% data.N = 2461;

%% Get data
% 状態毎に分割して保存
% XYに結合する際の都合で↓時系列,→状態
%--------------------time----------------------
data.t = logger.Data.t(1:data.N);
%-------------------estimator----------------------
data.est.p = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.p,1:data.N,'UniformOutput',false))';
data.est.q = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.q,1:data.N,'UniformOutput',false))';
data.est.v = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.v,1:data.N,'UniformOutput',false))';
data.est.w = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.w,1:data.N,'UniformOutput',false))';
%-----------------------input----------------------
data.input = cell2mat(arrayfun(@(N) logger.Data.agent.input{N},1:data.N,'UniformOutput',false))';

%% Set Dataset and Input
% クープマン線形化のためのデータセットに結合
% ↓状態,→時系列
for i=1:1:data.N -1
    data.X(:,i) = [data.est.p(i,:)';data.est.q(i,:)';data.est.v(i,:)';data.est.w(i,:)'];
    data.Y(:,i) = [data.est.p(i+1,:)';data.est.q(i+1,:)';data.est.v(i+1,:)';data.est.w(i+1,:)'];
    data.U(:,i) = [data.input(i,:)'];
    data.T(:,i) = [data.t(i,:)];
end

end

