classdef WALL_REFERENCE < REFERENCE_CLASS
    % ���m�ł�����ɑ΂��C�ڕW�ʒu(x,y)�C�ڕW�p���p(yaw)�𐶐�����N���X
    % obj = WALL_REFERENCE()
    properties % obj�̒��ɉ����~���������߂鏊
        param
        func % ���Ԋ֐��̃n���h��
        self
        area_params
        region0
        region1
        region2
        area1
        area2
        fShow
        vrtx_len_limit
    end
    methods % ���t�@�����X�N���X
        function obj = WALL_REFERENCE(self,pparam) % do�ւ̋��n���C���g���v�Z�����肵�Č��߂�D1���I�ȕ���
            % �yInput�zref_gen, param, "HL"
            % ref_gen : reference function generator
            % param : parameter to generate the reference function
            % "HL" : flag to decide the reference for HL
            obj.self = self; % self�͌��݂̋@�̈ʒu������
            % obj.self.state.q = quat2eul(obj.self.state.q');
            
            % region�̐��� = region�͕ǖʁC���ȂǊ��m�Ƃ���S�Ă̊����
            % [region�͂܂�0�����C0�����1,2���쐬����D1�͔�s�o�H�C2�͎p���p�̖ڕW�_���o���ۂɎg�p] %
            % region0 : �ϑ����镔���̕ǖʂ⒌�̌`��(2���� x,y) <=���ꂾ�������ō��
            % region2 : region0����d[m]������region0�Ɠ����`����쐬����(���ꂪ�@�̂̔�s�o�H�ƂȂ�)
            % region1 : region2����d[m]�O����region2�Ɠ����`����쐬(���ꂪ�@�̎p���p�̖ڕW�_���쐬����o�H���Ȃ�)
            
            % pparam��Reference_Wall_observation������������Ă������̂�����.pparam=region0�ƂȂ�.
            obj.region0 = pparam.region0;
            obj.vrtx_len_limit = 1.5;
            d = 0.5; %�ǖʂƋ@�̂̋������ǂ̂��炢���������͂��Ă�������.           
            region2 = polybuffer(obj.region0,-d,'JointType','miter','MiterLimit',2); %�z����ɂ�����d [m]�����Ɉړ��o�H�p�|���o�b�t�@�쐬�@��s�o�H
            if isempty(region2.Vertices)
                error("ACSL : the region is too narrow to flight.");%��������Ƃ��̃G���[
            end
            region1 = polybuffer(region2,d,'JointType','miter','MiterLimit',2); % Vertices �̐���region1,2 �ő����邽�߁@�p���p�̃J�����̂��߂̂���
            if length(region1.Vertices(:,1))~=length(region2.Vertices(:,1))
                error("ACSL : The number of vertices is different between regions 1 and 2.");%���_�̐����Ⴄ�G���[
            end
            obj.result.state = STATE_CLASS(struct('state_list',["p","xd"],'num_list',[4,20]));
            
            %             obj.func=str2func(varargin{1}{1});
            %             obj.func=obj.func(varargin{1}{2});
            %             if length(varargin{1})>2
            %                 if strcmp(varargin{1}{3},"HL")
            %                     obj.func = gen_ref_for_HL(obj.func);
            %                     obj.result.state=STATE_CLASS(struct('state_list',["xd","p"],'num_list',[20,3]));
            %                 end
            %             else
            %                 obj.result.state=STATE_CLASS(struct('state_list',["xd","p"],'num_list',[length(obj.func(0)),3]));
            %             end
            
            %����%
            PlotColor=['r';'b';'g'];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%% �����͍� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Angle = 115; % �@�̂̎���p[��/deg]����͂��Ă��������D�S�̂ł͂Ȃ��g�p�ł������Ȑ^�񒆕����݂̂̕����ǂ�����
            Cover = 60;  % �ʐ^�̏d����[%] L���ǂ̒��x�킹�邩�D
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%% ���v�Z�� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�ꕔ�g��Ȃ�����
            area_params.Angle = (Angle/(180/pi))/2; % Angle�̊p�x�����W�A���ɒ����v�Z���s���Ă���D
            L = d * tan(area_params.Angle); % 2L���ϑ��\�ȉ����DL�͔���
            Cover = Cover * 0.01; % ���������ɕϊ�
            D = (2 * L) - ((2 * L)*Cover); % D�͋@�̂�1�X�e�b�v�ňړ����鋗���D��~point���玟�̖ڕW�ʒu�܂ł̋����D
            vrtx_idx = 6; % �t���b�O�Ǘ��p�D���Ɋp��ڕW�ʒu�ɐݒ肷�邽�߂Ɏg�p�D
            P_flag = 1; % ���ɋ@�̂̓����؂�ւ�������Ƃ��Ďg�p�D����Ȃ�����
            counter = 1;% ��~�̂��߂Ɏ��Ԃ��v�Z����悤
            area_params.LRS.Range = d/cos(area_params.Angle);% ��`�̔��a
            %%%%%%%%%%%%%%%%%%%%���v�Z�ɕK�v�ȗv�f��ݒ� %%%%%%%%%%%%%%%%%
            area_params.vrtx_idx = 1;%��flag
            area_params.fCCW = 0; % �ϑ�����ړ����� 0:���v���D1:�����v���
            area_params.curv_limit_num = 10;%�Ȗʂ��ړ�����ۂɔ�΂��_�̍ő吔
            area_params.D = D; % ��L��D
            area_params.counter = 10; % �ڕW�ʒu�ɂ��鎞�Ԃ𐔂���悤
            area_params.stoptime = 40; % �ڕW�ʒu�ɒ�~���鎞�Ԑݒ�D
            area_params.area_idx = 0; % ���Ă�����̂̐؂�ւ��p�@�ǂƒ��Ȃ�
            area_params.fAreaComplete = 2; % ���I����������ʂ���悤
            area_params.update = 1; % �ڕW�ʒu��ς��邩�ǂ����̔��f
            area_params.didx = 1; % �Ȗʏ�ŕǖʂ�1�����I�������̃P�A
            area_params.ka = 1; % ��ʋL�^�p.show�Ŏg�p
            nan_indices=find(isnan(region2.Vertices(:,1)));%nan�̈ʒu�Â� nan�̍s������
            obj.fShow = pparam.fShow;
            %% area �̕��ъ���
            area_num = length(nan_indices)+1;% �G���A�̐�
            if area_num ~= 1 % �����G���A������ꍇ
                tmp = [0;nan_indices;length(region2.Vertices(:,1))+1];
                [~,perm] = sort(arrayfun(@(i) min(vecnorm(obj.self.model.state.p(1:2)'-region2.Vertices(tmp(i)+1:tmp(i+1)-1,:),2,2)),1:area_num));% �e�G���A���_�ւ̍ŒZ�����ŏ����Ƀ\�[�g���邽�߂�permutation
                tmp1 = [];
                tmp2 = [];
                for i = 1:area_num
                    tmp1 = [tmp1;NaN NaN;region1.Vertices(tmp(perm(i))+1:tmp(perm(i)+1)-1,:)];% area����ѕς���region
                    tmp2 = [tmp2;NaN NaN;region2.Vertices(tmp(perm(i))+1:tmp(perm(i)+1)-1,:)];
                end
                region1.Vertices = tmp1(2:end,:);% ����NaN�폜
                region2.Vertices = tmp2(2:end,:);
                area1.Vertices=region1.Vertices(1:nan_indices(1)-1,:);% �ǖ�
                area2.Vertices=region2.Vertices(1:nan_indices(1)-1,:);% ��s�o�H
            else % �̈悪�P��G���A�̏ꍇ
                area1=region1;
                area2=region2;
            end
            nan_indices=find(isnan(region2.Vertices(:,1)));%nan�̈ʒu���Đݒ�
            area_params.nan_indices = [0;nan_indices]; % �擪�ɂO��ǉ��Fempty�̂Ƃ������l�Ɉ�����悤
            
            %% �������|���V�[�C���㒼���Fobj.self
            [obj.area1,obj.area2,obj.area_params] = obj.target_area_gen(obj.self.model,region1,region2,area1,area2,area_params);%
            obj.region1 = region1;
            obj.region2 = region2;
            obj.result.region0 = obj.region0;
            obj.result.region1 = obj.region1;
            obj.result.region2 = obj.region2;
            obj.result.area_params = area_params;
            if isempty(obj.result.state.p)
                % obj.result.state.p = [obj.self.estimator.result.state.p;0];
                obj.result.state.p = [0;0;0;0];
            end
        end
        function result = do(obj,target_height) %��������{��
            %%%%%%%%%%%%%% �ȉ��ɖڕW�ʒu���Z�o���闬����L�q %%%%%%%%%%%%%%%%%%%
            % 1. �O�ǂɋ߂��̈�͊O�ǂɃ}�[�W��area1, area2�𐶐�
            % 2. �t���O�������Ƃ�area2 ��ɖڕW�ʒurpos �ݒ�
            % 3. �Q�̈ʒu�ƃt���O��񂩂�area1��Ɏ����̌���Apos��ݒ�
            % 4. �t���O���̍X�V
            
            [obj.area1,obj.area2,obj.area_params] = obj.target_area_gen(obj.self.estimator.result,obj.region1,obj.region2,obj.area1,obj.area2,obj.area_params); %�P
            obj.area_params = obj.reference_position_gen(obj.self.estimator.result,obj.area1,obj.area2,obj.area_params); %�Q
            obj.area_params = obj.set_target_direction(obj.area1,obj.area_params); %�R
            obj.area_params = obj.update_flags(obj.self.estimator.result,obj.area_params); %�S
            % ���t�@�����X�ݒ�
            obj.result.area_params = obj.area_params;
            obj.result.state.p  = [obj.area_params.rpos;target_height{1};atan2(obj.area_params.Apos(2)-obj.area_params.rpos(2),obj.area_params.Apos(1)-obj.area_params.rpos(1))];
            obj.result.state.xd = [obj.area_params.rpos;target_height{1};atan2(obj.area_params.Apos(2)-obj.area_params.rpos(2),obj.area_params.Apos(1)-obj.area_params.rpos(1))];
            result = obj.result;
            if obj.fShow
                obj.show();
            end
        end
        function show(obj,param) % main��while�񂷂��т�plot�\�������镔��
            %             if (obj.area_params.fAreaComplete==2 && obj.area_params.update==1)  || obj.fShow == 1
            clf(figure(2));
            %%%%%%%%%%%%%%%%%%%%%%%% ���O���t�ŖڕW�ʒu��ݒ�  %%%%%%%%%%%%%%%%%%%%%%%%
            %       plot(Target.Point(1,:),Target.Point(2,:),'k:o', 'MarkerSize',20,'MarkerEdgeColor','black','MarkerFaceColor','green','DisplayName','Target Point');
            %%%%%%%%%%%%%%%%%%%%%%%% ���O���t��o���쐬����  %%%%%%%%%%%%%%%%%%%%%%%%%%%
            hold on;
            set( gca, 'FontSize', 26); % �����̑傫���ݒ�
            axis equal;
            axis([0 6 0 6]);
            daspect([1 1 1])
            %if wall.flag==1
            d  = 2; % ������d�͉���pgon�݂̂ŗ��p
            pgon = polybuffer(obj.region0,d,'JointType','square');
            frame=[min(pgon.Vertices);max(pgon.Vertices)];
            plot(obj.region0);
            xlim(frame(:,1)');
            ylim(frame(:,2)');
            hold on
            % xlim([min(obj.region0.Vertices(:,1))-2 max(obj.region0.Vertices(:,1))+2]);ylim([min(obj.region0.Vertices(:,2))-2 max(obj.region0.Vertices(:,2))+2]);
            plot (obj.region2,'FaceColor','w');
            %%%%%%%%%%%%%%%%%%%%%%%%% ���ڕW�ʒu�\��(��) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            plot (obj.area_params.Apos(1,1),obj.area_params.Apos(2,1),'k:o', 'MarkerSize',19,'MarkerEdgeColor','black','MarkerFaceColor','yello','DisplayName','Target Point');
            plot (obj.area_params.vpos(1,1),obj.area_params.vpos(2,1),'k:x', 'MarkerSize',19,'MarkerEdgeColor','black','MarkerFaceColor','yello','DisplayName','Target Point');
            plot (obj.area_params.vppos(1,1),obj.area_params.vppos(2,1),'k:x', 'MarkerSize',19,'MarkerEdgeColor','black','MarkerFaceColor','yello','DisplayName','Target Point');
            plot (obj.area_params.Vpos(1,1),obj.area_params.Vpos(2,1),'k:x', 'MarkerSize',19,'MarkerEdgeColor','black','MarkerFaceColor','yello','DisplayName','Target Point');
            plot (obj.area_params.Vppos(1,1),obj.area_params.Vppos(2,1),'k:x', 'MarkerSize',19,'MarkerEdgeColor','black','MarkerFaceColor','yello','DisplayName','Target Point');
            plot(obj.result.state.p(1,:),obj.result.state.p(2,:),'k:o', 'MarkerSize',19,'MarkerEdgeColor','black','MarkerFaceColor','red','DisplayName','Target Point');
            plot(obj.self.model.state.p(1,1),obj.self.model.state.p(2,1),"k:.", 'MarkerSize',40,'DisplayName','State of obj.self');%�@�̈ʒu�̕\��
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % yaw = quat2eul(obj.self.model.state.q');%�I�C���[�p�ɂ��ĕ�����ω��ł��Ă��邩�m�F����D
            OUGI = obj.arc(obj.area_params.LRS.Range,obj.self.model.state.p(1,1),obj.self.model.state.p(2,1),obj.area_params.Angle,obj.self.model.state.q(3));%�ϑ������̕\��(��`�̔��a,�@��X,�@��Y,��`�̊p�x,�@��yaw,�F(��))
            %     xticklabels({'0','20','40','60','80','100'})
            %     yticklabels({'0','20','40','60','80','100'})
            xlabel('{\sl x} [m]','FontSize',18);ylabel('{\sl y} [m]','FontSize',18);
            grid on;
            hold off;
            % M(obj.area_params.ka) = getframe(gcf);
            % obj.area_params.ka = obj.area_params.ka + 1;
            obj.fShow = 1;
            %             end
        end
        function draw_movie(obj,logger) % ����𕔕��i�������j
            %%%%%%%%%%%%%%%%%%%%%%%�ȉ������摜�쐬�p�ۑ���%%%%%%%%%%%%%%%%%%%%%%%%
            SAVE.k(:,ka) = ka;
            %SAVE.obj.self.input(:,ka) = obj.self.input;
            SAVE.AngleTarget(:,ka) = area_params.Apos;
            SAVE.obj.self.model.state.q(:,ka) = obj.self.model.state.q;%�@�̈ʒu���d�˂ĉ摜�Ɏg�p�Ƃ����D
            SAVE.obj.self.model.state.p(:,ka) = obj.self.model.state.p;%�@�̈ʒu���d�˂ĉ摜�Ɏg�p�Ƃ����D
            SAVE.obj.self.reference.point.result.state.p(:,ka) = obj.self.reference.point.result.state.p;%�@�̈ʒu���d�˂ĉ摜�Ɏg�p�Ƃ����D
            M(ka) = getframe(gcf);%����쐬�p
            ka = ka + 1;
        end
        %% ��[do�ȂǂŎg���֐���`]
        function D = arc(obj,r,xc,yc,omega,alpha) % show�Ŏg�p�����`�v���b�g�pfunction
            %%�ϑ������̕\��(��`�̔��a,�@��X,�@��Y,��`�̊p�x,�@��yaw)
            % r  : radius of obj.arc
            % xc : position x
            % yc : position y
            gamma=alpha-omega;%yaw-��̊p�x
            theta = linspace(0,omega*2);
            x = r*cos(theta+gamma) + xc;
            y = r*sin(theta+gamma) + yc;
            D=fill(x,y,'r');
            set(D,'FaceColor','red','FaceAlph',0.1,'EdgeColor','none');
            hold on;
            D=plot(x,y,'r');
            hold on;
            X=[xc x(1,1) xc x(1,end)];
            Y=[yc y(1,1) yc y(1,end)];
            D=plot(X,Y,'red');
            hold on;
            X=[xc x(1,1) x(1,end)];
            Y=[yc y(1,1) y(1,end)];
            D=fill(X,Y,'red');
            set(D,'FaceColor','red','FaceAlph',0.1,'EdgeColor','none');
        end
        function d = angle_diff(obj,a,b)
            % d : ����a,b �̃x�N�g���̓���
            d = cos(a)*cos(b)+sin(a)*sin(b);
        end
        function pos = projection_point(obj,p1,p2,p3)
            %  pos = p1-p2�@�����ւ�p3���牺�낵�������̑�
            a = p1(1);
            b = p1(2);
            c = p2(1);
            d = p2(2);
            X = p3(1);
            Y = p3(2);
            %%
            % syms a b c d x y X Y al be ga la s real
            % A=[a;b];
            % B=[c;d];
            % O=[X;Y];
            % H = [x;y];
            % ans0=solve([(A-B)'*(H-O)==0;H == s*A+(1-s)*B],[x,y,s]);
            % % J = (X-x)^2+(Y-y)^2  - la*(al*x+be*y + ga); �̍œK������
            % Jx=2*(X-x)+la*al==0;
            % Jy=2*(Y-y)+la*be ==0;
            % Jla = al*x+be*y + ga==0;
            % inner_prod = [(c-a), (d-b)]*[(X-x);(Y-y)]==0;
            % ans0=solve([al*a+be*b + ga==0;al*c+be*d + ga==0;inner_prod;Jx;Jy;Jla],[al,be,ga,x,y,la]);
            %%
            if (a^2 - 2*a*c + b^2 - 2*b*d + c^2 + d^2)~=0
                pos=[(X*a^2 - a*b*d + Y*a*b - 2*X*a*c + a*d^2 - Y*a*d + b^2*c - b*c*d - Y*b*c + X*c^2 + Y*c*d);       (a^2*d - a*b*c + X*a*b - a*c*d - X*a*d + Y*b^2 + b*c^2 - X*b*c - 2*Y*b*d + X*c*d + Y*d^2)]/(a^2 - 2*a*c + b^2 - 2*b*d + c^2 + d^2);
            else
                pos=[X;Y];
            end
            
            %%
        end
        function [area1,area2,area_params] = target_area_gen(obj,agent,region1,region2,area1,area2,area_params)
            % �����ꗗ�F�G���A�����I������C�ڕW�n�_�X�V
            if area_params.fAreaComplete==2 && area_params.update==1
                area_idx = area_params.area_idx;
                nan_indices = area_params.nan_indices;
                fCCW = area_params.fCCW;
                
                if area_idx+1 == length(nan_indices)
                    area1.Vertices=region1.Vertices(nan_indices(area_idx+1)+1:end,:);
                    area2.Vertices=region2.Vertices(nan_indices(area_idx+1)+1:end,:);
                    area_idx=area_idx+1;
                else
                    if area_idx == length(nan_indices)
                        area_idx=1;
                    else
                        area_idx=area_idx+1;
                    end
                    %        if length(nan_indices)>2
                    if sum(nan_indices ~= [0])
                        area1.Vertices=region1.Vertices(nan_indices(area_idx)+1:nan_indices(area_idx+1)-1,:);
                        area2.Vertices=region2.Vertices(nan_indices(area_idx)+1:nan_indices(area_idx+1)-1,:);
                    end
                end
                %% area2, vpos, vppos�̐ݒ�Fagent �ʒu�ɉ�����area ���Ĕz�u�iagent�ŋߖTvertex��CW�łP��CCW��X�Ɂj
                apos=agent.state.p(1:2); % agent position
                X = length(area2.Vertices(:,1));
                [~,vrtx_idx]=min(vecnorm(apos'-area2.Vertices,2,2)); % ���Ȉʒu�ɋ߂��_��I��
                if fCCW
                    area2.Vertices = [area2.Vertices(vrtx_idx+1:end,:);area2.Vertices(1:vrtx_idx,:)];
                    vppos = area2.Vertices(1,:)';
                    area1.Vertices = [area1.Vertices(vrtx_idx+1:end,:);area1.Vertices(1:vrtx_idx,:)];
                    Vppos = area1.Vertices(1,:)';
                    vrtx_idx = X;
                else
                    area2.Vertices = [area2.Vertices(vrtx_idx:end,:);area2.Vertices(1:vrtx_idx-1,:)];
                    vppos = area2.Vertices(X,:)';
                    area1.Vertices = [area1.Vertices(vrtx_idx:end,:);area1.Vertices(1:vrtx_idx-1,:)];
                    Vppos = area1.Vertices(X,:)';
                    vrtx_idx = 1;
                end
                vpos = area2.Vertices(vrtx_idx,:)';
                Vpos = area1.Vertices(vrtx_idx,:)';
                
                area_params.rpos = vpos;
                area_params.Apos = Vpos;
                area_params.area_idx  = area_idx;
                area_params.vpos = vpos;
                area_params.vppos = vppos;
                area_params.Vpos = Vpos;
                area_params.Vppos = Vppos;
                area_params.vrtx_idx = vrtx_idx;
                area_params.X = X;
                area_params.fAreaComplete = 0;
                area_params.update = 1;
            end
        end
        function area_params = reference_position_gen(obj,agent,area1,area2,area_params)
            if area_params.update % �ڕW�n�_�X�V
                apos = agent.state.p(1:2);
                rpos=area_params.rpos;
                vpos=area_params.vpos;
                vppos=area_params.vppos;
                Vpos=area_params.Vpos;
                Apos=area_params.Apos;
                D=area_params.D;
                vrtx_idx=area_params.vrtx_idx;
                X=area_params.X;
                fCCW = area_params.fCCW;
                didx = 1;
                curv_limit_num = area_params.curv_limit_num;
                % �ڕW���p�Ŋp�����Ă���Ƃ�
                if prod([vpos;Apos] == [rpos;Vpos])
                    tmp = vrtx_idx;
                    [vrtx_idx,fLoop] = obj.vrtx_idx_func(vrtx_idx,1,X,fCCW);
                    % �ڕW�ʒu���߂�����ꍇ�̃P�A�F�Ȗʑ΍�
                    
                    while norm(area2.Vertices(vrtx_idx,:)'-area2.Vertices(tmp,:)')<obj.vrtx_len_limit && abs(vrtx_idx-tmp) < curv_limit_num
                        [vrtx_idx,fLoop] = obj.vrtx_idx_func(vrtx_idx,1,X,fCCW);
                        didx = didx+1;
                    end
                    vppos = vpos;
                    vpos = area2.Vertices(vrtx_idx,:)';
                    area_params.Vppos = Vpos;
                    area_params.Vpos = area1.Vertices(vrtx_idx,:)';
                    if fLoop == 1
                        area_params.fAreaComplete = 1;
                    end
                else
                    if norm(vpos-apos) < D
                        area_params.rpos = vpos;
                    else
                        area_params.rpos = apos + D*(vpos-vppos)/norm(vpos-vppos);
                    end
                end
                area_params.didx= didx;
                area_params.vpos = vpos;
                area_params.vppos = vppos;
                area_params.vrtx_idx = vrtx_idx;
            end
        end
        function area_params = set_target_direction(obj,area1,area_params)
            if area_params.update % �ڕW�n�_�X�V
                rpos=area_params.rpos;
                Vpos=area_params.Vpos;
                Vppos=area_params.Vppos;
                Apos=area_params.Apos;
                area_params.Apos = obj.projection_point(Vpos,Vppos,rpos);
                % �p�ɂ��āC�p�����Ă��Ȃ��ꍇ
                if prod(area_params.Apos == Apos) && ~prod(Vpos == Apos)
                    area_params.Apos=Vpos;
                end
                if prod(Vpos == Vppos)
                    vrtx_idxn = obj.vrtx_idx_func(find(sum(area1.Vertices==Vpos',2)==2),1,area_params.X,area_params.fCCW);
                    area_params.Vnpos=area1.Vertices(vrtx_idxn,:)';
                    area_params.Apos= obj.projection_point(area_params.Vnpos,Vpos,rpos);
                end
            end
        end
        function area_params = update_flags(obj,agent,area_params)
            % update : �ڕW�n�_�̍X�V
            % fAreaComplete : �G���A�����I��������̔���
            rpos=area_params.rpos;
            vppos=area_params.vppos;
            update = area_params.update;
            fAreaComplete = area_params.fAreaComplete;
            vrtx_idx = area_params.vrtx_idx;
            X = area_params.X;
            counter = area_params.counter;
            stoptime = area_params.stoptime;
            fCCW = area_params.fCCW;
            didx=area_params.didx;
            if update == 1
                if vppos == rpos % �ڕW���p�ɂ��鎞
                    [~,fLoop] = obj.vrtx_idx_func(obj.vrtx_idx_func(vrtx_idx,-didx-1,X,fCCW),didx,X,fCCW);
                    if fLoop == 1  && fAreaComplete == 1
                        area_params.fAreaComplete = 2;
                    end
                end
                update = 0;% �ڕW�ʒu�̍X�V�����邩
            end
            %% update counterer
            Lra = obj.result.state.p(1:2) - agent.state.p(1:2);
            %                          yaw = quat2eul(obj.self.model.state.q');
            if norm(Lra) < 0.15 %&& obj.angle_diff(yaw(3),obj.result.state.p(4))>0.85
                counter = counter+1;
                if counter > stoptime %��~����
                    update = 1;
                    counter = 0;
                end
            end
            area_params.counter = counter;
            area_params.update = update;
        end
        function [idx,flag]  = vrtx_idx_func(obj,idx,num,X,fCCW)
            if fCCW
                idx = idx - num;
            else
                idx = idx + num;
            end
            flag = 1;
            if idx < 1
                idx = X+idx;
            elseif idx > X
                idx = idx-X;
            else
                flag = 0;
            end
        end
        function [region0] = regions(Q)
            if Q == 0 % �������p
                th=pi/2:-0.1:-0.1;
                x1 = [5+5*cos(th) 10 0 0 5];
                y1 = [5+5*sin(th) 0 0 10 10];
                %  x1 = [10 0 0 10];
                %  y1 = [0 0 10 10];
                x2 = [6 4 4 6];
                y2 = [4 4 6 6];
                region0 = polyshape({x1,x2},{y1,y2}); %�h�[�i�c�`
                %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
                xlim([-2 12]);ylim([-2 12])
                
            elseif Q == 1 % ���ƋȖ�
                th=pi/2:-0.1:-0.1;
                x1 = [5+5*cos(th) 10 0 0 5];
                y1 = [5+5*sin(th) 0 0 10 10];
                %  x1 = [10 0 0 10];
                %  y1 = [0 0 10 10];
                x2 = [6 4 4 6];
                y2 = [4 4 6 6];
                region0 = polyshape({x1,x2},{y1,y2}); %�h�[�i�c�`
                %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
                xlim([-2 12]);ylim([-2 12])
                
            elseif  Q == 2 % ����Ȋ�
                thh=0:0.1:2*pi;
                th=0:-0.1:-pi/2;
                x1 = [7 0 0 3 3 0 0 5 5 10 10 14 7+7*cos(th)];
                y1 = [0 0 9 9 10 10 14 14 16 16 14 14 7+7*sin(th)];
                % x2 = [5 3 3 5];
                % y2 = [3 3 5 5];
                x2 = [4.5+1*cos(thh)];%�~��
                y2 = [4.5+1*sin(thh)];%�~��
                x3 = [10 8 8 10];
                y3 = [8 8 10 10];
                region0 = polyshape({x1,x2,x3},{y1,y2,y3}); %�h�[�i�c�`
                %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
                xlim([-2 16]);ylim([-2 18])
                
            elseif  Q == 3 % ���Q
                th=pi/2:-0.1:-0.1;
                x1 = [15 0 0 15];
                y1 = [0 0 15 15];
                x2 = [5 3 3 5];
                y2 = [3 3 5 5];
                x3 = [12 8 8 12];
                y3 = [8 8 12 12];
                region0 = polyshape({x1,x2,x3},{y1,y2,y3}); %�h�[�i�c�`
                xlim([-2 17]);ylim([-2 17]);
            end
        end
    end
end