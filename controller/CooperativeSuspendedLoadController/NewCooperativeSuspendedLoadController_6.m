function U = NewCooperativeSuspendedLoadController_6(x,qi,R0,Ri,R0d,xd,K,P,Pdagger)
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
b3_norm = ui./vecnorm(ui,2,1); % 3xN
b1 = repmat(xd(4:6),1,6);
if sum(vecnorm(b1,2,1)==0) ~=0
  b1(:,vecnorm(b1,2,1)==0) = cell2mat(arrayfun(@(i) Ri(:,:,i)*[1;0;0],vecnorm(b1,2,1)==0,'UniformOutput',false));
end 
dxd_norm = b1./vecnorm(b1,2,1);
% b1_norm = zeros(3,6);
% for i = 1:6
%     b3hat2 = Skew(b3_norm)^2;
%     b1_norm(:,i) = - b3hat2*dxd_norm(:,i);
% end
b1_norm = - cross(b3_norm,cross(b3_norm,dxd_norm));
b2_norm = cross(b3_norm, b1_norm); % 3xN
si = vecnorm(b2_norm,2,1);
ci = sum(b3_norm.* b1_norm,1);
% b2 = b2 ./ si;
% b1 = cross(b2, b3);
U= CSLC_6_Uvec(x,xd,R0,R0d,P,K,qid,ui,Ri,b1_norm,b2_norm,b3_norm,si,ci);
%% 回転行列の微分を指定 機体の角加速度を差分で求める
    % e3 = [0;0;1];
    % Ji = reshape(P(end-17:end),3,[]);
    % oi = reshape(x(end-17:end),3,[]);
    % d1b1 = repmat(xd(7:9),1,6)./vecnorm(xd(7:9),2,1);
    % d2b1 = repmat(xd(10:12),1,6)./vecnorm(xd(10:12),2,1);
    % d1b3 = zeros(size(b3_norm));
    % d2b3 = zeros(size(b3_norm));
    % d1b2 = zeros(size(b3_norm));
    % d2b2 = zeros(size(b3_norm));
    % for i = 1:N
    %     dRi = Ri(:,:,i)*Skew(oi(:,i));
    %     d1b3 = dRi*e3/vecnorm(dRi*e3);%zeros(size(b3_norm));
    %     d2b3 = (dRi(:,:,i)*Skew(oi(:,i)) + Skew(oi(:,i))*0)*e3;
    %     d1b2 = zeros(size(b3_norm));
    %     d2b2 = zeros(size(b3_norm));
    %     Ric{i} = [b1_norm(:,i) b2_norm(:,i) b3_norm(:,i)];% 3x3xN
    %     dRic{i} = [d1b1(:,i) d1b2(:,i) d1b3(:,i)];% 3x3xN
    %     ddRic{i} = [d2b1(:,i),d2b2(:,i),d2b3(:,i)];% 3x3xN
    %     oic(:,i) = Vee(Ric{i}'*dRic{i});% 3xN = Vee(hoic)
    %     doic(:,i) = Vee(Ric{i}'*ddRic{i} - (Ric{i}'*dRic{i})^2);%+ (dRic{i}'*dRic{i}));% 3xN
    % % end
    % % for i = 1:N
    %     eri(:,i) = Vee(Ric{i}'*Ri(:,:,i)-Ri(:,:,i)'*Ric{i})/2;
    %     eoi(:,i) = oi(:,i) - Ri(:,:,i)'*Ric{i}*oic(:,i);% 3xN
    % % end
    % % for i = 1:N
    %     fi(i) = ui(:,i)'*Ri(:,:,i)*e3;
    %     Mi(:,i) = - kri*eri(:,i)/(epsilon^2) - koi*eoi(:,i)/epsilon + Skew(oi(:,i))*Ji(:,i)*oi(:,i) - Ji(:,i)*(Skew(oi(:,i))*Ri(:,:,i)'*Ric{i}*oic(:,i)-Ri(:,:,i)*Ric{i}*doic(:,i));% 3xN
    % end
    % U = reshape([fi;Mi],[],1);
end