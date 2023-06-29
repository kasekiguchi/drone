classdef GEOMETRIC_CONTROLLER < handle
  % Hierarchical linearization based controller for a quadcopter
  properties
    self
    result
    param
    %parameter_name = ["g","m0","j01","j02","j03","rho1_1","rho1_2","rho1_3","rho2_1","rho2_2","rho2_3","rho3_1","rho3_2","rho3_3","rho4_1","rho4_2","rho4_3","li1","li2","li3","li4","mi1","mi2","mi3","mi4","ji1_1","ji1_2","ji1_3","ji2_1","ji2_2","ji2_3","ji3_1","ji3_2","ji3_3","ji4_1","ji4_2","ji4_3"];
    parameter_name = ["g","m0","J0","rho","li","mi","Ji"];
  end

  methods
    function obj = GEOMETRIC_CONTROLLER(self,param)
      obj.self = self;
      obj.param = param;
      %obj.param.P = self.parameter.get(obj.parameter_name);
      obj.param.P = self.parameter.get("all","row");
      obj.result.input = zeros(self.estimator.model.dim(2),1);
    end

    function result = do(obj,varargin)
      g = obj.param.P(1);
      m0 = obj.param.P(2);
      J0 = diag([obj.param.P(3),obj.param.P(4),obj.param.P(5)]);
      rho1 = obj.param.P(6:8)';
      rho2 = obj.param.P(9:11)';
      rho3 = obj.param.P(12:14)';
      rho4 = obj.param.P(15:17)';
      l1 = obj.param.P(18);
      l2 = obj.param.P(19);
      l3 = obj.param.P(20);
      l4 = obj.param.P(21);
      m1= obj.param.P(22);
      m2= obj.param.P(23);
      m3= obj.param.P(24);
      m4= obj.param.P(25);
      J1 = diag([obj.param.P(26),obj.param.P(27),obj.param.P(28)]);
      J2 = diag([obj.param.P(29),obj.param.P(30),obj.param.P(31)]);
      J3 = diag([obj.param.P(32),obj.param.P(33),obj.param.P(34)]);
      J4 = diag([obj.param.P(35),obj.param.P(36),obj.param.P(37)]);
      
      
      rho_hat = [Skew(rho1),Skew(rho2),Skew(rho3),Skew(rho4)];
      P_mat = [eye(3),eye(3),eye(3),eye(3);rho_hat]; 

      t = varargin{1,1}.t;

      e3 = [0;0;1];
      
      model = obj.self.estimator.result.state;
      ref = obj.self.reference.result;
      pd = ref.state.p;
      Qd = ref.state.Q;
      vd = ref.state.v;
      Od = ref.state.O;
      ddxd = ref.state.ddx;
      dOd = ref.state.dO; %ペイロード角加速度
      dqid = ref.state.dqi;
      dwid = ref.state.dwi;

      dqi1 = Skew(model.wi(1:3))*model.qi(1:3);
      dqi2 = Skew(model.wi(4:6))*model.qi(4:6);
      dqi3 = Skew(model.wi(7:9))*model.qi(7:9);
      dqi4 = Skew(model.wi(10:12))*model.qi(10:12); %応急処置

      P = obj.param.P;
%       xd=0;

      Rb0 = RodriguesQuaternion(model.Q);
      Rb1 = RodriguesQuaternion(model.Qi(1:4));
      Rb2 = RodriguesQuaternion(model.Qi(5:8));
      Rb3 = RodriguesQuaternion(model.Qi(9:12));
      Rb4 = RodriguesQuaternion(model.Qi(13:16));
      Rbd = RodriguesQuaternion(Qd);
%       kx0 = obj.param.F1; %Controller_Cooperative_Load(dt)から係数を持ってくる
%       kdx0 = obj.param.F2;
%       kR0 = obj.param.F3;
%       kO0 = obj.param.F4; 
%       kq = obj.param.F5; 
%       kw = obj.param.F6; 
%       kr = obj.param.F7; 
%       kO = obj.param.F8; 


      kx0 = 1; %Controller_Cooperative_Load(dt)から係数を持ってくる
      kdx0 = 1.2;
      kR0 = 1;
      kO0 = 1.2; 
      kq = 1; 
      kw = 1.2; 
      kr = 1; 
      kO = 1.2; 


      ex0 = model.p - pd;
      edx0 = model.v - vd;
      eR0 = 1/2*Vee(Rbd'*Rb0 - Rb0'*Rbd);

      eO0 = model.O - Rb0'*Rbd*Od;
      
      Fd = m0*(-kx0*ex0 - kdx0*edx0 + ddxd - g*e3);
      R0Fd = Rb0'*Fd;
      Md = -kR0*eR0 - kO0*eO0 + Skew(Rb0'*Rbd*Od)*J0*Rb0'*Rbd*Od + J0*Rb0'*Rbd*dOd;
      con_mat = [R0Fd;Md];


      img_mu = blkdiag(Rb0,Rb0,Rb0,Rb0)*P_mat'*inv(P_mat*P_mat')*con_mat;
      mu1 = model.qi(1:3)*model.qi(1:3)'*img_mu(1:3);
      mu2 = model.qi(4:6)*model.qi(4:6)'*img_mu(4:6);
      mu3 = model.qi(7:9)*model.qi(7:9)'*img_mu(7:9);
      mu4 = model.qi(10:12)*model.qi(10:12)'*img_mu(10:12);

      mu_sum = mu1+mu2+mu3+mu4;
      temp1 = (Skew(rho1)*Rb0'*mu1 +Skew(rho2)*Rb0'*mu2 +Skew(rho3)*Rb0'*mu3 +Skew(rho4)*Rb0'*mu4);
      a1 = mu_sum/m1 + Rb0*Skew(model.O)^2*rho1 + Rb0*Skew(rho1)*inv(J0)*(Skew(model.O)*J0*model.O - temp1);
      a2 = mu_sum/m2 + Rb0*Skew(model.O)^2*rho2 + Rb0*Skew(rho2)*inv(J0)*(Skew(model.O)*J0*model.O - temp1);
      a3 = mu_sum/m3 + Rb0*Skew(model.O)^2*rho3 + Rb0*Skew(rho3)*inv(J0)*(Skew(model.O)*J0*model.O - temp1);
      a4 = mu_sum/m4 + Rb0*Skew(model.O)^2*rho4 + Rb0*Skew(rho4)*inv(J0)*(Skew(model.O)*J0*model.O - temp1);

      up1 = mu1 +m1*l1*norm(model.wi(1:3)) + m1*model.qi(1:3)*model.qi(1:3)'*a1;
      up2 = mu2 +m2*l2*norm(model.wi(4:6)) + m1*model.qi(4:6)*model.qi(4:6)'*a2;
      up3 = mu3 +m3*l3*norm(model.wi(7:9)) + m1*model.qi(7:9)*model.qi(7:9)'*a3;
      up4 = mu4 +m4*l4*norm(model.wi(10:12)) + m1*model.qi(10:12)*model.qi(10:12)'*a4;

      qid1=-img_mu(1:3)/norm(img_mu(1:3));
      qid2=-img_mu(4:6)/norm(img_mu(4:6));
      qid3=-img_mu(7:9)/norm(img_mu(7:9));
      qid4=-img_mu(10:12)/norm(img_mu(10:12));

      wid1 = cross(qid1,dqid(1:3));
      wid2 = cross(qid2,dqid(4:6));
      wid3 = cross(qid3,dqid(7:9));
      wid4 = cross(qid4,dqid(10:12));

      eqi1 = cross(qid1,model.qi(1:3));
      eqi2 = cross(qid2,model.qi(4:6));
      eqi3 = cross(qid3,model.qi(7:9));
      eqi4 = cross(qid4,model.qi(10:12));

      ewi1 = model.wi(1:3) + Skew(model.qi(1:3))^2*wid1;
      ewi2 = model.wi(4:6) + Skew(model.qi(4:6))^2*wid1;
      ewi3 = model.wi(7:9) + Skew(model.qi(7:9))^2*wid1;
      ewi4 = model.wi(10:12) + Skew(model.qi(10:12))^2*wid1;

      uv1 = m1*l1*Skew(model.qi(1:3))*(-kq*eqi1 -kw*ewi1 -(model.qi(1:3)'*wid1)*dqi1 -Skew(model.qi(1:3))^2*dwid(1:3)) -m1*Skew(model.qi(1:3))^2*a1;
      uv2 = m2*l2*Skew(model.qi(4:6))*(-kq*eqi2 -kw*ewi2 -(model.qi(4:6)'*wid2)*dqi2 -Skew(model.qi(4:6))^2*dwid(4:6)) -m2*Skew(model.qi(4:6))^2*a2;
      uv3 = m3*l3*Skew(model.qi(7:9))*(-kq*eqi3 -kw*ewi3 -(model.qi(7:9)'*wid3)*dqi3 -Skew(model.qi(7:9))^2*dwid(7:9)) -m3*Skew(model.qi(7:9))^2*a3;
      uv4 = m4*l4*Skew(model.qi(10:12))*(-kq*eqi4 -kw*ewi4 -(model.qi(10:12)'*wid4)*dqi4 -Skew(model.qi(10:12))^2*dwid(10:12)) -m4*Skew(model.qi(10:12))^2*a4;

      u1 = up1 +uv1;
      u2 = up2 +uv2;
      u3 = up3 +uv3;
      u4 = up4 +uv4;

      b3i1 = - u1/norm(u1);
      b3i2 = - u2/norm(u2);
      b3i3 = - u3/norm(u3);
      b3i4 = - u4/norm(u4);

%       temp = [t+1;t+1;0];
      %ref.gen_func(t)
%       %temp = [cos(pi*t);sin(pi*t);0];
%       b1i1 = temp/vecnorm(temp);
% %       temp = [t+1;t+1;0];
%       %temp = [cos(pi*t);sin(pi*t);0];
%       b1i2 = temp/vecnorm(temp);
% %       temp = [t+1;t+1;0];
%       %temp = [cos(pi*t);sin(pi*t);0];
%       b1i3 = temp/vecnorm(temp);
% %       temp = [t+1;t+1;0];
%       %temp = [cos(pi*t);sin(pi*t);0];
%       b1i4 = temp/vecnorm(temp);
%       temp = [1;1;0];
%       temp = [-sin(pi*t);cos(pi*t);0];
%       db1i1 = temp/vecnorm(temp);
% %       temp = [1;1;0];
%       temp = [-sin(pi*t);cos(pi*t);0];
%       db1i2 = temp/vecnorm(temp);
% %       temp = [1;1;0];
%       temp = [-sin(pi*t);cos(pi*t);0];
%       db1i3 = temp/vecnorm(temp);
% %       temp = [1;1;0];
%       temp = [-sin(pi*t);cos(pi*t);0];
%       db1i4 = temp/vecnorm(temp);
      % Ric1 = [-Skew(b3i1)^2*b1i1/norm(Skew(b3i1)^2*b1i1), Skew(b3i1)*b1i1/norm(Skew(b3i1)*b1i1), b3i1];
      % Ric2 = [-Skew(b3i2)^2*b1i2/norm(Skew(b3i2)^2*b1i2), Skew(b3i2)*b1i2/norm(Skew(b3i2)*b1i2), b3i2];
      % Ric3 = [-Skew(b3i3)^2*b1i3/norm(Skew(b3i3)^2*b1i3), Skew(b3i3)*b1i3/norm(Skew(b3i3)*b1i3), b3i3];
      % Ric4 = [-Skew(b3i4)^2*b1i4/norm(Skew(b3i4)^2*b1i4), Skew(b3i4)*b1i4/norm(Skew(b3i4)*b1i4), b3i4];
if vecnorm(vd(1:2)) == 0
  vdt = [1;0;0];
  dvdt = [0;0;0];
  ddvdt = [0;0;0];
else
  vdt = vd;
  dvdt = dvd;
  ddvdt = ddvd;
end

      b2i1 = cross(b3i1,vdt);
      s1 = vecnorm(b2i1);
      b2i1 = b2i1/s1;
      b1i1 = cross(b2i1,b3i1);

      b2i2 = cross(b3i2,vdt);
      s2 = vecnorm(b2i2);
      b2i2 = b2i2/s2;
      b1i2 = cross(b2i2,b3i2);

      b2i3 = cross(b3i3,vdt);
      s3 = vecnorm(b2i3);
      b2i3 = b2i3/s3;
      b1i3 = cross(b2i3,b3i3);

      b2i4 = cross(b3i4,vdt);
      s4 = vecnorm(b2i4);
      b2i4 = b2i4/s4;
      b1i4 = cross(b2i4,b3i4);

db3i1 = [0;0;0];
db2i1 = cross(b3i1,dvdt)/s1 - (b3i1'*vdt)*b2i1/s1;
db1i1 = -cross(b3i1,db2i1);

db3i2 = [0;0;0];
db2i2 = cross(b3i2,dvdt)/s2 - (b3i2'*vdt)*b2i2/s2;
db1i2 = -cross(b3i2,db2i2);

db3i3 = [0;0;0];
db2i3 = cross(b3i3,dvdt)/s3 - (b3i3'*vdt)*b2i3/s3;
db1i3 = -cross(b3i3,db2i3);

db3i4 = [0;0;0];
db2i4 = cross(b3i4,dvdt)/s4 - (b3i4'*vdt)*b2i4/s4;
db1i4 = -cross(b3i4,db2i4);


      dRic1 = [db1i1, db2i1, db3i1];
      dRic2 = [db1i2, db2i2, db3i2];
      dRic3 = [db1i3, db2i3, db3i3];
      dRic4 = [db1i4, db2i4, db3i4];

    ddRic1 = [ddb1i1, ddb2i1, ddb3i1];
    ddRic2 = [ddb1i2, ddb2i2, ddb3i2];
    ddRic3 = [ddb1i3, ddb2i3, ddb3i3];
    ddRic4 = [ddb1i4, ddb2i4, ddb3i4];

    hOic1 = Ric1' * dRic1;
    hOic2 = Ric2' * dRic2;
    hOic3 = Ric3' * dRic3;
    hOic4 = Ric4' * dRic4;

    Oic1 = Vee(dOic1);
Oic2 = Vee(dOic2);
Oic3 = Vee(dOic3);
Oic4 = Vee(dOic4);

    dOic1 = Vee(Ric1' * ddRic1 - hOic1);
    dOic2 = Vee(Ric2' * ddRic2 - hOic2);
    dOic3 = Vee(Ric3' * ddRic3 - hOic3);
    dOic4 = Vee(Ric4' * ddRic4 - hOic4);
    
      eRi1 = 1/2*Vee(Ric1'*Rb1-Rb1'*Ric1);
      eRi2 = 1/2*Vee(Ric2'*Rb2-Rb2'*Ric2);
      eRi3 = 1/2*Vee(Ric3'*Rb3-Rb3'*Ric3);
      eRi4 = 1/2*Vee(Ric4'*Rb4-Rb4'*Ric4);

      eOi1 = model.Oi(1:3)-Rb1'*Rb1*Oic1;
      eOi2 = model.Oi(4:6)-Rb2'*Rb2*Oic2;
      eOi3 = model.Oi(7:9)-Rb3'*Rb3*Oic3;
      eOi4 = model.Oi(10:12)-Rb4'*Rb4*Oic4;

      f1 = -u1'*Rb1*e3;
      f2 = -u2'*Rb2*e3;
      f3 = -u3'*Rb3*e3;
      f4 = -u4'*Rb4*e3;

      epsilon = 1;

      M1=- kr/epsilon^2*eRi1 - kO/epsilon*eOi1 + cross(model.Oi(1:3),J1*model.Oi(1:3)) - J1*(Skew(model.Oi(1:3))*Rb1'*Ric1*Oic1);
      M2=- kr/epsilon^2*eRi2 - kO/epsilon*eOi2 + cross(model.Oi(4:6),J1*model.Oi(4:6)) - J2*(Skew(model.Oi(4:6))*Rb2'*Ric2*Oic2);
      M3=- kr/epsilon^2*eRi3 - kO/epsilon*eOi3 + cross(model.Oi(7:9),J1*model.Oi(7:9)) - J3*(Skew(model.Oi(7:9))*Rb3'*Ric3*Oic3);
      M4=- kr/epsilon^2*eRi4 - kO/epsilon*eOi4 + cross(model.Oi(10:12),J1*model.Oi(10:12)) - J4*(Skew(model.Oi(10:12))*Rb4'*Ric4*Oic4);

      M1 = M1.*[-1,-1,0]';
      M2 = M2.*[-1,-1,0]';
      M3 = M3.*[-1,-1,0]';
      M4 = M4.*[-1,-1,0]';
      obj.result.input = [-f1;M1;-f2;M2;-f3;M3;-f4;M4];



      % max,min are applied for the safty
      result = obj.result;
    end
  end
end