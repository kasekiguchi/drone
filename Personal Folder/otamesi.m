% ファイルの選択ダイアログを表示し、ユーザーにファイルを選択させる
[fileName, filePath] = uigetfile('*.*', 'ファイルを選択してください');

% ファイルが選択されなかった場合の処理
if isequal(fileName, 0)
    disp('ファイルが選択されませんでした。');
else
    % 選択されたファイルのフルパスを表示
    disp(['選択されたファイル: ', fullfile(filePath, fileName)]);
    load(fileName)
    disp('選択されたファイルの読み込みが完了しました')
    % 選択されたファイルを読み込む処理を追加
    % 例: テキストファイルの読み込み
    % fileContent = fileread(fullfile(filePath, fileName));
    % disp('ファイルの内容:');
    % disp(fileContent);
end
