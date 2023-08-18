function [U,tdqid,tddqid] = CooperativeSuspendedLoadController_3(x,qi,R0,Ri,R0d,xd,K,P,Pdagger,tdqid,tddqid)
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
R0TFdMd = CSLC_3_R0TFdMd(x,xd,R0,R0d,P,K);
muid = reshape(kron(eye(3),R0)*Pdagger*R0TFdMd,3,3); % 3xN
mui = sum(muid.*qi,1).*qi; % 3xN
qid = -muid./vecnorm(muid,2,1); % 3xN
Ap = -49/51;% -2/3
Bp = -100000/2601; % -250/9
Dp = 1000/51; % 50/3
tdqid = Ap*tdqid + Bp*qid;
dqid = 0*(tdqid + Dp*qid);
tddqid = Ap*tddqid + Bp*dqid;
ddqid =  0*(tddqid + Dp*dqid); 
ui = CSLC_3_ui(x,xd,R0,R0d,P,K,Pdagger,mui,qid,dqid,ddqid);
b3 = ui./vecnorm(ui,2,1); % 3xN
b1 = xd(4:6) + 0.1*cell2mat(arrayfun(@(i) Ri(:,:,i)*[1;0;0],1:3,'UniformOutput',false)); % Caution : problem if dx0d = - 10*xi.
b1 = b1./vecnorm(b1,2,1);
b2 = cross(b3, b1); % 3xN
si = vecnorm(b2,2,1);
ci = sum(b3.* b1,1);
b2 = b2 ./ si;
b1 = cross(b2, b3);
U= CSLC_3_Uvec(x,xd,P,K,ui,R0,Ri,R0d,qid,b1,b2,b3,si,ci);
end
