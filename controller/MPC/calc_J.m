function [J] = calc_J(x, r, u, Q, R, H)
%　評価関数の計算あってるのかー！！という関数
    % Q = obj.weight;
    % Qf = obj.weightF;
    % R = obj.weightR;
    % Rp = obj.weightRp;

    k = linspace(1,1.2, H);
    xe = (x-r(1:12,:)) .* k;
    ue = (u-r(13:16,:)) .* k;
    J = sum(diag(xe'*Q*xe + ue'*R*ue)); 
end