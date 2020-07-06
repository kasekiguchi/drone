function ret = getData(obj)
	obj.Count = obj.Count + 1;   
    if obj.Count == 1
        obj.StartTime = rostime('now');
    end
	t = rostime('now') - obj.StartTime;
	obj.data.T = double(t.Sec)+double(t.Nsec)*10^-9;
    
    pause(obj.TimeOut);
    try
        switch obj.Mode
            case {'Physics',   2}
                gtp{obj.odom}   = obj.subTopic{obj.odom}.LatestMessage;
                gtp{obj.gyr}    = obj.subTopic{obj.gyr}.LatestMessage;
                gtp{obj.pose}   = obj.subTopic{obj.pose}.LatestMessage;

                obj.data.odm(1) = gtp{obj.odom}.Pose.Pose.Position.X;
                obj.data.odm(2) = gtp{obj.odom}.Pose.Pose.Position.Y;
                obj.data.odm(3) = gtp{obj.odom}.Pose.Pose.Position.Z;
                obj.data.odm(4) = gtp{obj.odom}.Twist.Twist.Linear.X;
                obj.data.odm(5) = gtp{obj.odom}.Twist.Twist.Linear.Y;
                obj.data.odm(6) = gtp{obj.odom}.Twist.Twist.Linear.Z;
                obj.data.odm(7) = gtp{obj.odom}.Twist.Twist.Angular.X;
                obj.data.odm(8) = gtp{obj.odom}.Twist.Twist.Angular.Y;
                obj.data.odm(9) = gtp{obj.odom}.Twist.Twist.Angular.Z;

                obj.data.gyr(1) = gtp{obj.gyr}.X;
                obj.data.gyr(2) = gtp{obj.gyr}.Y;
                obj.data.gyr(3) = gtp{obj.gyr}.Z;

                obj.data.X = double(gtp{obj.pose}.Position.X);
                obj.data.Y = double(gtp{obj.pose}.Position.Y);
                obj.data.Z = double(gtp{obj.pose}.Position.Z);
                obj.data.qx =double(gtp{obj.pose}.Orientation.X);
                obj.data.qy =double(gtp{obj.pose}.Orientation.Y);
                obj.data.qz =double(gtp{obj.pose}.Orientation.Z);
                obj.data.qw =double(gtp{obj.pose}.Orientation.W);
                quat = [obj.data.qx, obj.data.qy, obj.data.qz, obj.data.qw];
                eulZYX = quat2eul(quat);
                obj.data.roll  = double(eulZYX(1));
                obj.data.pitch = double(eulZYX(2));
                obj.data.yaw   = double(eulZYX(3));

            case {'Expriment', 3}
                gtp{obj.odom}   = obj.subTopic{obj.odom}.LatestMessage;
                gtp{obj.gyr}    = obj.subTopic{obj.gyr}.LatestMessage;

                obj.data.odm(1) = gtp{obj.odom}.Pose.Pose.Position.X;
                obj.data.odm(2) = gtp{obj.odom}.Pose.Pose.Position.Y;
                obj.data.odm(3) = gtp{obj.odom}.Pose.Pose.Position.Z;
                obj.data.odm(4) = gtp{obj.odom}.Twist.Twist.Linear.X;
                obj.data.odm(5) = gtp{obj.odom}.Twist.Twist.Linear.Y;
                obj.data.odm(6) = gtp{obj.odom}.Twist.Twist.Linear.Z;
                obj.data.odm(7) = gtp{obj.odom}.Twist.Twist.Angular.X;
                obj.data.odm(8) = gtp{obj.odom}.Twist.Twist.Angular.Y;
                obj.data.odm(9) = gtp{obj.odom}.Twist.Twist.Angular.Z;

                obj.data.gyr(1) = gtp{obj.gyr}.X;
                obj.data.gyr(2) = gtp{obj.gyr}.Y;
                obj.data.gyr(3) = gtp{obj.gyr}.Z;
            otherwise
                error('Wrong number. Select the correct number again.');
        end

        if obj.Sensor(obj.LiDAR) == true
            gtp{obj.scan}   = obj.subTopic{obj.scan}.LatestMessage;
            gtp{obj.ptCloud}= obj.subTopic{obj.ptCloud}.LatestMessage;
            obj.data.scan	= gtp{obj.scan};
            obj.data.ptCloud= gtp{obj.ptCloud};
        end
        if obj.Sensor(obj.RealSence) == true
            gtp{obj.rgbPtCloud}= obj.subTopic{obj.rgbPtCloud}.LatestMessage;
            obj.data.rgbPtCloud= gtp{obj.rgbPtCloud};
            obj.data.xyz = readXYZ(gtp{obj.rgbPtCloud});
            obj.data.rgb = readRGB(gtp{obj.rgbPtCloud});
        end
    catch ME
        endExperiment(obj);
        warning('off','backtrace')
        warning('Emergency stop! Please check the connection between the computer network and your electric wheelchair.');
        rethrow(ME);
    end
	ret = obj.data;
end