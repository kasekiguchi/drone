classdef HLC_MEC < handle
    % クアッドコプター用階層型線形化を使った入力算出にモデル誤差補償器を導入
    properties
        self
        result
        param
        Q
        K%補償ゲイン inputの次元に合わせる 参考 大石さん
        dv1p %1時刻前の補償入力
        A2 = [0 1;0 0];
        B2 = [0;1];
        A4 =diag([1 1 1],1);
        B4 = [0;0;0;1];
    end
    
    methods
        function obj = HLC_MEC(self,param,~)
            obj.self = self;
            obj.param = param;
            obj.param.P = self.parameter.get();
            obj.Q = STATE_CLASS(struct('state_list',["q"],'num_list',[4]));
            %MEC追加
            obj.dv1p = 0;
            obj.K = param.K;

        end
        
        function result = do(obj,param,varargin) 
            % param (optional) : 構造体：物理パラメータP，ゲインF1-F4 
            % varargin : nominal input
            
            model = obj.self.model;
            ref = obj.self.reference.result;
            plant = obj.self.estimator;%estimatorの値をシステムの出力とみなす

            xd = ref.state.get();

            Param= obj.param;
            P = Param.P;
            F1 = Param.F1;
            F2 = Param.F2;
            F3 = Param.F3;
            F4 = Param.F4;
            xd=[xd;zeros(20-size(xd,1),1)];% 足りない分は０で埋める．
            %x=cell2mat(arrayfun(@(t) state.(t)',string(state.list),'UniformOutput',false))';
            %x = state.get();%状態ベクトルとして取得
% 
            Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
            xn = [R2q(Rb0'*model.state.getq("rotmat"));Rb0'*model.state.p;Rb0'*model.state.v;model.state.w]; % [q, p, v, w]に並べ替え
            x = [R2q(Rb0'*plant.result.state.getq("rotmat"));Rb0'*plant.result.state.p;Rb0'*plant.result.state.v;plant.result.state.w]; % [q, p, v, w]に並べ替え
            xd(1:3)=Rb0'*xd(1:3);
            xd(4) = 0;
            xd(5:7)=Rb0'*xd(5:7);
            xd(9:11)=Rb0'*xd(9:11);
            xd(13:15)=Rb0'*xd(13:15);
            xd(17:19)=Rb0'*xd(17:19);
            
            if isfield(Param,'dt')
                dt = Param.dt;
                vfn = Vfd(dt,xn,xd',P,F1);
                vf = Vfd(dt,x,xd',P,F1);
            else
                vfn = Vf(xn,xd',P,F1);%v1
                vf = Vf(x,xd',P,F1);%v1
            end
            
%% MEC
            Kz = obj.K(1:2);
            Kx = obj.K(3:6);
            Ky = obj.K(7:10);
           %nominalを線形化
            z1n = Z1(xn,xd',P);
            z2n = Z2(xn,xd',vfn,P);
            z3n = Z3(xn,xd',vfn,P);
            z4n = Z4(xn,xd',vfn,P);

            yn = [z1n;z2n;z3n;z4n];
            
            %plantを線形化
            z1 = Z1(x,xd',P);
            z2 = Z2(x,xd',vf,P);
            z3 = Z3(x,xd',vf,P);
            z4 = Z4(x,xd',vf,P);
            y = [z1;z2;z3;z4];

            dy = yn - y; %理想状態との誤差を算出
            
            dv1 =  Kz*dy(1:2);%補償入力
            dv1d = (dv1 - obj.dv1p)/dt;
            
            vf = vf + [dv1 dv1d 0 0];
            
            vs = Vs(x,xd',vf,P,F2,F3,F4);%v2-4
            dv2 = Kx* dy(3:6);
            dv3 = Ky* dy(7:10);
            dv4 = 0;
            vs = vs + [dv2 dv3 dv4];
            
           tmp = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P);   %Uf,Us:実入力変換
           obj.result.input = [tmp(1);
                                        tmp(2);
                                        tmp(3);
                                        tmp(4)];

            obj.dv1p =dv1; %dv1p更新

            obj.self.input = obj.result.input;
            result = obj.result;
        end
        function show(obj)
            obj.result
        end
    end
end

