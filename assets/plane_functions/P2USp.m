function Sp = P2USp(P)
% convert points in 3D space to unit spherical coordinates
% P = [x1,y1,z1;x2,y2,z2; ...];
% Sp = [phi1,theta1;phi2,theta2;...];
% phi : angle on x-y plane
% theta : angle from z axis

D = vecnorm(P,2,2);
E = P./D; % unit sphere
DXY = vecnorm(E(:,1:2),2,2);
Sp = [sign(E(:,2)).*acos(E(:,1)./DXY),acos(E(:,3))];
end

