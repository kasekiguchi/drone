function H = Calc_entropy(sigma)
%This program calculate  Entropy of multiple variables Gause density  
%sigma: covariance matrix
% n: dimension of state
n = size(sigma,1);
H = (n/2) * (1+ log(2*pi)) + (1/2) * log(det(sigma));
end