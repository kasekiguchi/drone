%% make folder&save
run("makeSavePath")
    % agent name
    agentContents=strcat('agent_',contents);
    SaveTitle2=strcat(date,'_',agentContents);
    % logger name
    loggerContents=strcat('log_',contents);
    SaveTitle=strcat(date,'_',loggerContents);    
    % simple logger name
    simpleLoggerContents = strcat('simple_',loggerContents);
    simpleSaveTitle=strcat(date,'_',simpleLoggerContents);

    % if exist("logger","var")
    % % multiple var : save logger, simple logger and agent
        tic
        eval([agentContents '=agent;']);%agentの名前をagent_contentsに変更
        toc
        % tic
        eval([loggerContents '= logger;']);%loggerの名前をlogger_contentsに変更
        toc
        % tic
        for i = 1:length(logger.target)
            loggers{i,1} = simplifyLoggerForCoop(logger,i);
        end
        eval([simpleLoggerContents,'= loggers;']);
        toc
    % else
    % single var : save logger, simple logger and agent
        % eval([agentContents '=gui.agent;']);%agentの名前をagent_contentsに変更
        % eval([loggerContents '= gui.logger;']);%loggerの名前をlogger_contentsに変更
        % for i = 1:length(gui.logger.Data.agent)
        %     loggers{i,1} = simplifyLoggerForSingle(gui.logger,i );
        % end
        % eval([simpleLoggerContents,'= loggers;']);
        % for i = 1:length(logger.target)
        %     loggers{i,1} = simplifyLoggerForCoop(logger,i);
        % end
        % eval([simpleLoggerContents,'= simplifyLoggerForSingle(gui.logger,agentNum );']);
        % eval([agentContents '=gui.agent;']);%agentの名前をagent_contentsに変更
        
        %Dataフォルダから読み込んだ場合agentはなし
        % agentNum = length(log.Data.agent);
        % eval([loggerContents '= log;']);%loggerの名前をlogger_contentsに変更
        % eval([simpleLoggerContents,'= simplifyLoggerForSingle(log,agentNum );']);
    % end
save(fullfile(FolderNameD, SaveTitle2),agentContents);
save(fullfile(FolderNameD, SaveTitle),loggerContents);
save(fullfile(FolderNameL, simpleSaveTitle),simpleLoggerContents);
    %savefig
%     SaveTitle=strcat(date,'_',ExpSimName);
%         saveas(1, fullfile(FolderName, SaveTitle ),'jpg');
    %     saveas(1, fullfile(FolderName, SaveTitle ),'fig');
    %     saveas(f(i), fullfile(FolderName, SaveTitle(i) ),'eps');