classdef TWOD_TANBUG < REFERENCE_CLASS
    % 時間関数としてのリファレンスを生成するクラス
    % obj = TWOD_TANBUG_REFERENCE()
    properties
        state %現在位置 
        state_initial %初期位置
        goal %目標位置
        obstacle %障害物である端点
        radius %端点を中心とする円の半径
        margin %通過してよいかの判断の閾値
        waypoint %通過点
        target_position %疑似目標位置
        forward %ドローンが向かう座標
        r %現在位置から目標位置までの距離
        angle %ドローンの姿勢角
        param
        self
    end

    methods
        function obj = TWOD_TANBUG(self, varargin)
            obj.state = [0,0,0];
            obj.state_initial = [0,0,0];
            obj.goal = [5,0,0];
            obj.obstacle = [2,0,0];
            obj.radius = 0.5;
            obj.margin = 0.5;
            obj.r = 0;
            obj.waypoint.A = [0,0,0];
            obj.waypoint.B = [0,0,0];
            obj.target_position = [0,0,0];
            obj.forward = [0,0,0];
            obj.angle = 0;
            obj.self=self;
            obj.result.state = STATE_CLASS(struct('state_list', ["xd","p","q"], 'num_list', [20, 3, 3]));            
        end
        
        function result = do(obj, ~)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            obj.state = obj.self.estimator.result.state.p;
            obj.angle = obj.self.estimator.result.state.q;
            obj.r = obj.distance(obj.state(1),obj.state(2),obj.goal(1),obj.goal(2));
            obj.angle = atan2((obj.goal(2) - obj.state(2)),(obj.goal(1) - obj.state(1)));
            X = abs(obj.obstacle(1) - obj.state(1));
            Y = abs(obj.obstacle(2) - obj.state(2));  
            f = 0;
            if (0 <= Y && Y <= obj.margin && 0 <= X && X <= obj.r)
                f = 1;
            end
            if (f == 1)
                [obj.waypoint.A(1),obj.waypoint.A(2),obj.waypoint.B(1),obj.waypoint.B(2)] = obj.conection(obj.state_initial(1),obj.state_initial(2),obj.obstacle(1),obj.obstacle(2),obj.radius);
                obj.target_position(1) = obj.waypoint.A(1);
                obj.target_position(2) = abs(obj.waypoint.A(2));
%                 obj.forward = obj.transformation(obj.state(1),obj.state(2),obj.angle,obj.target_position(1),obj.target_position(2));
%                 x = obj.forward(1);
%                 y = obj.forward(2);
                x = obj.target_position(1);
                y = obj.target_position(2);
                
            else
                x = obj.goal(1);
                y = obj.goal(2);
            end
            
           z = 0;
           yaw = 0;
%            agent.reference.result.state.p = [x;y;z];
            
%            obj.result.state.p = [x;y;z];
%            obj.result.state.q = obj.angle;
           obj.result.state.xd = [x;y;z];
           obj.result.state.p = obj.result.state.xd;
           result = obj.result;     
        end
        
        function d = distance(~,x1,y1,x2,y2) %2点間の距離を算出
            a = [x1,y1];
            b = [x2,y2];
            d = norm(b - a);
        end      
        
        function position = transformation(~,Dx,Dy,Dyaw,Ax,Ay) %端点座標をドローン座標に変換
            % Dx,Dy:ドローンの自己位置
            % Ax,Ay:障害物の座標
            % Dyaw: ドローンの角度
            x = Ax * cos(Dyaw) - Ay * sin(Dyaw) + Dx;
            y = Ax * sin(Dyaw) + Ay * cos(Dyaw) + Dy;
            position = [x,y];
        end
        
        function [A_x,A_y,B_x,B_y] = conection(obj,x,y,X,Y,r) %接点の算出
            % x,y:初期位置
            % X,Y:障害物の座標
            % r: 円の半径
            a = x - X;
            b = y - Y; 
%             a = X - x;
%             b = Y - y;
            c = X^2 + Y^2 - x * X - y * Y - r^2;
            D = abs(a*X + b*Y + c);
            A_x = ((a*D - b*sqrt((a^2 + b^2)*obj.radius^2 - D^2))/(a^2 + b^2)) + X;
            A_y = ((b*D + a*sqrt((a^2 + b^2)*obj.radius^2 - D^2))/(a^2 + b^2)) + Y;
            B_x = ((a*D + b*sqrt((a^2 + b^2)*obj.radius^2 - D^2))/(a^2 + b^2)) + X;
            B_y = ((b*D - a*sqrt((a^2 + b^2)*obj.radius^2 - D^2))/(a^2 + b^2)) + Y;
%             contact = [A_x,A_y,B_x,B_y];            
        end
        
        function show(obj,param)
        end
    end
end
