classdef HLC < handle
  % Hierarchical linearization based controller for a quadcopter
  properties
    self
    result
    param
    parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
     fRandn
    pdst
  end

  methods
    function obj = HLC(self,param)
      obj.self = self;
      obj.param = param;
      obj.param.P = self.parameter.get(obj.parameter_name);
      obj.result.input = zeros(self.estimator.model.dim(2),1);
      obj.fRandn =0;
    end

    function result = do(obj,varargin)
      model = obj.self.estimator.result;
      ref = obj.self.reference.result;
      xd = ref.state.xd;
      xd0 =xd;
      P = obj.param.P;
      F1 = obj.param.F1;
      F2 = obj.param.F2;
      F3 = obj.param.F3;
      F4 = obj.param.F4;
      xd=[xd;zeros(20-size(xd,1),1)];% 足りない分は０で埋める．

      % yaw 角についてボディ座標に合わせることで目標姿勢と現在姿勢の間の2pi問題を緩和
      % TODO : 本質的にはx-xdを受け付ける関数にして，x-xdの状態で2pi問題を解決すれば良い．
      Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
      x = [R2q(Rb0'*model.state.getq("rotmat"));Rb0'*model.state.p;Rb0'*model.state.v;model.state.w]; % [q, p, v, w]に並べ替え
      xd(1:3)=Rb0'*xd(1:3);
      xd(4) = 0;
      xd(5:7)=Rb0'*xd(5:7);
      xd(9:11)=Rb0'*xd(9:11);
      xd(13:15)=Rb0'*xd(13:15);
      xd(17:19)=Rb0'*xd(17:19);
      %if isfield(obj.param,'dt')
      if isfield(varargin{1},'dt') && varargin{1}.dt <= obj.param.dt
        dt = varargin{1}.dt;
      else
        dt = obj.param.dt;
        % vf = Vf(x,xd',P,F1);
        % vs = Vs(x,xd',vf,P,F2,F3,F4);
      end
        vf = Vfd(dt,x,xd',P,F1);
        vs = Vsd(dt,x,xd',vf,P,F2,F3,F4);
      %disp([xd(1:3)',x(5:7)',xd(1:3)'-xd0(1:3)']);
      %% 外乱(加速度で与える)
        
        %=======================================
        %定常外乱：並進方向は0.2m/s^2くらい，回転方向は3rad/s^2(180deg/s^2)
        %=======================================
                    dst = [zeros(6,1)];%[x,y,z,roll,pitch,yaw](加速次元)
        %-----------------------------------------------------------------
                    %確率の外乱
                    % t = param{1};
%                     rng("shuffle");
%                     a = 1;%外乱の大きさの上限
%                     dst = 2*a*rand-a;
%
                    %平均b、標準偏差aのガウスノイズ
                     if ~obj.fRandn%最初のループでシミュレーションで使う分の乱数を作成
                          rng(42,"twister");%シミュレーション条件を同じにするために乱数の初期値を決めることができる
                          a = 1;%標準偏差
                          b = 0;%平均
                          c = varargin{1, 1}.te/obj.self.plant.dt +1 ;%ループ数を計算param{2}はシミュレーション時間
                          obj.pdst = a.*randn(c,3) + b;%ループ数分の値の乱数を作成
                          obj.fRandn = 1;
                    end
                    dst(4) = obj.pdst(obj.fRandn,1);
                    dst(5) = obj.pdst(obj.fRandn,2);
                    dst(3) = obj.pdst(obj.fRandn,3);
                    obj.fRandn = obj.fRandn+1;%乱数の値を更新
        %-----------------------------------------------------------------
                    %一時的な外乱
%         t = param{1};
%         dst = 0;
%                     if t>=2 && t<=5.33
%                             dst= 0.6;
%                     end
        %特定の位置で外乱を与える
     
%                     dst=0;xxx0=0.5;TT=0.5;%TT外乱を与える区間
%                     xxx=model.state.p(1)-xxx0;
%                     if xxx>=0 && xxx<=TT
%                             dst=-5*sin(2*pi*xxx/(TT*2));
%                     end

      tmp = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P);
      % max,min are applied for the safty
      % obj.result.input = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
      obj.result.input = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)));dst];
      result = obj.result;
    end
  end
end

