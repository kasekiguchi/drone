classdef DensityMap_sim < ENV_CLASS
    % ���ݒ�
    % �p��
    % map �F���X�P�[���̃}�b�v
    % grid : ���X�P�[���}�b�v�ɃO���b�h��؂�������
    %
    % Properties
    % param : a structure consists of following field
    %         Vertex % �̈���K�肷��polygon �̒��_
    %         discrete = 1 % ���U���t���O �F�Ƃ肠�������U�����Ői�߂�D
    %         d % grid�ԋ���
    %         map_min % polygon�����钷���`��̍ŏ��l���W
    %         map_max % polygon�����钷���`��̍ő�l���W
    %         xq % x �����̊egrid�ɑΉ����������W�F n x 1
    %         yq % y �����̊egrid�ɑΉ����������W�F n x 1
    %         phi % phi(i) : (xq(i), yq(i)) �̈ʒu�ł̏d�v�x�̒l�Dn x 1  : = reshape(grid_density,[n 1]);
    %         grid_density % �egrid �_�ł�density �l grid_density(i,j) : �����W��d (i, j) �̈ʒu�ɂ���Z���̏d�v�x
    %         grid_row % grid �̍s�� : min:d:max
    %         grid_col % grid �̗� : min:d:max
    %         grid_n % grid �� row x col
    %         param % property ��name �ȊO���ׂ�param�̃t�B�[���h�ɂ��Ă������ƁD
    properties
        name % ��Fbldg1
        id
        param
    end
    methods
        function obj = DensityMap_sim(~,param)
            obj.param=param;
            % ���̃N���X�̃C���X�^���X���쐬
            obj.name = param.name;
            if ~strcmp(obj.name,"none")
                %obj.Vertex=obj.param.Vertex;
                if isfield(obj.param,'sigma')
                    density_sigma=obj.param.sigma;
                else
                    density_sigma=0.04;
                    obj.param.sigma=0.04;
                end
                %[obj.grid_density,obj.map_max,obj.map_min,obj.xq,obj.yq,obj.phi]=gen_map(Vertex,d,density_pos,density_sigma);
                [obj.param.grid_density,obj.param.map_max,obj.param.map_min,obj.param.xq,obj.param.yq]=gen_map(obj.param.Vertices,obj.param.d,obj.param.q,density_sigma);
                %obj.d=obj.param.d;
                obj.param.discrete=1;
                obj.param.grid_row=length(obj.param.map_min(1):obj.param.d:obj.param.map_max(1));
                obj.param.grid_col=length(obj.param.map_min(2):obj.param.d:obj.param.map_max(2));
                obj.param.grid_n = obj.param.grid_row*obj.param.grid_col;%length(obj.row)*length(obj.col);
            end
        end
        function [] = show(obj,varargin)
            %s=surf(1:obj.grid_row,1:obj.grid_col,obj.grid_density);
            %s.VertexColor = 'none';
            %pcolor(obj.param.xq,obj.param.yq,obj.param.grid_density);
            contourf(obj.param.xq,obj.param.yq,obj.param.grid_density);
            %            surf(obj.param.xq,obj.param.yq,obj.param.grid_density);
            obj.show_setting();
        end
        function [] = show_setting(obj)
            %axes1=axes('Parent',fig);
            daspect([1 1 1])
            %set(axes1,'FontName','Times New Roman','FontSize',20,'XTick',(obj.min(1):(obj.max(1)-obj.min(1))/5:obj.max(1)),'YTick',(obj.min(2):(obj.max(2)-obj.min(2))/5:obj.max(2)));
            xlabel('x [m]');
            ylabel('y [m]');
            xlim([obj.param.map_min(1) obj.param.map_max(1)]);
            ylim([obj.param.map_min(2) obj.param.map_max(2)]);
            view(0, 90);
            cmap=[[1 1 1];parula];
            colormap(cmap)
            colorbar
            %caxis([-50 255])
            grid on;
        end
    end
end

