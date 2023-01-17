classdef DRAW_BIRD_MOTION
    % フレーム付きで動画を作成するためのクラス
    % obj = DRAW_DRONE_MOTION(logger,param)
    % obj.draw(p,q,u) : １スナップを描画
    % obj.animation(logger,param) : 動画描画
    % TODO : methodなど一般化して抽象化したほうが良いか？

    properties
        frame
        frame_bird
        thrust
        thrust_bird
        fig
    end

    methods
        function obj = DRAW_BIRD_MOTION(logger,logger_bird,param)
            % 【usage】 obj = DRAW_DRONE_MOTION(logger,param)
            % logger : LOGGER class instance
            % param.frame_size : drone size [Lx,Ly]
            % param.rotor_r : rotor radius r
            % param.plot_ref : reference plot true or not
            arguments
                logger
                logger_bird
                param.frame_size
                param.rotor_r
                param.plot_ref = true;
                param.animation = false;
                param.drone = 1;
                param.bird = 1;
                param.gif = 0;
                param.Motive_ref = 0;
                param.fig_num = 1;
                param.mp4 = 0;
            end
            data_drone = logger.data(param.drone,"p","e");
            data_bird = logger_bird.data(param.bird,"p","e");
            droneM = max(data_drone);
            dronem = min(data_drone);
            birdM = max(data_bird);
            birdm = min(data_bird);
            tM = [droneM,birdM];
            tm = [dronem,birdm];
            M = [max(tM(1:3:end)),max(tM(2:3:end)),max(tM(3:3:end))];
            m = [min(tm(1:3:end)),min(tm(2:3:end)),min(tm(3:3:end))];
            L = param.frame_size;
            figure();
            ax = axes('XLim',[m(1)-L(1) M(1)+L(1)],'YLim',[m(2)-L(2) M(2)+L(2)],'ZLim',[0 M(3)+1]);
            xlabel(ax,"x [m]");
            ylabel(ax,"y [m]");
            zlabel(ax,"z [m]");
            obj.fig = figure(param.fig_num);

            view(5,40)
            grid on
            daspect([1 1 1]);
            hold on

            % rotor setup
            r = param.rotor_r;
            [xr,yr,zr] = cylinder([0 r]); % rotor
            zr = 0.001*zr;

            % body setup
            [xb,yb,zb] = ellipsoid(0,0,0, 1.2*L(1)/4, 0.8*L(2)/4, 0.02);
            d = L/2; % 重心からローター１の位置ベクトル
            r = 0.3; % ロータ―間半径
            rp = [d(1),d(2),0.02;-d(1),d(2),0.02;d(1),-d(2),0.02;-d(1),-d(2),0.02]; % relative rotor position
            c = ["red","green","blue","cyan",'#4DBEEE'];

            % arm setup
            [x,y,z] = cylinder(0.01);
            z = z*vecnorm(d)*2;
            R1 = rotmat(quaternion([L(2),-L(1),0]*pi/(vecnorm(L)*2),"rotvec"),'point');
            R2 = rotmat(quaternion([L(2),L(1),0]*pi/(vecnorm(L)*2),"rotvec"),'point');
            F1 = [R1*[x(1,:);y(1,:);z(1,:)];R1*[x(2,:);y(2,:);z(2,:)]]+[d(1);d(2);0;d(1);d(2);0];
            F2 = [R2*[x(1,:);y(1,:);z(1,:)];R2*[x(2,:);y(2,:);z(2,:)]]+[-d(1);d(2);0;-d(1);d(2);0];
            for n = param.drone
                for i = 4:-1:1
                    h(n,i) = surface(ax,xr+rp(i,1),yr+rp(i,2),zr+rp(i,3),'FaceColor',c(i)); % rotor 描画
                    T(n,i) = quiver3(ax,rp(i,1),rp(i,2),rp(i,3),0,0,1,'FaceColor',c(i)); % 推力ベクトル描画
                    tt(n,i) = hgtransform('Parent',ax); set(T(n,i),'Parent',tt(n,i)); % 推力を慣性座標と紐づけ
                end
                h(n,5) = surface(ax,[F1(1,:);F1(4,:);NaN(1,size(F1,2));F2(1,:);F2(4,:)], ...
                    [F1(2,:);F1(5,:);NaN(1,size(F1,2));F2(2,:);F2(5,:)], ...
                    [F1(3,:);F1(6,:);NaN(1,size(F1,2));F2(3,:);F2(6,:)],'FaceColor',c(5)); % アーム部
                h(n,6) = surface(ax,xb,yb,zb,'FaceColor',c(5)); % ボディ楕円体
                h(n,7) = trisurf([5 1 2;5 2 3; 5 3 4; 5 4 1], ...
                    [0.02;0.02;0.02;0.02;4*1.2*L(1)/8], ...
                    0.8*L(2)*[1;-1;-1;1;0]/6, ...
                    0.01*[1;1;-1;-1;0],'FaceColor',c(5)); % 前を表す四角錐

                t1(n) = hgtransform('Parent',ax); set(h(n,:),'Parent',t1(n)); % ドローンを慣性座標と紐づけ
            end
            for n = param.bird
                for i = 4:-1:1
                    h_b(n,i) = surface(ax,xr+r*rp(i,1),yr+r*rp(i,2),zr+rp(i,3),'FaceColor','r'); % rotor 描画
                    T_b(n,i) = quiver3(ax,rp(i,1),rp(i,2),rp(i,3),0,0,0,'FaceColor',c(i)); % 推力ベクトル描画
                    tt_b(n,i) = hgtransform('Parent',ax); set(T_b(n,i),'Parent',tt_b(n,i)); % 推力を慣性座標と紐づけ
                end

                t2(n) = hgtransform('Parent',ax); set(h_b(n,:),'Parent',t2(n)); % ドローンを慣性座標と紐づけ
            end
            obj.frame = t1;
            obj.frame_bird = t2;
            obj.thrust = tt;
            obj.thrust_bird = tt_b;
            if param.animation
                obj.animation(logger,logger_bird,"realtime",true,"drone",param.drone,"bird",param.bird,"gif",param.gif,"Motive_ref",param.Motive_ref,"fig_num",param.fig_num,"mp4",param.mp4);
            end
        end

        function draw(obj,frame,thrust,p,q,u)
            % obj.draw(p,q,u)
            % p : 一ベクトル
            % q = [x,y,z,th] : 回転軸[x,y,z]にth回転
            % u (optional): 入力
            arguments
                obj
                frame
                thrust
                p
                q
                u = [1;1;1;1];
            end

            % Rotation matrix
            R = makehgtform('axisrotate',q(1:3),q(4));
            % Translational matrix
            Txyz = makehgtform('translate',p);
            % Scaling matrix
            for i = 1:4
                if u(i) > 0
                    S = makehgtform('scale',[1,1,u(i)]);
                elseif u(i) < 0
                    S1 = makehgtform('xrotate',pi);
                    S = makehgtform('scale',[1,1,-u(i)])*S1;
                else
                    S = eye(4);
                    S(3,3) = 1e-5;
                end
                set(thrust(i),'Matrix',Txyz*R*S);
            end
            % Concatenate the transforms and
            % set the transform Matrix property
            set(frame,'Matrix',Txyz*R);
            drawnow
        end
        function animation(obj,logger,logger_bird,param)
            % obj.animation(logger,param)
            % logger : LOGGER class instance
            % param.realtime (optional) : t-or-f : logger.data('t')を使うか
            % param.target = 1:4 描画するドローンのインデックス
            arguments
                obj
                logger
                logger_bird
                param.realtime = false;
                param.drone = 1;
                param.bird = 1;
                param.gif = 0;
                param.Motive_ref = 0;
                param.fig_num = 1;
                param.mp4 = 0;
            end

            %p = logger.data(param.target,"p","e");
            %q = logger.data(param.target,"q","e");
            for n = 1:length(param.drone)
                agent{n} = logger.Data.agent(n);
            end
            fi = [];
            p = logger.data(param.drone,"p","p");
            q = logger.data(param.drone,"q","p");
            u = logger.data(param.drone,"input");
            r = logger.data(param.drone,"p","r");
            p = reshape(p,size(p,1),3,length(param.drone));
            q = reshape(q,size(q,1),size(q,2)/length(param.drone),length(param.drone));
            u = reshape(u,size(u,1),4,length(param.drone));
            r = reshape(r,size(r,1),3,length(param.drone));
            p_b = logger_bird.data(param.bird,"p","p");
            q_b = logger_bird.data(param.bird,"q","p");
            u_b = logger_bird.data(param.bird,"input");
            r_b = logger_bird.data(param.bird,"p","r");
            p_b = reshape(p_b,size(p_b,1),3,length(param.bird));
            q_b = reshape(q_b,size(q_b,1),size(q_b,2)/length(param.bird),length(param.bird));
            u_b = reshape(u_b,size(u_b,1),4,length(param.bird));
            r_b = reshape(r_b,size(r_b,1),3,length(param.bird));
            farm = logger_bird.Data.agent(1).reference.result{1}.farm;
            for n = 1:length(param.drone)
                switch size(q(:,:,n),2)
                    case 3
                        Q1 = quaternion(q(:,:,n),'euler','XYZ','frame');
                    case 4
                        Q1 = quaternion(q(:,:,n));
                    case 9
                        Q1 = quaternion(q(:,:,n),'rotmat','frame');
                end
                Q1 = rotvec(Q1);
                tmp = vecnorm(Q1,2,2);
                Q(:,:,n) = zeros(size(Q1,1),4);
                Q(tmp==0,:,n) = 0;
                Q(tmp==0,1,n) = 1;
                Q(tmp~=0,:,n) = [Q1(tmp~=0,:)./tmp(tmp~=0),tmp(tmp~=0)];
            end
            for m = 1:length(param.bird)
                switch size(q_b(:,:,m),2)
                    case 3
                        Q2 = quaternion(q_b(:,:,m),'euler','XYZ','frame');
                    case 4
                        Q2 = quaternion(q_b(:,:,m));
                    case 9
                        Q2 = quaternion(q_b(:,:,m),'rotmat','frame');
                end
                Q2 = rotvec(Q2);
                tmp = vecnorm(Q2,2,2);
                Q_b(:,:,m) = zeros(size(Q2,1),4);
                Q_b(tmp==0,:,m) = 0;
                Q_b(tmp==0,1,m) = 1;
                Q_b(tmp~=0,:,m) = [Q2(tmp~=0,:)./tmp(tmp~=0),tmp(tmp~=0)];
            end

            if param.gif
                sizen = 256;
                delaytime = 0;
                filename = strrep(strrep(strcat('Data/Movie(',datestr(datetime('now')),').gif'),':','_'),' ','_');
            end

            if param.mp4
                sizen = 256;
                delaytime = 0;
                filename = strrep(strrep(strcat('Data/Movie(',datestr(datetime('now')),').mp4'),':','_'),' ','_');
                v = VideoWriter(filename,"MPEG-4");
                if param.mp4
                    v.Quality = 100;
                    v.FrameRate = 40; % dtの逆数
                    open(v);
                    writeAnimation(v);
                end
            end

            t = logger.data("t");
            tRealtime = tic;
            if param.Motive_ref
                for n = 1:length(param.drone)
                    f(n) = animatedline('Color','k','MaximumNumPoints',1000000); % ドローンの目標軌道の描画点の制限
                end
                for n = 1:length(param.bird)
                    f_b(n) = animatedline('Color','r','MaximumNumPoints',1000000); % 鳥の目標軌道の描画点の制限
                end
            end
            for i = 1:length(t)-1
                if param.Motive_ref
                    if ~isempty(fi)
                            delete(fi);
                    end
                    for n = 1:length(param.drone)
                        addpoints(f(n),p(i,1,n),p(i,2,n),p(i,3,n));
                        % drone pos
                        obj.draw(obj.frame(param.drone(n)),obj.thrust(param.drone(n),:),p(i,:,n),Q(i,:,n),u(i,:,n));
                        % voronoi face
                        fi(n)=trisurf(agent{n}.reference.result{i}.k{n},agent{n}.reference.result{i}.v(agent{n}.reference.result{i}.c{n},1),agent{n}.reference.result{i}.v(agent{n}.reference.result{i}.c{n},2),agent{n}.reference.result{i}.v(agent{n}.reference.result{i}.c{n},3),'Facecolor','r','Facealpha',0.3,'EdgeColor','none');
                    end
                    for n = 1:length(param.bird)
                        addpoints(f_b(n),p_b(i,1,n),p_b(i,2,n),p_b(i,3,n));
                        % bird pos
                        obj.draw(obj.frame_bird(param.bird(n)),obj.thrust_bird(param.bird(n),:),p_b(i,:,n),Q_b(i,:,n),u_b(i,:,n));
                        
                    end
                else
                    for n = 1:length(param.drone)
                        plot3(p(:,1,n),p(:,2,n),p(:,3,n),'k');
                        obj.draw(obj.frame(param.drone(n)),obj.thrust(param.drone(n),:),p(i,:,n),Q(i,:,n),u(i,:,n));
                    end
                    for n = 1:length(param.bird)
%                         plot3(p_b(:,1,n),p_b(:,2,n),p_b(:,3,n),'r');
                        obj.draw(obj.frame_bird(param.bird(n)),obj.thrust_bird(param.bird(n),:),p_b(i,:,n),Q_b(i,:,n),u_b(i,:,n));
                    end
                end
                % farm pos
                plot3(farm(1),farm(2),farm(3),'bs','MarkerFaceColor','b');
                if param.realtime
                    delta = toc(tRealtime);
                    if t(i+1)-t(i) > delta
                        pause(t(i+1)-t(i) - delta);
                    end
                    tRealtime = tic;
                else
                    pause(0.01);
                end
                if param.gif
                    im = frame2im(getframe(obj.fig));
                    [imind,cm] = rgb2ind(im,sizen);
                    if i==1
                        imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',delaytime);
                    else
                        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',delaytime);
                    end
                end
                if param.mp4
                    framev = getframe(obj.fig);
                    writeVideo(v,framev);
                end
            end
            if param.mp4
                close(v);
            end
        end
    end
end