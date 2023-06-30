classdef COOPERATIVE_CONTROLLER < handle
  % Hierarchical linearization based controller for a quadcopter
  properties
    self
    result
    param
    parameter_name = ["g","m0","J0","rho","li","mi","Ji"];
    P_mat
    e % epsilon
    e2 % e^2
  end

  methods
    function obj = COOPERATIVE_CONTROLLER(self,param)
      obj.self = self;
      obj.param = param;
      obj.param.P = self.parameter.get("all");
      obj.result.input = zeros(self.estimator.model.dim(2),1);
      obj.P_mat = cell2mat(arrayfun_col(@(rho) [eye(3);Skew(rho)],obj.param.P.rho));
      obj.e = 0.1;
      obj.e2 = obj.e^2;
    end

    function result = do(obj,varargin)
      g = obj.param.P.g;
      m0 = obj.param.P.m0;
      J0 = obj.param.P.J0;
      rho = obj.param.P.rho;
      li = obj.param.P.li;
      mi = obj.param.P.mi;
      J1 = obj.param.P.Ji;
      
      P_mat = obj.P_mat;

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


      %%%
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

      
      if vecnorm(vd(1:2)) == 0
        vdt = [1;0;0];
        dvdt = [0;0;0];
        ddvdt = [0;0;0];
      else
        vdt = vd;
        dvdt = dvd;
        ddvdt = ddvd;
      end
    b2i1 = cross(b3i1, vdt);
    si1 = vecnorm(b2i1);
    ci1 = b3i1' * vdt;
    si12 = si1^2;
    b2i1 = b2i1 / si1;
    b1i1 = cross(b2i1, b3i1);
    
    db3i1 = [0; 0; 0];
    b3db1i1 = cross(b3i1, dvdt);
    db2i1 = b3db1i1 / si1 - ci1 * b2i1 / si1;
    db1i1 = -cross(b3i1, db2i1);
        
    ddb3i1 = [0; 0; 0];
    ddb2i1 = cross(b3i1,ddvdt)/si1 - ci1*b3db1i1/si12 + b2i1/si12 - ci1*db2i1/si1;
    ddb1i1 = -cross(b3i1,ddb2i1);

    Ric1 = [b1i1,b2i1,b3i1];

    b2i2 = cross(b3i2, vdt);
    si2 = vecnorm(b2i2);
    ci2 = b3i2' * vdt;
    si22 = si2^2;
    b2i2 = b2i2 / si2;
    b1i2 = cross(b2i2, b3i2);
    
    db3i2 = [0; 0; 0];
    b3db1i2 = cross(b3i2, dvdt);
    db2i2 = b3db1i2 / si2 - ci2 * b2i2 / si2;
    db1i2 = -cross(b3i2, db2i2);
        
    ddb3i2 = [0; 0; 0];
    ddb2i2 = cross(b3i2,ddvdt)/si2 - ci2*b3db1i2/si22 + b2i2/si22 - ci2*db2i2/si2;
    ddb1i2 = -cross(b3i2,ddb2i2);

    Ric2 = [b1i2,b2i2,b3i2];

        b2i3 = cross(b3i3, vdt);
    si3 = vecnorm(b2i3);
    ci3 = b3i3' * vdt;
    si32 = si3^2;
    b2i3 = b2i3 / si3;
    b1i3 = cross(b2i3, b3i3);
    
    db3i3 = [0; 0; 0];
    b3db1i3 = cross(b3i3, dvdt);
    db2i3 = b3db1i3 / si3 - ci3 * b2i3 / si3;
    db1i3 = -cross(b3i3, db2i3);
        
    ddb3i3 = [0; 0; 0];
    ddb2i3 = cross(b3i3,ddvdt)/si3 - ci3*b3db1i3/si32 + b2i3/si32 - ci3*db2i3/si3;
    ddb1i3 = -cross(b3i3,ddb2i3);

    Ric3 = [b1i3,b2i3,b3i3];

        b2i4 = cross(b3i4, vdt);
    si4 = vecnorm(b2i4);
    ci4 = b3i4' * vdt;
    si42 = si4^2;
    b2i4 = b2i4 / si4;
    b1i4 = cross(b2i4, b3i4);
    
    db3i4 = [0; 0; 0];
    b3db1i4 = cross(b3i4, dvdt);
    db2i4 = b3db1i4 / si4 - ci4 * b2i4 / si4;
    db1i4 = -cross(b3i4, db2i4);
        
    ddb3i4 = [0; 0; 0];
    ddb2i4 = cross(b3i4,ddvdt)/si4 - ci4*b3db1i4/si42 + b2i4/si42 - ci4*db2i4/si4;
    ddb1i4 = -cross(b3i4,ddb2i4);

    Ric4 = [b1i4,b2i4,b3i4];



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

      Oic1 = Vee(hOic1);
      Oic2 = Vee(hOic2);
      Oic3 = Vee(hOic3);
      Oic4 = Vee(hOic4);

      dOic1 = Vee(Ric1' * ddRic1 - hOic1*hOic1);
      dOic2 = Vee(Ric2' * ddRic2 - hOic2*hOic2);
      dOic3 = Vee(Ric3' * ddRic3 - hOic3*hOic3);
      dOic4 = Vee(Ric4' * ddRic4 - hOic4*hOic4);

      eRi1 = 1/2*Vee(Ric1'*Rb1-Rb1'*Ric1);
      eRi2 = 1/2*Vee(Ric2'*Rb2-Rb2'*Ric2);
      eRi3 = 1/2*Vee(Ric3'*Rb3-Rb3'*Ric3);
      eRi4 = 1/2*Vee(Ric4'*Rb4-Rb4'*Ric4);

      eOi1 = model.Oi(1:3)-Rb1'*Rb1*Oic1;

      f = -ui'*Rbi*e3;
      M = - kr*eRi/obj.e2 - kO*eOi/obj.e + cross(Oi,Ji*Oi) - Ji*(cross(Oi,Rbi'*Ric*Oic) - Rbi'*Ric*dOic);

      obj.result.input = reshape([f;M].*[-1;1;-1;-1],[],1);
      result = obj.result;
    end
  end
end