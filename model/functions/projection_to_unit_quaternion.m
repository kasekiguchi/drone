function x = projection_to_unit_quaternion(state)
    x= state;
    if isfield(state,'q')
        x.q=state.q/norm(state.q);
    else % q を持たない場合
        x(1:4)=state(1:4)/norm(state(1:4));
    end
end
