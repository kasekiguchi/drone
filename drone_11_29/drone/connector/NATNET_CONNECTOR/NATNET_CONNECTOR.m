classdef NATNET_CONNECTOR < CONNECTOR_CLASS
    % motive = NATNET_CONNECTOR(param)
    %  param : HostIP, ClientIP
    properties
        result
    end
    properties (NonCopyable = true, SetAccess = private )
        init_time  % first getData time
        max_in_marker_num = 50; % max number of markers in field
        max_rigid_num = 10;     % max number of rigid bodies
        %getFrame  % all data from motive
    end
    properties%(Access = private)
        NatnetClient
        on_marker_nums
        on_marker
    end

    methods
        function obj = NATNET_CONNECTOR(info)
          arguments
            info.HostIP char
            info.ClientIP char
          end
            %-- connection NatNetClient
            disp('Connect to Motive')
            %-- connection takes about 0.3 seconds
            %-- setting ClientIP
            obj.NatnetClient = natnet;
            obj.NatnetClient.HostIP	= info.HostIP;
            obj.NatnetClient.ClientIP = info.ClientIP;
            obj.NatnetClient.ConnectionType = 'Multicast';
            obj.NatnetClient.connect;
            if obj.NatnetClient.IsConnected == 0
                error( 'Please check whether it is connected to the net. Is the IP address correctly specified?' )
            end            
            ModelDescription = obj.NatnetClient.getModelDescription;
            % get frame from motive
            Frame = obj.NatnetClient.getFrame;
            obj.result.rigid_num = ModelDescription.RigidBodyCount;
            omnum = 0;
            obj.on_marker = cell(1,obj.result.rigid_num);
            obj.result.rigid(obj.result.rigid_num) = struct('p',[],'q',[]);
            for i = 1:obj.result.rigid_num
                obj.on_marker_nums(i) = ModelDescription.MarkerSet(i).MarkerCount;
                obj.on_marker{i} = zeros(obj.on_marker_nums(i),3);
                for k = 1:obj.on_marker_nums(i)
                    marker=Frame.LabeledMarker(omnum+k);
%                    marker=Frame.UnlabeledMarker(omnum+k);
                    obj.on_marker{i}(k,:) = [marker.x, -marker.z, marker.y];
                end
                body = Frame.RigidBody(i);
                obj.result.local_marker_nums(i) = ModelDescription.MarkerSet(i).MarkerCount;
                %obj.result.local_marker{i} = double(rotmat(quaternion([body.qw body.qx -body.qz body.qy]),'frame')'*(obj.on_marker{i}-double([body.x, -body.z, body.y]))')';
                obj.result.local_marker{i} = double(RodriguesQuaternion([body.qw body.qx -body.qz body.qy]')'*(obj.on_marker{i}-double([body.x, -body.z, body.y]))')';
                omnum = omnum+obj.on_marker_nums(i);
            end
        end
        function ret = getData(obj,~,~)
            % 【fields of result】
            % rigid : (struct array) rigid body info
            % marker : (struct array) all marker position
            % rigid_num % number of rigid bodies
            % marker_num % number of UnLabeledMarker
            % time      % time from init_time
            %% 本来（MotiveからExcelで出力し確認すると）
            %    LabeledMarker : 剛体情報生成に使われるマーカー情報
            %    UnlabeledMarker : LabeledMarker+それ以外のマーカー情報を含む情報
            %  しかし，NatnetClientでgetFrameするとこの関係が逆になっている．
            %  おそらくどこかで修正が入るので更新があったら注意
            ModelDescription = obj.NatnetClient.getModelDescription;
            obj.result.rigid_num = ModelDescription.RigidBodyCount;
            if ( obj.result.rigid_num < 1 )
                %return
                warning("ACSL : no rigid body");
            end
            
            % get frame from motive
            Frame = obj.NatnetClient.getFrame;
            %Acquire time data from motive
            if isempty(obj.init_time)
                obj.init_time = Frame.Timestamp;
            end
            obj.result.time    = Frame.Timestamp - obj.init_time;
            
            % %Count number of marker and rigid body
            obj.result.marker_num = System.Array.IndexOf(Frame.LabeledMarker, []);
%            obj.result.marker_num = System.Array.IndexOf(Frame.UnlabeledMarker, []);
            
            % %Get obj.Data and Organize
            % %also organizing obj.Data in the same way in main.m
            for i = 1:obj.result.rigid_num
                body = Frame.RigidBody(i);
                obj.result.rigid(i).p = double([body.x; -body.z; body.y]); % 軸の対応関係注意
                
                %% quaternion
                obj.result.rigid(i).q = double([body.qw, body.qx, -body.qz, body.qy]'); % 軸の対応関係注意
            end
            obj.result.marker = zeros(obj.result.marker_num,3);
            for i = 1:obj.result.marker_num
                marker = Frame.LabeledMarker(i);
%                marker = Frame.UnlabeledMarker(i);
                obj.result.marker(i,:) = [marker.x -marker.z marker.y];
            end
            ret = obj.result;
        end
    end
end
