
%% RUN
%-- 複数回MPCを実行するためのファイル

N = 10;

WV = [50 60 70;
       60 90 100;
       70 10 10;
       80 20 20;
       90 40 20;
       20 30 100];

WP = [10 10 20;
    20 10 20;
    5 14 20;
    25 15 10;
    5 14 10];

for Wi = 1:size(WV, 1)
    WeightV = WV(Wi, :);
    WeightP = WP(Wi, :);
    main_sqp_Koopman_renew
    if dataRMSE(1:3) < 0.1 % x, yのRMSEが0.1未満であれば終了
        Wi
        Params
        break;
    end
end