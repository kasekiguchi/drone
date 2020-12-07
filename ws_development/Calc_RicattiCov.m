function [] = Calc_RicattiCov(theta)
% matrix define
A = zeros(state_count);
A(4,1:2)= [cos(theta),sin(theta)];
A(5,3) = 1;

B = [cos(theta) , sin(theta) , 0, 0, 0;
    0 , 0 , 1 , 0 , 0;];

H = zeros(association_available_count, state_count);
for i = 1:association_available_count
    curr = association_available_index(i);
    idx = association_info.index(association_available_index(i));
    angle = pre_state(3) + measured.angles(curr) - line_param.delta(idx);
    denon = line_param.d(idx) - pre_state(1) * cos(line_param.delta(idx)) - pre_state(2) * sin(line_param.delta(idx));
    % Observation jacobi matrix
    H(i, 1) = -cos(line_param.delta(idx)) / cos(angle);
    H(i, 2) = -sin(line_param.delta(idx)) / cos(angle);
    H(i, 3) = denon * tan(angle) / cos(angle);
    H(i, 4) = 0;
    H(i, 5) = 0;
    H(i, 6 + (idx - 1) * 2) = 1 / cos(angle);
    H(i, 7 + (idx - 1) * 2) = (pre_state(1) * sin(line_param.delta(idx)) - pre_state(2) * cos(line_param.delta(idx))) / cos(angle) ...
        - denon * tan(angle) / cos(angle);
end
dotP = @(P) -P*A - A'*P + H'*R*H - P*B*V*B'*P;%R : obseve noise, V: system noise

end