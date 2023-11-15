classdef MY_WAY_POINT_REFERENCE < handle
    properties
        param
        self
        coefficients
        time
        dtime
        t_powers
        t_ref
        t0
        t_ref0
        names
        i
        fref
        result
    end
    
    methods
        function obj = MY_WAY_POINT_REFERENCE(self,varargin)
            %縦ベクトルで書く
            %最初のコマンドは"f"で始める
            % 参照
            
            obj.self = self;
            val = varargin{1};
            n = val.n;
            obj.coefficients = val.coefficients;
            obj.names = fieldnames(val.coefficients);            
            for i = 1:length(obj.names)
                obj.t_powers.(obj.names{i}) = @(t) (t).^(0:n+1-i)';
            end
            obj.time = val.t;
            obj.dtime = val.dt;
            obj.i=1;
            obj.fref=0;
            obj.t_ref0=0;
            
            obj.result.state = STATE_CLASS(struct('state_list',["xd","p", "q","v"],'num_list',[20,3,3,3]));
            obj.result.state.set_state("xd",zeros(6,1));
            obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
            obj.result.state.set_state("q",obj.self.estimator.result.state.get("q"));
            obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
        end
        function  result= do(obj,varargin)
            % 【Input】result = {Xd(optional)}
            if isempty(obj.t0)
                obj.t0=varargin{1}.t;%目標地点が定められた時刻
            end
            
            t_f = varargin{1}.t - obj.t0;%目標地点が定められた時間からの経過時間
            obj.t_ref= t_f - obj.t_ref0;

            if round(obj.t_ref,4) >= obj.dtime(obj.i) 
               obj.i=obj.i+1;
                if obj.i > length(obj.time)
                    obj.i = length(obj.time);
                    obj.t_ref = obj.dtime(end);
                    %繰り返し用
                    % obj.i = 1;
                    % obj.t_ref0 = round(t_f,4);
                    % obj.t_ref=0;
                else
                    obj.t_ref0 = round(t_f,4);
                    obj.t_ref=0;
                end
            end

            xd=zeros(4,4);
            for j = 1:3
                xd(:,j) = [obj.coefficients.(obj.names{j})(:,:,obj.i)*obj.t_powers.(obj.names{j})(obj.t_ref); 0];
            end
            obj.result.state.xd = reshape(xd,16,1);%3階微分まで
            obj.result.state.p = xd(1:3)';
            obj.result.state.v = xd(5:7)';
            obj.result.state.q(3,1) = 0;%yaw
            result = obj.result;
        end
         function show(obj, logger)
            rp = logger.data(1,"p","r");
            plot3(rp(:,1), rp(:,2), rp(:,3));                     % xy平面の軌道を描く
            daspect([1 1 1]);
            hold on
            ep = logger.data(1,"p","e");
            plot3(ep(:,1), ep(:,2), ep(:,3));       % xy平面の軌道を描く
            legend(["reference", "estimate"]);
            title('reference and estimated trajectories');
            xlabel("x (m)");
            ylabel("y (m)");
            hold off
        end
    end

    methods (Static)
        function ref = way_point_ref(val,n,fconfirm,fdrowfig)
        % time=[0,2,5,12];%time
        % point = [0,4,6,2;0,2,-1,4;0,3,5,2];%way points
        % n=5;%多項式次数
        arguments
            val
            n           %多項式次数
            fconfirm=1    %確認するか
            fdrowfig=1  %図を描画するか
        end
        time = val(:,1)';
        point = val(:,2:end)';
        dtime = diff(time');%隣の点との差 dw_i = w_i - w_i-1 (dw_1 = 0),  i=1,2,3,...
        Sn=length(time(1:end-1)); %求める多項式の数
        D(1,:)=ones(1,n+1);
        
        for i = 1:n-1
            D(i+1,:)=[zeros(1,i), 1:n-i+1].*D(i,:);
            % D(i+1,:)=[zeros(1,i), polyder(D(i,i:end))];
        end
        % D=sort(D,2);
        
        D_ori=D;
        D=D./factorial(0:n-1)';
        
        power_dtime=zeros(Sn,n+1);
        for i=1:n+1
            power_dtime(:,i) = dtime.^(i-1);
        end
        %行列でやる
        X=zeros((n+1)*Sn);
        
        for i=1:Sn
            dr=(i-1)*2;
            dc=(i-1)*(n+1);
            X(1+dr:2+dr,1+dc:(n+1)+dc) = [1,zeros(1,n);power_dtime(i,:)];
        end
        
        poweT = zeros(n-1,n+1);
        for i = 1:Sn-1
            for j=1:n-1
                poweT(j,j+1:end) = power_dtime(i,1:end-j) ;
            end
            dr2=(i-1)*(n-1);
            dc2=(i-1)*(n+1);
            X(2*Sn+1+dr2 : 2*Sn+n-1+dr2, 1+dc2 : (n+1)+dc2) = D(2 : end,1:end).*poweT;
            X(2*Sn+1+dr2 : 2*Sn+n-1+dr2, n+3+dc2 : 2*n+1 +dc2) = - eye(n-1);
        end
        add=(n+1)*Sn - (n-1);
        for j=1:n-1
                poweT(j,j+1:end) = power_dtime(end,1:end-j) ;
        end
        
        for i = 1:n-2
            dr3=(i-1)*2;
            % X(add+1+dr3,1+i) = 1;%4関数でさいしょの端点で激しくなるか，最後収束しないかでインデックス1,2をへんこう
            % X(add+2+dr3,end-n:end) = D(i+1,:).*poweT(i,:) ;
            X(add+2+dr3,1+i) = 1;%さいしょの端点で激しくなるか，最後収束しないかでインデックス1,2をへんこう
            X(add+1+dr3,end-n:end) = D(i+1,:).*poweT(i,:) ;
        end
        
        s=1:(n+1)*Sn;
        Xp =X(s,s);
        
        P = zeros(3,n+1,Sn);
        for i = 1:3
            Y1 =  reshape(ones(2,Sn+1).*point(i, :),2*(Sn+1),1);
            Y1 = Y1(2:end-1);
            Y = [Y1;zeros((n+1)*Sn-2*Sn,1)];
            P(i,:,:) = reshape(Xp\Y,1,n+1,Sn);
        end
        
        co = ["d0","d1","d2","d3"];
        index = length(co);
        for i = 1:index
            coefficients.(co(i))=zeros(3,n+2-i ,Sn);
        end
        
        coefficients.d0 = P;
        if length(co) > n 
            index = n;
        end
        for i = 2:index
            coefficients.(co(i))=coefficients.d0(:,i:end,:).*D_ori(i,i:end);
        end
        ref.n=n;
        ref.coefficients=coefficients;
        ref.t=time(2:end);
        ref.dt=dtime;
        
        
                if fconfirm
                    names = fieldnames(ref.coefficients);            
                    for i = 1:length(names)
                        t_powers.(names{i}) = @(t) (t).^(0:n+1-i)';
                    end
                        t_ref0=0;
                        i=1;
                        j=1;
                        delta=0.02;
                        end_time=time(end)+1;
                        % length_time = length(0:delta:end_time);
                        for t_f = 0:delta:end_time
                        
                            t_ref= t_f - t_ref0;%目標地点が定められた時間からの経過時間
                        
                            if round(t_ref,4) >= dtime(i) 
                               i=i+1;
                                if i >length(ref.t) 
                                    i = length(ref.t);
                                    t_ref = dtime(end);
                                    % t_ref=0;
                                    %繰り返し用
                                    % obj.i = 1;
                                    % obj.t_ref0 = round(t_f,4);
                                    % obj.t_ref=0;
                                else
                                    t_ref0 = round(t_f,4);
                                    t_ref=0;
                                end
                            end
                            % for k = 1:3
                                xyz(:,j) = coefficients.(names{1})(:,:,i)*t_powers.(names{1})(t_ref);
                                vxyz(:,j) = coefficients.(names{2})(:,:,i)*t_powers.(names{2})(t_ref);
                                axyz(:,j) = coefficients.(names{3})(:,:,i)*t_powers.(names{3})(t_ref);
                            % end
                            j=j+1;
                        end
            ref.xyz=xyz;
            ref.vxyz=vxyz;
            ref.axyz=axyz;
                        if fdrowfig
                            close all
                            i=1;
                            figure(i)
                            plot3(xyz(1,:),xyz(2,:),xyz(3,:),"LineWidth",2);
                            hold on
                            plot3(point(1,:),point(2,:),point(3,:),"LineStyle","none","Marker","o","LineWidth",2)
                            grid on
                            xlabel('$x$ (m)','FontSize',18,'Interpreter','latex')
                            ylabel('$y$ (m)','FontSize',18,'Interpreter','latex')
                            zlabel('$z$ (m)','FontSize',18,'Interpreter','latex')
                            set(gca,"TickLabelInterpreter","latex","FontSize",18)
                            hold off
                            i=i+1;
            
                            figure(i)
                            plot(0:delta:end_time,xyz,"LineWidth",2)
                            grid on
                            xlabel('$t$ (s)','FontSize',18,'Interpreter','latex')
                            ylabel('$p$ (m)','FontSize',18,'Interpreter','latex')
                            legend({"$x$","$y$","$z$"},'Interpreter','latex')
                            set(gca,"TickLabelInterpreter","latex","FontSize",18)
                            i=i+1;
            
                            figure(i)
                            tiledlayout("horizontal")
                            nexttile
                            plot(xyz(1,:),xyz(2,:),"LineWidth",2)
                            xlabel('$x$ (m)','FontSize',18,'Interpreter','latex')
                            ylabel('$y$ (m)','FontSize',18,'Interpreter','latex')
                            set(gca,"TickLabelInterpreter","latex","FontSize",18)
                            daspect([1,1,1])
                            pbaspect( [1,0.78084714548803,0.78084714548803]);
                            hold on
                            plot(point(1,:),point(2,:),'Marker','o','LineStyle','none',"LineWidth",2)
                            grid on
                            nexttile
                            plot(xyz(1,:),xyz(3,:),"LineWidth",2)
                            xlabel('$x$ (m)','FontSize',18,'Interpreter','latex')
                            ylabel('$z$ (m)','FontSize',18,'Interpreter','latex')
                            set(gca,"TickLabelInterpreter","latex","FontSize",18)
                            daspect([1,1,1])
                            pbaspect( [1,0.78084714548803,0.78084714548803]);
                            hold on
                            plot(point(1,:),point(3,:),'Marker','o','LineStyle','none',"LineWidth",2)
                            grid on
                            nexttile
                            plot(xyz(2,:),xyz(3,:),"LineWidth",2)
                            daspect([1,1,1])
                            pbaspect( [1,0.78084714548803,0.78084714548803]);
                            hold on
                            plot(point(2,:),point(3,:),'Marker','o','LineStyle','none',"LineWidth",2)
                            xlabel('$y$ (m)','FontSize',18,'Interpreter','latex')
                            ylabel('$z$ (m)','FontSize',18,'Interpreter','latex')
                            set(gca,"TickLabelInterpreter","latex","FontSize",18)
                            grid on
                            i=i+1;
            
                            figure(i)
                            plot(0:delta:end_time,vxyz,"LineWidth",2)
                            hold on
                            grid on
                            v_norm=sum(vxyz.^2).^0.5;
                            plot(0:delta:end_time,v_norm,"LineWidth",2)
                            xlabel('$t$ (s)','FontSize',18,'Interpreter','latex')
                            ylabel('$v$ (m/s)','FontSize',18,'Interpreter','latex')
                            legend({"$x$","$y$","$z$","$|v|$"},"Interpreter","latex")
                            set(gca,"TickLabelInterpreter","latex","FontSize",18)
                            i=i+1;
            
                            figure(i)
                            plot(0:delta:end_time,axyz,"LineWidth",2)
                            hold on
                            grid on
                            a_norm=sum(axyz.^2).^0.5;
                            plot(0:delta:end_time,a_norm,"LineWidth",2)
                            xlabel('$t$ (s)','FontSize',18,'Interpreter','latex')
                            ylabel('$a$ (m/$\mathrm{s^2}$)','FontSize',18,'Interpreter','latex')
                            legend({"$x$","$y$","$z$","$|a|$"},"Interpreter","latex")
                            set(gca,"TickLabelInterpreter","latex","FontSize",18)
                            i=i+1;
            
                            fprintf("If you confirmed trajectory, push the Enter key.");
                            input("");
                            close all
                        end
                end
        end

    end
end
