%%ファイル名を一括で変えるプログラム(2周連続で回す時はloading_filenameを変更するように！)
% folderPath = 'D:\workspace\GitHub\drone\drone-isobe2022\drone-isobe2022\Data\simData_KoopmanApproach_2023_9_6_experiment_saddle'; %フォルダの指定
folderPath = 'C:\Users\kiyam\Documents\卒業研究\GitHub2\drone\drone-isobe2022\drone-isobe2022\Data\simData_KoopmanApproach_2023_9_6_experiment_saddle_circle'; %フォルダの指定(自分のPC)
fileList = dir(fullfile(folderPath,'*.mat')); %対象のファイルを取得
loading_filename = 'experiment_9_5_saddle_circle'; %変更後のファイル名の指定
for i = 1:length(fileList)
    oldFileName = fullfile(folderPath,fileList(i).name);
    newFileName = fullfile(folderPath,[append(loading_filename,'_',num2str(i),'.mat')]);

    movefile(oldFileName, newFileName); %名前の変更
end

