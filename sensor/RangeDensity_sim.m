classdef RangeDensity_sim < SENSOR_CLASS
    % RangeDensity��simulation�p�N���X�F�o�^���ꂽ�G�[�W�F���g�̂������a���̃G�[�W�F���g�̈ʒu��Ԃ�
    %   rdensity = RangeDensity_sim(param)
    %   (optional) param.r : ���a
    %   param.id : ���̃Z���T�[��ς�ł���@�̂�id�ƈ�v������D
    properties
        name = "";
        result
        interface = @(x) x;
        target % �ϑ��Ώۂ̊�
        self % �Z���T�[��ς�ł���@�̂�handle object
    end
    properties (SetAccess = private) % construct ������ς��Ȃ��l�D
        r = 10;
        id
    end
    
    methods
        function obj = RangeDensity_sim(self,param)
            obj.self=self;
            %  ���̃N���X�̃C���X�^���X���쐬
            if isfield(param,'r'); obj.r= param.r;end
            %            if isfield(param,'target'); obj.target= param.target;end
            obj.id= self.id;
%             else
%                 disp('"id" field is required.');
%             end
        end
        
        function result = do(obj,varargin)
            % result=rdensity.do(varargin) : obj.r ����density map��Ԃ��D
            %   result.state : State_obj,  p : position
            % �y���́zvarargin = {{Env}}      agent : �Z���T�[��ς�ł���@��obj,    Env�F�ϑ��Ώۂ�Env_obj
                param=varargin{1}{1}.param;
%                obj.self=varargin{1}{1};
            state=obj.self.state; % �^�l
            env = polyshape(param.Vertices);
            
            %% �Z���V���O�̈���`
            tmp = 0:0.1:2*pi;
            sensor_range=polyshape(state.p(1)+obj.r*sin(tmp),state.p(2)+obj.r*cos(tmp)); % �G�[�W�F���g�̈ʒu�𒆐S�Ƃ����~
            
            %% �̈�Ɗ���intersection�������̈�
            region=intersect(sensor_range, env); % �����̈�
            region.Vertices=region.Vertices-state.p(1:2)'; % ���ΓI�ȑ����̈�
            
            %% �d�ݕ��z
            pxy=state.p(1:2)'-param.map_min; % �̈捶�����猩���G�[�W�F���g���W
            pmap_min=max(pxy+[-obj.r,-obj.r],[0,0]); % �G�[�W�F���g�𒆐S�Ƃ����Z���T�[�����W�̒���������W
            pmap_max=min(pxy+[obj.r,obj.r],param.map_max-param.map_min); % �E����W
            rpmap_min=pmap_min-pxy; % ���΍��W �Fgrid�����邽�߂ɓ����ɂȂ�悤ceil���Ă���
            rpmap_max=pmap_max-pxy; %  ���΍��W �Fgrid�����邽�߂ɓ����ɂȂ�悤floor���Ă����D
%             rpmap_min=ceil((pmap_min-pxy)/param.d); % ���΍��W �Fgrid�����邽�߂ɓ����ɂȂ�悤ceil���Ă���
%             rpmap_max=floor((pmap_max-pxy)/param.d); %  ���΍��W �Fgrid�����邽�߂ɓ����ɂȂ�悤floor���Ă����D
            [xq,yq]=meshgrid(rpmap_min(1):param.d:rpmap_max(1),rpmap_min(2):param.d:rpmap_max(2));% ���΍��W
            xq=xq';      yq=yq'; % cell index�͍��ォ�炾���C���W�n�͍�������Ȃ̂ō��W�n�ɍ��킹��悤�ɓ]�u����D
%    [xq,yq]=meshgrid(rpmap_min(1):param.d:rpmap_max(1),rpmap_max(2):-param.d:rpmap_min(2));% ���΍��W
    
            % �Ώۗ̈�̏d�v�x�}�b�v�����o��
            min_grid_cell=floor(pmap_min/param.d);
            min_grid_cell(min_grid_cell==0)=1; % ���ꂪ������0����ɂȂ��Ă��܂�
            max_grid_cell=min_grid_cell+size(xq)-[1 1]; % region_phi �� in�̃T�C�Y�����킹�邽��
            region_phi=param.grid_density(min_grid_cell(1):max_grid_cell(1),min_grid_cell(2):max_grid_cell(2));% ���ΓI�ȏd�v�x�s��
            in = inpolygon(xq,yq,region.Vertices(:,1),region.Vertices(:,2)); % �i���΍��W�j�����̈攻��
            

            result.grid_density = region_phi.*in-0*(~in);  % region_phi(i,j) : grid (i,j) �̈ʒu�ł̏d�v�x�F�����̈�O��0
            %result.grid_pos=-rpmap_min; % region_phi ����`����Ă���grid ���W��ł̃G�[�W�F���g�̈ʒu�Z��
            result.xq=xq;
            result.yq=yq;
            result.map_max=rpmap_max;
            result.map_min=rpmap_min;
            %% �o�͂Ƃ��Đ��`
            result.region=region;
            
            obj.result = result;
        end
        function show(obj,varargin)
            if ~isempty(obj.result)
                contourf(obj.result.xq,obj.result.yq,obj.result.grid_density);
%            surf(obj.result.xq,obj.result.yq,obj.result.grid_density);
                obj.draw_setting();
            else
                disp("do measure first.");
            end
        end
        function [] = draw_setting(obj)
            %axes1=axes('Parent',fig);
            daspect([1 1 1])
            %set(axes1,'FontName','Times New Roman','FontSize',20,'XTick',(obj.min(1):(obj.max(1)-obj.min(1))/5:obj.max(1)),'YTick',(obj.min(2):(obj.max(2)-obj.min(2))/5:obj.max(2)));
            xlabel('x [m]');
            ylabel('y [m]');
            xlim([obj.result.map_min(1) obj.result.map_max(1)]);
            ylim([obj.result.map_min(2) obj.result.map_max(2)]);
            view(0, 90);
            cmap=[[1 1 1];parula];
            colormap(cmap)
            colorbar
            %caxis([-50 255])
            grid on;
        end

    end
end
