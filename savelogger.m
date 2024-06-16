%% make folder&save
%TODO------------------------
%plotに必要なところだけ抜き取ったファイルを作成するプログラムを追加する．
%------------------------
    %変更しない
    ExportFolder='W:\workspace\Work2023\momose';%実験用pcのパス
    % ExportFolder='C:\Users\Students\Documents\work2023\momose';%実験用pcのパス
    % ExportFolder='C:\Users\81809\OneDrive\デスクトップ\results';%自分のパス
    % ExportFolder='C:\Users\81809\OneDrive\ドキュメント\GitHub\drone\Data';
    % ExportFolder='Data';%github内
    DataFig='data';%データか図か
    date=string(datetime('now','Format','yyyy_MMdd_HHmm'));%日付
    date2=string(datetime('now','Format','yyyy_MMdd'));%日付
%変更==============================================================================
    subfolder='exp';%sim or exp
    ExpSimName='23TADR_spline_modelerro';%実験,シミュレーション名
    % contents='FT_apx_max';%実験,シミュレーション内容
    contents='spHLFT';%実験,シミュレーション内容
%======================================================================================
    FolderNamed=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'data');%保存先のpath
    FolderNamef=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'figure');%保存先のpath
    FolderNamel=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'loggers');%保存先のpath
    %フォルダができてないとき
    if ~exist(FolderNamed,"dir")
        mkdir(FolderNamed);
        mkdir(FolderNamef);
        mkdir(FolderNamel);
        addpath(genpath(ExportFolder));
    end
    
    % save logger, simple logger and agent
        agentContents=strcat('agent_',contents);
        SaveTitle2=strcat(date,'_',agentContents);
        eval([agentContents '=gui.agent;']);%agentの名前をagent_contentsに変更
        save(fullfile(FolderNamed, SaveTitle2),agentContents);

        loggerContents=strcat('log_',contents);
        SaveTitle=strcat(date,'_',loggerContents);    
        eval([loggerContents '= gui.logger;']);%loggerの名前をlogger_contentsに変更
        save(fullfile(FolderNamed, SaveTitle),loggerContents);
        
        simpleLoggerContents = strcat('simple_',loggerContents);
        simpleSaveTitle=strcat(date,'_',simpleLoggerContents);    
        eval([simpleLoggerContents,'= simplifyLogger(',loggerContents,');']);
        save(fullfile(FolderNamel, simpleSaveTitle),simpleLoggerContents);
