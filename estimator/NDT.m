classdef NDT < handle
% classdef NDT < MODEL_CLASS
    
    properties
        result
        self
        model

        state
    end

    properties
        fixedSeg
        tform
        initialtform
        PCdata_use
        matching_mode = "slam"%slam or mapmatching
        gridstep = 1.0;
    end
    
    methods
        function obj = NDT(self,param)% constractor
            obj.self = self; % agent that 
            model = param.model;
            obj.model = model;
            param = param.param;
            obj.initialtform = obj.initial_matching(rigidtform3d(eul2rotm(deg2rad(param(:,2)'),"XYZ"),param(:,1)));
            % obj.fixedSeg = param.fixedSeg;
            
            obj.result.state=state_copy(obj.model.state);
        end


        function [result] = do(obj,varargin)
            % obj.PCdata_use = obj.self.sensor.result{1};
            obj.PCdata_use = obj.scanpcplot_rov(obj.self.sensor.ros{2},obj.self.sensor.ros{1});            
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


        function pcdata = scanpcplot_rov(obj,data1,data2)
            scanlidardata_b = data1.getData;
            scanlidardata_f = data2.getData;
            moving_f = rosReadCartesian(scanlidardata_f);
            moving_b = rosReadCartesian(scanlidardata_b);
            moving_pc.f = [moving_f zeros(size(moving_f,1),1)];
            moving_pc.b = [moving_b zeros(size(moving_b,1),1)];
            roi = [0.1 0.35 -0.18 0.16 -0.1 0.1];
            moving_pc.f = obj.Pointcloud_manual_roi(moving_pc.f,roi);
            moving_pc.b = obj.Pointcloud_manual_roi(moving_pc.b,roi);
            rot = eul2rotm(deg2rad([0 0 180]),'XYZ');
            T = [0.46 0.023 0];
            moving_pc2_m_b = obj.tform_manual(moving_pc.b,rot,T);
            ptCloudOut = [moving_pc.f;moving_pc2_m_b];
            rot = eul2rotm(deg2rad([0 0 180]),'XYZ');
            T = [0.17 0 0];
            moving_pcm = obj.tform_manual(ptCloudOut,rot,T);
            pcdata = pointCloud(moving_pcm);
        end

        function pointcloud_out_roi = Pointcloud_manual_roi(obj,ptobj,roi)
            for inc = 1:length(ptobj)
                if roi(1) < ptobj(inc,1) && ptobj(inc,1) < roi(2)
                    if roi(3) < ptobj(inc,2) && ptobj(inc,2) < roi(4)
                        ptobj(inc,1) = nan;
                        ptobj(inc,2) = nan;
                        ptobj(inc,3) = nan;
                    end
                end
            end
            R = rmmissing(ptobj);
            ptobj_B = R;
            pointcloud_out_roi = ptobj_B;
        end

        function out = tform_manual(obj,pt,rot,T)
            for i = 1:length(pt)
                tform = rot * pt(i,:)' + T';
                ptobj_tform(i,1) = tform(1,1);
                ptobj_tform(i,2) = tform(2,1);
                ptobj_tform(i,3) = tform(3,1);
            end
            out=ptobj_tform;
        end

        function initform=initial_matching(obj,initialtform)
            % pcd
            if obj.matching_mode == "slam"
                % savedata(1).initialtform = initialtform;
                % obj.fixedSeg = pctransform(obj.scanpcplot_rov(ros{3},ros{2}),obj.initialtform);        %slam map
                obj.PCdata_use = obj.scanpcplot_rov(obj.self.sensor.ros{1,2},obj.self.sensor.ros{1,1});
                obj.fixedSeg = pointCloud(obj.tform_manual(obj.PCdata_use.Location,initialtform.R,initialtform.Translation));
                initform = initialtform;
            else
                % fixedSeg = pcread("fixmap_room_1.pcd"); %room map
                % fixedSeg = pcread("fixmapv6.pcd");          %廊下 map
                load("fixmapv6.mat");
                obj.fixedSeg = fixedSeg;
                %初期位置探索
                obj.PCdata_use = obj.scanpcplot_rov(obj.self.sensor.ros{2},obj.self.sensor.ros{1});
                initform = pcregisterndt(obj.PCdata_use,obj.fixedSeg,obj.gridstep, ...
                        "InitialTransform",initialtform,"OutlierRatio",0.1,"Tolerance",[0.01 0.1]);%マッチング
            end
            obj.model.state.p = initform.Translation';
            obj.model.state.q = rad2deg(rotm2eul(initform.R,"XYZ"))';            
        end

        function tform_add_odom(obj)
            odom_data = obj.self.plant.connector.getData;
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
            %コマンド
            %agent.estimator.show(logger)
            num_lim = logger.k - 1;
            mkmap = pctransform(logger.Data.agent.estimator.result{1,7}.ndtPCdata, ...
                logger.Data.agent.estimator.result{1,7}.tform);
            hold on
            for j=8:num_lim
                ndtPCdata = pctransform(logger.Data.agent.estimator.result{1,j}.ndtPCdata, ...
                    logger.Data.agent.estimator.result{1,j}.tform);    
                mkmap = pcmerge(mkmap,ndtPCdata, 0.001);
            end
            hold off
            % figure
            scatter(mkmap.Location(:,1),mkmap.Location(:,2),1);
            xlabel('X');ylabel('Y');

            figure
            for j=8:num_lim
                X(j) = logger.Data.agent.estimator.result{1,j}.tform.A(1,4) ;%+ 1;
                Y(j) = logger.Data.agent.estimator.result{1,j}.tform.A(2,4);
                ndtx(j) = logger.Data.agent.estimator.result{1,j}.state.p(1,1);%+ 1;
                ndty(j) = logger.Data.agent.estimator.result{1,j}.state.p(2,1);
            end
            % figure
            plot(ndtx,ndty,'*-');
            hold on
            plot(X,Y,'o-')
            grid on
            xlabel(texlabel('X'));ylabel(texlabel('Y'));
            pcshow(obj.fixedSeg,BackgroundColor=[1 1 1],MarkerSize=12,ViewPlane="XY")
        end
        
        % function result=do(obj,varargin)
        %     result=obj.result;
        % end
    end
end