classdef BIRD_MOVEMENT < REFERENCE_CLASS
    %鳥の動きを算出するクラス
    %   詳細説明をここに記述
    
    properties
        param
        self
        id
    end
    
    methods
        function obj = BIRD_MOVEMENT(self,param)
            arguments
                self
                param
            end
            obj.self = self;
            obj.param = param;
            obj.result.state = STATE_CLASS(struct('state_list',"p",'num_list',3));
            obj.id = self.sensor.motive.rigid_num;
        end
        
        function result = do(obj,Param)
            sensor = obj.self.sensor.motive.result.rigid;
            state = obj.self.estimator.result.state;
            time = Param{1};
            N = Param{2};
            Nb = Param{3};

            if obj.id == 1
                obj.result.state.p = [cos(time.t);sin(time.t);abs(sin(time.t))];
            elseif obj.id == 2
                obj.result.state.p = [sin(time.t);sin(time.t);2];
            else
                obj.result.state.p = [sin(time.t);sin(time.t);1];
            end

            result = obj.result;
        end

        function show(obj,verargin)
        end
    end
end

