classdef TimeVaryingReferenceSuspendedLoad < REFERENCE_CLASS
    % ���Ԋ֐��Ƃ��Ẵ��t�@�����X�𐶐�����N���X
    % obj = TimeVaryingReference()
    properties
        param
        func % ���Ԋ֐��̃n���h��
        self
    end
    
    methods
        function obj = TimeVaryingReferenceSuspendedLoad(self,varargin)
            % �yInput�zref_gen, param, "HL"
            % ref_gen : reference function generator
            % param : parameter to generate the reference function
            % "HL" : flag to decide the reference for HL
            obj.func=str2func(varargin{1}{1});
            obj.func=obj.func(varargin{1}{2});
            if length(varargin{1})>2
                if strcmp(varargin{1}{3},"HL")
                    obj.func = gen_ref_for_HL_Suspended_Load(obj.func);
                    obj.result.state=STATE_CLASS(struct('state_list',["xd","pL","yaw"],'num_list',[20,3,1]));
                end
            else
                obj.result.state=STATE_CLASS(struct('state_list',["xd","pL","yaw"],'num_list',[length(obj.func(0)),3,1]));
            end
        end
        function  result= do(obj,Param)
            % �yInput�zParam = {Time.t}
            obj.result.state.xd = obj.func(Param{1}.t); % �ڕW�d�S�ʒu�i��΍��W�j
            obj.result.state.pL = obj.result.state.xd(1:3);
            obj.result.state.yaw = obj.result.state.xd(4);
            result=obj.result;
        end
        function show(obj,param)
           
        end
    end
end

