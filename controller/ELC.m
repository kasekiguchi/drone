classdef ELC < handle
properties
    self
    result
    param
    parameter_name = ["mass", "Lx", "Ly", "lx", "ly", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4"];
    Vep%線形化したシステムの仮想入力を生成する関数
    z
    tf
    modelErrorInput
end

methods
    function obj = ELC(self, param)
        % クアッドコプターの動的拡大システムの線形化を使った入力算出
% DynamicExtendedLinearizationBasedController に対応
        %クワッドコプタを動的拡大したシステムを線形化したシステムの仮想入力を計算し，線形化前の動的拡大システムの入力を求める
%Zep1~Zep4は動的拡大システムの状態から線形化後の状態に変換する関数である
%Trs=[T(クワッドコプタの合計推力), dT(合計推力の微分)]である
%z1~z4は線形化後のz,x,y,yawサブシステムの状態である
%Vepはサブシステムの状態を用いて仮想入力を求める関数である
%Uepで仮想入力を動的拡大システムの入力に変更する
        obj.self = self;
        obj.param = param;
        obj.param.P = self.parameter.get(obj.parameter_name);
        obj.Vep = param.Vep; % 動的拡大したシステムを線形化したシステムの仮想入力を生成する関数
        obj.z=0;
        obj.result.input = zeros(self.estimator.model.dim(2),1);
        obj.result.u = zeros(self.estimator.model.dim(2),1);
        obj.tf=0;
        obj.modelErrorInput = THRUST2FORCE_TORQUE_FOR_MODEL_ERROR(self); % modelerror用
    end

    function result = do(obj ,varargin)
        % param (optional) : 構造体：物理パラメータP，ゲインF1-F4
        % if varargin{2}=="f"
        %     if obj.tf==0
        %         obj.tf = varargin{1}.t;
        %     end
        %     obj.result.ftime = varargin{1}.t - obj.tf;
        % else
        %     obj.result.ftime = 0;
        % end

        model = obj.self.estimator.result;
        ref = obj.self.reference.result;
        xd = ref.state.xd;
        P = obj.param.P;
        xd = [xd; zeros(20 - size(xd, 1), 1)]; % 足りない分は０で埋める．

        % yaw 角についてボディ座標に合わせることで目標姿勢と現在姿勢の間の2pi問題を緩和
        % TODO : 本質的にはx-xdを受け付ける関数にして，x-xdの状態で2pi問題を解決すれば良い．
        Rb0 = RodriguesQuaternion(Eul2Quat([0; 0; xd(4)]));
        x = [R2q(Rb0' * model.state.getq("rotmat")); Rb0' * model.state.p; Rb0' * model.state.v; model.state.w;model.state.Trs]; % [q, p, v, w]に並べ替え
        xd(1:3) = Rb0' * xd(1:3);
        xd(4) = 0;
        xd(5:7) = Rb0' * xd(5:7);
        xd(9:11) = Rb0' * xd(9:11);
        xd(13:15) = Rb0' * xd(13:15);
        xd(17:19) = Rb0' * xd(17:19);

        %% calc Z
        z1 = Zep1(x, xd', P);
        z2 = Zep2(x, xd', P);
        z3 = Zep3(x, xd', P);
        z4 = Zep4(x, xd', P);
        
        %subsystem controller
        % vep = obj.Vep(z1, z2, z3, z4);%serevoなし
        %servo
        if varargin{1}.t > 5
                obj.z = obj.z + xd(3)-x(7);
        end
        vep = obj.Vep(z1, z2, z3, z4,obj.z);
        % % z FTC+servo
        % vep(1) = vep(1) - obj.param.F1s(5)*obj.z;
        %% calc actual input
        tmp = Uep(x, xd', vep, P);
        obj.result.u = tmp;
        %input of subsystems
        obj.result.uHL =vep;
        %state of subsystems
        obj.result.z1 = z1;
        obj.result.z2 = z2;
        obj.result.z3 = z3;
        obj.result.z4 = z4;
        % max,min are applied for the safty
        tmp(1) = x(14);
        % tmp = obj.modelErrorInput.do([],[],[],[],tmp,[]);
        % obj.result.u(2:4) = tmp(2:4);
        obj.result.input = [max(0,min(20,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];           
        % obj.result.input = [max(0,min(10,x(14)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];           
        result = obj.result;
    end

    function show(obj)
        obj.result
    end

end

end
