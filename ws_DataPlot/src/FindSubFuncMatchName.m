function [Index,dimension,data,Flag] = FindSubFuncMatchName(logger,Name)
tmp = regexp(logger.SubFuncitems,Name);
tmp = arrayfun(@(c) ~isempty(c),tmp);
Index = find(tmp)+1;
if isempty(Index)
    Flag = false;
    dimension = 0;
    data = 0;
else
    Flag = true;
    if ~iscolumn(logger.Data.SubFuncData{1,Index})
        dimension = size(logger.Data.SubFuncData{1,Index}',1);
        data = zeros(dimension,size(logger.Data.t,1));
        for pI = 1:dimension
            data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.SubFuncData{N,Index}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
        end
    else
        dimension = size(logger.Data.SubFuncData{1,Index},1);
        data = zeros(dimension,size(logger.Data.t,1));
        for pI = 1:dimension
            data(pI,:) = cell2mat(arrayfun(@(N) logger.Data.SubFuncData{N,Index}(pI),1:size(logger.Data.t,1),'UniformOutput',false));
        end
    end
end
end