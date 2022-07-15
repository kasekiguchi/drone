classdef PARTICLE_FILTER < ESTIMATOR_CLASS
    % Particle filter
    properties
        m % number of input
        p % number of output
        sample % number of sample
        R % diag([r1,...,rm]) : variance of output
        sd % standard deviation
        prediction % prediction(x,u) : sample数分のデータに対応した状態更新関数
        output_function % output_function(x) : sample数分のデータに対応した出力方程式
        y % measured state
        result
        % state : estimated state
        % xhp : particle estimated states
        % W : weight
        self
        FH
        dt 
    end

    methods
        function obj = PARTICLE_FILTER(self,param)
            obj.self= self;
            model = self.model;
            obj.m = model.dim(2);
            obj.self.input = zeros(obj.m,1);
            obj.result.state= state_copy(model.state);
            obj.y= state_copy(model.state);
            if isfield(param,'list')
                obj.y.list = param.list;
            else
                obj.y.list = [];
            end
            obj.prediction = param.prediction;
            obj.output_function = param.output_function;
            obj.sd = param.sd;
            obj.sample = param.sample;
            obj.result.xhp = obj.result.state.get() + chol(param.P)*randn(model.dim(1),obj.sample); % xhp : n x sample : 共分散Pkの正規分布
            obj.result.W = ones(1,obj.sample) / obj.sample; %Importance for each row
            obj.R = param.R;
            obj.FH = 10;
            obj.dt = param.dt;
        end

        function [result]=do(obj,~)
            % preprocessing
            sensor = obj.self.sensor.result;
            state_convert(sensor.state,obj.y);% sensorの値をy形式に変換
            u = obj.self.input + diag(obj.sd)*randn(obj.m,obj.sample); % noisy input : m x sample
            % prediction step
            xhpp = obj.prediction(obj.result.xhp,u); % xhpp : n x sample : particle prediction
            yhpp = obj.output_function(xhpp); % yhpp : p x sample : output particle prediction
            ytpp = obj.y.get() - yhpp; % ytilde : innovation : p x sample : next time step particle output error
            M = sum(ytpp.*(obj.R\ytpp),1); % yt'*inv(R)*yt : 1 x sample : 各データの(誤差の二乗/分散)の和
            obj.result.W = exp(-0.5*M); % データの重み：各サンプルの尤度 : Table 4.3の5行目(pを正規分布とした場合)

            % 尤度Wによる重点サンプリング
            ind = randsample(obj.sample,obj.sample,true,obj.result.W);
            xhp = xhpp(:,ind);

            % 事後推定 : リサンプリングされたサンプルの平均
            xh = mean(xhp,2);

            obj.result.state.set_state(xh);
            obj.result.xhp = xhp;
            result=obj.result;
        end
        function show(obj,p,xhp,opts)
            % draw 3d position estimation result
            % opts.xp : true position
            arguments
                obj
                p = obj.result.state.p
                xhp = obj.result.xhp
                opts.FH = obj.FH
                opts.xp = []
                opts.flag = 1;
            end
            obj.FH = figure(opts.FH);
            hold on; grid on; axis equal
            view([1 1 1]);
            if opts.flag == 1
                plot3(xhp(1,:),xhp(2,:),xhp(3,:),'.g');
                obj.drawErrorEllipse(p,cov(xhp(1:3,:)'));
            end
            plot3(p(1),p(2),p(3),'xm');
            if isempty(opts.xp)
                legend('PF samples','PF Confidence','PF est.');
            else
                y = obj.y.p; % global coordinate
                plot3(opts.xp(1),opts.xp(2),'-b');
                plot3([opts.xp(1,1) y(1,1)],[opts.xp(2,1) y(2,1)],[opts.xp(3,1) y(3,1)],'--or');
                legend('PF samples','PF Confidence','PF est.','True position','True/observation');
            end
            drawnow
            %            daspect([1 1 1]);
        end
        function animation(obj,logger,param,opts)
            % TODO : result.xhpのloggerでの保存方法
            % 3d position estimation result movie
            arguments
                obj
                logger
                param.target = 1;
                param.realtime = false;
                param.gif = false;
                opts.xp = [] % true value
                opts.y = [] % measured position
                opts.FH = obj.FH
            end
            t = logger.data("t");
            p = logger.data(param.target,"p","e");
            pp = logger.data(param.target,"estimator.result.xhp"); % particle position matrix
            r = logger.data(param.target,"p","r");
            plot3(r(:,1),r(:,2),r(:,3),'k');

            for i = 1:length(t)-1
                obj.show(p(i,:),pp(1:3,obj.sample*(i-1)+1:obj.sample*i),"flag",mod(t(i),0.2)<obj.dt,"FH",opts.FH)
                if param.realtime
                    delta = toc(tRealtime);
                    if t(i+1)-t(i) > delta
                        pause(t(i+1)-t(i) - delta);
                    end
                    tRealtime = tic;
                else
                    pause(0.01);
                end
                if param.gif
                    im = frame2im(getframe(obj.fig));
                    [imind,cm] = rgb2ind(im,sizen);
                    if i==1
                        imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',delaytime);
                    else
                        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',delaytime);
                    end
                end
            end

        end

        function drawErrorEllipse(obj,x,P)

            [V,D] = eig(P);

            chi=9.210; %0.99 % TODO

            AX = sqrt(diag(D)*chi);
            [X,Y,Z] = ellipsoid(0,0,0,AX(1),AX(2),AX(3));
            ELLX = V(1,1)*X + V(1,2)*Y + V(1,3)*Z + x(1);
            ELLY = V(2,1)*X + V(2,2)*Y + V(2,3)*Z + x(2);
            ELLZ = V(3,1)*X + V(3,2)*Y + V(3,3)*Z + x(3);
            surf(ELLX,ELLY,ELLZ,'FaceAlpha',0.3,"FaceColor",'c');
        end
    end
end

