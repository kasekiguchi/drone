function [Index,dimension,data,Flag] = FindDataMatchName(logger,Name)
tmp = regexp(logger.items,Name);
tmp = cellfun(@(c) ~isempty(c),tmp);
Index = find(tmp);
if isempty(Index)
    Flag = false;
    dimension = 0;
    data = 0;
else
    Flag = true;
    if ~iscolumn(logger.Data.agent{1,Index})
        dimension = size(logger.Data.agent{1,Index}',1);
        data = zeros(dimension,size(logger.Data.t,1));
        for pI = 1:dimension
            data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,Index}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
        end
    else
        dimension = size(logger.Data.agent{1,Index},1);
        data = zeros(dimension,size(logger.Data.t,1));
        for pI = 1:dimension
            data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.agent{N,Index}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
        end
    end
end
end