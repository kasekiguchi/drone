classdef rosConectorObj < handle
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
		subTopicNum= 3;
		odom	  = 1;
		scan	  = 2;
		
  		%- Publisher topic -%
		pubTopicNum= 1;      
		cmdVel  = 1;
		%- Sensor -%
		Prime	 = 1;
		LiDAR	 = 2;
        RealSence= 3;
        subTopicName = 
        pubTopicName = {'/turtlebot3/cmd_vel'};
        subMsgName = {'nav_msgs/Odometry', ...
                      'sensor_msgs/LaserScan', ...
                      'geometry_msgs/Pose'};
        pubMsgName = {'geometry_msgs/Twist'};
	end
	methods
		function obj = ros2ConectorObj(info, mode, sensor)
			disp('Now is preparing to setup for robot operating system...');
            
			%-- Configulations for ROS
			obj.Count  = 0;
			obj.Mode   = mode;
			obj.Sensor = sensor;
			obj.subTopic   = cell(obj.subTopicNum,1);
			obj.subMessage = cell(obj.subTopicNum,1);
            obj.pubTopic   = cell(obj.pubTopicNum,1);
			obj.pubMessage = cell(obj.pubTopicNum,1);
            
            %-- Setting the environment variables to connect to ROS2
			obj.DomainID = 30;
            
			%-- Declaring the node, publishers and subscribers 
			obj.Node	 = ros2node('/matlab',DomainID);
			obj.subTopic = cellfun(@(X, Y) ros2Subscriber(obj.Node, X, Y), obj.subTopicName, obj.subMsgName, 'UniformOutput', false);
			obj.pubTopic = cellfun(@(X, Y) ros2Publisher(obj.Node, X, Y),  obj.pubTopicName, obj.pubMsgName, 'UniformOutput', false);
			obj.subMessage = cellfun(@ros2message, obj.subTopic, 'UniformOutput', false);
            obj.pubMessage = cellfun(@ros2message, obj.pubTopic, 'UniformOutput', false);

			disp('Translational and rotational Velocities of the wheelchair are being initialized...');
            obj.subMsgName{obj.cmdVel}.linear.x = 0.0;
			obj.pubMessage{obj.cmdVel}.angular.z = 0.0;
			send(obj.pubTopic{obj.cmdVel}, obj.pubMessage{obj.cmdVel});
		end
		ret = getData(obj)
		[]  = sendTopic(obj, DataSet)
		[]  = endExperiment(obj)
		[]  = updateData(obj, RawData, EstimatedData, ControledData)
		[]  = saveData2file(obj, Datadir)
	end
end
