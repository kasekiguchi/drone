classdef THREED_TANBUG < REFERENCE_CLASS
    % 時間関数としてのリファレンスを生成するクラス
    % 接点を通過点として障害物回避するプログラム
    % obj = THRD_TANBUG_REFERENCE()
   
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
        e_y %y方向のベクトル
        e_z %z方向のベクトル
        v_max %速度ベクトルの上限
        dtheta %目標角度とセンサが見ている角度の差

        v_layer
        
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
        path0
        gpath
        Gpath
        path_generator 

        g
        G
        v
        count
        l_goal
    end

    methods
        function obj = THREED_TANBUG(self, varargin)
            %obj.state = [0,0,0];

%            obj.pitch = self.sensor.lrf.pitch;
            tmp = self.sensor.lidar.phi_range;%3D
            obj.pitch = tmp(2)-tmp(1);%3D
            obj.sensor = [0,0];        

            obj.state_initial = [0,0,0]';
            obj.goal = [5,3,0]';%[5,0,0]';%2Dgoal
%            obj.goal = [0,15,0]';% global goal position

            obj.obstacle = [0,0,0]';% 障害物座標
%            obj.radius = self.sensor.lrf.radius;
            obj.radius = self.sensor.lidar.radius;%3D
            obj.margin = 0.5;
            obj.margin_conect = 0.4;
            obj.threshold = 1.5;
            obj.d = 0;
            obj.waypoint.under = [0,0,0]';
            obj.waypoint.top = [0,0,0]';
            obj.angle = 0;
            obj.result.state.p = [0;0;0];

            obj.v_layer = 32; %3DLiDARの層
                       
            obj.self=self;
            obj.e_y = [0,1,0]';
            obj.e_z = [0,0,1]';
            obj.v_max = 0.3;

            obj.g %TangentBugで算出した目標位置
            obj.G %最終目標位置
            obj.v 
            obj.count = 0;
            obj.l_goal
            
%             obj.result.state = STATE_CLASS(struct('state_list', ["xd","p","q"], 'num_list', [20, 3, 3]));     
%             obj.result.state = STATE_CLASS(struct('state_list', ["p","v"], 'num_list', [3,3]));
            obj.result.state = STATE_CLASS(struct('state_list', ["p","v"], 'num_list', [3,3]));
%             obj.result.state = STATE_CLASS(struct('state_list', ["p"], 'num_list', [3]));
            obj.result.state.p = [0;0;0];
%            obj.path_goal = zeros(size(self.sensor.lrf.angle_range));
            obj.path_goal = zeros(size(self.sensor.lidar.phi_range));%3D
            as = 0:obj.pitch:2*pi; %センサの分解能(ラジアン)（行列）

            %radius = ...;
            radius = self.sensor.lidar.radius;
            hx= radius;
            hy = 0.15;%3D_enviroment_hv3(v)
            hz= 0.15;%3D_enviroment_hv3(v)

%             hy = 0.15;%3D_Simple(v)
%             hz= 0.15;%3D_Simple(v)
%             hy = 0.2;%3D_Simple_reverce(v)
%             hz= 0.2;%3D_Simple_reverce(v)
            P = [-0.05,hy,hz;-0.05,-hy,hz;-0.05,-hy,-hz;-0.05,hy,-hz;
                  hx,hy,hz;hx,-hy,hz;hx,-hy,-hz;hx,hy,-hz];
            T= [1,3,2;1,4,3;1,5,8;1,8,4;1,2,6;1,6,5;2,7,6;2,3,7;3,8,7;3,4,8;5,6,7;5,7,8];
            T(:,2:3) = T(:,[3,2]);
            env = triangulation(T,P);
            tmpstate= STATE_CLASS(struct('state_list',["p","q"],'num_list',[3,3]));
            tmpstate.set_state("p",[0;0;0],"q",[0;0;0]);
            tmpparam= struct('env', env, 'theta_range', self.sensor.lidar.theta_range, 'phi_range', self.sensor.lidar.phi_range, 'radius', radius);
            tmplidar = LiDAR3D_SIM(struct('plant',struct('state',tmpstate)),tmpparam);
            obj.path0 = tmplidar.do([]);
            obj.path_generator = tmplidar;
            obj.gpath.length= radius*ones(size(obj.path0.length));
        end
  
%          function gen_path()

        function result = do(obj, t)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            % 
            p = obj.self.estimator.result.state.p;
            v = obj.self.estimator.result.state.v;
            R = obj.self.estimator.result.state.getq('rotmat');
            obj.sensor = obj.self.sensor.result; %センサ情報
            obj.length = obj.sensor.length; % 距離データ
            l_points = obj.sensor.sensor_points; %座標データ
            obj.l_goal = R'*(obj.goal-p); % local でのゴール位置
            goal_length = vecnorm(obj.l_goal); % ゴールまでの距離
            l_goal_angle = atan2(obj.l_goal(2),obj.l_goal(1)); %ゴールまでの角度
            [~,id]=min(abs(obj.self.sensor.lidar.phi_range - l_goal_angle)); % goal に一番近い角度であるレーザーインデックス(3D)

%             % 32x63 に整形
            change_length = reshape(obj.length,obj.v_layer,numel(obj.length)/obj.v_layer); %計算しやすいようにセンサの距離データを並び替え
%             % G-path 設定
            obj.Gpath = obj.gen_path(p,R,obj.goal);%検出範囲の向き変更
%             % Main algorithm
            if (find(obj.length < obj.Gpath.length,1)) % Gpath内に点群がある場合
              if(find(obj.length < obj.gpath.length,1)) % gpath 内に点群がある場合
                [obj.g,obj.v] = obj.T_bug(obj,change_length,l_points,goal_length,id);
              else% gpath内に点群がない場合
                obj.count = obj.check_reach_to_g(p,obj.g,obj.count);
                if (obj.count > 20) % 到達した場合
                    [obj.g,obj.v] = obj.T_bug(obj,change_length,l_points,goal_length,id);
                end 
                obj.g = obj.g;
              end
              obj.v = obj.v;
              obj.gpath = obj.gen_path(p,R,obj.g);
            else % Gpath内に点群がない場合
              % G へ向かう
              obj.g = obj.l_goal; 
              obj.v = [0;0;0];
              obj.gpath = obj.gen_path(p,R,obj.g);
            end     
            obj.result.state.p =  R * obj.g + p;
            obj.result.state.v = obj.v;
            result = obj.result;   
        end   

%         function path = make_path(~,theta,margin,range,radius,goal_angle,goal)%検出範囲の作成
%             %theta: センサの分解能
%             %margin: ドローンの横幅（検出範囲の横の長さ）
%             %range: センサのレンジ
%             %goal_angle: ゴールまでの角度
%             %goal: ゴールまでの距離
%             path = zeros(size(range));
%             tmp =find((radius*sin(theta) >= margin).*(theta <= pi/2));%2~16列目のインデックスを算出
%             path(tmp) = margin./sin(theta(tmp));
%             path(1:find(path,1)-1) = radius;
%             margin =margin;
% 
%             tmp = find((radius*sin(theta) <= -margin).*(theta >= 3*pi/2));%49~63列目のインデックスを算出
%             path(tmp) = -margin./sin(theta(tmp));
%             path(find(path,1,'last')+1:end) = radius;
%             margin =margin;
%             [~,id] = min(abs(range - goal_angle));
%             path = circshift(path,id-1);
%             path(path>goal) = goal;        
%         end


        function [tid,edge_ids] = ancher_detection(~,length,nlength,threshold,l_points,pitch,id,goal,goal_length,th,zero_change) %端点を検出する
            edge_ids = find(abs(nlength-length) > threshold); %隣との距離の差が大きいところのindex配列（端点）
            edge_points = l_points(:,edge_ids);
            %これより下をいじる必要あり？
            tmp = length(edge_ids) > nlength(edge_ids);%障害物→壁の場合の配列  /壁→障害物
            edge_ids(tmp) = edge_ids(tmp) - th;%壁が配列なので-32or-1して障害物にする
            edge_ids(edge_ids==0) = numel(length);%0配列は63or32にする%%%%%%%%%%%%
            edge_ids(edge_ids<0) = edge_ids(edge_ids<0)+numel(length);%%%%%%%%%%
            te_angle = pitch*abs(edge_ids - id); % angle between target-edge
            [~,tmp] = min(length(edge_ids).*(length(edge_ids)-goal_length*cos(te_angle))); % target id
%             [~,tmp] = min((length(edge_ids)-goal_length*cos(te_angle)));%最終目標までの距離が短い方の配列番号を決定
%             reference_goal = goal - l_points(:,edge_ids);
%             reference_goal = vecnorm(reference_goal);%端点の候補→referenceの距離
%             [~,tmp] = min(length(edge_ids)+reference_goal');%自己位置→端点の候補→referenceの距離が小さい配列
            tid = edge_ids(tmp);%最短経路の配列
        end

        function [tid,edge_p,route] = ancher_determine(~,v,h,goal,l_points,length,pitch) %左右の端点とz方向の端点を比較し経路とする端点を決定する(z方向の重みを考慮する可能性あり)
            % v:縦方向の端点の配列番号
            % h:横方向の端点の配列番号
            % goal:最終目標位置の座標
            % l_points:LiDARの座標データ
            % length:LiDARの距離データ
            edge_ids = [v,h];
            reference_goal = goal - l_points(:,edge_ids);
            reference_goal = vecnorm(reference_goal);
            [~,tmp] = min(length([v,h])+reference_goal);
            tid = edge_ids(tmp);%最短経路の配列
%             edge_p = length(tid)*[cos((tid-1)*pitch-pi);sin((tid-1)*pitch-pi);l_points()];
            edge_p = l_points(:,tid);%最短経路の端点座標
            if tmp == 1%左右の移動か上下の移動かを決めるための変数
                route = v;
            else
                route = h;
            end
        end
%         
        function path = gen_path(obj,p,R,r) %検出範囲の向きを変える     
           % p, R : 機体位置(3x1)姿勢(3x3)
           % r : 目標位置(慣性座標系：3x1)グローバル系？
           rp = R'*(r-p); % ボディ座標系で見たrの位置
           % rp を極座標表示 r=1, theta, phi
           Rphi = Rodrigues([0;0;1],atan2(rp(2),rp(1))); % phi に関する回転行列
           Rtheta= Rodrigues([0;1;0],-atan2(rp(3),vecnorm(rp(1:2))));% thetaに関する回転行列
           % Rtheta*Rphi*[1;0;0] がrpの向き        
           obj.path_generator.self.plant.state.set_state("q", Rtheta'*Rphi');
           path = obj.path_generator.do([]);
%            obj.path_generator.show("FH",figure());
         end

         function [g,v] = T_bug(~,obj,length,l_points,goal_length,id)
            %length:センサの距離データ
            %l_points:センサの座標データ
            %goal_length:goalと自己位置の距離
            %id:l_goal_angleに一番近いセンサのインデックス
            h_th = obj.v_layer;
            v_th = 1;
            [v,h] = size(length);
            hlength = circshift(length,[0 1]); %右に１つずらした距離データ
            [h_tid,edge_ids] = obj.ancher_detection(length,hlength,obj.threshold,l_points,obj.pitch,id,obj.l_goal,goal_length,h_th,h); %左右方向の端点検出
            vlength = circshift(length,[1 0]);%上に1つずらした距離データ
            [v_tid,~] = obj.ancher_detection(length,vlength,obj.threshold,l_points,obj.pitch,id,obj.l_goal,goal_length,v_th,v); %上下方向の端点検出
            
            Length = [length(:,end),length,length(:,1)];
            [tid,edge_p,route] = ancher_determine(obj,v_tid,h_tid,obj.l_goal,l_points,length,obj.pitch); %経路とする端点を決定

            if route == v_tid %上下方向の端点の場合
                if Length(tid+2) > Length(tid) %下を潜り抜ける場合

                    anchor_ids = find(abs(edge_p(2) - l_points(2,edge_ids))<obj.margin/2,1);
                    anchor_ids = edge_ids(anchor_ids);
                    [~,~,tmp1,tmp2] = obj.conection(obj.state_initial(1),obj.state_initial(3),edge_p(1),edge_p(3),obj.margin_conect);%x-zで端点を中心とする接点作成
%                     if isempty(anchor_ids)
%                         g = [tmp1;edge_p(2);tmp2];%ローカル
%                         g = [edge_p(1);edge_p(2);edge_p(3)+obj.margin];
%                     elseif edge_p(2) > l_points(2,anchor_ids)
%                         g = [tmp1;l_points(2,anchor_ids)+obj.margin_conect;edge_p(3)-obj.margin_conect];
%                     else
%                         g = [tmp1;l_points(2,anchor_ids)-obj.margin_conect;edge_p(3)-obj.margin_conect];
%                     end

                    [tmp1,tmp2,~,~] = obj.conection(obj.state_initial(1),obj.state_initial(3),edge_p(1),edge_p(3),obj.margin_conect);%x-zで端点を中心とする接点作成
                    g = [tmp1;edge_p(2);tmp2];%ローカル
                    v = obj.velocity_vector(obj.state_initial,edge_p,g,obj.e_y);%ローカル
                else %上を通る場合

                    anchor_ids = find(abs(edge_p(2) - l_points(2,edge_ids))<obj.margin/2,1);
                    anchor_ids = edge_ids(anchor_ids);
                    [~,~,tmp1,tmp2] = obj.conection(obj.state_initial(1),obj.state_initial(3),edge_p(1),edge_p(3),obj.margin_conect);%x-zで端点を中心とする接点作成
%                     if isempty(anchor_ids)
%                         g = [tmp1;edge_p(2);tmp2];%ローカル
% %                         g = [edge_p(1);edge_p(2);edge_p(3)+obj.margin];
%                     elseif edge_p(2) > l_points(2,anchor_ids)
%                         g = [tmp1;l_points(2,anchor_ids)+obj.margin_conect;edge_p(3)+obj.margin_conect];
%                     else
%                         g = [tmp1;l_points(2,anchor_ids)-obj.margin_conect;edge_p(3)+obj.margin_conect];
%                     end
%                     

                    [~,~,tmp1,tmp2] = obj.conection(obj.state_initial(1),obj.state_initial(3),edge_p(1),edge_p(3),obj.margin_conect);%x-zで端点を中心とする接点作成
                    g = [tmp1;edge_p(2);tmp2];%ローカル
                    v = -obj.velocity_vector(obj.state_initial,edge_p,g,obj.e_y);%ローカル
                end
            else %左右方向の端点の場合
                if Length(tid+obj.v_layer*2) > Length(tid) % 左回りで避ける
                    %tid = obj.width_check(tid,-1);
                    [~,~,tmp1,tmp2] = obj.conection(obj.state_initial(1),obj.state_initial(2),edge_p(1),edge_p(2),obj.margin_conect);%x-yで端点を中心とする接点作成
                    g = [tmp1;tmp2;edge_p(3)];%ローカル
                    v = obj.velocity_vector(obj.state_initial,edge_p,g,obj.e_z);%ローカル
                else % 右回り
                    %tid = obj.width_check(tid,1);
                    [tmp1,tmp2,~,~] = obj.conection(obj.state_initial(1),obj.state_initial(2),edge_p(1),edge_p(2),obj.margin_conect);%x-yで端点を中心とする接点作成
                    g = [tmp1;tmp2;edge_p(3)];%ローカル
                    v = -obj.velocity_vector(obj.state_initial,edge_p,g,obj.e_z);%ローカル
                end
            end
         end

         function count = check_reach_to_g(~,p,g,count)
            r = 0.3;
            p_glength = p - g;
            p_glength = vecnorm(p_glength);
            if r > p_glength
                count = count+1;
            else
                count = 0;
            end
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
        
        function v = velocity_vector(obj,x,y,P,e)
            % x:ドローンの現在位置
            % y:障害物点の座標
            % P:疑似目標位置
            T = y - x;
            P_r = P - x;
            N = P_r - T;
            t = cross(N,e);
            o = (obj.v_max/obj.margin_conect);
            v = t*o;          
        end

%             obj.state = obj.self.estimator.result.state; %自己位置
%             obj.past.state.p = obj.result.state.p(1:3); %一時刻前の目標位置
%             obj.past.state.v = obj.result.state.v; %一時刻前の速さ 
% %             obj.past.state.q = obj.result.state.q; %一時刻前の姿勢角
%             yaw = obj.state.q(3);
%             as = 0:obj.pitch:2*pi;
%             R = [cos(yaw),-sin(yaw),0;sin(yaw),cos(yaw),0;0,0,1];
%             obj.sensor = obj.self.sensor.result; %センサ情報
%             obj.length = obj.sensor.length; % 距離データ
%             obj.l_points = obj.sensor.sensor_points; %座標データ
%             obj.length = reshape(obj.length,obj.v_layer,numel(obj.length)/obj.v_layer); %計算しやすいようにセンサの距離データを並び替え
%             l_goal = R'*(obj.goal-obj.state.p); % local でのゴール位置        
%             goal_length = vecnorm(l_goal); % ゴールまでの距離
%             l_goal_angle = atan2(l_goal(2),l_goal(1)); %ゴールまでの角度
%             l_reference = R'*(obj.past.state.p - obj.state.p); %localでの一時刻前のreference位置
%             reference_length = vecnorm(l_reference); %referenceまでの距離
%             l_reference_angle =atan2(l_reference(2),l_reference(1)); %referenceまでの角度
% %            [~,id]=min(abs(obj.sensor.angle - l_goal_angle)); % goal に一番近い角度であるレーザーインデックス
%            [~,id]=min(abs(obj.self.sensor.lidar.phi_range - l_goal_angle)); % goal に一番近い角度であるレーザーインデックス(3D)
% %            [~,reference_id]=min(abs(obj.self.sensor.lidar.phi_range - l_reference_angle));% reference に一番近い角度であるレーザーインデックス(3D)
% 
%             path_goal = obj.make_path(as,obj.margin,obj.self.sensor.lidar.phi_range,obj.radius,l_goal_angle,goal_length);%ゴールとの間に経路生成
%             path_reference = obj.make_path(as,obj.margin,obj.self.sensor.lidar.phi_range,obj.radius,l_reference_angle,reference_length);%referenceとの間に経路生成

%             if find(path_reference)%1時刻目以降はこっち
%                 N = 2;
%             else%1時刻目はこっち
%                 N = 1;
%             end
% 
%             switch N
%                 case 1
%                     if find(obj.length < path_goal) % ゴールまでの間に障害物がある場合
%                         hlength = circshift(obj.length,[0 1]); %右に１つずらした距離データ
%                         h_tid = obj.ancher_detection(obj.length,hlength,obj.threshold,obj.l_points,obj.pitch,id,obj.goal,goal_length); %左右方向の端点検出
%                         vlength = circshift(obj.length,[1 0]);%上に1つずらした距離データ
%                         v_tid = obj.ancher_detection(obj.length,vlength,obj.threshold,obj.l_points,obj.pitch,id,obj.goal,goal_length); %上下方向の端点検出
% 
%                         Length = [obj.length(:,end),obj.length,obj.length(:,1)];
%                         [tid,edge_p,route] = ancher_determine(obj,v_tid,h_tid,obj.goal,obj.l_points,obj.length,obj.pitch); %経路とする端点を決定
%                         %tid:端点の配列
%                         %edge_p:端点の座標
%                         %route:上下方向か左右方向かを識別するための変数
%                         
% %                         edge_p = obj.length(tid)*[cos((tid-1)*obj.pitch-pi);sin((tid-1)*obj.pitch-pi);0];%端点
% %                         edge_p = obj.sensor.sensor_points(:,tid);
% 
%                         
%                         if route == v_tid %上下方向の端点の場合
%                             if Length(tid+2) > Length(tid) %下を潜り抜ける場合
%                                 [tmp1,tmp2,~,~] = obj.conection(obj.state_initial(1),obj.state_initial(3),edge_p(1),edge_p(3),obj.margin_conect);%x-zで端点を中心とする接点作成
%                                 obj.result.state.p = [tmp1;edge_p(2);tmp2];%ローカル
%                                 obj.result.state.v = -obj.velocity_vector([0;0;0],edge_p,obj.result.state.p);%ローカル
%                             else %上を通る場合
%                                 [~,~,tmp1,tmp2] = obj.conection(obj.state_initial(1),obj.state_initial(3),edge_p(1),edge_p(3),obj.margin_conect);%x-zで端点を中心とする接点作成
%                                 obj.result.state.p = [tmp1;edge_p(2);tmp2];%ローカル
%                                 obj.result.state.v = obj.velocity_vector([0;0;0],edge_p,obj.result.state.p);%ローカル
%                             end
%                         else %左右方向の端点の場合
%                             if Length(tid+obj.v_layer*2) > Length(tid) % 左回りで避ける
%                                 %tid = obj.width_check(tid,-1);
%                                 [~,~,tmp1,tmp2] = obj.conection(obj.state_initial(1),obj.state_initial(2),edge_p(1),edge_p(2),obj.margin_conect);%x-yで端点を中心とする接点作成
%                                 obj.result.state.p = [tmp1;tmp2;edge_p(3)];%ローカル
%                                 obj.result.state.v = obj.velocity_vector([0;0;0],edge_p,obj.result.state.p);%ローカル
%                             else % 右回り
%                                 %tid = obj.width_check(tid,1);
%                                 [tmp1,tmp2,~,~] = obj.conection(obj.state_initial(1),obj.state_initial(2),edge_p(1),edge_p(2),obj.margin_conect);%x-yで端点を中心とする接点作成
%                                 obj.result.state.p = [tmp1;tmp2;edge_p(3)];%ローカル
%                                 obj.result.state.v = -obj.velocity_vector(obj.state_initial,edge_p,obj.result.state.p);%ローカル
%                             end
%                         end
%                         
%                         obj.tid = tid;
%                         obj.local_tp = edge_p;
%                         % local から global に変換
%                         obj.result.state.p = [R*obj.result.state.p+obj.state.p;0];
%                         obj.result.state.v = R*obj.result.state.v;
%                         result = obj.result;   
%  
%                     else % まっすぐゴールに行ける場合
%                         obj.result.state.p = l_goal; % local座標での位置
%                         obj.result.state.v = obj.state_initial; % local座標での位置
%                         % local から global に変換
%                         obj.result.state.p = [R*obj.result.state.p+obj.state.p;0];
%             %             obj.result.state.p = [R*obj.result.state.p;0];
%                         obj.result.state.v = R*obj.result.state.v;
%                         result = obj.result;   
%                     end     
% 
%                 %2時刻目以降
%                 case 2
% %                     obj.past.state.q(3) = obj.result.state.q(3);
%                     if find(obj.length < path_goal) % ゴールまでの間に障害物がある場合
%                         if find(obj.length < path_reference) %referenceまでの間に障害物がある場合                              
%                             hlength = circshift(obj.length,[0 1]); %横に１つずらした距離データ
%                             h_tid = obj.ancher_detection(obj.length,hlength,obj.threshold,obj.l_points,obj.pitch,id,obj.goal,goal_length);%左右方向の端点検出
%                             vlength = circshift(obj.length,[1 0]);%縦に1つずらした距離データ
%                             v_tid = obj.ancher_detection(obj.length,vlength,obj.threshold,obj.l_points,obj.pitch,id,obj.goal,goal_length);%上下方向の端点検出
% 
%                             Length = [obj.length(:,end),obj.length,obj.length(:,1)];
%                             [tid,edge_p,route] = ancher_determine(obj,v_tid,h_tid,obj.goal,obj.l_points,obj.length,obj.pitch);%経路とする端点を決定                 
% 
%                             if route == v_tid
%                                 if Length(tid+2) > Length(tid) %下を潜り抜ける場合
%                                     [tmp1,tmp2,~,~] = obj.conection(obj.state_initial(1),obj.state_initial(3),edge_p(1),edge_p(3),obj.margin_conect);%x-zで端点を中心とする接点作成
%                                     obj.result.state.p = [tmp1;edge_p(2);tmp2];%ローカル
%                                     obj.result.state.v = -obj.velocity_vector([0;0;0],edge_p,obj.result.state.p);%ローカル
%                                 else %上を通る場合
%                                     [~,~,tmp1,tmp2] = obj.conection(obj.state_initial(1),obj.state_initial(3),edge_p(1),edge_p(3),obj.margin_conect);%x-zで端点を中心とする接点作成
%                                     obj.result.state.p = [tmp1;edge_p(2);tmp2];%ローカル
%                                     obj.result.state.v = obj.velocity_vector([0;0;0],edge_p,obj.result.state.p);%ローカル
%                                 end
%                             else
%                                 if Length(tid+obj.v_layer*2) > Length(tid) % 左回りで避ける
%                                     %tid = obj.width_check(tid,-1);
%                                     [~,~,tmp1,tmp2] = obj.conection(obj.state_initial(1),obj.state_initial(2),edge_p(1),edge_p(2),obj.margin_conect);%x-yで端点を中心とする接点作成
%                                     obj.result.state.p = [tmp1;tmp2;edge_p(3)];%ローカル
%                                     obj.result.state.v = obj.velocity_vector([0;0;0],edge_p,obj.result.state.p);%ローカル
%                                 else % 右回り
%                                     %tid = obj.width_check(tid,1);
%                                     [tmp1,tmp2,~,~] = obj.conection(obj.state_initial(1),obj.state_initial(2),edge_p(1),edge_p(2),obj.margin_conect);%x-yで端点を中心とする接点作成
%                                     obj.result.state.p = [tmp1;tmp2;edge_p(3)];%ローカル
%                                     obj.result.state.v = -obj.velocity_vector(obj.state_initial,edge_p,obj.result.state.p);%ローカル
%                                 end
%                             end
%                             obj.tid = tid;
%                             obj.local_tp = edge_p;
% 
%                             % local から global に変換
%                             obj.result.state.p = [R*obj.result.state.p+obj.state.p;0];
%                 %             obj.result.state.p = [R*obj.result.state.p;0];
%                             obj.result.state.v = R*obj.result.state.v;
%                             result = obj.result;   
%                            
%                         else %referenceまではいけるので行きます                        
%                             obj.result.state.p = obj.past.state.p; 
%                             obj.result.state.v = obj.past.state.v;
%                             result = obj.result; 
%                        end                         
%      
%                     else % まっすぐゴールに行ける場合
%                         obj.result.state.p = l_goal; % local座標での位置
%                         obj.result.state.v = obj.state_initial; % local座標での位置
% %                         yaw = atan2(obj.result.state.p(2),obj.result.state.p(1));
% %                         obj.result.state.q(3) = yaw;
%                         % local から global に変換
%                         obj.result.state.p = [R*obj.result.state.p+obj.state.p;0];
%             %             obj.result.state.p = [R*obj.result.state.p;0];
%                         obj.result.state.v = R*obj.result.state.v;
%                         result = obj.result;   
%                     end          
%             end
        
        
            
        
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
