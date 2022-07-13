BB = find(~logger.Data.t);
logger.Data.t(BB,:) = [];
AA = all(cellfun(@isempty,logger.Data.agent),2);
logger.Data.agent(AA,:) = [];