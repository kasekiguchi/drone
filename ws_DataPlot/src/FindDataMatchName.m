function [Index,dimension,data,Flag] = FindDataMatchName(logger,Name)
% tmp = regexp(logger.items,Name);
% tmp = cellfun(@(c) ~isempty(c),tmp);
% Index = find(tmp);
Index = [];
teid = find(logger.Data.t,1,'last')-1;
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
            data(pI,1:teid) = cell2mat(arrayfun(@(N) logger.Data.agent{N,Index}(pI),1:teid,'UniformOutput',false));
        end
    else
        dimension = size(logger.Data.agent{1,Index},1);
        data = zeros(dimension,size(logger.Data.t,1));
        for pI = 1:dimension
            data(pI,1:teid) = cell2mat(arrayfun(@(N) logger.Data.agent{N,Index}(pI),1:teid,'UniformOutput',false));
        end
    end
end
Flag = true;
data = logger.data(1,Name,[])';
dimension = size(data,1);
end