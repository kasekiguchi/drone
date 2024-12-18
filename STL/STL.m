classdef STL < handle


    properties
        mode=0
        time
        state
        self
        modechangeflag
        currentmodecount=0;
        automodeflag
        param
        func % 時間関数のハンドル
        t=[];
        cha='s';
        dfunc
        result
        base_state=[0 0 0];
        th_offset
        th_offset0 = 200;

    end
    %modeflag: action mode   0:auto   1:semiauto
    methods
        function obj=STL(self,modechangeflag)

            arguments
                self
                modechangeflag

            end
            obj.self = self;
            obj.modechangeflag=modechangeflag;   %0=keep the mode/mode has been changed   1= the mode is changing
            obj.automodeflag=1;     %1=automode 2=semiautoflag
        end




        function result = do(obj,varargin)
            modeExecution=zeros(1,4);
            obj.t=varargin{1};
            if mod((obj.t.k),100)==0 && obj.t.t ~=0
                obj.modechangeflag=1;
                obj.currentmodecount=obj.currentmodecount+1;

            end
            if obj.modechangeflag ~=0
                obj.cha = varargin{2};
                modeExecutionCount = length(obj.cha);
                %   modeExecution=struct();
                for i = 1:modeExecutionCount
                    if strcmp(obj.cha(1,i),'l') && ~isempty(obj.t)
                        modeExecution(1,i)=1;
                    elseif strcmp(obj.cha(1,i),'c') && ~isempty(obj.t)
                        modeExecution(1,i)=2;
                    elseif strcmp(obj.cha(1,i),'h') && ~isempty(obj.t)
                        modeExecution(1,i)=3;
                    elseif strcmp(obj.cha(1,i),'t') && ~isempty(obj.t)
                        modeExecution(1,i)=4;
                    end
                end
                obj.mode=modeExecution(1,obj.currentmodecount);
                obj.result.state = STATE_CLASS(struct('state_list',["xd","p","v"],'num_list',[20,3,3]));
                switch obj.mode %mode change for % 1: landing 2:circle movement 3:hoving 4:take off  etc...
                    case 1
                        obj.result.state.xd=obj.LANDING_REFERENCE_KYOREF(varargin{1}.t);

                    case 2
                        obj.result.state.xd=obj.CIRCLEMOVING_REFERENCE_KYOREF(varargin{1}.t);

                    case 3
                        obj.result.state.xd=obj.HOVERING_REFERENCE_KYOREF(varargin{1}.t);

                    case 4
                        obj.result.state.xd=obj.TAKINGOFF_REFERENCE_KYOREF(varargin{1}.t);

                    otherwise
                end

                obj.modechangeflag=0;

                obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
                %              obj.result.state.set_state("q",obj.self.estimator.result.state.get("q"));
                obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
                % obj.self.input_transform.param.th_offset = obj.th_offset - (obj.th_offset-obj.th_offset0)*min(obj.te,varargin{1}.t-obj.base_time)/obj.te;
                result = obj.result;
            end


        end
        function Xd = LANDING_REFERENCE_KYOREF(obj,t)
            %UNTITLED2 Summary of this class goes here
            %   Detailed explanation goes here

            Xd  = zeros( 20, 1);
            %% Set Xd
            if t <= obj.t.te
                Zd = curve_interpolation_9order(t,obj.t.te,obj.base_state(3),0,0,0);
            elseif t> obj.t.te
                Zd = zeros(1,5);
            end
            Xd(1:3,1) = obj.base_state(1:3);
            Xd(3,1) = Zd(1);
            Xd(7,1) = Zd(2);
            Xd(11,1) = Zd(3);
            Xd(15,1) = Zd(4);
            Xd(19,1) = Zd(5);
        end
        %  function obj=stl_chcek_disturbance(~,~)
        %        disturbance=0;
        % end
        %
        %
        % function obj=stl_destination(~,~)
        %         obj.modechangeflag=0;
        % end
        %
        % function obj=stl_semiauto(time,modeflag)
        %         obj.modechangeflag = 0;
        % end
        %
        %
        % function obj=stl_checkground(time)
        %         obj.modelchangeflag=0;
        % end
        function Xd = CIRCLEMOVING_REFERENCE_KYOREF(obj,t)
            %UNTITLED2 Summary of this class goes here
            %   Detailed explanation goes here

            
           if ~isempty(obj.t)    %flightからreferenceの時間を開始
                ttemp =t-obj.t; % 目標重心位置（絶対座標）
           else
                ttemp = obj.t;
           end 
           obj.result.state.xd = obj.func(ttemp); % 目標重心位置（絶対座標）
           obj.result.state.p = obj.result.state.xd(1:3);
           if length(obj.result.state.xd)>4
            obj.result.state.v = obj.result.state.xd(5:7);
           else
            obj.result.state.v = [0;0;0];
           end
           obj.result.state.q(3,1) = atan2(obj.result.state.v(2),obj.result.state.v(1));
           result = obj.result;
        end
        function Xd = HOVERING_REFERENCE_KYOREF(obj,t)
            %UNTITLED2 Summary of this class goes here
            %   Detailed explanation goes here
            Xd  = zeros( 20, 1);
           Xd = obj.result.state.xd(1:3);
           
        end
        function Xd = TAKINGOFF_REFERENCE_KYOREF(obj,t)
            %UNTITLED2 Summary of this class goes here
            %   Detailed explanation goes here

          
        end
    end
end