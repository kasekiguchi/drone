function x = get_state(state)
 x = cell2mat(arrayfun(@(t) state.(t)',string(state.list),'UniformOutput',false))';
end