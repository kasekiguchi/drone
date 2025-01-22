%% make path and folder
    %変更しない
    % ExportFolder='A:\Work2024\momose';%実験用pcのパス
    ExportFolder='C:\きょうゆう';
    ExportFolder='\\Desktop-2pivavv\きょうゆう';
    % ExportFolder='X:\Work2024\momose';
    % % % ExportFolder='C:\Users\acsl_students\Documents\students\workspace2024\momose';%実験用pcのパス
    % ExportFolder='C:\Users\81809\OneDrive\デスクトップ\results';%自分のパス
    % ExportFolder='C:\Users\81809\OneDrive\ドキュメント\GitHub\drone\Data';
    % ExportFolder='Data';%github内
    DataFig='data';%データか図か
    date=string(datetime('now','Format','yyyy_MMdd_HHmm'));%日付ファイル
    date2=string(datetime('now','Format','yyyy_MMdd'));%日付フォルダ
%変更==============================================================================
    % date2 = "2025_0116";%日付が変わってしまった場合は自分で変更
    % subfolder='exp';%sim or exp
    subfolder='sim';%sim or exp
    ExpSimName='drone4p1';%実験,シミュレーション名
    % contents='FT_apx_max';%実験,シミュレーション内容
    contents='p2p_rot_t_noNoize_hikaku';%実験,シミュレーション内容64文字以内
    % contents='loadSysEKF';%実験,シミュレーション内容64文字以内
    % contents='expnadAndloadSysEKF';%実験,シミュレーション内容64文字以内
    % contents='epandAndLoadSysEKFsensorNoize0_01inputNoizeT0_01Tq0_001';%実験,シミュレーション内容64文字以内
%======================================================================================
    FolderNameD=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'data');%保存先のpath
    FolderNameR=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName));%保存先のpath
    FolderNameF=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'figure');%保存先のpath
    FolderNameL=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'simpleLog');%保存先のpath
    %フォルダができてないとき
    if ~exist(FolderNameD,"dir")
        mkdir(FolderNameD);
        mkdir(FolderNameF);
        mkdir(FolderNameR);
        mkdir(FolderNameL);
        addpath(genpath(ExportFolder));
    end
     %フォルダをrmる
    %     rmpath(genpath(ExportFolder))