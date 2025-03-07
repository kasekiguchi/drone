classdef FOR_LOAD < SENSOR_CLASS
      properties
        result                  % 現在時刻の結果
        rigid_num               % 剛体番号
        self                    % agent
        tt0                     % takeoffの開始時間
        tl0                     % landingの開始時間
        tte         = 10        % センサー値を何秒で100%使うか
        tle         = 5         % センサー値を何秒で0%使うか
        ratet                   % 二次関数で0-1の間で変化するための定数
        ratel                   % 二次関数で0-1の間で変化するための定数
        inispL                  % 初期の牽引物位置
        isAir       = 0         % 機体が一定高度より高くなっている
        isGround    = 0         % 地面判定の初期化
        cableL_landing          % landing開始時の機体と牽引物の距離
        k=0
    end
    
    methods
        function obj = FOR_LOAD(self,varargin)
            %自律を考えたときに条件分岐は推定値を使ったほうがいい場合もあるかも
            obj.self                = self;
            if ~isempty(varargin)
                if isfield(varargin{1},'rigid_num')
                    obj.rigid_num   = varargin{1,1}.rigid_num;
                end
            end
            obj.result.state        = STATE_CLASS(struct('state_list',["p","q","pL","pT","real_pL","isGround","k"],"num_list",[3,4,3,3,1,1]));
            obj.ratet               = 1/obj.tte^2;%二次関数で0-1の間で変化する
            obj.ratel               = 1/obj.tle^2;%二次関数で0-1の間で変化する
        end
        
        function result = do(obj,varargin)
            %   param : optional
            tc          = varargin{1}{1}.t;                                     % 現在時刻
            cha         = varargin{1}{2};                                       % phase
            sp          = obj.self.sensor.motive.result.state.p;                % 機体位置
            sq          = obj.self.sensor.motive.result.state.q;                % 機体角度
            spL         = obj.self.sensor.motive.result.rigid(obj.rigid_num).p; % 牽引物位置
            ipL         = sp -[0;0;obj.self.parameter.get("cableL")];           % 機体の真下にあると仮定したときの牽引物位置
            
            %flight
            if strcmp(cha,'f')
                obj.tt0         =[];                                            % takeoffの開始時間を初期化
                obj.tl0         =[];                                            % landingの開始時間を初期化
                obj.isGround    =0;                                             % 地面判定の初期化
            %take off
            elseif strcmp(cha,'t')
                if isempty(obj.inispL)
                    obj.inispL  = spL;                                                  % 初期の牽引物位置
                end
                % 牽引物の初期高さ+機体の全高より高くなったらセンサ値を使い始める
                % if sp(3)> obj.inispL(3) + 0.3 || obj.isAir
                if sp(3)> obj.inispL(3) + obj.self.parameter.get("cableL")*0.9 || obj.isAir
                    obj.isAir   = 1;
                    if isempty(obj.tt0)
                        obj.tt0 = tc;
                    end
                    t           = min((tc - obj.tt0),obj.tte);                   %takeoffの経過時間がセンサ値使用率100%になる時間を越えないようにする
                    obj.k           = obj.ratet*t^2;                                 %センサ値反映割合
                    spL(1:2)    = sp(1:2) + obj.k*(spL(1:2) - sp(1:2));              %牽引物位置と機体位置の差に反映割合をかけてセンサ値を反映
                    spL(3)      = ipL(3);
                    obj.k
                %閾値を越えなかったら機体の真下に牽引物がいることにする
                else
                    spL         = ipL;
                end
            %landing
            elseif strcmp(cha,'l') 
                %地面についたかの判定
                if ~obj.isGround 
                    % 牽引物質量推定を行っている場合
                    if isprop(obj.self.estimator.result.state,"mL")
                        %コントローラクラスで地面についた判定があるか
                        if obj.self.controller.isGround
                            obj.isGround        = 1;
                        end
                    % 牽引物質量推定していない場合はlanding開始時の機体と牽引物の距離からの差によって判断
                    else
                        if isempty(obj.cableL_landing)
                            obj.cableL_landing  = sp - spL;                     % landing開始時の機体と牽引物の距離
                        end
                        % landing開始時の機体と牽引物の距離のz方向の半分の長さより現在の差の距離の方が短い場合
                        if sp(3) - spL(3) < obj.cableL_landing(3)*0.9
                            obj.isGround        = 1;
                        end
                    end
                end
                sfG = obj.isGround
                % 地面についた判定になったらセンサ値を使い始める
                % if obj.isGround
                    if isempty(obj.tl0)
                        obj.tl0 = tc;
                    end
                    t           = min(tc - obj.tl0, obj.tle);                   % landingの経過時間がセンサ値使用率0%になる時間を越えないようにする
                    obj.k           = -obj.ratel*t^2 + 1;                           % センサ値反映割合
                    spL(1:2)    = sp(1:2) + obj.k*(spL(1:2) - sp(1:2));             % 牽引物位置と機体位置の差に反映割合をかけてセンサ値を反映
                    % spL    = ipL + obj.k*(ipL - spL);             % 牽引物位置と機体位置の差に反映割合をかけてセンサ値を反映
                % end
                spL(3)      = ipL(3);
            else
                spL             = ipL;                                          % 機体の真下にあると仮定したときの牽引物位置
                obj.tt0         = [];                                           % takeoffの開始時間を初期化
                obj.tl0         = [];                                           % landingの開始時間を初期化
                obj.isGround    = 0;                                            % 地面判定の初期化
            end
        %log
            obj.result.state.p          = sp;
            obj.result.state.q          = sq;
            obj.result.state.pL         = spL;
            obj.result.state.real_pL    = obj.self.sensor.motive.result.rigid(obj.rigid_num).p;
            obj.result.state.pT         = (spL-sp)/norm(spL-sp);                % 機体からみた牽引物までの単位方向ベクトル
            obj.result.state.isGround         = obj.isGround;
            obj.result.state.k         = obj.k;
            result                      = obj.result;
        end
        function show()
        end
    end
end

