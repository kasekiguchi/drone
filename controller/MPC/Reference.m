function xr = Reference(H, Ur, Y, dT)
% [Input]
% H: horizon
% Ur:input reference
% Y: current output
% dT: step size for MPC
% [Output]
% xr : state reference
xr = ones(2, H);
for L = 1:H
  xr(:, L) = [Y(1) + Ur(1)*(L-1)*dT; 0.];
end
end
