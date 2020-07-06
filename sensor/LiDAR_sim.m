classdef LiDAR_sim < SENSOR_CLASS
    % �����؁F�P��LiDAR�i�S���ʃZ���T�[�j��simulation�p�N���X
    %   lidar = LiDAR(param)
    %   (optional) radius = 1 default 40 m
    %   (optional) angle_range = -pi/2:0.1:pi/2 default -pi:0.1:pi
    properties
        name = "LiDAR";
        result
        self
        interface = @(x) x;
    end
    properties (Access = private) % construct ������ς��Ȃ��D
        radius = 40;
        angle_range = -pi:0.1:pi;
    end
    
    methods
        function obj = LiDAR_sim(self,param)
            obj.self=self;
            %  ���̃N���X�̃C���X�^���X���쐬
            % radius, angle_range
            if isfield(param,'interface'); obj.interface = Interface(param.interface);end
            if isfield(param,'radius'); obj.radius = param.radius;         end
            if isfield(param,'angle_range');  obj.angle_range = param.angle_range;end
        end
        
        function result = do(obj,param)
            % result=lidar.do(param)
            %   result.region : �Z���T�[�̈�i�Z���T�[�ʒu�����_�Ƃ����jpolyshape
            %   result.length : [1 0]����̊p�x��angle,
            %   angle_range �ŋK�肳�������̋�������ׂ��x�N�g���F�P��LiDAR�̏o�͂�͋[
            % �y���́zparam = {Env}        Plant �F����ΏہC Env�F���^�l
            Plant=obj.self.plant;
            Env=param;
            tmp = obj.angle_range;            
            pos=Plant.state.p; % �����
            circ=[obj.radius*cos(tmp);obj.radius*sin(tmp)]';
            if tmp(end)-tmp(1) > pi
                %sensor_range=polyshape(circ(:,1)+pos(1),circ(:,2)+pos(2)); % �G�[�W�F���g�̈ʒu�𒆐S�Ƃ����~
                sensor_range=polyshape(circ(:,1),circ(:,2)); % �G�[�W�F���g�̈ʒu�𒆐S�Ƃ����~
            else
                %sensor_range=polyshape([pos(1);circ(:,1)+pos(1)],[pos(2);circ(:,2)+pos(2)]); % �G�[�W�F���g�̈ʒu�𒆐S�Ƃ����~
                sensor_range=polyshape([0;circ(:,1)],[0;circ(:,2)]); % �G�[�W�F���g�̈ʒu�𒆐S�Ƃ����~
            end
            env = polyshape(Env.param.Vertices-pos(1:2)'); %���ΓI�Ȋ�
            
            result.region=intersect(sensor_range,env);
            %% �o�͂Ƃ��Đ��`
            %result.region.Vertices=result.region.Vertices-pos(1:2)'; % ���ΓI�ȑ����̈�
            
            %lineseg(1:2:size(circ,1)*2,:)=circ;
            %in=intersect(result.region,[lineseg;0 0]);
            for i = 1:length(circ)
                in=intersect(result.region,[circ(i,:);0 0]);
                if ~isempty(in)
                    in=setdiff(in(~isnan(in(:,1)),:),[0 0],'rows'); % ���[�U�[�Ɨ̈�̌�_
                    [~,mini]=min(vecnorm(in')');
                    result.sensor_points(i,:)=in(mini,:);
                end
            end
            result.length=vecnorm(result.sensor_points'); % ���[�U�[�_�܂ł̋���
            %result.region=intersect(polyshape(result.sensor_points(:,1),result.sensor_points(:,2)),env); % 
            obj.result=result;
        end
        function show(obj,~)
            if ~isempty(obj.result)
                points(1:2:2*size(obj.result.sensor_points,1),:)=obj.result.sensor_points;
                plot([points(:,1);0],[points(:,2);0],'r-');hold on; plot(obj.result.region);axis equal;
            else
                disp("do measure first.");
            end
        end
    end
end
