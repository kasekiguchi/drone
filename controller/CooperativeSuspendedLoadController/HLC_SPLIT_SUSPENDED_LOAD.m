classdef HLC_SPLIT_SUSPENDED_LOAD < handle
    % クアッドコプター用階層型線形化を使った入力算出
    properties
        self
        result
        param
        isGround = 0
        mLlanding
        cableL_landing
    end
    
    methods
        function obj = HLC_SPLIT_SUSPENDED_LOAD(self,param)
            obj.self            = self;    % agent
            obj.param           = param;  % param (optional) : 構造体：物理パラメータP，ゲインF1-F4 
            obj.result.input    = [(self.parameter.loadmass*0 + self.parameter.mass)*self.parameter.gravity;0;0;0];% 初期入力
        end
        
        function result = do(obj,varargin)
            if isscalar(varargin)
                agent   = varargin{1};
            else
                agent   = varargin;
            end
            Param       = obj.param;                    % param (optional) : 構造体：物理パラメータP，ゲインF1-F4 
            model       = obj.self.estimator.result;    % 推定した状態
            ref         = obj.self.reference.result;    % 目標値
            x           = [model.state.getq('compact');model.state.w;model.state.pL;model.state.vL;model.state.pT;model.state.wL]; % [q, w ,pL, vL, pT, wL]に並べ替え
        % 目標値を取得
            if isprop(ref.state,'xd')
                xd      = ref.state.xd;                 % 20次元の目標値に対応する用
            else
                xd      = ref.state.get();
            end
        % yaw角の定義域の問題を回避
            yaw         = model.state.q(3);                                     % 機体yaw角
            yawd        = xd(4);                                                % 目標yaw角
            yawUnit     = [cos(yaw);sin(yaw);0];                                % yawの方向ベクトル
            yawdUnit    = [cos(yawd);sin(yawd);0];                              % yawdの方向ベクトル
            deltaYaw    = sign(cross(yawdUnit,yawUnit))*acos(yawdUnit'*yawUnit);% 目標角度からみた機体角度との誤差
            xd(4)       = yaw - deltaYaw(3);                                    % 機体yaw角度から誤差分引いて目標yaw角を求める
        %目標値の格納
            xd          =[xd;zeros(28-size(xd,1),1)];   % 足りない分は0で埋める．
        %物理パラメータ
            P           = obj.self.parameter.get(["mass", "jx", "jy", "jz", "gravity", "loadmass", "cableL"]);
        %拡張質量システムのekfで牽引物の質量を求める場合
            if contains(obj.self.estimator.model.name,"Load_mL")
                %landingのとき
                if varargin{2} == "l"
                    if isempty(obj.cableL_landing)
                        obj.cableL_landing = model.state.p - model.state.pL;                          % landing開始時の機体と牽引物の距離
                    end
                    if isempty(obj.mLlanding)
                        obj.mLlanding   = model.state.mL;                       % landing開始時の質量
                    end
                    % 推定質量がobj.mLlandingの90%未満またはlanding開始時の機体と牽引物の距離のz方向の90%の長さより現在の差の距離の方が短い場合の時は牽引物質量0
                    if model.state.mL < obj.mLlanding*0.9 || model.state.p(3) - model.state.pL(3) < obj.cableL_landing(3)*0.9 || obj.isGround == 1
                        obj.isGround    = 1;                                    % この分岐に一回でも入ったら入り続けるようにフラグ立てる
                        p(6)            = 0;                                    % 地面についたら質量は0とする
                    % 地面についた判定出ないなとき
                    else
                        p(6)            = min(model.state.mL, obj.mLlanding);   % 傾いて着陸した時に推定が吹っ飛ばないように制限
                    end
                % landing以外のとき
                else 
                    P(6)                = max(model.state.mL,0);                % 推定質量の下限を0に設定
                end
                % 紐の長さを推定するとき
                if isprop(model.state,"cableL")
                    % P(7) = max(model.state.cableL,0.1);
                    P(7)                = max(min(model.state.cableL,P(7)*1.2),P(7)*0.8);
                end
                obj.result.mLi          = P(6);
            end

        % 階層型線形化による入力計算
            % 仮想入力のゲイン
            F1              = Param.F1;                                 % z方向サブシステムのゲイン
            F2              = Param.F2;                                 % x方向サブシステムのゲイン
            F3              = Param.F3;                                 % y方向サブシステムのゲイン
            F4              = Param.F4;                                 % yaw方向サブシステムのゲイン
            % 第一層のz方向サブシステムの仮想入力の計算
            if isfield(Param,'dt')
                dt          = Param.dt;                                 % 現在時刻の刻み時間
                vf          = Vfd_SuspendedLoad(dt,x,xd',P,F1);         % 実験で刻み時間が変わったときに対応
            else
                vf          = Vf_SupendedLoad(x,xd',P,F1);              % 刻み時間は一定
            end
            
            vs              = Vs_SuspendedLoad(x,xd',vf,P,F2,F3,F4);    % 第二層x,y,yawサブシステムの仮想入力の計算
            % obj.result.Z1 = Z1_SuspendedLoad(x,xd',vf,P);             % z方向サブシステムの仮想状態
            % obj.result.Z2 = Z2_SuspendedLoad(x,xd',vf,P);             % x方向サブシステムの仮想状態
            % obj.result.Z3 = Z3_SuspendedLoad(x,xd',vf,P);             % y方向サブシステムの仮想状態
            % obj.result.Z4 = Z4_SuspendedLoad(x,xd',vf,P);             % yaw方向サブシステムの仮想状態
            
            uf              = Uf_SuspendedLoad(x,xd',vf,P);             % 第一層の仮想入力の実入力(推力)への変換
            % h234            = H234_SuspendedLoad(x,xd',vf,vs',P);       % ただの単位行列なのでなくてもいい
            invbeta2        = inv_beta2_SuspendedLoad(x,xd',vf,vs',P);  % 第二層のbetaの逆行列
            vs_alpha2       = vs_alpha2_SuspendedLoad(x,xd',vf,vs',P);  % 第二層のvs - alpha
            us              = [0;invbeta2*vs_alpha2];                   % 第二層の実入力（roll,pitch,yawのトルク）への変換：bate^(-1)*(vs - alpha)%h234*invbeta2*a2;
            tmp             = uf + us;                                  % 実入力へ変換
            obj.result.tmp  = tmp;                                      % 入力に制限を付けてない値を格納

            % 安全のため入力値に制限を付ける．推定した牽引物質量や紐の長さ，外乱などを表示．
            if isprop(model.state,"dst") || isprop(model.state,"cableL")
                 disp("time: "+ num2str(agent{1}.t,2)+" z position of drone: "+num2str(model.state.p(3),3)+" estimated load mass: "+num2str(P(6),4)+" dst: "+num2str(model.state.dst',4))
                % obj.result.input = [max(0,min(20,tmp(1) - fdst));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];%+[normrnd(0,0.002,1);normrnd(0,0.001,[3,1])];
                % disp("time: "+ num2str(agent{1}.t,2)+" z position of drone: "+num2str(model.state.p(3),3)+" estimated load mass: "+num2str(P(6),4)+" dst: "+num2str(model.state.cableL,4))
                obj.result.input = [max(0,min(200,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];%+[normrnd(0,0.01,1);normrnd(0,0.001,[3,1])]*1;%入力にノイズを付与可能
            else
                disp("time: "+ num2str(agent{1}.t,2)+" z position of drone: "+num2str(model.state.p(3),3)+" estimated load mass: "+num2str(P(6),4))
                obj.result.input = [max(0,min(20,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];%+[normrnd(0,0.01,1);normrnd(0,0.001,[3,1])]*1;%入力にノイズを付与可能
            end
            result = obj.result;  
        end
        function show(obj)
            obj.result
        end
    end
end
