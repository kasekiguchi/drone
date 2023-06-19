function Data = loadData(loading_filename,reference_filepath)
%LOADDATA  実験データから必要なものを抜き出す処理,↓状態,→データ番号(同一番号のデータが対応関係にある)
% Data.X 入力前の対象の状態
% Data.U 対象への入力
% Data.Y 入力後の対象の状態
if isfolder(reference_filepath)
    reference_filename = dir(fullfile(reference_filepath)).name;
else
    reference_filename = reference_filepath;
end

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
    % フォルダの中にシミュレーションで基準にしたいファイルがあった場合は除外して読み込む
    if ~isempty(dir(fullfile(loading_filename,reference_filename)))
        fileList(contains({fileList.name},reference_filename)) = [];
    end
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
    disp(['quaternion norm = ' ,num2str(attitude_norm)])
end
end

