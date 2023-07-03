function U = CooperativeSuspendedLoadController_4(x_no_q,qi,R0,Ri,R0d,xd,K,P,Pdagger)
 % x_no_q : state except for q
 % qi : subpart of x 3xN
 % xd : reference 18x1 : =[x0d;dx0d;ddx0d;dddx0d;o0d;do0d] 
 % R0 : load attitude 3x3
 % Ri : drone attitude
 % R0d : reference attitude
 % K : gains = []
 % P : physical parameter
 % Pdagger = pinv(P) in (26)
 % U : [f1;M1;f2;M2;...] for zup system
R0TFdMd = CSLC_4_R0TFdMd(x_no_q,xd,R0,R0d,P,K);
muid = reshape(kron(eye(4),R0)*Pdagger*R0TFdMd,3,4); % 3xN
mui = sum(muid.*qi,1).*qi; % 3xN
qid = -muid./vecnorm(muid,1); % 3xN
ui = CSLC_4_ui(x_no_q,xd,R0,R0d,P,K,Pdagger,mui,qid);
b3 = -ui./sqrt(sum(ui.*ui,1)); % 3xN
b1 = xd(4:6) + 0.1*cell2mat(arrayfun(@(i) Ri(:,:,i)*[1;0;0],1:4,'UniformOutput',false)); % Caution : problem if dx0d = - 10*xi.
b1 = b1./sqrt(sum(b1.*b1,1));
b2 = cross(b3, b1); % 3xN
si = sqrt(sum(b2.*b2,1));
ci = sum(b3.* b1,1);
b2 = b2 ./ si;
b1 = cross(b2, b3);
U= CSLC_4_Uvec(x_no_q,xd,P,K,ui,R0,Ri,R0d,qid,b1,b2,b3,si,ci);
end
