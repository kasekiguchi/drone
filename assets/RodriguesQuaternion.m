function [R,L] = RodriguesQuaternion(q)
% [R,L]=RodriguesQuaternion(q) : convert quaternion to rotaiton matrix
%  R is the rotation matrix
%  q is 4th dim vector : [1 0 0 0]
% R = rotmat(quaternion(q),'frame') と等価？違いそう
    q  = q(:);
    q0 = q(1);
    q1 = q(2);
    q2 = q(3);
    q3 = q(4);
	E = [-q1, q0,-q3, q2;
		 -q2, q3, q0,-q1;
		 -q3,-q2, q1, q0];
	L = [-q1, q0, q3,-q2;
		 -q2,-q3, q0, q1;
		 -q3, q2,-q1, q0];
	R = E*L';
end
