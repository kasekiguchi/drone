% コマンドウィンドウにメッセージを表示し、ファイル名を入力させる
fileName = input('ファイル名を入力してください: ', 's');

% 入力が空の場合の処理
if isempty(fileName)
    disp('ファイル名が入力されませんでした。');
else
    % 入力されたファイル名を表示
    disp(['入力されたファイル名: ', fileName]);
    
    % 入力されたファイル名を使用して、ファイルを読み込む処理を追加
    % 例: テキストファイルの読み込み
    % try
    %     fileContent = fileread(fileName);
    %     disp('ファイルの内容:');
    %     disp(fileContent);
    % catch
    %     disp('ファイルの読み込みに失敗しました。');
    % end
end
