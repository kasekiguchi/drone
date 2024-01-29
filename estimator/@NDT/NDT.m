classdef NDT < handle
% classdef NDT < MODEL_CLASS
    
    properties
        result
        self
        model

        state
    end

    properties
        fixedSeg                     %pcregisterndtに使用する事前地図(PointCloud)
        tform                        %pcregisterndtから出てくる推定値(rigidform3d)
        initialtform                 %pcregisterndtに使用するマッチング探索位置，姿勢(rigidform3d)
        PCdata_use                   %pcregisterndtに使用するスキャンデータ(PointCloud)
        matching_mode = "mapmatching"%slam or mapmatching
        gridstep = 1.0;              %pcregisterndtに使用するボクセルのグリッドサイズ(メートル)
    end
    
    methods
        function obj = NDT(self,param)% constractor
            %ROS2でsubscribeするLiDAR点群用のEstimatorクラス
            obj.self = self; % agent that 
            obj.model = param.model;
            param = param.param;
            

            obj.initialtform = obj.initial_matching(rigidtform3d(eul2rotm(deg2rad(param(:,2)'),"XYZ"),param(:,1)));
            % obj.fixedSeg = param.fixedSeg;            
            obj.result.state=state_copy(obj.model.state);
        end


        function [result] = do(obj,varargin)
            obj.PCdata_use = obj.self.sensor.result.pc;
            obj.tform = pcregisterndt(obj.PCdata_use,obj.fixedSeg,0.5,"InitialTransform",obj.initialtform,"OutlierRatio",0.1,"Tolerance",[0.01 0.1]);%マッチング
            if (obj.matching_mode == "slam")
                ndt_PCdata = pctransform(obj.PCdata_use,obj.tform);
                obj.fixedSeg = pcmerge(obj.fixedSeg,ndt_PCdata,0.01);
            end
            obj.tform_add_odom
            obj.result.tform = obj.tform;
            obj.result.ndtPCdata = obj.PCdata_use;
            disp(obj.tform)
            tmpvalue.p = obj.tform.Translation';
            tmpvalue.q = rotm2eul(obj.tform.R,"XYZ")';
            % tmpvalue = obj.result.tform.Translation';
            obj.result.state.set_state(tmpvalue);%%%%%推定結果
            obj.model.state.set_state(tmpvalue);%%%%%%モデルの更新
        end


        function initform=initial_matching(obj,initialtform)
            %コンストラクタでロボット初期位置の探索を行う
            %mat
            if obj.matching_mode == "slam"
                % savedata(1).initialtform = initialtform;
                % obj.fixedSeg = pctransform(obj.scanpcplot_rov(ros{3},ros{2}),obj.initialtform);        %slam map
                % obj.PCdata_use = obj.scanpcplot_rov(obj.self.sensor.ros{1,2},obj.self.sensor.ros{1,1});
                obj.PCdata_use = obj.combine_pc(obj.self.sensor.ros{1,2},obj.self.sensor.ros{1,1});
                obj.fixedSeg = pointCloud(obj.tform_manual(obj.PCdata_use.Location,initialtform.R,initialtform.Translation));
                initform = initialtform;
            else
                % fixedSeg = pcread("fixmap_room_1.pcd"); %room map
                % fixedSeg = pcread("fixmapv6.pcd")%廊下 map
                load("fixmapv6.mat");
                obj.fixedSeg = fixedSeg;
                %初期位置探索
                % obj.PCdata_use = obj.scanpcplot_rov(obj.self.sensor.ros{2},obj.self.sensor.ros{1});
                obj.PCdata_use = obj.self.sensor.result.pc;
                initform = pcregisterndt(obj.PCdata_use,obj.fixedSeg,obj.gridstep, ...
                        "InitialTransform",initialtform,"OutlierRatio",0.1,"Tolerance",[0.01 0.1]);%マッチング
            end
            obj.model.state.p = initform.Translation';
            obj.model.state.q = rad2deg(rotm2eul(initform.R,"XYZ"))';            
        end

        function tform_add_odom(obj)
            %ローバーの加速度，角速度をuに入れてモデルの状態をする．
            odom_data = obj.self.sensor.result.odom_data;%plant.connector.getData;
            u = [odom_data.linear.x,odom_data.angular.z]';%u
            zini = obj.model.state.get;
            B = [cos(zini(6)),0;sin(zini(6)),0;0,1]*obj.model.dt;
            A = [1 0 0;0 1 0;0 0 1];
            x_yaw = rotm2eul(obj.tform.R,"XYZ");
            X_hat = [obj.tform.Translation(1:2), x_yaw(3)]';
            X = A * X_hat + (B * u);
            initialtform_T   = X(1:2);
            initialtform_rot = eul2rotm([0 0 X(3)],"XYZ");
            obj.initialtform = rigidtform3d(initialtform_rot,[initialtform_T; 0]);
        end


        function show(obj,logger)
            %実機を動かした後，推定値をplot
            %コマンド
            %agent.estimator.show(logger)            
            num_lim = logger.k - 1;
            i=1;
            while(1)
                if isfield(obj.result{1,i},"tform")
                    break;
                end
                i = i + 1;
                % obj.result{1,1} = obj.result{1,i}
            end            
            mkmap = pctransform(logger.Data.agent.estimator.result{1,i}.ndtPCdata, ...
                logger.Data.agent.estimator.result{1,i}.tform);
            hold on
            for j=i:num_lim
                ndtPCdata = pctransform(logger.Data.agent.estimator.result{1,j}.ndtPCdata, ...
                    logger.Data.agent.estimator.result{1,j}.tform);    
                mkmap = pcmerge(mkmap,ndtPCdata, 0.001);
            end
            hold off
            % figure
            scatter(mkmap.Location(:,1),mkmap.Location(:,2),1);
            xlabel('X');ylabel('Y');

            figure
            for j=i:num_lim
                X(j) = logger.Data.agent.estimator.result{1,j}.tform.A(1,4) ;%+ 1;
                Y(j) = logger.Data.agent.estimator.result{1,j}.tform.A(2,4);
                % ndtx(j) = logger.Data.agent.estimator.result{1,j}.state.p(1,1);%+ 1;
                % ndty(j) = logger.Data.agent.estimator.result{1,j}.state.p(2,1);
            end
            % figure
            % plot(ndtx,ndty,'*-');
            hold on
            plot(X,Y,'o-')
            grid on
            xlabel(texlabel('X'));ylabel(texlabel('Y'));
            if ~isfield(obj,"fixedSeg")                
                obj.fixedSeg = mkmap;
            end
            % pcshow(obj.fixedSeg,BackgroundColor=[1 1 1],MarkerSize=12,ViewPlane="XY")
            scatter(obj.fixedSeg.Location(:,1),obj.fixedSeg.Location(:,2),2,"filled");
        end
        
        % function result=do(obj,varargin)
        %     result=obj.result;
        % end
    end
end