function state=state_copy(orgstate)
% STATE_CLASS object��l�Ƃ��ăR�s�[���邽�߂̊֐�
state=copy(orgstate);
F=fieldnames(orgstate);
for i = 1:length(F)
    if ~strcmp(F{i},'list') && ~strcmp(F{i},'num_list') && ~strcmp(F{i},'type')
        addprop(state,F{i});
        state.set_state(F{i},orgstate.(F{i}));
    end
end
end
