classdef FTC < handle
% クアッドコプター用階層型線形化を使った入力算出
properties
    self
    result
    param
    parameter_name = ["mass", "Lx", "Ly", "lx", "ly", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4"];
    Vf % 階層１の入力を生成する関数ハンドル
    Vs % 階層２の入力を生成する関数ハンドル
end

methods

    function obj = FTC(self, param)
        obj.self = self;
        obj.param = param;
        obj.param.P = self.parameter.get(obj.parameter_name);
        obj.result.input = zeros(self.estimator.model.dim(2),1);
        obj.Vf = obj.param.Vf; % 階層１の入力を生成する関数ハンドル
        obj.Vs = obj.param.Vs; % 階層２の入力を生成する関数ハンドル
    end

    function result = do(obj,varargin)
        model = obj.self.estimator.result;
        ref = obj.self.reference.result;
        xd = ref.state.xd;

        P = obj.param.P;

        xd = [xd; zeros(20 - size(xd, 1), 1)]; % 足りない分は０で埋める．

        Rb0 = RodriguesQuaternion(Eul2Quat([0; 0; xd(4)]));
        x = [R2q(Rb0' * model.state.getq("rotmat")); Rb0' * model.state.p; Rb0' * model.state.v; model.state.w]; % [q, p, v, w]に並べ替え
        xd(1:3) = Rb0' * xd(1:3);
        xd(4) = 0;
        xd(5:7) = Rb0' * xd(5:7);
        xd(9:11) = Rb0' * xd(9:11);
        xd(13:15) = Rb0' * xd(13:15);
        xd(17:19) = Rb0' * xd(17:19);
        
        %z方向:FT
        z1 = Z1(x, xd', P);%z
        vf = obj.Vf(z1); 
        %x,y,psiの状態変数の値
        z2 = Z2(x, xd', vf, P); %x方向
        z3 = Z3(x, xd', vf, P); %y方向
        z4 = Z4(x, xd', vf, P); %yaw
        vs = obj.Vs(z2,z3,z4);
        %検証用
%      vf(1)=-F1*(sign(z1).*abs(z1).^az(1:2));%z近似なし
        % vs(3) = -F4 * z4; %yaw:LS
        tmp = Uf(x, xd', vf, P) + Us(x, xd', vf, vs, P);
        %input of subsystems
        obj.result.uHL = [vf(1); vs];
        %differential virtual input first layer
        obj.result.vf = vf;
        %state of subsystems
        obj.result.z1 = z1;
        obj.result.z2 = z2;
        obj.result.z3 = z3;
        obj.result.z4 = z4;
      % max,min are applied for the safty
        obj.result.input =[max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];%外乱用
        result = obj.result;
    end

    function show(obj)
        obj.result
    end

end

end
