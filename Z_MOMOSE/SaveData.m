%% make folder&save
    %変更しない
    % ExportFolder='W:\workspace\Work2023\momose';%実験用pcのパス
    ExportFolder='C:\Users\Students\Documents\work2023\momose';%実験用pcのパス
    % ExportFolder='C:\Users\81809\OneDrive\デスクトップ\results';%自分のパス
    % ExportFolder='C:\Users\81809\OneDrive\ドキュメント\GitHub\drone\Data';
    % ExportFolder='Data';%github内
    DataFig='data';%データか図か
    date=string(datetime('now','Format','yyyy_MMdd_HHmm'));%日付
    date2=string(datetime('now','Format','yyyy_MMdd'));%日付
%変更==============================================================================
    subfolder='exp';%sim or exp
    ExpSimName='HL_flightEL';%実験,シミュレーション名
    % contents='FT_apx_max';%実験,シミュレーション内容
    contents='second';%実験,シミュレーション内容
%======================================================================================
    FolderNamed=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'data');%保存先のpath
    FolderNamef=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'figure');%保存先のpath
    %フォルダができてないとき
    
        mkdir(FolderNamed);
        mkdir(FolderNamef);
        addpath(genpath(ExportFolder));
    
    % save logger and agent
        logger_contents=strcat('log_',contents);
        SaveTitle=strcat(date,'_',logger_contents);    
        eval([logger_contents '= gui.logger;']);%loggerの名前をlogger_contentsに変更
        save(fullfile(FolderNamed, SaveTitle),logger_contents);
      
        agent_contents=strcat('agent_',contents);
        SaveTitle2=strcat(date,'_',agent_contents);
        eval([agent_contents '=gui.agent;']);%agentの名前をagent_contentsに変更
        save(fullfile(FolderNamed, SaveTitle2),agent_contents);

    %savefig
%     SaveTitle=strcat(date,'_',ExpSimName);
%         saveas(1, fullfile(FolderName, SaveTitle ),'jpg');
    %     saveas(1, fullfile(FolderName, SaveTitle ),'fig');
    %     saveas(f(i), fullfile(FolderName, SaveTitle(i) ),'eps');

% ratio = 0.7;
% agent.set_model_error("lx",0.0585*(ratio-0.6));%0.0585 %0.06くらいでFT=FB 
% agent.set_model_error("ly",0.0466*(ratio-0.6));%0.0466
% agent.set_model_error("mass",0.269*ratio);%0.269
% agent(i).set_model_error("jx", 0.02237568*ratio);%0.02237568;
% agent.set_model_error("jy", 0.02985236*ratio);%0.02985236;
% agent.set_model_error("jz",0.0480374*ratio);%0.0480374;
% agent.set_model_error("km1",0.0301*ratio);%0.0301
% agent.set_model_error("km2",0.0301*ratio);%0.0301
% agent.set_model_error("km3",0.0301*ratio);%0.0301
% agent.set_model_error("km4",0.0301*ratio);%0.0301
% agent.set_model_error("k1",-100000000);%0.000008
% agent.set_model_error("k2",0.05);%0.000008
% agent.set_model_error("k3",0.05);%0.000008
% agent.set_model_error("k4",0.05);%0.000008