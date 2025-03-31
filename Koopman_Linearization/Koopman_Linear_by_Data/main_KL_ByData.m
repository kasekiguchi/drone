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
flg.weight = 0; % 重み付き最小二乗法

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
% F = @quaternions_all_26;
% F = @fF;
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
        % est = KL(Data.X,Data.U,Data.Y,F,flg); 
      [H,f] = gen_Hf(Data.X,Data.U,Data.Y,0.025,F);
      % [xxT,xuT,uuT,xy,uy] = gen_Hf(Data.X,Data.U,Data.Y,0.025,F);
      % n = size(xxT,1);
      % m = size(Data.U,1);
      % txxT = arrayfun(@(i) xxT,1:n,'UniformOutput',false);
      % txuT = arrayfun(@(i) xuT,1:n,'UniformOutput',false);
      % tuuT = arrayfun(@(i) uuT,1:n,'UniformOutput',false);
      % tH = [blkdiag(txxT{:}),blkdiag(txuT{:});blkdiag(txuT{:})',blkdiag(tuuT{:})];
      % tf = [xy;uy];
      % 
      % %% constraint
      % dt_ids = [7,8,9] + (0:2)*n;
      % z_ids = [1:3*n,n^2+1:n^2+3*m];   
      % NN = (1:size(tH,1));
      % NN(z_ids) = [];
      % H = tH(:,NN);
      % H(z_ids,:) = [];
      % f = tf;
      % ttH = tH(:,dt_ids)*dt;
      % f(z_ids,:) = [];
      % ttH(z_ids,:) = [];
      % f = f+ sum(ttH,2);
      var = quadprog(H,f);
      % est.A =[eye(3),zeros(3,3),0.025*eye(3),zeros(3,17);reshape(var(1:26*23),26,[])'];
      % est.B = [zeros(3,4);reshape(var(26*23+1:end),4,[])'];
      est.A =[eye(6),0.025*eye(6),zeros(6,26-12);reshape(var(1:26*20),26,[])'];
      est.B = [zeros(6,4);reshape(var(26*20+1:end),4,[])'];
      est.C = [eye(12),zeros(12,size(est.A,1)-12)];
         % est = KL_optimization(Data.X,Data.U,Data.Y,F,flg);
    end%クープマン線形化の具体的な計算をしてる部分
end

est.observable = F;
fprintf('\n＜クープマン線形化が完了しました＞\n')

save(targetpath,'est')
disp('Saved to')
disp(targetpath)
toc
