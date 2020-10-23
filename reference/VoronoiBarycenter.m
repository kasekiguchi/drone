classdef VoronoiBarycenter < REFERENCE_CLASS
    % �{���m�C�d�S���Z�o����N���X
    %   �ڍא����������ɋL�q
    properties
        param
        self
    end
    
    methods
        function obj = VoronoiBarycenter(self,varargin)
            obj.self= self;
            if isfield(varargin{1},'r'); obj.param.r = varargin{1}.r;  end
            if isfield(varargin{1},'R'); obj.param.R = varargin{1}.R; else obj.param.R = 100; end
            if isfield(varargin{1},'d'); obj.param.d = varargin{1}.d;  end
            if isfield(varargin{1},'void'); obj.param.void = varargin{1}.void;  end
            obj.result.state = STATE_CLASS(struct('state_list',["p"],'num_list',[3]));
        end
        function  result= do(obj,Param)
            % �yInput�zParam = {sensor,estimator,env,param}
            %  param = range, pos_range, d, void,
            % �yOutput�z result = �ڕW�l�i�O���[�o���ʒu�j
            %% ���ʐݒ�P�F�P���{���m�C�Z���m��
            sensor = obj.self.sensor.result;%Param{1}.result;
            state = obj.self.model.state;%Param{2}.state; % handle ���Ӂ@�\�����
            env = obj.self.env;%Param{3}.param;             % ���Ƃ��ė\����������
%             param = Param{4}; % �r���ŕς�����K�v�����邩�H
%             if isfield(param,'range'); obj.param.r = param.range;  end
%             if isfield(param,'pos_range'); obj.param.R = param.pos_range;  end
%             if isfield(param,'d'); obj.param.d = param.d;  end
%             if isfield(param,'void'); obj.param.void = param.void;  end
            r = obj.param.r; % �d�v�x�𑪋��ł��郌���W
            R = obj.param.R; % �ʐM�����W
            d= obj.param.d; % �O���b�h�Ԋu
            void=obj.param.void; % VOID��
            if isfield(sensor,'neighbor')
                neighbor=sensor.neighbor; % �ʐM�̈���̃G�[�W�F���g�ʒu ��΍��W
            elseif isfield(sensor,'rigid')
                neighbor=[sensor.rigid(1:size(sensor.rigid,2)~=obj.self.id).p];
            end
            if ~isempty(neighbor)% �ʐM�͈͂ɃG�[�W�F���g�����݂��邩�̔���
                neighbor_rpos=neighbor-state.p; % �ʐM�̈���̃G�[�W�F���g�̑��Έʒu
    %        if size(neighbor_rpos,2)>=1 % �אڃG�[�W�F���g�̈ʒu�_�d�ݍX�V
                % �ȉ��͌v�Z���ׂ��������邪�d�ݕt��voronoi�����ƃZ���`�󂪕����
                %     tri=delaunay([0,neighbor_rpos(1,:)],[0,neighbor_rpos(2,:)]); % ���@��(0,0)���������h���l�[�O�p�`����
                %     tmpid=tri(logical(sum(tri==1,2)),:); % 1 �܂莩�@�̂��܂ގO�p�`���������o���D
                %     tmpid=unique(tmpid(tmpid~=1))-1; % tmpid = �אڃG�[�W�F���g�̃C���f�b�N�X �ineighbor_rpos���̃C���f�b�N�X�ԍ��j
                %     neighbor_rpos=neighbor_rpos(:,tmpid); % �אڃG�[�W�F���g�̑��Έʒu
                %     neighbor.pos=neighbor.pos(:,tmpid); % �אڃG�[�W�F���g�̈ʒu
                %     neighbor.weight=sensor_obj.output.neighbor.weight(tmpid); % neighbor weight
                %     neighbor.mass=sensor_obj.output.neighbor.mass(tmpid); % neighbor mass
                Vn=voronoi_region([[0;0;0],(neighbor_rpos)],[R,R;-R,R;-R,-R;R,-R],1:size(neighbor,2)+1);% neighbors�Ƃ̂݃{���m�C�����i���΍��W�j
            else % �ʐM�͈͂ɃG�[�W�F���g�����Ȃ��ꍇ
                Vn=voronoi_region([0;0;0],[R,R;-R,R;-R,-R;R,-R],1);
            end
            V=intersect(sensor.region,Vn{1}); % range_region�Z���T�̌��ʂƂ̋��ʕ����i���΍��W�j
            region=polybuffer(V,-void); % ���̈��VOID�}�[�W���������polyshape
            
            %%
            
            if area(region)<=0 
                %% �̈�̖ʐςO
                % �����ɂ��鑽���̏ꍇ��bug���H�ivoid�����Ƃ��肦��j�Ȃ瓮���Ȃ��iref = state�j
                result=[0;0;0]; % ���Έʒu
                obj.param.region=region;
                region_phi=[];
                yq=[];
                xq=[];
                warning("ACSL : The voronoi region is empty.")
            else
              if ~inpolygon(0,0,region.Vertices(:,1),region.Vertices(:,2))
                % �̈悪���@�̂��܂܂Ȃ��ivoid�����Ƃ��肦��j�Ȃ瓮���Ȃ��iref = state�j
                % �����ɂ��鑽���̏ꍇ��bug���H
                result=[0;0;0]; % ���Έʒu
                obj.param.region=region;
                region_phi=[];
                yq=[];
                xq=[];
                warning("ACSL : The agent is out of the voronoi region.")
              end
                %% ���ʐݒ�Q�F�P���{���m�C�Z���̏d�݊m��
                xq = sensor.xq;
                yq = sensor.yq;
                region_phi = sensor.grid_density;
                in = inpolygon(xq,yq,region.Vertices(:,1),region.Vertices(:,2)); % �i���΍��W�j�����̈攻��
                region_phi = region_phi.*in;  % region_phi(i,j) : grid (i,j) �̈ʒu�ł̏d�v�x�F�����̈�O�͂O
                mass=sum(region_phi,'all'); % �̈�̎���
                cogx=sum(region_phi.*xq,'all')/mass;% �ꎟ���[�����g/����
                cogy=sum(region_phi.*yq,'all')/mass;% �ꎟ���[�����g/����
                result = [cogx;cogy;0]; % ���Έʒu
            end
            % �`��p�ϐ�
            obj.result.region_phi=region_phi;
            obj.result.xq=xq;
            obj.result.yq=yq;
            % �����܂ő��΍��W
            obj.result.region=region.Vertices+state.p(1:2)';
            obj.result.state.p =(result+state.p);%.*[1;1;0]; % �d�S�ʒu�i��΍��W�j
            obj.result.state.p(3) = 1; % ���t�@�����X�����͂P��
            result = obj.result;
        end
        function show(obj,param)
            draw_voronoi({obj.result.region},1,[param.p(1:2),obj.result.p(1:2)]);
        end
        function draw_movie(obj,logger,N,Env)
                rp=strcmp(logger.items,'reference.result.state.p');
                ep=strcmp(logger.items,'estimator.result.state.p');
                sp=strcmp(logger.items,'sensor.result.state.p');
                %sp=strcmp(logger.items,'plant.state.p');
                regionp=strcmp(logger.items,'reference.result.region');
                gridp=strcmp(logger.items,'env.density.param.grid_density');
                tmpref=@(k,span) arrayfun(@(i)logger.Data.agent{k,rp,i}(1:3),span,'UniformOutput',false);
                tmpest=@(k,span) arrayfun(@(i)logger.Data.agent{k,ep,i}(1:3),span,'UniformOutput',false);
                tmpsen=@(k,span) arrayfun(@(i)logger.Data.agent{k,sp,i}(1:3),span,'UniformOutput',false);
                %make_gif(1:1:ke,1:N,@(k,span) draw_voronoi(arrayfun(@(i)  logger.Data.agent{k,regionp,i},span,'UniformOutput',false),span,[tmppos(k,span),tmpref(k,span)],Vertices),@() Env.draw,fig_param);
                make_animation(1:10:logger.i-1,1:N,@(k,span) draw_voronoi(arrayfun(@(i) logger.Data.agent{k,regionp,i},span,'UniformOutput',false),span,[tmpsen(k,span),tmpref(k,span),tmpest(k,span)],Env.param.Vertices),@() Env.show);
                %%
                %    make_animation(1:10:logger.i-1,1,@(k,span) contourf(Env.param.xq,Env .param.yq,logger.Data.agent{k,gridp,span}),@() Env.show_setting());
                make_animation(1:10:logger.i-1,1,@(k,span) arrayfun(@(i) contourf( Env.param.xq,Env .param.yq,logger.Data.agent{k,gridp,i}),span,'UniformOutput',false), @() Env.show_setting());            
        end
    end
end

