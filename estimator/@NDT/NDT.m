classdef NDT < handle
% classdef NDT < MODEL_CLASS

properties %eitimator class common
    result
    self
    model

    state
end
    properties%for ndt calculation
        fixedSeg                     %pcregisterndtに使用する事前地図(PointCloud)
        tform                        %pcregisterndtから出てくる推定値(rigidform3d)
        initialtform                 %pcregisterndtに使用するマッチング探索位置，姿勢(rigidform3d)
        PCdata_use                   %pcregisterndtに使用するスキャンデータ(PointCloud)
        matching_mode                %slam or mapmatching
        mapname                      %mapmatchingの時ロードするmatファイル名.中身がfixedSeg(PointCloud)である必要がある
        gridstep = 1.0;              %pcregisterndtに使用するボクセルのグリッドサイズ(メートル)
    end
    
    methods
        function obj = NDT(self,sample_param)% constractor
            %ROS2でsubscriveするLiDAR点群用のEstimatorクラス
            obj.self = self; % agent that 
            obj.model = sample_param.model;
            obj.result.state=state_copy(obj.model.state);
            obj.matching_mode = sample_param.ndt.matching_mode;
            obj.mapname = sample_param.ndt.mapname;

            param = sample_param.param;          
            obj.initialtform = obj.initial_matching(rigidtform3d(eul2rotm(deg2rad(param(:,2)'),"XYZ"),param(:,1)));
            tmpvalue.p = obj.initialtform.Translation';
            tmpvalue.q = rotm2eul(obj.initialtform.R,"XYZ")';
            obj.result.state.set_state(tmpvalue);
            % end
        end

    function [result] = do(obj, varargin)
        % obj.PCdata_use = obj.self.sensor.result{1};
        % obj.PCdata_use = obj.scanpcplot_rov(obj.self.sensor.ros{2},obj.self.sensor.ros{1});
        % obj.PCdata_use = obj.func(obj.self.sensor.ros{2},obj.self.sensor.ros{1});
        obj.PCdata_use = obj.self.sensor.result.pc;
        obj.tform = pcregisterndt(obj.PCdata_use, obj.fixedSeg,obj.gridstep, ...
            "InitialTransform", obj.initialtform, "OutlierRatio", 0.1, "Tolerance", [0.01 0.1]); %NDTマッチング

        if (obj.matching_mode == "slam")
            ndt_PCdata = pctransform(obj.PCdata_use, obj.tform);
            obj.fixedSeg = pcmerge(obj.fixedSeg, ndt_PCdata, 0.01);
        end

        if isfield(obj.self.sensor.result, 'odom_data')
            obj.tform_add_odom(obj.self.sensor.result.odom_data);
        else
            obj.tform_add_odom(struct('linear', struct('x', obj.self.controller.result.input(1)), 'angular', struct('z', obj.self.controller.result.input(2))));
        end

        obj.result.tform = obj.tform;%disp(obj.tform);
        obj.result.ndtPCdata = obj.PCdata_use;
        tmpvalue.p = obj.tform.Translation';
        tmpvalue.q = rotm2eul(obj.tform.R, "XYZ")';
        % tmpvalue = obj.result.tform.Translation';
        obj.result.state.set_state(tmpvalue); % % % % %推定結果
        obj.model.state.set_state(tmpvalue); % % % % % %モデルの更新
    end

    function initform = initial_matching(obj, initialtform)
        %コンストラクタでロボット初期位置の探索を行う
        if obj.matching_mode == "slam"
            obj.PCdata_use = obj.self.sensor.result.pc;

            obj.fixedSeg = pointCloud((initialtform.R * obj.PCdata_use.Location' + initialtform.Translation')');
            %obj.fixedSeg = pointCloud(tform_manual(obj.PCdata_use.Location,initialtform.R,initialtform.Translation));
            initform = initialtform;
        else
            % fixedSeg = pcread("fixmap_room_1.pcd"); %room map
            % fixedSeg = pcread("fixmapv6.pcd")%廊下 map
            load(obj.mapname);
            obj.fixedSeg = fixedSeg;
            %初期位置探索
            obj.PCdata_use = obj.self.sensor.result.pc;
            initform = pcregisterndt(obj.PCdata_use, obj.fixedSeg, obj.gridstep, ...
                "InitialTransform", initialtform, "OutlierRatio", 0.1, "Tolerance", [0.01 0.1]); %NDTマッチング
        end

        obj.model.state.p = initform.Translation';
        obj.model.state.q = rad2deg(rotm2eul(initform.R, "XYZ"))';
    end

    function tform_add_odom(obj, odom_data)
        %ローバーの加速度，角速度をuに入れてモデルの状態をする．
        odom_data = obj.self.sensor.result.odom_data;
        u = [odom_data.linear.x, odom_data.angular.z]'; %u
        zini = obj.model.state.get;
        B = [cos(zini(6)), 0; sin(zini(6)), 0; 0, 1] * obj.model.dt;
        A = [1 0 0; 0 1 0; 0 0 1];
        x_yaw = rotm2eul(obj.tform.R, "XYZ");
        X_hat = [obj.tform.Translation(1:2), x_yaw(3)]';
        X = A * X_hat + (B * u);
        initialtform_T = X(1:2);
        initialtform_rot = eul2rotm([0 0 X(3)], "XYZ");
        obj.initialtform = rigidtform3d(initialtform_rot, [initialtform_T; 0]);
    end

    function plot(obj, logger, save)
        %推定値をplot
        %logger=logger=LOGGER("filename.mat")%matデータからloggerを抽出
        %Command：
        %agent.estimator.plot(logger,savemode)
        %[savemode]
        % 0:don't save to pdf
        % 1:map_vs_trajectory save to pdf
        % 2:RMSE save to pdf
        % 3:map_vs_trajectory and RMSE save to pdf    
        % 4:animation make
        ax = gca; ax.FontSize = 12;
        num_lim = logger.k - 1;
        i = 1;
        while (1)
            if isfield(logger.Data.agent.estimator.result{1, i}, "tform")
                break;
            end
            i = i + 1;
            % obj.result{1,1} = obj.result{1,i}
        end
        % mkmap = pctransform(logger.Data.agent.estimator.result{1, i}.ndtPCdata, ...
        %     logger.Data.agent.estimator.result{1, i}.tform);
        mkmap = pointCloud([nan nan nan]);
        for j = i:num_lim
            ndtPCdata(j) = pctransform(logger.Data.agent.estimator.result{1, j}.ndtPCdata, ...
                logger.Data.agent.estimator.result{1, j}.tform);
            mkmap = pcmerge(mkmap, ndtPCdata(j), 0.01);

            X(j) = logger.Data.agent.estimator.result{1, j}.tform.A(1, 4);
            Y(j) = logger.Data.agent.estimator.result{1, j}.tform.A(2, 4);
            
            prime_x(j) = logger.Data.agent.sensor.result{1,j}.state.p(1,1) - logger.Data.agent.sensor.result{1,1}.state.p(1,1) + logger.Data.agent.estimator.result{1, 1}.tform.A(1, 4);
            prime_y(j) = logger.Data.agent.sensor.result{1,j}.state.p(2,1) - logger.Data.agent.sensor.result{1,1}.state.p(2,1) +logger.Data.agent.estimator.result{1, 1}.tform.A(2, 4);
            % prime_x(j) = logger.Data.agent.sensor.result{1,j}.state.p(1,1) + logger.Data.agent.estimator.result{1, 1}.tform.A(1, 4);
            % prime_y(j) = logger.Data.agent.sensor.result{1,j}.state.p(2,1) + logger.Data.agent.estimator.result{1, 1}.tform.A(2, 4);

            pr_x(j) = logger.Data.agent.reference.result{1,j}.state.p(1,1);
            pr_y(j) = logger.Data.agent.reference.result{1,j}.state.p(2,1);
            % rmse_x(j) = sqrt((X(j) - prime_x(j))^2);
            % rmse_y(j) = sqrt((Y(j) - prime_y(j))^2);
        end
        plot(X, Y, 'o-',"MarkerSize",3);
        hold on
        plot(prime_x,prime_y,'*-',"MarkerSize",3)
        plot(pr_x,pr_y,"pentagram","MarkerSize",20)
        grid on
        xlabel(texlabel('x [m]')); ylabel(texlabel('y [m]'));
        % if ~isfield(obj, "fixedSeg")
        %     obj.fixedSeg = mkmap;
        % end
        % pcshow(obj.fixedSeg,"ViewPlane","XY","BackgroundColor",[1 1 1])
        scatter(obj.fixedSeg.Location(:,1),obj.fixedSeg.Location(:,2),6,"filled");
        legend("NDTestimate","prime", "refernce Point","pcmap",'Location','northoutside')
        hold off
        % figure;ax_rmse_x = gca;ax_rmse_x.FontSize = 12;
        % bar(logger.Data.t(1:logger.k - i),rmse_x,0.75);xlabel(texlabel('time [sec]'));ylabel(texlabel('RMSE of X'));
        % figure;ax_rmse_y = gca;ax_rmse_y.FontSize = 12;
        % bar(logger.Data.t(1:logger.k - i),rmse_y,0.75);xlabel(texlabel('time [sec]'));ylabel(texlabel('RMSE of Y'));
        switch save
            case 1
                exportgraphics(ax, 'exroom_0209_takeN.pdf', 'ContentType', 'vector')
            case 2
                exportgraphics(ax_rmse_x, 'RMSE_X.pdf', 'ContentType', 'vector')
                exportgraphics(ax_rmse_y, 'RMSE_Y.pdf', 'ContentType', 'vector')
            case 3
                exportgraphics(ax, 'map_vs_trajectory.pdf', 'ContentType', 'vector')
                exportgraphics(ax_rmse_x, 'RMSE_X.pdf', 'ContentType', 'vector')
                exportgraphics(ax_rmse_y, 'RMSE_Y.pdf', 'ContentType', 'vector')
            case 4
                for j = 1:num_lim
                    filename = 'view2_0213.mp4'; % ファイル名
                    % fig(j) = scatter(obj.fixedSeg.Location(1,:),obj.fixedSeg.Location(2,:));
                    fig(j) = pcshowpair(obj.fixedSeg,ndtPCdata(j),"ViewPlane","XY","BackgroundColor",[1 1 1]);
                    text(-4,5,"t = " + num2str(logger.Data.t(j)))
                    hold on
                    % scatter(ndtPCdata(j).Location(1,:),ndtPCdata(j).Location(2,:));
                    scatter(X(j),Y(j),'MarkerFaceColor',[1 0 0]);
                    % xlim([-10 20]); ylim([-10 10]);
                    xlabel(texlabel('X [m]'));ylabel(texlabel('Y [m]'));
                    legend("pcmap","scanmap","ep")
                    hold off                    
                    frames(j) = getframe(fig(j));
                % end
                % 
                % for j = 1:num_lim
                    [A, map] = rgb2ind(frame2im(frames(j)), 2048); % 画像形式変換 2048
                    if j == 1
                        imwrite(A, map, filename, 'gif',"LoopCount",Inf, 'DelayTime', 1/5); % 出力形式(30FPS)を設定
                    else
                        imwrite(A, map, filename, 'gif',"LoopCount",Inf, 'DelayTime', 1/5, 'WriteMode', 'append'); % 2フレーム目以降は"追記"の設定も必要
                    end
                end
        end

    end
    function mapsave(obj)
        
    end

    % function result=do(obj,varargin)
    %     result=obj.result;
    % end
end

end
