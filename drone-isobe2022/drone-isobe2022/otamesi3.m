clc
clear all

parentFolderPath = 'Data';
newFolderName = input('データセットフォルダ内のファイルを移動します．\n移動先のフォルダ名を入力してください：','s');
newFolderPath = fullfile(parentFolderPath,newFolderName);
mkdir(newFolderPath)

sourceFolderPath = 'データセット';
destinationFolderPath = newFolderPath;

files = dir(fullfile(sourceFolderPath,'*.mat'));
for i = 1:length(files)
    filePath = fullfile(sourceFolderPath,files(i).name);
    movefile(filePath,destinationFolderPath);
end

disp('ファイルの移動完了')