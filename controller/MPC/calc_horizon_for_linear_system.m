function [AN,BN] = calc_horizon_for_linear_system(A,B,H)
% setupで一度実行するだけなので効率よりわかりやすさ重視
% AN = [A;A^2;A^3;...;A^H]
% BN = [B,0 0 ... 0;AB, B, 0,...,0;...;A^(H-1)B,A^(H-2)B,...,AB,B]
% X = AN*x0 + BN*U
% X = [x[1];x[2];...;x[H]]
% U = [u[0];u[1];...;u[H-1]]
n = size(A,1);
m = size(B,2);
AN = zeros(n*H,n);
BN = zeros(n*H,m*H);
Ai = eye(n);
Bi = zeros(n,m*H);
Bi(:,1:m) = B;
for i = 1:H
  Bi(:,1:m*i) = [Ai*B,Bi(:,1:m*(i-1))];
  BN((i-1)*n+1:i*n,:) = Bi;
  Ai = Ai*A;
  AN((i-1)*n+1:i*n,:) = Ai;
end
end