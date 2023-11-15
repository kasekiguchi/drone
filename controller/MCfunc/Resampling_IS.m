function [resampling_u, pw] = Resampling_IS(NP, H, pw, u)
    % 重点サンプリング
    % NP = obj.N;
    % pw = obj.input.EvalNorm; % 正規化された評価値
    resampling_u = zeros(4, H, NP);
    u1 = reshape(u(1,:,:), [], NP); 
    u2 = reshape(u(2,:,:), [], NP); 
    u3 = reshape(u(3,:,:), [], NP); 
    u4 = reshape(u(4,:,:), [], NP); 
    sumu1w = sum(u1.*pw);
    sumu2w = sum(u2.*pw);
    sumu3w = sum(u3.*pw);
    sumu4w = sum(u4.*pw);
    sumw = sum(pw);
    u1 = repmat(sumu1w ./ sumw, H, 1);
    u2 = repmat(sumu2w ./ sumw, H, 1);
    u3 = repmat(sumu3w ./ sumw, H, 1);
    u4 = repmat(sumu4w ./ sumw, H, 1);
    resampling_u(4, 1:H, 1:NP) = u4;
    resampling_u(3, 1:H, 1:NP) = u3;
    resampling_u(2, 1:H, 1:NP) = u2;
    resampling_u(1, 1:H, 1:NP) = u1;
end