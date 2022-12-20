function out = Fp2mat_for_matrix_inverse(obj,fp)
% fp : N x 9 : face points : each row = [x1 y1 z1, x2 y2 z2, x3 y3 z3];
% 　　each row = [q11,q21,q31,q12,q22,q32,q13,q23,q33]
% inv(Q - p) = adj(Q-p)/det(Q-p)
% det(Q-p) = det(Q) +  p'*cross(Q(:,3),Q(:,2))- p'*cross(Q(:,1),Q(:,3))- p'*cross(Q(:,2),Q(:,1))
% T1 = [Skew(P(2,:)')*P(3,:)',Skew(P(2,:)')*[1;1;1],Skew(P(3,:)')*[1;1;1]]';
% T2 = [Skew(P(1,:)')*[1;1;1],Skew(P(3,:)')*P(1,:)',Skew(P(3,:)')*[1;1;1]]';
% T3 = [Skew(P(1,:)')*[1;1;1],Skew(P(2,:)')*[1;1;1],Skew(P(1,:)')*P(2,:)']';
% adj(Q-p) = adj(Q) + 
%          = [[e2 -e3 1]*T1, [e3 -e1 1]*T2, [-e2 e1 1]*T3];
% これらを書き下して掛け算が少なくなるように整理した
% 使い方
% det(Q-p) : detP + dP1*p1 + dP2*p2 + dP3*p3;
% Ar = [Pi3*p2-Pi2*p3,Pi1*p3-Pi3*p1,Pi2*p1-Pi1*p2];
% adj(Q-r) : Pi + [Ar(:,1:3:end),Ar(:,2:3:end),Asr(:,3:3:end)];
% Qir : adj(Q-r)./det(Q-p)
% 検証
% Qec1 = Qc1' - p';
% Qec2 = Qc2' - p';
% Qec3 = Qc3' - p';
% Ans=[sum(Qec1.*Qir(:,1:3),2),sum(Qec1.*Qir(:,4:6),2),sum(Qec1.*Qir(:,7:9),2),...
% sum(Qec2.*Qir(:,1:3),2),sum(Qec2.*Qir(:,4:6),2),sum(Qec2.*Qir(:,7:9),2),...
% sum(Qec3.*Qir(:,1:3),2),sum(Qec3.*Qir(:,4:6),2),sum(Qec3.*Qir(:,7:9),2)];
% Ans(1,:) => [1 0 0, 0 1 0, 0 0 1] となっていれば正しい
Q11=fp(:,1);Q12=fp(:,4);Q13=fp(:,7);
Q21=fp(:,2);Q22=fp(:,5);Q23=fp(:,8);
Q31=fp(:,3);Q32=fp(:,6);Q33=fp(:,9);
Qc1 = [Q11,Q21,Q31];
Qc2 = [Q12,Q22,Q32];
Qc3 = [Q13,Q23,Q33];

%P0c = [cross(fp(:,4:6),fp(:,7:9)),cross(fp(:,7:9),fp(:,1:3)),cross(fp(:,1:3),fp(:,4:6))];% n-face x 9 : = [Pc1', Pc2', Pc3'] : P = Q^(-1)*det(Q) 
Pi = [cross(Qc2,Qc3),cross(Qc3,Qc1),cross(Qc1,Qc2)];% n-face x 9 : = [Pr1, Pr2, Pr3] : P = Q^(-1)*det(Q) 

Pi1 = [Q12-Q13,Q13-Q11,Q11-Q12];
Pi2 = [Q22-Q23,Q23-Q21,Q21-Q22];
Pi3 = [Q32-Q33,Q33-Q31,Q31-Q32];

dP3 = Q12.*Q21 - Q11.*Q22 + Q11.*Q23 - Q13.*Q21 - Q12.*Q23 + Q13.*Q22;
dP2 = Q11.*Q32 - Q12.*Q31 - Q11.*Q33 + Q13.*Q31 + Q12.*Q33 - Q13.*Q32;
dP1 = - Q21.*Q32 + Q22.*Q31 + Q21.*Q33 - Q23.*Q31 - Q22.*Q33 + Q23.*Q32;
detP = Q11.*Q22.*Q33 - Q11.*Q23.*Q32 - Q12.*Q21.*Q33 + Q12.*Q23.*Q31 + Q13.*Q21.*Q32 - Q13.*Q22.*Q31;
out = [Pi,Pi1,Pi2,Pi3,detP,dP1,dP2,dP3];
end