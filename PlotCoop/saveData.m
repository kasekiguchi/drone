%% make folder&save
    run("makeSavePath")
    % agent name
    agentContents = strcat('agent_',contents);    
    SaveTitleAgent = strcat(date,'_',agentContents);            % 保存するagent の名前
    % logger name
    loggerContents = strcat('log_',contents); 
    SaveTitleLog = strcat(date,'_',loggerContents);             % 保存するlog の名前
    % simple logger name
    simpleLoggerContents = strcat('simple_',loggerContents);
    SaveTitleSimple = strcat(date,'_',simpleLoggerContents);    % 保存するsimpleにしたlogの名前

    % if exist("logger","var")
    if ~exist("gui","var")
    % multiple var : save logger, simple logger and agent
        tic
        eval([agentContents '=agent;']);                        % agentの名前をagent_contentsに変更
        toc
        % tic
        eval([loggerContents '= logger;']);                     % loggerの名前をlogger_contentsに変更
        toc
        % tic
        for i = 1:length(logger.target)
            loggers{i,1} = simplifyLogger(logger,i);
        end
        eval([simpleLoggerContents,'= loggers;']);              % loggerの名前をsimple_loggerに変更
        toc
    else
    % single var : save logger, simple logger and agent
        tic
        eval([agentContents '=gui.agent;']);                    % agentの名前をagent_contentsに変更
        toc
        eval([loggerContents '= gui.logger;']);                 % loggerの名前をlogger_contentsに変更
        toc
        for i = 1:length(gui.logger.Data.agent)
            loggers{i,1} = simplifyLogger(gui.logger,i );
        end
        eval([simpleLoggerContents,'= loggers;']);              % loggerの名前をsimple_loggerに変更 
        toc
    end
    %Dataフォルダから読み込んだ場合agentはなし
        % agentNum = length(log.Data.agent);
        % eval([agentContents '=gui.agent;']);%agentの名前をagent_contentsに変更
        % eval([loggerContents '= log;']);%loggerの名前をlogger_contentsに変更
        % eval([simpleLoggerContents,'= simplifyLoggerForSingle(log,agentNum );']);
    % save date
        save(fullfile(FolderNameD, SaveTitleAgent),agentContents);          % agentを保存
        save(fullfile(FolderNameD, SaveTitleLog),loggerContents);           % logを保存
        save(fullfile(FolderNameL, SaveTitleSimple),simpleLoggerContents);  % 簡単にしたlogを保存
    %savefig
    %     SaveTitle=strcat(date,'_',ExpSimName);
    %     saveas(1, fullfile(FolderName, SaveTitle ),'jpg');
    %     saveas(1, fullfile(FolderName, SaveTitle ),'fig');
    %     saveas(f(i), fullfile(FolderName, SaveTitle(i) ),'eps');