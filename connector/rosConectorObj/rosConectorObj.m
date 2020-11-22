classdef rosConectorObj < CONNECTOR_CLASS
	properties(NonCopyable = true, SetAccess = private)
		data
		Data
		Count
		Mode
		Node
		subTopic
        pubTopic
		subMessage
        pubMessage
	end
	properties(Access = private)
		Sensor
		StartTime
    end
    properties(Access = private, Constant)
        Wheel = 0.256/2;
        Width = 0.490/2;
	end
	properties(Constant)
		TimeOut = 1.e-3;
		%- Subscriber topic -%
		subTopicNum= 6;
		odom	  = 1;
		gyr		  = 2;
		scan	  = 3;
		ptCloud   = 4;
		pose	  = 5;
        rgbPtCloud= 6;
  		%- Publisher topic -%
		pubTopicNum= 1;      
		cmdVel  = 1;
		%- Sensor -%
		Prime	 = 1;
		LiDAR	 = 2;
        RealSence= 3;
        subTopicName = {'/wheelchair/odom', ...
                        '/wheelchair/gyr', ...
                        '/scan', ...
                        '/velodyne_points', ...
                        '/camera/depth/color/points', ...
                        '/wheelchair/pose'};
        pubTopicName = {'/wheelchair/cmd_vel'};
        subMsgName = {'nav_msgs/Odometry', ...
                      'geometry_msgs/Point', ...
                      'sensor_msgs/LaserScan', ...
                      'sensor_msgs/PointCloud2', ...
                      'sensor_msgs/PointCloud2', ...
                      'geometry_msgs/Pose'};
        pubMsgName = {'geometry_msgs/Twist'};
	end
	methods
		function obj = rosConectorObj(info, mode, sensor)
			disp('Now is preparing to setup for robot operating system...');
            
			%-- Configulations for ROS
			obj.Count  = 0;
			obj.Mode   = mode;
			obj.Sensor = sensor;
			obj.subTopic   = cell(obj.subTopicNum,1);
			obj.subMessage = cell(obj.subTopicNum,1);
            obj.pubTopic   = cell(obj.pubTopicNum,1);
			obj.pubMessage = cell(obj.pubTopicNum,1);
            
            %-- Setting the environment variables to connect to ROS
			URL = strcat('http://', info.ROSHostIP, ':11311');
			setenv('ROS_MASTER_URI', URL);
			setenv('ROS_IP', info.ROSClientIP);
            
			%-- Connection of ROS core using "rosinit"
			rosshutdown;
			rosinit(URL);
            
			%-- Declaring the node, publishers and subscribers 
			obj.Node	 = robotics.ros.Node('/matlab');
			obj.subTopic = cellfun(@(X, Y) robotics.ros.Subscriber(obj.Node, X, Y), obj.subTopicName, obj.subMsgName, 'UniformOutput', false);
			obj.pubTopic = cellfun(@(X, Y) robotics.ros.Publisher(obj.Node, X, Y),  obj.pubTopicName, obj.pubMsgName, 'UniformOutput', false);
			obj.subMessage = cellfun(@rosmessage, obj.subTopic, 'UniformOutput', false);
            obj.pubMessage = cellfun(@rosmessage, obj.pubTopic, 'UniformOutput', false);

			disp('Translational and rotational Velocities of the wheelchair are being initialized...');
			obj.pubMessage{obj.cmdVel}.Linear.X  = 0.;
			obj.pubMessage{obj.cmdVel}.Angular.Z = 0.;
			send(obj.pubTopic{obj.cmdVel}, obj.pubMessage{obj.cmdVel});
		end
		ret = getData(obj)
		[]  = sendTopic(obj, DataSet)
		[]  = endExperiment(obj)
		[]  = updateData(obj, RawData, EstimatedData, ControledData)
		[]  = saveData2file(obj, Datadir)
	end
end
