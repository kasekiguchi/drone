%%
function state = input_state(param)
%一定推力を印加したときの状態遷移
    thrust = param{5};
    torque = param{6};
    step = param{4};
    % U = repmat([thrust; torque], 1, step);
    U = [thrust; torque];

    A = param{1};
    B = param{2};
    C = param{3};

    % X = zeros(12,1);
    % Z = quaternions_all(X);

    pos = param{7};
    Z = quaternions_all(pos(:, param{8})); % ある区間の始めの状態

    try
        for i = 1:step
            Z(:,i+1) = A * Z(:,i) + B * U(:,i);
        end
        state = C * Z; 
    catch
        open('quaternions_all.m');
        error('観測量の次元が一致しません');
    end
end