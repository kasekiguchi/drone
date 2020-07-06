classdef Approximate_Differentiation < ESTIMATOR_CLASS
    
    properties
        previous
        result
        dt
        list
        num_list
        return_list
        self
    end
    
    methods
        function obj = Approximate_Differentiation(self,param)
            %UNTITLED ���̃N���X�̃C���X�^���X���쐬
            %   �ڍא����������ɋL�q
            obj.self = self;
            model = self.model;
            obj.result.state=state_copy(model.state); % STATE_CLASS�Ƃ��ăR�s�[
            obj.previous=state_copy(model.state); % STATE_CLASS�Ƃ��ăR�s�[
            obj.dt=model.dt;
            if isfield(param,'list')
                obj.list = param.list(1,:);
                obj.return_list = param.list(2,:);
            end
%             obj.result.state=STATE_CLASS(struct('state_list',obj.list,'num_list',obj.num_list)); % STATE_CLASS�Ƃ��ăR�s�[
        end
        
        function result=do(obj,param,varargin)
            % param(optional) : list  = ['p', 'q';'v', 'w'] 
            %           : the first row is a list to be applied
            %           : the second row is a list of vars storred the result
            if ~isempty(varargin)
                sensor = varargin{1};
            else
                sensor = obj.self.sensor.result;
            end            
            if isfield(sensor,'dt')
                obj.dt = sensor.dt;
            end
            if isfield(sensor,'state')
                sensor = sensor.state;
            end
            if length(param) == 2
                obj.list = param{2}(1,:);
                obj.return_list = param{2}(2,:);
            end            
            for i = 1:length(obj.list)
                if strcmp(obj.list(i),'q')
                    obj.result.state.set_state(obj.list(i),sensor.q); % �S�ẴZ���T�[�Ɏp������Ԃ����͕K��STATE_CLASS�Ƃ�������������getq�ł���D
                else
                    obj.result.state.(obj.list(i)) = sensor.(obj.list(i));
                end
                % ��ޔ���
                obj.result.state.(obj.return_list(i))=(obj.result.state.(obj.list(i))-obj.previous.(obj.list(i)))/obj.dt;
            end
            obj.previous = state_copy(obj.result.state);
            result=obj.result;
        end
        function show()
        end
    end
end

