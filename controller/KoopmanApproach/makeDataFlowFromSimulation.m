function output = makeDataFlowFromSimulation(varargin)
%MAKEDATAFLOWFROMSIMULATION 入力されたシミュレーションデータからクープマンモード分解のためのデータセットを出力する
%   varargin(1) : シミュレーションデータの保存場所 char,string
%                 フォルダを指定する場合はベースフォルダからのパスで指定すること
%   varargin(2) : 出力されるデータフローに追加する値を計算するための関数(観測量とか) 関数ハンドル
%                 X = varargin(2)(varagin(1))
%                 入力する関数ハンドルXの出力が追加したい値を含む縦ベクトルであること
%   output: 出力されるデータフロー行列 ↓系列, →時系列
%   入力にvararginを使っているのはデータフローに観測量を追加するしないで分けるのがいやだったから
%% ファイル名の読み込み
% 拡張子をチェックして含まれていない(フォルダを指定)している場合はフラグをON
data_Filename = varargin{1};
[filepath, name, ext] = fileparts(char(data_Filename));
if isempty(ext)
    flg_multiFile = 1;
else
    flg_multiFile = 0;
end
if numel(varargin) > 1
    flg_F = 1; % データフローに追加データを与えるフラグ
    F = varargin{2};
else
    flg_F = 0;
end
if flg_multiFile == 0
    % データ読み込み
    simData = ImportFromExpData(data_Filename);
    % Data.XとData.Yの合成
    % ImportFromExpDataを使いまわしているのが理由
    simData = [simData.X,simData.Y(:,end)];
    % 構造体の使わないフィールドを削除 要らない処理かも
    % simData = rmfield(simData,{'Y','U','T'});
    [M N] = size(simData);
    if flg_F == 1
        for i = 1:N
            appendData(:,i) = F(simData(:,i));
        end
        output = [simData;appendData];
    else
        output = simData;
    end
elseif flg_multiFile == 1
    fileList = dir(fullfile(data_Filename,'*.mat'));
    for i = 1:numel(fileList)
        filePath = fullfile(data_Filename,fileList(i).name);
        simData = ImportFromExpData(filePath);
        disp(fileList(i).name);
        % Data.XとData.Yの合成
        % ImportFromExpDataを使いまわしているのが理由
        simData = [simData.X,simData.Y(:,end)];
        [M N] = size(simData);
        if flg_F == 1
            for j = 1:N
                appendData(:,j) = F(simData(:,j));
            end
            dataHaven = [simData;appendData];
        else
            dataHaven = simData;
        end
        if i == 1
            output = dataHaven;
        else
            output = [output,dataHaven];
        end
    end
end