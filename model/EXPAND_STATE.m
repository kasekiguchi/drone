function [expandA, expandB] = EXPAND_STATE(obj)
    H = obj.param.H;
    L = size(obj.A, 1);
    expandA = zeros(L*H, 12);
    expandB = zeros(L*H, 4*H);
    tmpA = obj.A(:,:,1);
    tmpB = obj.B(:,:,1);
    BB = zeros(12, 4*H);
    for n = 1:H
        BB(:, 4*(n-1)+1 : 4*n) = tmpA.^(n-1)*tmpB; % 12 * (4H)
    end

    for n = 1:H
        expandA(L*(n-1)+1:L*n,:) = tmpA.^n; % 12H * 4
        expandB(L*(n-1)+1:L*n,:) = [BB(:, 1:4*n), zeros(12, (H-n)*4)]; % 12H * 4H
    end

    % サンプル分拡張
    expandA = repmat(expandA, 1,1,obj.N);
    expandB = repmat(expandB, 1,1,obj.N);
end