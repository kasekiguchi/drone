function [state] = state_convert(state1,state2)
% state = state_convert(state1,state2)
% state1‚Ìó‘Ô‚ğstate2‚ÌŒ`®‚É•ÏŠ·‚µ‚Ästate2‚É‘ã“üistate2 ‚Ìlist‚É–³‚¢€–Ú‚Í–³‹j
% state = ‘ã“üŒã‚Ìstate2.get()
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

