classdef DRAW_WHILL
    % フレーム付きで動画を作成するためのクラス
    % obj = DRAW_CART_PENDULUM(logger,param)
    % obj.draw(p,q,u) : １スナップを描画
    % obj.animation(logger,param) : 動画描画
    % TODO : methodなど一般化して抽象化したほうが良いか？

    properties
        body
        fig
        qf0
        df0
        dp0
    end

    methods
        function obj = DRAW_WHILL(data,param)
            % 【usage】 obj = DRAW_WHILL(logger,param)
            % data : draw area
            % param.frame_size : cart size : [L,W,H]
            % param.L : wheel base : L
            % param.W : Tread
            % param.H : Height
            % param.r : wheel radius : r
            % param.ww : wheel width : ww
            % param.plot_ref : reference plot true or not
            arguments
                data
                param.frame_size = [1,0.5,1.2]
                param.L = 1;
                param.W = 0.5;
                param.H = 1.2;
                param.r = 0.13;
                param.ww = 0.06;
                param.animation = false;
            end
            tM = max(data,[],1);
            tm = min(data,[],1);
            M = [max(tM(1:3:end)),max(tM(2:3:end)),max(tM(3:3:end))];
            m = [min(tm(1:3:end)),min(tm(2:3:end)),min(tm(3:3:end))];
            B = param.frame_size;
            figure();
            if length(M) > 2
                B(3) = M(3) + B(3);
            end
            ax = axes('XLim',[m(1)-B(1) M(1)+B(1)],'YLim',[m(2)-B(2) M(2)+B(2)],'ZLim',[0 B(3)]);
            xlabel(ax,"x [m]");
            ylabel(ax,"y [m]");
            zlabel(ax,"z [m]");
            obj.fig = ax;

            view(3)
            grid on
            daspect([1 1 1]);
            hold on

            % cart 
            % Side lengths
            L = param.frame_size(1);
            W = param.frame_size(2);
            H = param.frame_size(3);
            r = param.r;
            ww = param.ww;

            % Faces
            boxf = [
                1, 2, 5, 3;  % #1
                1, 3, 6, 4;  % #2
                1, 4, 7, 2;  % #3
                4, 7, 8, 6;  % #4
                2, 5, 8, 7;  % #5
                3, 6, 8, 5]; % #6

            % seat
            Lx = L;
            Ly = W - ww;
            [X,Y,Z]=ellipsoid(Lx/2,0,0.5,Ly/2,Ly/2,0.05);
            seat(3) = surface(ax,X,Y,Z,'FaceColor','#AAAAAA','EdgeColor','#555555');
%             [x,y,z] = meshgrid([-1:0.01:1]);
%             V = exp(real(-x.^(1.8) -y.^(1.8) -(8*z).^2));
%             tmp = isosurface(x,y,z,V,0.9);
%             seat(3) = patch(ax,'Faces', tmp.faces, 'Vertices', tmp.vertices+[Lx/2,0,0.5], 'FaceColor', '#555555');

            % back
            Lx = 0.1;
            Ly = W - ww;
            Lz = H;
            R = Rodrigues([0,1,0],-pi/12);
            boxv = obj.box_vertices(Lx,Ly,Lz);
            boxv = (R*boxv')' + [r,-Ly/2,r];
            seat(2) = patch(ax,'Faces', boxf, 'Vertices', boxv, 'FaceColor', '#555555');

            % base
            Lx = L - 2*r;
            Ly = W - ww;
            Lz = 0.1;
            boxv = obj.box_vertices(Lx,Ly,Lz);
            boxv = boxv + [0,-Ly/2,r];
            seat(1) = patch(ax,'Faces', boxf, 'Vertices', boxv, 'FaceColor', 'k');

            % wheel
            R = rotmat(quaternion([1,0,0]*pi/2,"rotvec"),'point');
            [xr,yr,zr] = cylinder([0;r;r;0]);
            zr(2,:) = 0;
            zr(3,:) = 1;
            zr = zr*ww-ww/2;
            d = [Lx,-Ly/2-ww/2,r;Lx,Ly/2+ww/2,r;0,-Ly/2-ww/2,r;0,Ly/2+ww/2,r];
            for i = 1:4
                 %F = [R*[xr(1,:);yr(1,:);zr(1,:)];R*[xr(2,:);yr(2,:);zr(2,:)]]+[d(i,:)';d(i,:)'];
                 F = [R*[xr(1,:);yr(1,:);zr(1,:)];R*[xr(2,:);yr(2,:);zr(2,:)];R*[xr(3,:);yr(3,:);zr(3,:)];R*[xr(4,:);yr(4,:);zr(4,:)]] ...
                 +[d(i,:)';d(i,:)';d(i,:)';d(i,:)'];
                 h(i) = surface(ax,[F(1,:);F(4,:);F(7,:);F(10,:)],[F(2,:);F(5,:);F(8,:);F(11,:)],[F(3,:);F(6,:);F(9,:);F(12,:)],'FaceColor','#AAA');
            end

            t = hgtransform('Parent',ax); 
            set(h,'Parent',t); % tireを慣性座標と紐づけ
            set(seat,'Parent',t); % seatを慣性座標と紐づけ

            obj.body = t;
        end

        function draw(obj,p,q)
            % obj.draw(p,q,u)
            % p : 位置ベクトル
            % q : body = th : 回転軸[0,0,1]にth回転
            arguments
                obj
                p
                q
            end
            % Rotation matrix
            R = makehgtform('axisrotate',[0,0,1],q);
            % Translational matrix
            Txyz = makehgtform('translate',p);
            set(obj.body,'Matrix',Txyz*R);
            drawnow
        end
        function animation(obj,data,param)
            % data : field t, p, q
            %   t : time
            %   p : 3D position
            %   q : yaw angle
            % param.realtime (optional) : t-or-f : logger.data('t')を使うか
            arguments
                obj
                data
                param.realtime = false;
                param.gif = 0;
            end
            t = data.t;
            p = data.p;           
            q = data.q(:,end);
            if size(p,2) < 3
                p = [p,zeros(size(p,1),1)];
            end

            if param.gif
                sizen = 256;
                delaytime = 0;
                filename = strrep(strrep(strcat('Data/Movie(',datestr(datetime('now')),').gif'),':','_'),' ','_');
            end

            tRealtime = tic;
            for i = 1:length(t)-1
                obj.draw(p(i,:),q(i))
                if mod(t(i),0.1)<0.001
                    title("Time : " + t(i));
                end
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
            end
        end
        function boxv = box_vertices(obj,Lx,Ly,Lz)
             boxv = [
                0,   0,  0;  % #1
                Lx,  0,  0;  % #2
                0,  Ly,  0;  % #3
                0,   0, Lz;  % #4
                Lx, Ly,  0;  % #5
                0,  Ly, Lz;  % #6
                Lx,  0, Lz;  % #7
                Lx, Ly, Lz]; % #8
        end
    end
end