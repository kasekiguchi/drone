function U = NewCooperativeSuspendedLoadController_6(x,qi,R0,Ri,R0d,xd,K,P,Pdagger,doi)
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
% R0TFdMd = CSLC_6_R0TFdMd(x,xd,R0,R0d,P,K);%(26)の理想入力
% muid = reshape(kron(eye(6),R0)*Pdagger*R0TFdMd,3,6); % 3xN(26)理想張力
% mui = sum(muid.*qi,1).*qi; % 3xN(27)
if anynan(R0d)
    R0d = eye(3);
end
if anynan(xd(end-5:end))
    xd(end-5:end) = zeros(6,1);
end
muid_mui = Muid_6(x,qi,R0,R0d,xd,K,P,Pdagger);
muid = muid_mui(1:3,:); 
mui = muid_mui(4:6,:);
qid = -muid./vecnorm(muid,2,1); % 3xN(28)
ui = CSLC_6_ui(x,xd,R0,R0d,P,K,qid,Pdagger,mui,muid);%(35)
b3_norm = ui./vecnorm(ui,2,1); % 3xN
b1 = repmat(xd(4:6),1,6);
if sum(vecnorm(b1,2,1)==0) ~=0
  b1(:,vecnorm(b1,2,1)==0) = cell2mat(arrayfun(@(i) Ri(:,:,i)*[1;0;0],vecnorm(b1,2,1)==0,'UniformOutput',false));
end 
% dxd_norm = b1./vecnorm(b1,2,1);
% b1_norm = zeros(3,6);
% for i = 1:6
%     b3hat2 = Skew(b3_norm)^2;
%     b1_norm(:,i) = - b3hat2*dxd_norm(:,i);
% end
% b1_norm = - cross(b3_norm,cross(b3_norm,dxd_norm));
% b2_norm = cross(b3_norm, b1_norm); % 3xN
% si = vecnorm(b2_norm,2,1);
% ci = sum(b3_norm.* b1_norm,1);
% b2 = b2 ./ si;
% b1 = cross(b2, b3);
% U= CSLC_6_Uvec(x,xd,R0,R0d,P,K,qid,ui,Ri,b1_norm,b2_norm,b3_norm,si,ci);
%% 回転行列の微分を指定 機体の角加速度を差分で求める
    e3 = [0;0;1];
    Ji = reshape(P(end-17:end),3,[]);
    oi = reshape(x(end-17:end),3,[]);
    kri = K(end-2);
    koi = K(end-1);
    epsilon = K(end);

    b1 = repmat(xd(4:6),1,6);
    b1 = repmat([1;0;0],1,6);
    d1b1 = repmat(xd(7:9),1,6);
    d2b1 = repmat(xd(10:12),1,6);
    b3 = ui./vecnorm(ui,2,1);
    C1 = cross(b3,cross(b3,b1));
    C2 = Skew(b3)*b1;
    Ric1 = -C1./vecnorm(C1);
    Ric2 = C2./vecnorm(C2);
    Ric3 = b3;

    % d1b3 = zeros(size(b3_norm));
    % d2b3 = zeros(size(b3_norm));
    % d1b2 = zeros(size(b3_norm));
    % d2b2 = zeros(size(b3_norm));
    for i = 1:6
        dRi = Ri(:,:,i)*Skew(oi(:,i));
        d2Ri = dRi*Skew(oi(:,i)) + Ri(:,:,i)*Skew(doi(:,i));
        if vecnorm(dRi*e3) ~= 0
            d1b3 = dRi*e3/vecnorm(dRi*e3);
        else
            d1b3 = dRi*e3;
        end
        if vecnorm(d2Ri*e3) ~= 0
            d2b3 = d2Ri*e3/vecnorm(d2Ri*e3);
        else
            d2b3 = d2Ri*e3;
        end
        Skb3 = Skew(b3(:,i));
        d1Skb3 = Skew(d1b3);
        d2Skb3 = Skew(d2b3);

        d1C1 = Skb3^2*d1b1(:,i) + 2*Skb3*d1Skb3*b1(:,i);%b3(t)^2*diff(b1(t), t) + 2*b1(t)*b3(t)*diff(b3(t), t)
        d1C2 = d1Skb3*b1(:,i) + Skb3*d1b1(:,i);
        d2C1 = 2*d1Skb3^2*b1(:,i) + Skb3^2*d2b1(:,i) + 2*Skb3*d2Skb3*b1(:,i) + 4*Skb3*d1Skb3*d1b1(:,i);%2*b1(t)*diff(b3(t), t)^2 + b3(t)^2*diff(b1(t), t, t) + 2*b1(t)*b3(t)*diff(b3(t), t, t) + 4*b3(t)*diff(b1(t), t)*diff(b3(t), t)
        d2C2 = d2Skb3*b1(:,i) + Skb3*d2b1(:,i) + 2*d1Skb3*d1b1(:,i);%b1(t)*diff(b3(t), t, t) + b3(t)*diff(b1(t), t, t) + 2*diff(b1(t), t)*diff(b3(t), t)
        
        d1Ric1 = -d1C1./vecnorm(d1C1);
        d1Ric2 = d1C2./vecnorm(d1C2);
        d1Ric3 = d1b3;

        d2Ric1 = -d2C1./vecnorm(d2C1);
        d2Ric2 = d2C2./vecnorm(d2C2);
        d2Ric3 = d2b3;

        Ric{i} = [Ric1(:,i) Ric2(:,i) Ric3(:,i)];% 3x3xN
        dRic{i} = [d1Ric1 d1Ric2 d1Ric3];% 3x3xN
        ddRic{i} = [d2Ric1 d2Ric2 d2Ric3];% 3x3xN
        oic(:,i) = Vee(Ric{i}'*dRic{i});% 3xN = Vee(hoic)
        doic(:,i) =Vee(dRic{i}'*dRic{i} + Ric{i}*ddRic{i});
        % doic(:,i) = Vee(Ric{i}'*ddRic{i} - (Ric{i}'*dRic{i})^2);%+ (dRic{i}'*dRic{i}));% 3xN
    % end
    % for i = 1:N
        eri(:,i) = Vee(Ric{i}'*Ri(:,:,i)-Ri(:,:,i)'*Ric{i})/2;
        eoi(:,i) = oi(:,i) - Ri(:,:,i)'*Ric{i}*oic(:,i);% 3xN
    % end
    % for i = 1:N
        fi(i) = ui(:,i)'*Ri(:,:,i)*e3;
        Mi(:,i) = - kri*eri(:,i)/(epsilon^2) - koi*eoi(:,i)/epsilon + Skew(oi(:,i))*diag(Ji(:,i))*oi(:,i) - diag(Ji(:,i))*(Skew(oi(:,i))*Ri(:,:,i)'*Ric{i}*oic(:,i)-Ri(:,:,i)'*Ric{i}*doic(:,i));% 3xN
    end
    U = reshape([fi;Mi],[],1);
end