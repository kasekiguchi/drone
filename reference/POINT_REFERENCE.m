classdef POINT_REFERENCE < handle
    properties
        param
        self
        result

        pointflag = 1
        point

        % plot_x
        % plot_y
    end
    
    methods
        function obj = POINT_REFERENCE(self,sample_param)
            % 参照
            obj.self = self;
            % obj.result.state = STATE_CLASS(struct('state_list',["p","q"],'num_list',[3,3]));
            obj.result.state = state_copy(obj.self.estimator.model.state);
            % obj.result.state = STATE_CLASS(struct('state_list',["xd","p","q","v"],'num_list',[9,3,3,3]));
            
            % obj.param = varargin;
            obj.param = sample_param;

            % obj.result.state.p = obj.param{1};
            % obj.result.state.q = obj.param{2};
            obj.result.state.set_state(obj.param.point(1));
        end
        function  result= do(obj,varargin)
            % 【Input】result = {Xd(optional)}
            % ids = abs(obj.self.estimator.result.state.p(1) - obj.point(obj.pointflag).p(1)) < obj.param.threshold && abs(obj.self.estimator.result.state.p(2) - obj.point(obj.pointflag).p(2)) < obj.param.threshold;
            % if norm(abs(obj.self.estimator.result.state.p - obj.param.point(obj.pointflag).p)') < obj.param.threshold && obj.pointflag < obj.param.num  
                pe = obj.self.estimator.result.state.p - obj.param.point(obj.pointflag).p;
                qe = obj.self.estimator.result.state.q - obj.param.point(obj.pointflag).q;
                if vnorm(pe - qe) < obj.param.threshold && obj.pointflag < obj.param.num
                obj.pointflag = obj.pointflag + 1;%フラグ更新
                if obj.pointflag <= obj.param.num
                obj.result.state.set_state(obj.param.point(obj.pointflag));
                disp("flag passed")
                end
            end
            % if obj.pointflag <= obj.param.num
            %     obj.result.state.set_state(obj.param.point(obj.pointflag));
            %     disp("flag paaed")
            % end


            % plot_x = [plot_x, obj.self.estimator.result.state.p(1)];
            % plot(obj.param.ax,obj.self.estimator.result.state.p(1),obj.self.estimator.result.state.p(2),"o");

            result=obj.result;
        end
        % function [Xp, Yp] = mause_point(obj)
        %     figure
        %     map = obj.self.agent.estimator.fixedSeg;
        %     scatter(map.Location(:,1),map.Location(:,2));
        %     hold on
        %     scatter(0,0,"filled")
        %     for d = 1:3
        %         % ここで、ライン上をマウスで選択します。
        %         % この例では、WAITFORBUTTONPRESSコマンドを使い
        %         % 入力待ち状態にします。
        %         waitforbuttonpress; 
        %         % マウスの現在値の取得
        %         Cp = get(gca,'CurrentPoint');
        %         Xp(1,d) = Cp(2,1);  % X座標
        %         Yp(1,d) = Cp(2,2);  % Y座標
        %         X = [0 Xp];
        %         Y = [0 Yp];
        %         plot(X,Y)
        %         str = sprintf('\\leftarrow point');
        %         ht = text(Xp(1,d),Yp(1,d),str,'Clipping','off');
        %     end
        %     hold off
        % end
        % function kabe = kaihi(obj)
        %     pc = obj.self.sensor.result.pc;
        %     roi
        % 
        % end
        function show(obj,param)
            
        end
    end
end
