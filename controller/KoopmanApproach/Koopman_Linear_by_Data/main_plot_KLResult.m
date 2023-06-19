%% MAIN_PLOT_KLRESULT
% plot_KLResult.mのみを実行するスクリプト

clear

loadfilename{1} = 'savetest.mat';
loadfilename{2} = 'EstimationResult_quaternion12state_bilinear_plusConst.mat';

flg = struct('calcFile1RMSE',0,'ylimHold',0,'xlimHold',0,'figureSave',0);

HowmanyFile = numel(loadfilename);

for i = 1:HowmanyFile
    file{i} = load(loadfilename{i});
end

plot_KLResult(file,flg);