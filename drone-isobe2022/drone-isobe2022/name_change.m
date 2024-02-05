%%ファイル名を一括で変えるプログラム(2周連続で回す時はloading_filenameを変更するように！)
clear all
folderPath = 'Data\ExpData_KoopmanApproach_2024_2_4'; %フォルダの指定(自分のPC)
fileList = dir(fullfile(folderPath,'*.mat')); %対象のファイルを取得
loading_filename = 'Exp_2_4'; %変更後のファイル名の指定
for i = 1:length(fileList)
    oldFileName = fullfile(folderPath,fileList(i).name);
    newFileName = fullfile(folderPath,[append(loading_filename,'_',num2str(i),'.mat')]);

    movefile(oldFileName, newFileName); %名前の変更
end
fprintf('namechange finished \n')

