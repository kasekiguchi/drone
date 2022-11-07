classdef TWOD_TANBUG_jirei < REFERENCE_CLASS
    % 時間関数としてのリファレンスを生成するクラス
    % obj = TWOD_TANBUG_REFERENCE()
    properties
        state %現在位置 
        sensor %センサ情報
        state_initial %初期位置
        goal %目標位置
        pitch %laser間隔
        self
        param
    end

    methods
        function obj = TWOD_TANBUG_jirei(self, varargin)
            obj.pitch = self.sensor.lrf.pitch;
            obj.state_initial = [0,0,0]';
            obj.goal = [6,0,0]';
            obj.self=self;
            obj.result.state = STATE_CLASS(struct('state_list', ["p","v"], 'num_list', [3, 3]));
        end
        
        function result = do(obj, t)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            obj.state = obj.self.estimator.result.state; %自己位置
            yaw = obj.state.q(3);
            obj.sensor = obj.self.sensor.result; %センサ情報






            obj.result.state.p = obj.goal; % local座標での位置
            obj.result.state.v = [0;0;0];

            result = obj.result;
        end
        
        

%%
        function show(obj,env)
            arguments
                obj
                env=[]
            end
            yaw = obj.state.q(3);
            R = [cos(yaw),-sin(yaw);sin(yaw),cos(yaw)];
            angles= (0:0.01:2*pi)';
%             circ = obj.margin*[cos(angles),sin(angles)];
            if isempty(env)
                obj.self.sensor.lrf.show();
%                 hold on
%                 local_rp =R'*obj.result.state.p(1:2)-obj.state.p(1:2);
%                 local_tp = obj.local_tp;
%                 angle= 0:0.1:2*pi;
%                 wp = obj.waypoint;
%                 plot(local_rp(1),local_rp(2),'ro');
%                 plot(local_tp(1)+circ(:,1),local_tp(2)+circ(:,2));
%                 plot(obj.goal(1)-obj.state.p(1),obj.goal(2)-obj.state.p(2),"ys");
            else
                plot(polyshape(env.param.Vertices),'FaceColor','g');
                hold on
                tmp = (R*(obj.self.sensor.result.sensor_points'))';
                points(1:2:2*size(tmp,1),:)=tmp;
                points = points + obj.state.p(1:2)';
                plot(points(:,1),points(:,2),'r-');
                hold on; 
%                 text(points(1,1),points(1,2),'1','Color','b','FontSize',10);%センサインデックスの1を表示
                %plot(obj.self.sensor.result.region);
                %plot(obj.head_dir);
                plot(obj.state.p(1),obj.state.p(2),'b*');
                plot(obj.result.state.p(1),obj.result.state.p(2),'bo');%referenceの表示
%                 local_tp = R*obj.local_tp(1:2);
%                 plot(obj.state.p(1)+local_tp(1)+circ(:,1),obj.state.p(2)+local_tp(2)+circ(:,2));%接点を生成するための円
                plot(obj.goal(1),obj.goal(2),"ks","MarkerFaceColor",[0.5,0.5,0.5]);
                axis equal;
                writeAnimation('drone.gif')
            end

        end
    end
end
