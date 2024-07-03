function U = CooperativeSuspendedLoadController_6(x,qi,R0,Ri,R0d,xd,K,P,Pdagger,doi)
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
R0TFdMd = CSLC_6_R0TFdMd(x,xd,R0,R0d,P,K);%(26)の理想入力
muid = reshape(kron(eye(6),R0)*Pdagger*R0TFdMd,3,6); % 3xN(26)理想張力
mui = sum(muid.*qi,1).*qi; % 3xN(27)
qid = -muid./vecnorm(muid,2,1); % 3xN(28)
ui = CSLC_6_ui(x,xd,R0,R0d,P,K,qid,Pdagger,mui,muid);%(35)
b3 = ui./vecnorm(ui,2,1); % 3xN
b1 = repmat(xd(4:6),1,6);
if sum(vecnorm(b1,2,1)==0) ~=0
  b1(:,vecnorm(b1,2,1)==0) = cell2mat(arrayfun(@(i) Ri(:,:,i)*[1;0;0],vecnorm(b1,2,1)==0,'UniformOutput',false));
end
b1 = b1./vecnorm(b1,2,1);
b2 = cross(b3, b1); % 3xN
si = vecnorm(b2,2,1);
ci = sum(b3.* b1,1);
% b2 = b2 ./ si;
% b1 = cross(b2, b3);
U= CSLC_6_Uvec(x,xd,R0,R0d,P,K,qid,ui,Ri,b1,b2,b3,si,ci);
end
