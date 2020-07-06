classdef HLController_quadcopter < CONTROLLER_CLASS
    % クアッドコプター用階層型線形化を使った入力算出
    properties
        self
        result
        param
    end
    
    methods
        function obj = HLController_quadcopter(self,param)
            obj.self = self;
            obj.param = param;
        end
        
        function u = do(obj,param,~)
            % param (optional) : 構造体：物理パラメータP，ゲインF1-F4 
            model = obj.self.model;
            ref = obj.self.reference.result;
            x = [model.state.getq('compact');model.state.p;model.state.v;model.state.w]; % [q, p, v, w]に並べ替え
            if isprop(ref.state,'xd')
                xd = ref.state.xd; % 20次元の目標値に対応するよう
            else
                xd = ref.state.get();
            end
            Param= obj.param;
            P = Param.P;
            F1 = Param.F1;
            F2 = Param.F2;
            F3 = Param.F3;
            F4 = Param.F4;
            %     xd=Xd.p;
            %     if isfield(Xd,'v')
            %         xd=[xd;Xd.v];
            %         if isfield(Xd,'dv')
            %             xd=[xd;Xd.dv];
            %         end
            %     end
            xd=[xd;zeros(20-size(xd,1),1)];% 足りない分は０で埋める．
            %x=cell2mat(arrayfun(@(t) state.(t)',string(state.list),'UniformOutput',false))';
            %x = state.get();%状態ベクトルとして取得
            if isfield(Param,'dt')
                dt = Param.dt;
                vf = Vfd(dt,x,xd',P,F1);
            else
                vf = Vf(x,xd',P,F1);
            end
            vs = Vs(x,xd',vf,P,F2,F3,F4);
            obj.result.input = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P);

%             if isfield(Param,'dt')
%                 dt = Param.dt;
%                 vf = Vfdp(dt,x,xd',P,F1);
%             else
%                 vf = Vfp(x,xd',P,F1);
%             end
%             vs = Vsp(x,xd',vf,P,F2,F3,F4);
%             obj.result = Ufp(x,xd',vf,P) + Usp(x,xd',vf,vs',P);
            u = obj.result;
        end
        function show(obj)
            obj.result
        end
    end
end

