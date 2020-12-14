classdef Follower_HL_MPCholizontal < CONTROLLER_CLASS
    % クアッドコプター用階層型線形化を使った入力算出
    properties
        options
        param
        model
        result
        self
        Section_change
        previous_variables
        slack
        P_chips
        wall_width_y
        wall_width_x
        S_limit
        Sectionconect
    end
    
    methods
        
        function obj = Follower_HL_MPCholizontal(self,param)
            obj.self = self;
            
            %---MPCパラメータ設定---%
            obj.param.H  = param.H;                % モデル予測制御のホライゾン 
            obj.param.dt = param.dt;              % モデル予測制御の刻み時間
            obj.param.N  = param.N;
            
            obj.param.P = param.P;
            obj.param.F1 = param.F1;%z
            obj.param.F2 = param.F2;%x
            obj.param.F3 = param.F3;%y
            obj.param.F4 = param.F4;%yaw

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
            obj.slack=zeros(2,obj.param.Num);
            %重み%
            %Follower drone weight paramerter
            obj.param.V =  diag([10.;10.]);%速度
            obj.param.Qm = 10;%機体間距離Ql 10
            obj.param.Qmf = 10;%機体間距離の終端コストQlf  10
            obj.param.Qt = 40;%経路との距離Qr
            obj.param.Qtf = 50;%経路との距離の終端コストQrf 50
            obj.param.R  = diag([1.;1.]);    % モデル予測制御の入力に対するステージコスト重み
            obj.param.Num= obj.param.H + 1;
            obj.param.W_s = 40;%スラック変数の重み
            obj.param.W_r = 20;
            %スルーレートっぽいやつの設定
            obj.param.Slew = 0.1;
            %制約距離
            obj.param.D_lim = [3,0.1];%[3,0.5]
            %ケーブルに対する制約
            obj.param.r_limit = [0.3,0.6];%[soft,hard]
            
%             obj.previous_variables = ones(obj.param.input_size + obj.param.state_size,obj.param.Num);
            obj.previous_variables = param.arranged_pos(1:2,obj.self.id);
            obj.previous_variables = repmat([obj.previous_variables(1);zeros(3,1);obj.previous_variables(2);zeros(5,1)],1,obj.param.Num);
            
            
            obj.model = self.model;
            obj.param.A = sysd.A;
            obj.param.B = sysd.B;
            


            obj.param.P_chips = param.P_chips;
            
            %経路幅
            obj.param.wall_width_y = param.wall_width_y;
            obj.param.wall_width_x = param.wall_width_x;
            
            
%             %セクションポイント
            obj.param.sectionpoint = param.sectionpoint;
            obj.param.sectionnumber = param.Sectionnumber;
            obj.param.Section_change = param.Section_change;
            [obj.S_limit,~] = size(obj.param.sectionpoint);
            obj.param.Sectionconect=param.Sectionconect;
            obj.param.wall_width_xx = param.wall_width_xx;
            obj.param.wall_width_yy = param.wall_width_yy;
            
            obj.param.Cdis = param.Cdis;
            obj.param.Line_Y = param.Line_Y;
            

            if isfield(param,'agent');obj.param.agent=param.agent;end
        end
        function u = do(obj,~,~)
                        % param{1} : 推定したstate構造体
            % param{2} : 参照状態の構造体
            % param{3} : 構造体：物理パラメータP，ゲインF1-F4 
            modelstate = obj.self.estimator.result.state;
            
            modelstate.q=(eul2quat(modelstate.q','XYZ'))';%オイラーからクォータニオンへの変換

            
%             x = modelstate.get; % [q, p, v, w]に並べ替え
            x = [modelstate.q;modelstate.p;modelstate.v;modelstate.w];
            xd = obj.self.reference.result.state.get();
            xd=[xd;zeros(20-size(xd,1),1)];% 足りない分は０で埋める．
            %x=cell2mat(arrayfun(@(t) state.(t)',string(state.list),'UniformOutput',false))';
            %x = state.get();%状態ベクトルとして取得
            %仮想入力，仮想出力算出
            if isfield(obj.param,'dt')
                dt = obj.param.dt;
                vf = Vfd(dt,x,xd',obj.param.P,obj.param.F1);
            else
                vf = Vf(x,xd',obj.param.P,obj.param.F1);
            end
            vs = Vs(x,xd',vf,obj.param.P,obj.param.F2,obj.param.F3,obj.param.F4);
            v4 = vs(3);
            %実状態を仮想状態に変換
            xd1 = zeros(20,1);
            h2 = Z2(x,xd1',vf,obj.param.P);   %x方向の仮想状態
            h3 = Z3(x,xd1',vf,obj.param.P);   %y方向
            %h2とh3を状態にしたMPC
            
            % セクションチェンジ更新
            [obj.param.Section_change] = Sectionnumbersetting(obj.param.sectionnumber,obj.S_limit);

 %%%%%%%%%%%%%%%%%%%%paramに全機体のagentを入れて対応%%%%%%%%%%%%%%%%%%%%%      
%             frontUAVnum = string(obj.self.id-1);% 一機前の機体番号(string型)
%             strSC = strcat('agent(',frontUAVnum,').controller.mpc_f.param.Section_change');% 他の部分と結合
%             obj.param.S_front = evalin('base',strSC);% メインのワークスペースから引っ張ってくる
            if isfield(obj.param,'agent')
                obj.param.S_front=obj.param.agent(obj.self.id-1).controller.mpc_f.param.Section_change;
            else
                obj.param.S_front=obj.param.Section_change;
            end
            obj.param.S_front(obj.param.S_front>obj.S_limit) = obj.S_limit;% S_limitより大きくならないように
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
            
%自機体
            %区分多項式の線を変更
            prev_sp = obj.param.sectionpoint(obj.param.Section_change(1),:);%previous section
            now_sp =obj.param.sectionpoint(obj.param.Section_change(2),:);%now section
            next_sp = obj.param.sectionpoint(obj.param.Section_change(3),:);%next section
            n_next_sp =obj.param.sectionpoint(obj.param.Section_change(4),:);%nextnext section
            prev_r = abs(det([[prev_sp(1),prev_sp(2)]-[now_sp(1),now_sp(2)];[x(5),x(6)]-[now_sp(1),now_sp(2)]]))/norm([prev_sp(1),prev_sp(2)]-[now_sp(1),now_sp(2)]);
            next_r =abs(det([[next_sp(1),next_sp(2)]-[n_next_sp(1),n_next_sp(2)];[x(5),x(6)]-[n_next_sp(1),n_next_sp(2)]]))/norm([next_sp(1),next_sp(2)]-[n_next_sp(1),n_next_sp(2)]);
            [~,PcSection] = min([prev_r;next_r]);
            
            
            

%             xx = [obj.param.sectionpoint(1,1),obj.param.sectionpoint(2,1)-0.1,obj.param.sectionpoint(3,1)];
%             yy = [obj.param.sectionpoint(1,2),obj.param.sectionpoint(2,2),obj.param.sectionpoint(3,2)];
%             obj.param.P_chips = [xx;yy];

            
            Pchipvariables =Line_Setting(obj.param.sectionnumber,obj.param.sectionpoint,PcSection,obj.S_limit);
            obj.param.P_chips = Pchipvariables;

            
            %ループの中で変動するパラメータを設定
            %evalinは重いのでループ内では使わない


%           mainのtypical_Sensor_RangePosをオンにしてobj.self.sensor.resultの中にneighborを引っ張ってくる．1列目が前の機体で，二列目が後ろの機体
            obj.param.front = [repmat([obj.self.sensor.result.neighbor(1,obj.self.id-1);obj.self.sensor.result.neighbor(2,obj.self.id-1)],1,obj.param.Num)];%前機体の座標
            obj.param.behind = repmat([obj.self.sensor.result.neighbor(1,obj.self.id);obj.self.sensor.result.neighbor(2,obj.self.id)],1,obj.param.Num);

            
            
            obj.param.X0 = [h2;h3];
            obj.param.Xd = xd;
%             obj.param.sectionpoint(end,:) = obj.self.sensor.result.rigid(1).p(1:2);% 先頭機体の位置座標を引っ張ってくる
            
            
            
                       
            %前後機体との距離更新
%             FstrSN = strcat('agent(',frontUAVnum,').controller.mpc_f.param.sectionnumber');
%             obj.param.frontSN = evalin('base',FstrSN);
            
%             behindUAVnum = string(obj.self.id+1);% 一機後の機体番号(string型)
%             BstrSN = strcat('agent(',behindUAVnum,').controller');
%             Bcontroller = evalin('base',BstrSN);
            % 最終機体でのエラー回避
            if isfield(obj.param,'agent')            %前機体のセクションナンバー
                obj.param.frontSN = obj.param.agent(obj.self.id-1).controller.mpc_f.param.sectionnumber;
            else
                obj.param.frontSN =1;
            end
            if isfield(obj.param,'agent')            %後ろ機体
                if obj.self.id+1 ~= obj.param.N
                    obj.param.behindSN = obj.param.agent(obj.self.id+1).controller.mpc_f.param.sectionnumber;
                else
                obj.param.behindSN = 1;
                end
            else
                obj.param.behindSN = 1;
            end

            obj.param.FLD = cell2mat(arrayfun(@(L) Linedistance(obj.param.front(1,L),obj.param.front(2,L),obj.param.sectionpoint,obj.param.frontSN),1:obj.param.Num,'UniformOutput',false));
            obj.param.BLD = Linedistance(obj.self.sensor.result.neighbor(1,obj.self.id),obj.self.sensor.result.neighbor(2,obj.self.id),obj.param.sectionpoint,obj.param.behindSN);



            
%========================MEX化部分===================================%    

        if isfield(obj.param,'agent')
            tmp=obj.param.agent;
            obj.param.agent=0;
            MPCparam = obj.param;
            obj.param.agent=tmp;
        else
            obj.param.agent=0;
            MPCparam = obj.param;
        end
            MPCprevious_variables = obj.previous_variables;
            MPCslack = obj.slack;
%             var = F_HL_MPCfunc(MPCparam,MPCprevious_variables,MPCslack);
            var=F_HL_MPCfunc_mex(MPCparam,MPCprevious_variables,MPCslack);%MEX化

%==================================================================%
            obj.previous_variables = var(1:10,:);            
            v23 = var(obj.param.state_size + 1:obj.param.total_size, 1); % 最適化計算での現在時刻の入力を制御対象に印可する入力として採用
            v2 = v23(1);%x方向の仮想出力
            v3 = v23(2);%y方向
           
            %評価値をいったん保存
%             tmp_fval(N) = fval;
%             disp(fval);
            %計算の指標を一時保存
%             tmp_exitflag(N) = exitflag;
            
            
            vxy=[v2,v3];%x方向とy方向の仮想入力
            vs=[vxy,v4];

%           区間変更    2の場合今のセクションが一番近い．３になったときのみ次セクションに変更後2に戻る
            FSectionPlus = SectionNumchange(x(5:7),obj.param.sectionpoint,obj.param.Section_change);

            obj.param.sectionnumber = obj.param.sectionnumber + FSectionPlus - 2;
            if obj.param.sectionnumber < 1
                obj.param.sectionnumber = 1;
            end
            

    %-----------------------------------------------------------------%
            obj.result.input = Uf(x,xd',vf,obj.param.P) + Us(x,xd',vf,vs',obj.param.P);
            obj.result.var = var;
            


            u = obj.result;
%             obj.self.input = obj.result.input;%こっちに変更2020/10/22
            
        end
        function show(obj)
            obj.result
        end
       
    end
end

