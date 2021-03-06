function [state] = state_convert(state1,state2)
% state = state_convert(state1,state2)
% state1の状態をstate2の形式に変換してstate2に代入（state2 のlistに無い項目は無視）
% state = 代入後のstate2.get()
% if length(state2.list)==length(state1.list)
%     if state2.list==state1.list
%         state2.set_state(state1.get());
%     end
% else
    for i = 1:length(state2.list)
        field = state2.list(i);
        state2.set_state(field,state1.(field));
    end
%end
state = state2.get();
end

