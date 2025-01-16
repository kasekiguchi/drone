classdef FOR_LOAD < SENSOR_CLASS
      properties
        state
        result
        rigid_num
        self
        fpLXY=0;
        tt0
        tl0
        tte = 5;%センサー値を何秒で100%使うか
        tle = 5;%センサー値を何秒で0%使うか
        ratet
        ratel
        ilength %実際のxy位置を使い始めるか
        inispL
    end
    
    methods
        function obj = FOR_LOAD(self,varargin)
            obj.self= self;
            if ~isempty(varargin)
                if isfield(varargin{1},'rigid_num')
                    obj.rigid_num = varargin{1,1}.rigid_num;
                end
            end
            obj.result.state = STATE_CLASS(struct('state_list',["p","q","pL","pT","real_pL"],"num_list",[3,4,3,3]));
            obj.ratet = 1/obj.tte^2;%二次関数で0-1の間で変化する
            obj.ratel = 1/obj.tle^2;%二次関数で0-1の間で変化する
        end
        
        function [result]=do(obj,varargin)
            %   param : optional
            if isempty(obj.ilength)
                obj.self.sensor.motive.result.rigid(1).p(3) + 0.1;%牽引物の高さ+定数
            end
            sp = obj.self.sensor.motive.result.state.p;
            sq = obj.self.sensor.motive.result.state.q;
            spL=obj.self.sensor.motive.result.rigid(obj.rigid_num).p;
            ipL = sp -[0;0;obj.self.parameter.get("cableL")];% For:PE-Model
            if strcmp(varargin{1}{2},'f')%obj.result.state.pL(3) >= 0.2&&(cha,'f')||strcmp(cha,'l')
                obj.result.state.pL = spL;
                obj.tt0=[];
                obj.tl0=[];
            % elseif strcmp(varargin{1}{2},'t')&& norm(sp - spL) > 0.8*obj.self.parameter.get("cableL") %take off
            elseif strcmp(varargin{1}{2},'t')&& sp(3) - spL(3)> 0.5*1.73*obj.self.parameter.get("cableL")%take off,複数牽引で紐の角度が60deg
            % elseif strcmp(varargin{1}{2},'t')&&ipL(3)> obj.ilength%take off
                if isempty(obj.tt0)
                    obj.tt0 = varargin{1}{1}.t;
                end
                t = min((varargin{1}{1}.t - obj.tt0),obj.tte);
                k = obj.ratet*t^2;%反映割合
                % spL(1:2) = sp(1:2) + k*(spL(1:2) - sp(1:2));
                spL = spL + k*(spL - sp);
            elseif strcmp(varargin{1}{2},'l')&& norm(sp - spL) < 0.8*obj.self.parameter.get("cableL")%landing
            % elseif strcmp(varargin{1}{2},'l')&&ipL(3) < obj.ilength%landing
                if isempty(obj.tl0)
                    obj.tl0 = varargin{1}{1}.t;
                end
                t = min(varargin{1}{1}.t - obj.tl0, obj.tle);
                k = -obj.ratel*t^2 + 1;%反映割合
                spL = spL + k*(spL - sp);
                % spL(1:2) = sp(1:2) + k*(spL(1:2) - sp(1:2));
                % spL(3) = ipL(3);
            else
                spL = ipL;
                obj.tt0=[];
                obj.tl0=[];
            end
            obj.result.state.p = sp;
            obj.result.state.q = sq;
            obj.result.state.pL = spL;
            obj.result.state.real_pL = obj.self.sensor.motive.result.rigid(obj.rigid_num).p;
            obj.result.state.pT = (spL-sp)/norm(spL-sp);
            result = obj.result;
        end
        function show()
        end
    end
end

