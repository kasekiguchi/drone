classdef FOR_LOAD < SENSOR_CLASS
      properties
        state
        result
        rigid_num
        self
        fpLXY=0;
        tf0
        tl0
        te = 10;%ÉZÉìÉTÅ[ílÇâΩïbÇ≈100%égÇ§Ç©
        rate = 1/te^2;%ìÒéüä÷êîÇ≈0-1ÇÃä‘Ç≈ïœâªÇ∑ÇÈ
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
            % if sum(contains(self.model.state.list,"q"))==1
            %     obj.result.state.num_list=[3,length(self.model.state.q),3]; % modelÇ∆çáÇÌÇπÇÈ
            %     obj.result.state.type = length(self.model.state.q);
            % end
        end
        
        function [result]=do(obj,varargin)
            %   param : optional
            sp = obj.self.sensor.motive.result.state.p;
            sq = obj.self.sensor.motive.result.state.q;
            spL=obj.self.sensor.motive.result.rigid(obj.rigid_num).p;
            ipL = sp -[0;0;obj.self.parameter.get("cableL")];% For:PE-Model
            if strcmp(varargin{1}{2},'f')%obj.result.state.pL(3) >= 0.2&&(cha,'f')||strcmp(cha,'l')
                obj.result.state.pL = spL;
                obj.tf0=[];
                obj.tl0=[];
            % elseif strcmp(varargin{1}{2},'t')&&spL(3)>0.35&&(norm(spL(1:2) - obj.result.state.p(1:2))<0.01||obj.fpLXY==1)
            % % elseif strcmp(varargin{1}{2},'t')&&(norm(spL(1:2) - obj.result.state.p(1:2))<0.01||obj.fpLXY==1)
            %     obj.result.state.pL(1:2) = spL(1:2);
            %     obj.fpLXY=1;
            elseif strcmp(varargin{1}{2},'t')&&ipL(3)>0.1%take off
                if isempty(obj.tf0)
                    obj.tf0 = varargin{1}{1}.t;
                end
                t = min((varargin{1}{1}.t - obj.tf0),obj.te);
                k = obj.rate*t^2;%îΩâfäÑçá
                spL(1:2) = sp(1:2) + k*(spL(1:2) - sp(1:2));
                % spL = spL + min(k,0)*(spL - sp);
            elseif strcmp(varargin{1}{2},'l')&&ipL(3)>0.1%landing
                if isempty(obj.tl0)
                    obj.tl0 = varargin{1}{1}.t;
                end
                t = min(varargin{1}{1}.t - obj.tl0, obj.te);
                k = obj.rate*(t - obj.te)^2;%îΩâfäÑçá
                spL = spL + k*(spL - sp);
            else
                spL = ipL;% For:PE-Model
                obj.tf0=[];
                obj.tl0=[];
            end
            obj.result.state.p = sp;
            obj.result.state.q = sq;
            obj.result.state.pL = spL;
            obj.result.state.pT = (spL-sp)/norm(spL-sp);
            result = obj.result;
        end
        function show()
        end
    end
end

