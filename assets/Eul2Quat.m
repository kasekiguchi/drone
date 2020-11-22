function [q] = Eul2Quat(eul)
    % convert euler angle to quaternion
    % 【Input】 eul : euler angle
    % 【Output】q : quaternion
	phi = eul(1)/2;
    th  = eul(2)/2;
    psi = eul(3)/2;
	q0 = cos(phi)*cos(th)*cos(psi) + sin(phi)*sin(th)*sin(psi);
	q1 = sin(phi)*cos(th)*cos(psi) - cos(phi)*sin(th)*sin(psi);
	q2 = cos(phi)*sin(th)*cos(psi) + sin(phi)*cos(th)*sin(psi);
	q3 = cos(phi)*cos(th)*sin(psi) - sin(phi)*sin(th)*cos(psi);
% % Normalize quaternion
    tmp = sqrt(q0.^2 + q1.^2 + q2.^2 + q3.^2);
	q0 = q0/tmp;
	q1 = q1/tmp;
	q2 = q2/tmp;
	q3 = q3/tmp;
    q = [q0; q1; q2; q3];
end
