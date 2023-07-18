function out = checkZero(in)
%CHECKZERO 値を確認し0の場合に微小な値を代入
%   あ

v = 1.0 * 10^-6; % 微小な値

if in == 0
    out = v;
else
    out = in;
end

end

