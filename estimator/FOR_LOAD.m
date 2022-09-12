classdef FOR_LOAD < SENSOR_CLASS
      properties
        state
        result
        rigid_num
        self
    end
    
    methods
        function obj = FOR_LOAD(self,varargin)
            obj.self= self;
            if ~isempty(varargin)
                if isfield(varargin{1},'rigid_num')
                    obj.rigid_num = varargin{1,1}.rigid_num;
                end
            end
            obj.result.state = STATE_CLASS(struct('state_list',["p","q","pL","pT"],"num_list",[3,4,3,3]));
            if sum(contains(self.model.state.list,"q"))==1
                obj.result.state.num_list=[3,length(self.model.state.q),3]; % model‚Æ‡‚í‚¹‚é
                obj.result.state.type = length(self.model.state.q);
            end
        end
        
        function [result]=do(obj,~)
            %   param : optional
            obj.result.state.p = obj.self.sensor.motive.result.rigid(obj.rigid_num(1)).p;
            obj.result.state.q = obj.self.sensor.motive.result.rigid(obj.rigid_num(1)).q;
            cha = obj.self.reference.point.flag;
            obj.result.state.pL = obj.result.state.p + [obj.self.model.param(17);obj.self.model.param(18);-obj.self.model.param(19)] -[0;0;obj.self.model.param(16)];
%             obj.result.state.pL = obj.result.state.p -[0;0;obj.self.model.param(16)];% For:PE-Model
            if obj.result.state.pL(3) >= 0.1%strcmp(cha,'f')||strcmp(cha,'l')
                obj.result.state.pL = obj.self.sensor.motive.result.rigid(obj.rigid_num(2)).p;
            end
            R = RodriguesQuaternion(obj.result.state.q);
            obj.result.state.pT = (obj.result.state.pL-obj.result.state.p-R*[obj.self.model.param(17);obj.self.model.param(18);obj.self.model.param(19)])/norm(obj.result.state.pL-obj.result.state.p-R*[obj.self.model.param(17);obj.self.model.param(18);obj.self.model.param(19)]);
%             obj.result.state.pT = (obj.result.state.pL-obj.result.state.p-R*[obj.self.estimator.ekf.result.state.e(1);obj.self.estimator.ekf.result.state.e(2);obj.self.estimator.ekf.result.state.e(3)])/norm(obj.result.state.pL-obj.result.state.p-R*[obj.self.estimator.ekf.result.state.e(1);obj.self.estimator.ekf.result.state.e(2);obj.self.estimator.ekf.result.state.e(3)]);
%             obj.result.state.pT = (obj.result.state.pL-obj.result.state.p)/norm(obj.result.state.pL-obj.result.state.p);% For:PE-Model
            result = obj.result;
        end
        function show()
        end
    end
end

