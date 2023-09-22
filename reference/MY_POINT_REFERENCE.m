classdef MY_POINT_REFERENCE < handle
    properties
        param
        self
        cha
        fns
        length_fns
        ref_t
        fref_t
        t0
        i
        result
    end
    
    methods
        function obj = MY_POINT_REFERENCE(self,varargin)
            %縦ベクトルで書く
            %最初のコマンドは"f"で始める
            % 参照
            obj.self = self;
            var=varargin{1};
            if length(var) ==2
                obj.ref_t=var{2};%目標地点の更新までの時間
                obj.fref_t = (var{2}>=5 ) ;%5s以上の時は自動で更新
            else
                obj.fref_t =false;%時間が入力されてない場合
            end
            % obj.fref_t = (var{2}>=5 ) ;%5s以上の時は自動で更新
            obj.param=var{1};%{"f",[1,1,1]}
            obj.fns = cell2mat(fieldnames(obj.param));
            obj.length_fns=length(obj.fns);
            %yawの目標角度が指定されてなかったら0にする
            for j = 1:obj.length_fns
                if length(obj.param.(obj.fns(j)))==3
                    obj.param.(obj.fns(j))= [obj.param.(obj.fns(j));0];
                end
            end
            obj.i=1;%目標地点を自動で更新するためのインデックスの初期値
            obj.result.state = STATE_CLASS(struct('state_list',["xd","p", "q","v"],'num_list',[20,3,3,3]));
            obj.result.state.set_state("xd",zeros(6,1));
            obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
            obj.result.state.set_state("q",obj.self.estimator.result.state.get("q"));
            obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
        end
        function  result= do(obj,varargin)
            % 【Input】result = {Xd(optional)}
            if obj.fref_t 
                if isempty(obj.t0)
                    obj.t0=varargin{1}.t;%目標地点が定められた時刻
                end
                t = varargin{1}.t - obj.t0;%目標地点が定められた時間からの経過時間
            
            %指定した時刻を過ぎた場合に実行
                if t > obj.ref_t 
                    obj.i=obj.i+1;%目標地点の場所を定義された順番に更新していく
                    obj.t0=varargin{1}.t;%目標地点が更新された時刻
                    %定義された最後の目標地点の場所が終わったら最初の目標地点に戻る
                    if obj.i > obj.length_fns
                        obj.i=1;
                    end
                end

                    obj.result.state.p = obj.param.(obj.fns(obj.i))(1:3);%xyz
                    obj.result.state.q(3,1) = obj.param.(obj.fns(obj.i))(4);%yaw

            else
                obj.cha=varargin{2};%入力された文字
                %入力された文字に対応した目標地点を選択
                if isfield(obj.param,obj.cha)
                    obj.result.state.p = obj.param.(obj.cha)(1:3);%xyz
                    obj.result.state.q(3,1) = obj.param.(obj.cha)(4);%yaw
                end
            end
            obj.result.state.v = [0;0;0];
            obj.result.state.xd = [obj.result.state.p; obj.result.state.q(3,1); obj.result.state.v; 0];
            result = obj.result;
        end
         function show(obj, logger)
            rp = logger.data(1,"p","r");
            plot3(rp(:,1), rp(:,2), rp(:,3));                     % xy平面の軌道を描く
            daspect([1 1 1]);
            hold on
            ep = logger.data(1,"p","e");
            plot3(ep(:,1), ep(:,2), ep(:,3));       % xy平面の軌道を描く
            legend(["reference", "estimate"]);
            title('reference and estimated trajectories');
            xlabel("x [m]");
            ylabel("y [m]");
            hold off
        end
    end
end
