function state=state_copy(orgstate)
% STATE_CLASS objectを値としてコピーするための関数
state=copy(orgstate);
F=fieldnames(orgstate);
for i = 1:length(F)
    if ~strcmp(F{i},'list') && ~strcmp(F{i},'num_list') && ~strcmp(F{i},'type')
        addprop(state,F{i});
        state.set_state(F{i},orgstate.(F{i}));
    end
end
end
