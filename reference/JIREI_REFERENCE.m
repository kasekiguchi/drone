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
            obj.screenXm = 35.64e-3;%暫定
             obj.result.state=STATE_CLASS(struct('state_list',["xd","p","q","v"],'num_list',[4,4,1,1]));%x,y,theta,v
        end

        function  result= do(obj,param)
            EstData = obj.self.estimator.result.state.get();
            pe = EstData(1:2);
            the = EstData(3);
            R = [cos(the), -sin(the);sin(the), cos(the)];
            
            sensor = obj.self.sensor.result;
            Xcp = (sensor.Uxy(1)+sensor.Dxy(1))/2;
            Xcs = ( Xcp - obj.screenX/2 )*(obj.screenXm/obj.screenX);
            theta = atan(Xcs/obj.f);
            
            obj.result.state.p = [pe(1);pe(2)];
            obj.result.state.q = -theta;
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
