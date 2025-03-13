function haven = DataSet_randomSort(Data)
%% 取得したデータセットの順番をランダムに入れ替える
% Data          : 元のデータセット
% > Data.T
% > Data.X
% > Data.U
% > Data.Y
%
% dataN         : 元のデータの数
% sootNumber    : sootNumberに格納された番号順にデータセットを入れかえる
% haven         : 入れ替えたあとのデータセットを格納する構造体

    haven = Data;
    haven = rmfield(haven,{'X','U','Y','T'});
    
    [~,dataN] = size(Data.T);

    sortNumber = randperm(dataN);

    for i = 1:1:dataN
        haven.T(:,i) = Data.T(:,sortNumber(i));
        haven.X(:,i) = Data.X(:,sortNumber(i)); 
        haven.U(:,i) = Data.U(:,sortNumber(i));
        haven.Y(:,i) = Data.Y(:,sortNumber(i));
    end

    disp('Random sorting completed.');

end