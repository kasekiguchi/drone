function output = structure2vector(state)
output = cell2mat(arrayfun(@(t) state.(t)',string(state.list),'UniformOutput',false))';
end
