classdef TWOD_TANBUG < REFERENCE_CLASS
    % 時間関数としてのリファレンスを生成するクラス
    % 接点を通過点として障害物回避するプログラム
    % obj = TWOD_TANBUG_REFERENCE()
    properties
        state %現在位置 
        sensor %センサ情報
        state_initial %初期位置
        goal %目標位置
        obstacle %障害物である端点
        radius %laserレンジ
        margin %通過してよいかの判断の閾値
        waypoint %通過点
        target_position %疑似目標位置
        forward %ドローンが向かう座標
        d %現在位置から目標位置までの距離
        angle %ドローンの姿勢角
        e_z %z方向のベクトル
        v_max %速度ベクトルの上限
        dtheta %目標角度とセンサが見ている角度の差
        target_angle 
        margin_conect
        param
        self
        l_points
        g_points
        length
        pitch = 0.1 % laser間隔
        path_goal
        threshold
        tid = 1;
        local_tp = [0;0;0];
        past
    end

    methods
        function obj = TWOD_TANBUG(self, varargin)
            %obj.state = [0,0,0];

%            obj.pitch = self.sensor.lrf.pitch;
            tmp = self.sensor.lidar.phi_range;%3D
            obj.pitch = tmp(2)-tmp(1);%3D
            obj.sensor = [0,0];          
            obj.state_initial = [0,0,0]';
            obj.goal = [0,15,0]';%2Dgoal
%            obj.goal = [0,15,0]';% global goal position
            obj.obstacle = [0,0,0]';% 障害物座標
%            obj.radius = self.sensor.lrf.radius;
            obj.radius = self.sensor.lidar.radius;%3D
            obj.margin = 0.3;
            obj.margin_conect = 0.5;
            obj.threshold = 1.5;
            obj.d = 0;
            obj.waypoint.under = [0,0,0]';
            obj.waypoint.top = [0,0,0]';
            obj.target_position = [0,0,0]';
            obj.forward = [0,0,0]';
            obj.angle = 0;
            obj.result.state.p = [0;0;0];
                       
            obj.self=self;
            obj.e_z = [0,0,1]';
            obj.v_max = 0.35;
            obj.target_angle = 0;
%             obj.result.state = STATE_CLASS(struct('state_list', ["xd","p","q"], 'num_list', [20, 3, 3]));     
            obj.result.state = STATE_CLASS(struct('state_list', ["p","v"], 'num_list', [3, 3]));
            obj.result.state.p = [0;0;0];
%            obj.path_goal = zeros(size(self.sensor.lrf.angle_range));
            obj.path_goal = zeros(size(self.sensor.lidar.phi_range));%3D
            as = 0:obj.pitch:2*pi; %センサの分解能(ラジアン)（行列）
        end
        
        function result = do(obj, t)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            obj.state = obj.self.estimator.result.state; %自己位置
            obj.past.state.p = obj.result.state.p(1:3); %一時刻前の目標位置
            obj.past.state.v = obj.result.state.v; %一時刻前の速さ
            yaw = obj.state.q(3);
            as = 0:obj.pitch:2*pi;
            R = [cos(yaw),-sin(yaw),0;sin(yaw),cos(yaw),0;0,0,1];
            obj.sensor = obj.self.sensor.result; %センサ情報
            obj.length = obj.sensor.length; % 距離データ
            obj.l_points = obj.sensor.sensor_points; %座標データ
            l_goal = R'*(obj.goal-obj.state.p); % local でのゴール位置        
            goal_length = vecnorm(l_goal); % ゴールまでの距離
            l_goal_angle = atan2(l_goal(2),l_goal(1)); %ゴールまでの角度
            l_reference = R'*(obj.past.state.p - obj.state.p); %localでのreference位置
            reference_length = vecnorm(l_reference);
            l_reference_angle =atan2(l_reference(2),l_reference(1));
%            [~,id]=min(abs(obj.sensor.angle - l_goal_angle)); % goal に一番近い角度であるレーザーインデックス
           [~,id]=min(abs(obj.self.sensor.lidar.phi_range - l_goal_angle)); % goal に一番近い角度であるレーザーインデックス(3D)
            
%%
%             hold on
%             plot(path_goal.*cos(as),path_goal.*sin(as),"o")
%             plot(obj.length.*cos(as),obj.length.*sin(as),"o")
%             hold off
%%

            path_goal = obj.make_path(as,obj.margin,obj.self.sensor.lidar.phi_range,obj.radius,l_goal_angle,goal_length);%ゴールとの間に経路生成
            path_reference = obj.make_path(as,obj.margin,obj.self.sensor.lidar.phi_range,obj.radius,l_reference_angle,reference_length);%referenceとの間に経路生成

            
%             figure(8)
%             hold on
%             plot(path_goal.*cos(as),path_goal.*sin(as),"ro")
%             plot(path_reference.*cos(as),path_reference.*sin(as),"bo")
%             plot(obj.length.*cos(as),obj.length.*sin(as),"yo")
%             hold off     
%             clf

            if find(path_reference)
                N = 2;
            else
                N = 1;
            end

            switch N
                case 1
                    if find(obj.length < path_goal) % ゴールまでの間に障害物がある場合                              
                        tid = obj.ancher_detection(obj.length,obj.threshold,obj.l_points,obj.pitch,id,obj.goal,obj.sensor.sensor_points);
                        Length = [obj.length(end),obj.length,obj.length(1)];
                        edge_p = obj.length(tid)*[cos((tid-1)*obj.pitch-pi);sin((tid-1)*obj.pitch-pi);0];%端点
%                         edge_p = obj.sensor.sensor_points(:,tid);
                        if Length(tid+2) > Length(tid) % 左回りで避ける
                            %tid = obj.width_check(tid,-1);
                            [~,~,tmp1,tmp2] = obj.conection(0,0,edge_p(1),edge_p(2),obj.margin_conect);
                            obj.result.state.p = [tmp1;tmp2;0];
                            obj.result.state.v = obj.velocity_vector([0;0;0],edge_p,obj.result.state.p);
                        else % 右回り
                            %tid = obj.width_check(tid,1);
                            [tmp1,tmp2,~,~] = obj.conection(0,0,edge_p(1),edge_p(2),obj.margin_conect);
                            obj.result.state.p = [tmp1;tmp2;0];
                            obj.result.state.v = -obj.velocity_vector([0;0;0],edge_p,obj.result.state.p);
                        end
                        obj.tid = tid;
                        obj.local_tp = edge_p;
                        % local から global に変換
                        obj.result.state.p = [R*obj.result.state.p+obj.state.p;0];
            %             obj.result.state.p = [R*obj.result.state.p;0];
                        obj.result.state.v = R*obj.result.state.v;
                        result = obj.result;   
 
                    else % まっすぐゴールに行ける場合
                        obj.result.state.p = l_goal; % local座標での位置
                        obj.result.state.v = [0;0;0]; % local座標での位置
                        % local から global に変換
                        obj.result.state.p = [R*obj.result.state.p+obj.state.p;0];
            %             obj.result.state.p = [R*obj.result.state.p;0];
                        obj.result.state.v = R*obj.result.state.v;
                        result = obj.result;   
                    end     

                case 2
                    if find(obj.length < path_goal) % ゴールまでの間に障害物がある場合
                        if find(obj.length < path_reference) %referenceまでの間に障害物がある場合                              
                            tid = obj.ancher_detection(obj.length,obj.threshold,obj.l_points,obj.pitch,id,obj.goal,obj.sensor.sensor_points);
                            Length = [obj.length(end),obj.length,obj.length(1)];
%                             edge_p = obj.sensor.sensor_points(:,tid);
                            edge_p = obj.length(tid)*[cos((tid-1)*obj.pitch-pi);sin((tid-1)*obj.pitch-pi);0];%端点
                            if Length(tid+2) > Length(tid) % 左回りで避ける
                                %tid = obj.width_check(tid,-1);
                                [~,~,tmp1,tmp2] = obj.conection(0,0,edge_p(1),edge_p(2),obj.margin_conect);  
%                                 [~,~,tmp1,tmp2] = obj.conection(obj.state.p(1),obj.state.p(2),edge_p(1),edge_p(2),obj.margin_conect);  
                                obj.result.state.p = [tmp1;tmp2;0];
                                obj.result.state.v = obj.velocity_vector([0;0;0],edge_p,obj.result.state.p);
                            else % 右回り
                                %tid = obj.width_check(tid,1);
                                [tmp1,tmp2,~,~] = obj.conection(0,0,edge_p(1),edge_p(2),obj.margin_conect);
%                                 [tmp1,tmp2,~,~] = obj.conection(obj.state.p(1),obj.state.p(2),edge_p(1),edge_p(2),obj.margin_conect); 
                                obj.result.state.p = [tmp1;tmp2;0];
                                obj.result.state.v = -obj.velocity_vector([0;0;0],edge_p,obj.result.state.p);
                            end
                            obj.tid = tid;
                            obj.local_tp = edge_p;

                            % local から global に変換
                            obj.result.state.p = [R*obj.result.state.p+obj.state.p;0];
                %             obj.result.state.p = [R*obj.result.state.p;0];
                            obj.result.state.v = R*obj.result.state.v;
                            result = obj.result;   

%                             figure(4)
%                             hold on
%                             angles= (0:0.01:2*pi)';
%                             circ = obj.margin*[cos(angles),sin(angles)];
%                             local_tp = R*obj.local_tp;
%                             plot(obj.sensor.sensor_points(1,tid),obj.sensor.sensor_points(2,tid),'ro')
%                             plot(obj.state.p(1),obj.state.p(2),'b*');
%                             plot(obj.state.p(1)+local_tp(1)+circ(:,1),obj.state.p(2)+local_tp(2)+circ(:,2));
%                             plot(obj.result.state.p(1),obj.result.state.p(2),'bo');                            
%                             hold off
%                             clf
                           
                        else %referenceまではいけるので行きます
                            reference_state = obj.past.state.p - obj.state.p;
                            reference_state = vecnorm(reference_state);

                            if reference_state < 1.0
                                tid = obj.ancher_detection(obj.length,obj.threshold,obj.l_points,obj.pitch,id,obj.goal,obj.sensor.sensor_points);
                                Length = [obj.length(end),obj.length,obj.length(1)];
    %                             edge_p = obj.sensor.sensor_points(:,tid);
                                edge_p = obj.length(tid)*[cos((tid-1)*obj.pitch-pi);sin((tid-1)*obj.pitch-pi);0];%端点
                                if Length(tid+2) > Length(tid) % 左回りで避ける
                                    %tid = obj.width_check(tid,-1);
                                    [~,~,tmp1,tmp2] = obj.conection(0,0,edge_p(1),edge_p(2),obj.margin_conect);  
    %                                 [~,~,tmp1,tmp2] = obj.conection(obj.state.p(1),obj.state.p(2),edge_p(1),edge_p(2),obj.margin_conect);  
                                    obj.result.state.p = [tmp1;tmp2;0];
                                    obj.result.state.v = obj.velocity_vector([0;0;0],edge_p,obj.result.state.p);
                                else % 右回り
                                    %tid = obj.width_check(tid,1);
                                    [tmp1,tmp2,~,~] = obj.conection(0,0,edge_p(1),edge_p(2),obj.margin_conect);
    %                                 [tmp1,tmp2,~,~] = obj.conection(obj.state.p(1),obj.state.p(2),edge_p(1),edge_p(2),obj.margin_conect); 
                                    obj.result.state.p = [tmp1;tmp2;0];
                                    obj.result.state.v = -obj.velocity_vector([0;0;0],edge_p,obj.result.state.p);
                                end
                                obj.tid = tid;
                                obj.local_tp = edge_p;
    
                                % local から global に変換
                                obj.result.state.p = [R*obj.result.state.p+obj.state.p;0];
                    %             obj.result.state.p = [R*obj.result.state.p;0];
                                obj.result.state.v = R*obj.result.state.v;
                                result = obj.result;   
                            else    
                                obj.result.state.p = obj.past.state.p; % local座標での位置
                                obj.result.state.v = obj.past.state.v;
                                result = obj.result; 
                            end
                        end
                           
     
                    else % まっすぐゴールに行ける場合
                        obj.result.state.p = l_goal; % local座標での位置
                        obj.result.state.v = [0;0;0]; % local座標での位置
                        % local から global に変換
                        obj.result.state.p = [R*obj.result.state.p+obj.state.p;0];
            %             obj.result.state.p = [R*obj.result.state.p;0];
                        obj.result.state.v = R*obj.result.state.v;
                        result = obj.result;   
                    end          
            end
        end   
        
            
        function path = make_path(~,theta,margin,range,radius,goal_angle,goal)%検出範囲の作成
            %theta: センサの分解能
            %margin: ドローンの横幅
            %range: 角度？
            %goal_angle: ゴールまでの角度
            %goal: ゴールまでの距離
            path = zeros(size(range));
            tmp =find((radius*sin(theta) >= margin).*(theta <= pi/2));%2~16列目のインデックスを算出
            path(tmp) = margin./sin(theta(tmp));
            path(1:find(path,1)-1) = radius;
            margin =margin;

            tmp = find((radius*sin(theta) <= -margin).*(theta >= 3*pi/2));%49~63列目のインデックスを算出
            path(tmp) = -margin./sin(theta(tmp));
            path(find(path,1,'last')+1:end) = radius;
            margin =margin;
            [~,id] = min(abs(range - goal_angle));
            path = circshift(path,id-1);
            path(path>goal) = goal;        
        end

        function tid = ancher_detection(~,length,threshold,l_points,pitch,id,goal,sensor_points) %端点を検出する
            nlength = circshift(length,1); %１つずらした距離データ
            edge_ids = find(abs(nlength-length) > threshold); %隣との距離の差が大きいところのindex配列（端点）
            edge_points = l_points(:,edge_ids);%2Dだとエラー吐く
            %これより下をいじる必要あり？
            tmp = length(edge_ids) > nlength(edge_ids);%障害物→壁の場合の配列
            edge_ids(tmp) = edge_ids(tmp) - 1;%壁が配列なので-1して障害物にする
            edge_ids(edge_ids==0) = length(end);%0配列は63にする     
            te_angle = pitch*abs(edge_ids - id); % angle between target-edge
%             [~,tmp] = min(obj.length(edge_ids).*(obj.length(edge_ids)-goal_length*cos(te_angle))); % target id
%             [~,tmp] = min((length(edge_ids)-goal_length*cos(te_angle)));%最終目標までの距離が短い方の配列番号を決定
            reference_goal = goal - sensor_points(:,edge_ids);
            reference_goal = vecnorm(reference_goal);
            [~,tmp] = min(length(edge_ids)+reference_goal);
            tid = edge_ids(tmp);%最短経路の配列
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
        
        function d = distance2(~,Q_1,Q_2,P)
            % Q_1自己位置
            % Q_2目標位置
            % P 円の中心
            d = abs(det([Q_2(1:2) - Q_1(1:2);P(1:2) - Q_1(1:2)])/norm(Q_2 - Q_1));
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
            A_x = real(((a*D - b*sqrt((a^2 + b^2)*r^2 - D^2))/(a^2 + b^2)) + X);
            A_y = real(((b*D + a*sqrt((a^2 + b^2)*r^2 - D^2))/(a^2 + b^2)) + Y);
            B_x = real(((a*D + b*sqrt((a^2 + b^2)*r^2 - D^2))/(a^2 + b^2)) + X);
            B_y = real(((b*D - a*sqrt((a^2 + b^2)*r^2 - D^2))/(a^2 + b^2)) + Y);
%             contact = [A_x,A_y,B_x,B_y];            
        end
        
        function v = velocity_vector(obj,x,y,P)
            % x:ドローンの現在位置
            % y:障害物点の座標
            % P:疑似目標位置
            T = y - x;
            P_r = P - x;
            N = P_r - T;
            t = cross(N,obj.e_z);
            o = (obj.v_max/obj.margin_conect);
            v = t*o;
            
        end
%         function id = width_check(obj,tid,sign)
%             obj.tid
%         end

%%
        function fh = show(obj,opt)
            %"logger",opt.logger,"FH",opt.FH,"t",opt.t,"param",param
            arguments
                obj
                opt.logger = [];
                opt.FH = 1;
                opt.t = [];
                opt.param = [];
            end
            env = opt.param;
            yaw = obj.state.q(3);
            R = [cos(yaw),-sin(yaw);sin(yaw),cos(yaw)];
            angles= (0:0.01:2*pi)';
            circ = obj.margin*[cos(angles),sin(angles)];
            fh = figure(opt.FH);
            hold on
            if isempty(env)
                %obj.self.sensor.lrf.show();
                hold on
                local_rp =R'*obj.result.state.p(1:2)-obj.state.p(1:2);
                local_tp = obj.local_tp;
                angle= 0:0.1:2*pi;
                wp = obj.waypoint;
                plot(local_rp(1),local_rp(2),'ro');
                plot(local_tp(1)+circ(:,1),local_tp(2)+circ(:,2));
                plot(obj.goal(1)-obj.state.p(1),obj.goal(2)-obj.state.p(2),"ys");
            else
                plot(polyshape(env.param.Vertices),'FaceColor','g');
                hold on
                tmp = (R*(obj.self.sensor.result.sensor_points'))';
                points(1:2:2*size(tmp,1),:)=tmp;
                points = points + obj.state.p(1:2)';
                plot(points(:,1),points(:,2),'r-');
                hold on; 
                text(points(1,1),points(1,2),'1','Color','b','FontSize',10);%センサインデックスの1を表示
                %plot(obj.self.sensor.result.region);
                %plot(obj.head_dir);
                plot(obj.state.p(1),obj.state.p(2),'b*');
                plot(obj.result.state.p(1),obj.result.state.p(2),'bo');%referenceの表示
                local_tp = R*obj.local_tp(1:2);
%                 plot(obj.state.p(1)+local_tp(1)+circ(:,1),obj.state.p(2)+local_tp(2)+circ(:,2));%接点を生成するための円
                plot(obj.goal(1),obj.goal(2),"ks","MarkerFaceColor",[0.5,0.5,0.5]);
                axis equal;
                writeAnimation('drone.gif')
            end

        end
    end
end
