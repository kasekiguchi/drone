function parameter = FittingEndPoint(map, Constant)    
    % Pre-calculation of each coeffient
    a_pow_2 = map.a .^ 2;
    b_pow_2 = map.b .^ 2;
    a_plus_b_pow_2 = a_pow_2 + b_pow_2;
    a_multi_b = map.a .* map.b;
    a_multi_c = map.a .* map.c;
    b_multi_c = map.b .* map.c;
    % Projection of start and end point to line
    parameter.x = (b_pow_2 .* map.x - a_multi_b .* map.y - a_multi_c) ./ a_plus_b_pow_2;
    parameter.y = (a_pow_2 .* map.y - a_multi_b .* map.x - b_multi_c) ./ a_plus_b_pow_2;
end
