clear; clc;
tmp = matlab.desktop.editor.getActive;
cd(strcat(fileparts(tmp.Filename), '../../../'));
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
%%
clear; clc;
flg.bilinear = 0; % 双線形モデル
flg.normalize = 0; % 正規化
flg.without_pos = 0; % 位置無観測量
flg.weight = 0 % 重み付き最小二乗法

FileName_common = strcat(string(datetime('now'), 'yyyy-MM-dd'), '_'); 
Exp_tra = 'saddle'; % リファレンスデータを特定するための変数
exp_data = 'Exp_Kyomo';    %zのみ速度から
FileName = strcat(FileName_common, exp_data, '_', 'code00_', Exp_tra); % 保存先
activeFile = matlab.desktop.editor.getActive;
nowFolder = fileparts(activeFile.Filename);
targetpath=append(nowFolder,'\..\EstimationResult\',FileName);
% load('Koopman_Linearization\Integration_Dataset\Kiyama_Exp_Dataset.mat'); %2023年度
load('Koopman_Linearization\Integration_Dataset\momo.mat');

if isfile(strcat('Koopman_Linearization\EstimationResult\', FileName, '.mat'))
    error('Exist file. Require change filename');
end

%-- 観測量は固まったら分けた方が快速
F = @quaternions_all_00; % 個別用
% F = @quaternions_all; % 2024 全観測量

% データのかさまし
flg.increased = 1; % このフラグがあるときは生成データ保存時にデータセットを含ませない
% if flg.increased
%     Data = data_increased(Data, [0.0001, 0.0001, 0], 10);
% end

% 正規化
if flg.normalize == 1 %正規化を行うか(正規化については自分で調べて！)
    Ndata = Normalization(Data);
    Data.X = Ndata.x;
    Data.Y = Ndata.y;
    Data.U = Ndata.u;
    disp('Normalization is complete')
end

disp(FileName); % 保存名，flgの確認
%% Koopman linearization
fprintf('\n＜クープマン線形化を実行＞\n')
tic
if flg.bilinear == 1
    est = KL_biLinear(Data.X,Data.U,Data.Y,F);
else
    if flg.without_pos
        est = KL(Data.X(4:end,:),Data.U,Data.Y(4:end,:),F,flg); % 位置を観測量に入れないときのKL
    else 
        est = KL(Data.X,Data.U,Data.Y,F,flg); 
        % est = KL_optimization(Data.X,Data.U,Data.Y,F,flg);
    end%クープマン線形化の具体的な計算をしてる部分
end

est.observable = F;
fprintf('\n＜クープマン線形化が完了しました＞\n')

save(targetpath,'est')
disp('Saved to')
disp(targetpath)
toc
