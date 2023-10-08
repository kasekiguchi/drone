function xr = Reference(n, H, vr, Y, dT)
% [Input]
% H: horizon
% vr: velocity reference
% Y: current output
% dT: step size for MPC
% [Output]
% xr : state reference
xr = zeros(n*H,1);
xr(1,1) = Y(1) + vr(1)*dT;
for L = 2:H
  xr(n*(L-1)+1,1) = xr(n*(L-2)+1,1) + vr(L)*dT;
end
end
