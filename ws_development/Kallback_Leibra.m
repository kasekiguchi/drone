function [KL] = Kallback_Leibra(sigma1,mu1,sigma2,mu2)
%calculate Kallback leibra divergence
%sigma = covariance matrix
% mu = average of probability
d = size(sigma1,1);
KL = (1/2) * ( log(det(sigma2)/det(sigma1)) - d + trace(sigma2\sigma1) + (mu2 - mu1)' * inv(sigma2) * (mu2 - mu1) );
end

