function Mui = Muid_6(x,qi,R0,R0d,xd,K,P,Pdagger)
 % x : state
 % qi : subpart of x 3xN
 % xd : reference 18x1 : =[x0d;dx0d;ddx0d;dddx0d;o0d;do0d] 
 % R0 : load attitude 3x3
 % Ri : drone attitude
 % R0d : reference attitude
 % K : gains = []
 % P : physical parameter
 % Pdagger = pinv(P) in (26)
 % U : [f1;M1;f2;M2;...] for zup system
R0TFdMd = CSLC_6_R0TFdMd(x,xd,R0,R0d,P,K);
muid = reshape(kron(eye(6),R0)*Pdagger*R0TFdMd,3,6); % 3xN
mui = sum(muid.*qi,1).*qi; % 3xN
Mui = [muid;mui];
end