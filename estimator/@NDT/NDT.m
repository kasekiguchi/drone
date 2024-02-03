classdef NDT < handle
% classdef NDT < MODEL_CLASS

properties %eitimator class common
    result
    self
    model

    state
end

properties %for ndt calculation
    fixedSeg %pcregisterndtに使用する事前地図(PointCloud)
    tform %pcregisterndtから出てくる推定値(rigidform3d)
    initialtform %pcregisterndtに使用するマッチング探索位置，姿勢(rigidform3d)
    PCdata_use %pcregisterndtに使用するスキャンデータ(PointCloud)
    matching_mode %slam or mapmatching
    mapname %mapmatchingの時ロードするmatファイル名.中身がfixedSeg(PointCloud)である必要がある
    gridstep = 1.0; %pcregisterndtに使用するボクセルのグリッドサイズ(メートル)
    % func                         %前後のLiDAR点群を合成する関数.LiDARが一つの場合はいらない
end

methods

    function obj = NDT(self, sample_param) % constractor
        %ROS2でsubscriveするLiDAR点群用のEstimatorクラス
        obj.self = self; % agent that
        obj.model = sample_param.model;

        % obj.func = sample_param.ndt.func;
        obj.matching_mode = sample_param.ndt.matching_mode;
        obj.mapname = sample_param.ndt.mapname;

        param = sample_param.param;
        obj.initialtform = obj.initial_matching(rigidtform3d(eul2rotm(deg2rad(param(:, 2)'), "XYZ"), param(:, 1)));
        obj.result.state = state_copy(obj.model.state);
        % end
    end

    function [result] = do(obj, varargin)
        % obj.PCdata_use = obj.self.sensor.result{1};
        % obj.PCdata_use = obj.scanpcplot_rov(obj.self.sensor.ros{2},obj.self.sensor.ros{1});
        % obj.PCdata_use = obj.func(obj.self.sensor.ros{2},obj.self.sensor.ros{1});
        obj.PCdata_use = obj.self.sensor.result.pc;
        obj.tform = pcregisterndt(obj.PCdata_use, obj.fixedSeg, 0.5, "InitialTransform", obj.initialtform, "OutlierRatio", 0.1, "Tolerance", [0.01 0.1]); %マッチング

        if (obj.matching_mode == "slam")
            ndt_PCdata = pctransform(obj.PCdata_use, obj.tform);
            obj.fixedSeg = pcmerge(obj.fixedSeg, ndt_PCdata, 0.01);
        end

        if isfield(obj.self.sensor.result, 'odom_data')
            obj.tform_add_odom(obj.self.sensor.result.odom_data);
        else
            obj.tform_add_odom(struct('linear', struct('x', obj.self.controller.result.input(1)), 'angular', struct('z', obj.self.controller.result.input(2))));
        end

        obj.result.tform = obj.tform;
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
                "InitialTransform", initialtform, "OutlierRatio", 0.1, "Tolerance", [0.01 0.1]); %マッチング
        end

        obj.model.state.p = initform.Translation';
        obj.model.state.q = rad2deg(rotm2eul(initform.R, "XYZ"))';
    end

    function tform_add_odom(obj, odom_data)
        %ローバーの加速度，角速度をuに入れてモデルの状態をする．
        < << < << < Updated upstream
        odom_data = obj.self.sensor.result.odom_data;
        = == = == =
        odom_data = obj.self.sensor.result.odom_data; %plant.connector.getData;
        > >> > >> > Stashed changes
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
        %mommand：
        %agent.estimator.plot(logger,savemode)
        %[savemode]
        % 0:don't save to pdf
        % 1:map_vs_trajectory save to pdf
        % 2:RMSE save to pdf
        % 1:map_vs_trajectory and RMSE save to pdf
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

        mkmap = pctransform(logger.Data.agent.estimator.result{1, i}.ndtPCdata, ...
            logger.Data.agent.estimator.result{1, i}.tform);
        % hold on
        for j = i:num_lim
            ndtPCdata = pctransform(logger.Data.agent.estimator.result{1, j}.ndtPCdata, ...
                logger.Data.agent.estimator.result{1, j}.tform);
            mkmap = pcmerge(mkmap, ndtPCdata, 0.01);
        end

        for j = i:num_lim
            X(j) = logger.Data.agent.estimator.result{1, j}.tform.A(1, 4); %+ 1;
            Y(j) = logger.Data.agent.estimator.result{1, j}.tform.A(2, 4);
            % prime_x(j) = logger.Data.agent.sensor.result{1,j}.state.p(1,1) - logger.Data.agent.sensor.result{1,1}.state.p(1,1);
            % prime_y(j) = logger.Data.agent.sensor.result{1,j}.state.p(2,1) - logger.Data.agent.sensor.result{1,1}.state.p(2,1);
            % rmse_x(j) = sqrt((X(j) - prime_x(j))^2);
            % rmse_y(j) = sqrt((Y(j) - prime_y(j))^2);
        end

        plot(X, Y, 'o-')
        hold on
        % plot(prime_x,prime_y,'*-')
        grid on
        xlabel(texlabel('x [m]')); ylabel(texlabel('y [m]'));

        if ~isfield(obj, "fixedSeg")
            obj.fixedSeg = mkmap;
        end

        pcshow(mkmap)
        % scatter(obj.fixedSeg.Location(:,1),obj.fixedSeg.Location(:,2),2,"filled");
        legend("NDTestimate", "pcmap")
        hold off
        % figure;ax_rmse_x = gca;ax_rmse_x.FontSize = 12;
        % bar(logger.Data.t(1:logger.k - i),rmse_x,0.75);xlabel(texlabel('time [sec]'));ylabel(texlabel('RMSE of X'));
        % figure;ax_rmse_y = gca;ax_rmse_y.FontSize = 12;
        % bar(logger.Data.t(1:logger.k - i),rmse_y,0.75);xlabel(texlabel('time [sec]'));ylabel(texlabel('RMSE of Y'));
        switch save
            case 1
                exportgraphics(ax, 'exroom_0131_take3.pdf', 'ContentType', 'vector')
            case 2
                exportgraphics(ax_rmse_x, 'RMSE_X.pdf', 'ContentType', 'vector')
                exportgraphics(ax_rmse_y, 'RMSE_Y.pdf', 'ContentType', 'vector')
            case 3
                exportgraphics(ax, 'map_vs_trajectory.pdf', 'ContentType', 'vector')
                exportgraphics(ax_rmse_x, 'RMSE_X.pdf', 'ContentType', 'vector')
                exportgraphics(ax_rmse_y, 'RMSE_Y.pdf', 'ContentType', 'vector')
        end

    end

    % function result=do(obj,varargin)
    %     result=obj.result;
    % end
end

end
