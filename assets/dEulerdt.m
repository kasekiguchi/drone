
function deu = dEulerdt(eu,o)
% eu : euler angle
% o : anguler velocity vector
% deu : deu/dt
% 
% algorithm
% using euler parameter model : dq/dt = L*o/2
% syms eu [3 1] real
% syms deu [3 1] real
% syms q [4 1] real % unit quaternion
% [~,L] = RodriguesQuaternion(q); % 
% Eq = simplify(Eul2Quat(eu));
% dP=simplify(jacobian(Eq,eu)); % dq/deu
% EL = simplify(subs(L,q,Eq));
% dER=solve(dP*deu==EL'*o/2,deu);
% tmp = struct2cell(dER);
% deu = simplify([tmp{:}]');
deu = [(o(1,:).*cos(eu(2,:)) + o(3,:).*cos(eu(1,:)).*sin(eu(2,:)) + o(2,:).*sin(eu(1,:)).*sin(eu(2,:)))./cos(eu(2,:));
                                                o(2,:).*cos(eu(1,:)) - o(3,:).*sin(eu(1,:));
                                    (o(3,:).*cos(eu(1,:)) + o(2,:).*sin(eu(1,:)))./cos(eu(2,:))];
end
