classdef TWOD_TANBUG < REFERENCE_CLASS
    % 時間関数としてのリファレンスを生成するクラス
    % obj = TWOD_TANBUG_REFERENCE()
    properties
        param
        self
    end

    methods
        function obj = TWOD_TANBUG(self, varargin)
            obj.self=self;
            obj.result.state = STATE_CLASS(struct('state_list', ["p","v"], 'num_list', [3, 3]));            
        end
        function result = do(obj, Param)  
           obj.result.state.p = obj.self.estimator.result.state.p;
           obj.result.state.v = obj.self.estimator.result.state.v;
           result = obj.result;     
        end
        function show(obj,env)
            arguments
                obj
                env=[]
            end
            yaw = obj.state.q(3);
            R = [cos(yaw),-sin(yaw);sin(yaw),cos(yaw)];
            angles= (0:0.01:2*pi)';
            circ = obj.margin*[cos(angles),sin(angles)];
            if isempty(env)
                obj.self.sensor.lrf.show();
                hold on
                local_rp =R'*obj.result.state.p(1:2)-obj.state.p(1:2);
                local_tp = obj.local_tp;
                angle= 0:0.1:2*pi;
                wp = obj.waypoint;
                plot(local_rp(1),local_rp(2),'ro');
                plot(local_tp(1)+circ(:,1),local_tp(2)+circ(:,2));
                plot(obj.goal(1)-obj.state.p(1),obj.goal(2)-obj.state.p(2),"ys");
            else
                plot(polyshape(env.param.Vertices));
                hold on
                tmp = (R*(obj.self.sensor.result.sensor_points'))';
                points(1:2:2*size(tmp,1),:)=tmp;
                points = points + obj.state.p(1:2)';
                plot(points(:,1),points(:,2),'r-');
                hold on;
                text(points(1,1),points(1,2),'1','Color','b','FontSize',10);
                %plot(obj.self.sensor.result.region);
                %plot(obj.head_dir);
                plot(obj.state.p(1),obj.state.p(2),'b*');
                plot(obj.result.state.p(1),obj.result.state.p(2),'go');
                local_tp = R*obj.local_tp(1:2);
                plot(obj.state.p(1)+local_tp(1)+circ(:,1),obj.state.p(2)+local_tp(2)+circ(:,2));
                plot(obj.goal(1),obj.goal(2),"ys");
                axis equal;
            end
        end
    end
end
