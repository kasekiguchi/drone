function [a, b, c, x0, y0] = LinearizePoints(x, y)
% 最小二乗法を用いて点群を直線の方程式に変案
% 直線の傾きに応じて線分の算出方法を変更
    if length(x) > 1
        % Pre-calculation of inclination using start and end point.
        x_pre = [min(x), max(x)];
        y_pre = [min(y), max(y)];
        a_pre = (y_pre(2) - y_pre(1)) / (x_pre(2) - x_pre(1));
        % Calculation of "ax + by + c = 0"
        if a_pre > -1 && a_pre < 1  
            % Calculation of each coeffient in "y = ax + c"
            b = -1;
            [a, c] = LeastSquaresMethod(x, y);
            x0 = [min(x), max(x)];
            y0 = a .* x0 + c;
        else
            % Calculation of each coeffient in "x = by + c"
            a = -1;
            [b, c] = LeastSquaresMethod(y, x);
            y0 = [min(y), max(y)];
            x0 = b .* y0 + c;
        end
    else
        % If there are no points, each value are cleared to zero.
        a = 0;
        b = 0;
        c = 0;
        x0 = [0, 0];
        y0 = [0, 0];
    end
end
 
%% Calculation of each coeffient in "y = ax + b"
function [a, b] = LeastSquaresMethod(x, y)%直線の方程式
    % Calculation of each coeffient
    N = length(x);
    xy_sum = sum(x .* y);
    x_sum = sum(x);
    y_sum = sum(y);
    x_sum_2 = x_sum ^ 2;
    x_2_sum = sum(x .^ 2);
    % Calculation of "a" and "b" using least squares method
    a = (N * xy_sum - x_sum * y_sum) / (N * x_2_sum - x_sum_2);
    b = (x_2_sum * y_sum - x_sum * xy_sum) / (N * x_2_sum - x_sum_2);
end
