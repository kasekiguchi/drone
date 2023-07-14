classdef CSLC < handle
  % Hierarchical linearization based controller for a quadcopter
  properties
    self
    result
    P
    parameter_name = ["g","m0","J0","rho","li","mi","Ji"];
    gains
    Pdagger
    gen_input
    N
    toR
  end

  methods
    function obj = CSLC(self,param)
      obj.self = self;
      obj.P = self.parameter.get("all","row");
      obj.result.input = zeros(self.estimator.model.dim(2),1);
      P = cell2mat(arrayfun_col(@(rho) [eye(3);Skew(rho)],self.parameter.rho));
      obj.Pdagger = pinv(P);
      obj.N = size(P,2)/3;
      %obj.gains = [0.1*[1 1 1], 1,0.45*[1 1 1],1.7, 10.0000 ,10.9545,0.1,0.45,0.1]; 
      %obj.gains = [1*[1 1 1], 1,3.4641*[1 1 1],3.4641, 31.6228, 32.6074,0.1414 ,0.5503,0.09]; 
      obj.gains = param.gains; %
      %[kx0' kr0 kdx0' ko0 kqi kwi kri koi epsilon]
      obj.gen_input = str2func(param.method);
      if self.estimator.model.state.type ==3
        obj.toR= @(r) RodriguesQuaternion(Eul2Quat(reshape(r,3,[])));
      else
        obj.toR= @(r) RodriguesQuaternion(reshape(r,4,[]));
      end
    end

    function result = do(obj,varargin)
      model = obj.self.estimator.result.state;
      ref = obj.self.reference.result.state;
      x = model.get(["p"  "Q" "v"    "O"    "qi"    "wi"  "Qi"  "Oi"]);
      qi = reshape(model.qi,3,obj.N);
      Ri = obj.toR(model.Qi);
      R0 = obj.toR(model.Q);

      

      xd = ref.xd;
      R0d = RodriguesQuaternion([xd(19);xd(20);xd(21);xd(22)]);

      % TODO : 本質的にはx-xdを受け付ける関数にして，x-xdの状態で2pi問題を解決すれば良い．
      % Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
      % % x = [x0;r0;dx0;o0;reshape([qi,wi],6*N,1);reshape(ri,4*N,1);reshape(oi,3*N,1)];
      % xd = [x0d;dx0d;ddx0d;dddx0d;o0d;do0d]
%       t = varargin{1}.t;
%       w = 1;%min(0.1*(t+0.001)/2,0.2);
%       r0x = [(4*2^(1/2)*w*cos(2*pi*t*w))/(abs(w)*(16*cos(4*t*w*pi) - 49*cos(2*t*w*pi) + 65)^(1/2)) -(7*2^(1/2)*w*sin(pi*t*w))/(abs(w)*(16*cos(4*t*w*pi) - 49*cos(2*t*w*pi) + 65)^(1/2)) 0]';
%       r0z = [0;0;1];
%       r0y = [   (7*2^(1/2)*w*sin(pi*t*w))/(abs(w)*(16*cos(4*t*w*pi) - 49*cos(2*t*w*pi) + 65)^(1/2));(4*2^(1/2)*w*cos(2*pi*t*w))/(abs(w)*(16*cos(4*t*w*pi) - 49*cos(2*t*w*pi) + 65)^(1/2));               0];
%       R0d = [r0x r0y r0z];
%       o0d = [ 0;    0;-(28*w*pi*(3*cos(pi*t*w) - 2*cos(pi*t*w)^3))/(64*cos(pi*t*w)^4 - 113*cos(pi*t*w)^2 + 65)];
%       do0d = [   0;   0;-(28*w^2*pi^2*sin(pi*t*w)*(51*cos(pi*t*w)^2 + 350*cos(pi*t*w)^4 - 128*cos(pi*t*w)^6 - 195))/(64*cos(t*w*pi)^4 - 113*cos(t*w*pi)^2 + 65)^2];
      %R0d = obj.toR([1;0;0;0]);
%       x0d = [1.2*sin(2*w*pi*t);4.2*cos(w*pi*t);2];
%       dx0d = [ (12*w*pi*cos(2*pi*t*w))/5; -(21*w*pi*sin(pi*t*w))/5;    0];
%       ddx0d = [-(24*w^2*pi^2*sin(2*pi*t*w))/5;  -(21*w^2*pi^2*cos(pi*t*w))/5;       0];
%       dddx0d = [ -(48*w^3*pi^3*cos(2*pi*t*w))/5;   (21*w^3*pi^3*sin(pi*t*w))/5;     0];
      %o0d = [0;0;0];
      %do0d = [0;0;0];
%       xd = [x0d;dx0d;ddx0d;dddx0d;o0d;do0d];
      % xd(1:3)=Rb0'*xd(1:3);
      % xd(4) = 0;
      % xd(5:7)=Rb0'*xd(5:7);
      % xd(9:11)=Rb0'*xd(9:11);
      % xd(13:15)=Rb0'*xd(13:15);
      % xd(17:19)=Rb0'*xd(17:19);

      % if vecnorm(vd(1:2)) == 0
      %   vdt = [1;0;0];
      %   dvdt = [0;0;0];
      %   ddvdt = [0;0;0];
      % else
      %   vdt = vd;
      %   dvdt = dvd;
      %   ddvdt = ddvd;
      % end
%       dispxd_y = xd2(1:18)-xd;
%       dispxd_x = t*ones(length(xd),1)
%       dispexd = [dispxd_x,dispxd_y];
%       print(dispexd)
      obj.result.input = obj.gen_input(x,qi,R0,Ri,R0d,xd,obj.gains,obj.P,obj.Pdagger);
      result = obj.result;
    end
  end
end