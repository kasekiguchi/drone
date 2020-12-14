classdef Leader_HL_MPCholizontal < CONTROLLER_CLASS
    % クアッドコプター用階層型線形化を使った入力算出
    properties
        options
        param
        model
        result
        self
        previous_variables
        linearmodel
    end
    
    methods
        
        function obj = Leader_HL_MPCholizontal(self,param)
            obj.self = self;
            
            
            %---MPCパラメータ設定---%
            obj.param.H  = param.H;                % モデル予測制御のホライゾン 
%             obj.param.dt = param.dt;              % モデル予測制御の刻み時間
            obj.param.dt = 0.2;              % モデル予測制御の刻み時間
            
            obj.param.Slew=0.5;%0.5
            
%             構造体：物理パラメータP，ゲインF1-F4 
            obj.param.P = param.P;
            obj.param.F1 = param.F1;%z
            obj.param.F2 = param.F2;%x
            obj.param.F3 = param.F3;%y
            obj.param.F4 = param.F4;%yaw

            %経路幅
            obj.param.wall_width_y = param.wall_width_y;
            obj.param.wall_width_x = param.wall_width_x;

            
            %% Model Setting
            %model state : virtual state 2nd layor h2 h3  MPC内状態方程式
            A23 = diag([1,1,1],1);
            B23 = [0;0;0;1];
            C=ones(8,8);
            D=zeros(8,2);
            A=blkdiag(A23,A23);
            B=blkdiag(B23,B23);
            sys=ss(A,B,C,D);
            sysd = c2d(sys,obj.param.dt);
            
            
            
            obj.param.input_size = size(sysd.B,2);
            obj.param.state_size = size(sysd.A,2);
            obj.param.total_size = obj.param.input_size + obj.param.state_size;
            obj.param.Num = obj.param.H+1; %初期状態とホライゾン数の合計
            
            %重み%
            obj.param.Q = diag(10*ones(1,obj.param.state_size));
            obj.param.R = diag(10*ones(1,obj.param.input_size));
            obj.param.Qf = diag(10*ones(1,obj.param.state_size));
            
%             obj.previous_variables = zeros(obj.param.input_size + obj.param.state_size,obj.param.Num);
            obj.previous_variables = param.arranged_pos(1:2,1);%mainのarranged_posから引っ張ってきたこの機体の初期位置をホライゾン数分拡張
            obj.previous_variables = repmat([obj.previous_variables(1);zeros(3,1);obj.previous_variables(2);zeros(5,1)],1,obj.param.Num);


            
            obj.param.Pdata=param.Pdata;
            
            obj.model = self.model;
            obj.linearmodel.A = sysd.A;
            obj.linearmodel.B = sysd.B;
            
% %             %セクションポイント
% %             run('SectionsSetting');
            obj.param.sectionpoint = param.sectionpoint;
            obj.param.sectionnumber = param.Sectionnumber;
            obj.param.P_limit=param.P_limit;%SectionsSettingのなかのPointToLeaderの行数＝セクションポイントの数
            obj.param.Section_change = param.Section_change;
        end
        function u = do(obj,~,~)
            
            if strcmp(obj.self.reference.point.flight_phase ,'f')

            modelstate = state_copy(obj.self.estimator.result.state);
            
            modelstate.q=(eul2quat(modelstate.q','XYZ'))';%オイラーからクォータニオンへの変換
            
            
%             x = modelstate.get; % [q, p, v, w]に並べ替え
            x = [modelstate.q;modelstate.p;modelstate.v;modelstate.w];
            xd = obj.self.reference.result.state.get();
            xd=[xd;zeros(20-size(xd,1),1)];% 足りない分は０で埋める．
            
            if isfield(obj.param,'dt')
                dt = obj.param.dt;
                vf = Vfd(dt,x,xd',obj.param.P,obj.param.F1);
            else
                vf = Vf(x,xd',obj.param.P,obj.param.F1);
            end
            vs = Vs(x,xd',vf,obj.param.P,obj.param.F2,obj.param.F3,obj.param.F4);
            v4 = vs(3);
            %実状態を仮想状態に変換
            h2 = Z2(x,zeros(20,1)',vf,obj.param.P);   %x方向の仮想状態
            h3 = Z3(x,zeros(20,1)',vf,obj.param.P);   %y方向
            %h2とh3を状態にしたMPC
            
            %ループの中で変動するパラメータを設定
            obj.param.X0 = [h2;h3];
            obj.param.Xd = xd;
            
            [ref] = calcreference(h2,h3,obj.param.Num,obj.param.Pdata,obj.param.dt);
            obj.param.Xr = ref;

            
 %============================MEX化部分================================%    
 

            MPCparam.Q = obj.param.Q;
            MPCparam.Qf = obj.param.Qf;
            MPCparam.R = obj.param.R;
            MPCparam.Xr = obj.param.Xr;
            MPCparam.X0 = obj.param.X0;
            MPCparam.Slew = obj.param.Slew;
            linear_model = obj.linearmodel;
            MPCprevious_variables = obj.previous_variables;
%             funcresult = L_HL_MPCfunc(MPCparam,linear_model,MPCprevious_variables);%通常のfunction
            funcresult=L_HL_MPCfunc_mex(MPCparam,linear_model,MPCprevious_variables);%MEX化後
 %====================================================================%       
            obj.previous_variables = funcresult;

            v23 = obj.previous_variables(obj.param.state_size + 1:obj.param.total_size, 1); % 最適化計算での現在時刻の入力を制御対象に印可する入力として採用
            v2 = v23(1);%x方向の仮想出力
            v3 = v23(2);%y方向
            vxy=[v2,v3];%x方向とy方向の仮想入力
            vs=[vxy,v4];
            
            %区間変更用
            [obj.param.Section_change] = Sectionnumbersetting(obj.param.sectionnumber,obj.param.P_limit+1);
            [LSectionPlus] = SectionNumchange(x(5:7),vertcat([0,0],obj.param.Pdata.Target),obj.param.Section_change);
            
            obj.param.sectionnumber = obj.param.sectionnumber + LSectionPlus - 2;
                if obj.param.sectionnumber < 1
                    obj.param.sectionnumber = 1;
                end

    %-----------------------------------------------------------------%
            obj.result.input = Uf(x,xd',vf,obj.param.P) + Us(x,xd',vf,vs',obj.param.P);
            obj.result.var = obj.previous_variables;

            %リーダー機体用の更新
            obj.param.Pdata.flag = obj.param.sectionnumber(1);

            u = obj.result;
            obj.self.input = obj.result.input;%こっちに変更2020/10/22

            
            else
                            % param (optional) : 構造体：物理パラメータP，ゲインF1-F4
            model = obj.self.estimator.result;
            ref = obj.self.reference.result;
            x = [model.state.getq('compact');model.state.p;model.state.v;model.state.w]; % [q, p, v, w]に並べ替え
            if isprop(ref.state,'xd')%~isempty(ref.state.xd)
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
            
            Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
            x = [R2q(Rb0'*model.state.getq("rotmat"));Rb0'*model.state.p;Rb0'*model.state.v;model.state.w]; % [q, p, v, w]に並べ替え
            xd(1:3)=Rb0'*xd(1:3);
            xd(4) = 0;
            xd(5:7)=Rb0'*xd(5:7);
            xd(9:11)=Rb0'*xd(9:11);
            xd(13:15)=Rb0'*xd(13:15);
            xd(17:19)=Rb0'*xd(17:19);
            
            if isfield(Param,'dt')
                dt = Param.dt;
                vf = Vfd(dt,x,xd',P,F1);
            else
                vf = Vf(x,xd',P,F1);
            end
            vs = Vs(x,xd',vf,P,F2,F3,F4);
            tmp = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P);
            obj.result.input = [tmp(1);
                tmp(2);tmp(3);
                tmp(4)];
            obj.self.input = obj.result.input;
            u = obj.result;

            end
        end
        function show(obj)
            obj.result
        end
        
       
    end
end
 
