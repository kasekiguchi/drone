function x = projection_to_unit_quaternion(state)
    x= state;
    if isfield(state,'q')
        x.q=state.q/norm(state.q);
    else % q ‚ğ‚½‚È‚¢ê‡
        x(1:4)=state(1:4)/norm(state(1:4));
    end
end
