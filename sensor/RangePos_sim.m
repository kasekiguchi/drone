classdef RangePos_sim < SENSOR_CLASS
    % RangePos��simulation�p�N���X�F�o�^���ꂽ�G�[�W�F���g�̂������a���̃G�[�W�F���g�̈ʒu��Ԃ�
    %   rpos = RangePos_sim(param)
    %   (optional) param.r : ���a
    %   (optional) param.target : ���@���܂ޑΏ۔z��
    %   param.id : ���̃Z���T�[��ς�ł���@�̂�id�ƈ�v������D
    properties
        name = "RangePos";
      %  result
        interface = @(x) x;
        target % �Z���V���O�Ώۂ�handle object
        self % �Z���T�[��ς�ł���@�̂�handle object
        result
    end
    properties (SetAccess = private) % construct ������ς��Ȃ��l�D
        r = 10;
        id
    end
    
    methods
        function obj = RangePos_sim(self,param)
            %  ���̃N���X�̃C���X�^���X���쐬
            obj.self=self;
            if isfield(param,'r'); obj.r= param.r;end
%            if isfield(param,'target'); obj.target= param.target;end
            obj.id= obj.self.id;
        end
        
        function result = do(obj,varargin)
            % result=rpos.do(Target) : obj.r ���ɂ���Target�̈ʒu��Ԃ��D
            %   result.state : State_obj,  p : position
            % �y���́zTarget �F�ϑ��Ώۂ�Model_obj�̃��X�g
            if ~isempty(varargin)
                Target=varargin{1}{1};
%                obj.target=Target;
            else
                Target=obj.target;
            end
            obj.target=obj.check_range(Target);
            obj.result.neighbor=cell2mat(arrayfun(@(i) obj.target(i).state.p,1:length(obj.target),'UniformOutput',false)); % private �v���p�e�B�Ƃ��Ă�plant�i���V�X�e���j�̏�ԂɃA�N�Z�X�D
            result=obj.result;
        end
        function target=check_range(obj,Target)
            neighbor.p=cell2mat(arrayfun(@(i) Target(i).state.p,1:length(Target),'UniformOutput',false)); % private �v���p�e�B�Ƃ��Ă�plant�i���V�X�e���j�̏�ԂɃA�N�Z�X�D
%             if isempty(obj.self)
%                 obj.self=Target([Target.id]==obj.id); % ���@�̐^�l��Ԃ����̂܂ܓn���D
%             end
            epos=neighbor.p-obj.self.state.p;
            len2=sum(epos.*epos,1); % ���������v�Z
            rid = logical((len2< obj.r^2)-(len2==0)); % �ʐM�͈͓��̃G�[�W�F���gID�C��񍀂͎��@�̂���������
            target=Target(rid);% �Z���T�[�͈͓��̃G�[�W�F���g��Ԃ��D
        end
        function show(obj,varargin)
            if ~isempty(obj.result)
                if isempty(varargin)
                    states=[obj.result.neighbor];
                    points=[states.p];
                    plot(points(:,1),points(:,2),'rx');axis equal;
                else
                    disp("p=");obj.self.state.p
                end
            else
                disp("do measure first.");
            end
        end
    end
end
