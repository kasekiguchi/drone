function [eul] = Quat2Eul(q)
    % convert quaternion to euler angle
    % ÅyInputÅzq : quaternion
    % ÅyOutputÅzeul : euler angle
    nq=norm(q);
    q0 = q(1)/nq;
    q1 = q(2)/nq;
    q2 = q(3)/nq;
    q3 = q(4)/nq;
	phi = atan2((2*(q0.*q1 + q2.*q3)),(q0.^2 - q1.^2 - q2.^2 + q3.^2));
	th  = asin(2*(q0.*q2 - q1.*q3));
	psi = atan2((2*(q0.*q3 + q1.*q2)),(q0.^2 + q1.^2 - q2.^2 - q3.^2));
    eul = [phi; th; psi];
end
