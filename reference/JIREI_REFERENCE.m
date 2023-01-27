classdef JIREI_REFERENCE < REFERENCE_CLASS
    % 通路の中心を通るリファレンスを生成するクラス
    % 曲がり角では外側の二本の壁面の中線と曲がり角に進入時の位置から近い壁面に下した垂線の交点を中心とした回転をする．
    properties
        refv
        PreTrack
        dt
        screenX
        screenY
        f
        screenXm
        self
        O = [] % 回転中心
        r  % 回転半径
        th = [];
        constant
    end

    methods
        function obj = JIREI_REFERENCE(self,varargin)

            obj.self = self;
            param = varargin{1};
            obj.refv = param{1,1};
            obj.screenX = param{1,2};
            obj.screenY = param{1,3};
            obj.f = 40e-3;%暫定
            obj.screenXm = 36.00e-3;%暫定
             obj.result.state=STATE_CLASS(struct('state_list',["p","q","v"],'num_list',[2,1,1]));%x,y,theta,v
        end

        function  result= do(obj,param)
            EstData = obj.self.estimator.result.state.get();
            pe = EstData(1:2);
            the = obj.self.plant.result.state.q;
            R = [cos(the), -sin(the);sin(the), cos(the)];
            
            sensor = obj.self.sensor.result;%センサ受け取り
            Xcp = (sensor.Uxy(1)+sensor.Dxy(1))/2;%バウンディングボックスの中心算出
            Xcs = ( Xcp - obj.screenX/2 )*(obj.screenXm/obj.screenX);%画面中央との差，m変換
            theta = -atan(Xcs/obj.f);%Θ算出
            theta_ref = theta + the;%ロボットの角度を追加

            
            obj.result.state.p = [obj.self.plant.result.state.p(1);obj.self.plant.result.state.p(2)];
            obj.result.state.q = theta_ref;
            obj.self.reference.result.state = obj.result.state;
            obj.result.state.v = obj.refv;
            
            result = obj.result;
        end
        
        function show(obj,result)
            arguments
                obj
                result = []
            end
            if isempty(result)
                result = obj.result;
            end
            l = result.focusedLine;
            rp = result.state.p(1:2,:);
            rth = result.state.p(3,:);
            plot(l(1:2,1),l(1:2,2),'LineWidth',3,'Color','b');
            hold on
            plot(l(4:5,1),l(4:5,2),'LineWidth',2,'Color','r');
            plot(rp(1,:),rp(2,:),'yo','LineWidth',1);
            quiver(rp(1,:),rp(2,:),2*cos(rth),2*sin(rth),'Color','y');
            p = result.O;
            plot(p(1),p(2),'r*');
            p = obj.self.estimator.result.state.p;
            th = obj.self.estimator.result.state.q;
            plot(p(1),p(2),'ro');
            quiver(p(1),p(2),cos(th),sin(th),'Color','r');
            hold off
        end

    end
end
