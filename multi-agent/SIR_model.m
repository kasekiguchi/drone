classdef SIR_model < handle
    
    properties
        x
        A
        B
        Si % vector of S state = [1;0;...;0]
        Ii % vector of I1 state
        Ri % vector of R state
        u
        v
        map
        N % number of agent
        n % number of state
        ti
        h
        S % indices of S agents
        I % indices of I agents
        R % indices of R agents
    end
    
    methods
        function obj = SIR_model(N,ti,h)
            % SIR model
            %   N : number of agents
            %   ti : length of infected time step = number of "I" state
            %   h : transition probability to R
            %   xi : corresponds to (S,I1,I2,I3,...,Iti,R)'; = ti+2 dimension
            %       xi = [1,0,...,0]'; means xi is S
            %       xi = [0,0,1,0,...,0]'; means xi is I2
            %       xi = [0,...,0,1]'; means xi is R
            %   x = [x1; x2; ... ; xN];
            % xn = A*xc + B*v   if u = 0
            % xn = R            if u = 1
            %   xn : next state
            %   xc : current state
            %   v  : state transition input from S to I
            %   u  : state transition input to R
            obj.N = N;
            obj.ti = ti;
            obj.h = h;
            obj.x = zeros(N*(ti+2),1);
            obj.x(1:(ti+2):end,1) = 1;% 初期状態は全エージェントがS
            obj.x = obj.x;
            
            Ai = [[1;0],zeros(2,ti+1);zeros(ti,1),eye(ti),[zeros(ti-1,1);1]];
            Bi = [-1;1;zeros(ti,1)];
            obj.A = kron(speye(N),sparse(Ai));
            obj.B = kron(speye(N),sparse(Bi));
            obj.S = ones(N,1);  % constructorでは全てのエージェントはS
            obj.I = zeros(N,1); % constructorではIのエージェントは無い
            obj.R = zeros(N,1); % constructorではRのエージェントは無い
            obj.Si = [1;zeros(obj.ti+1,1)];
            obj.Ii = [0;1;zeros(obj.ti,1)];
            obj.Ri = [zeros(obj.ti+1,1);1];
            obj.n = obj.ti+2;% number of state
        end
        function init(obj,I,R)
            obj.I = I;
            obj.R = R;
            obj.S(find(I+R))=0;
            obj.x = (obj.x & kron(~I,ones(obj.n,1))) + kron(I,obj.Ii);
            obj.x = sparse((obj.x & kron(~R,ones(obj.n,1))) + kron(R,obj.Ri));
        end
        function calc_v(obj,E)
            % E : edge matrix
            % eij : (i,j) element of E
            % eij > 0 if edge exists from j to i else eij = 0
            % 重いので分解して適宜sparse化することで高速化した
            sI = sparse(obj.I);
            sS = sparse(obj.S);
            sIt= sI';
            Tsi = sS*sIt;% 向き注意！eij の感染の向きに従うように．具体的な数値で確認せよ
            aa=E.*Tsi;% Iの拡散edge重み = Iの拡散確率行列
            aaa = spones(aa)-aa; % I が拡散しないスパース確率行列
            [i,~,v]=find(aaa);
            [ui,~,ic] = unique(i,'stable');
            bb = ones(size(ui));
            for k = 1:length(v)
                bb(ic(k),1) = bb(ic(k),1)*v(k); 
            end            
            dd = rand(length(ui),1); % [0,1]乱数
            cc = spones(bb)-bb; % Iになる確率
            kk = sparse(size(aa,1),1);
            kk(ui)=dd <= cc;
            obj.v=kk;
        end
        function transition_to_R(obj,u)
            % u = [u1; u2; ... ; uN];
            % ui = 0 or 1;
            R = (u.*(rand(obj.N,1) <= obj.h)); % indices of agents to be R
            obj.x=sparse((obj.x & kron(~R,ones(obj.n,1))) + kron(R,obj.Ri));% transform to R
            % kron(R,obj.Ri) : a vector such that subvector corresponding to R-th agents position equals Ri
            % kron(~R,ones(n,1)) : a vector such that subvector
            % corresponding to ('not' R)-th agents position equals 1
            obj.S=obj.S & ~R;% update S agents
            obj.I=obj.I & ~R;% update I agents
            obj.R=obj.R | R;% update R agents
        end
        function next_step_func(obj,u,E)
            %   next_step_func : function to calculate next state
            %       [usage] 
            %          xn = next_step_func(xc, u);
            %       where xn : next state, xc : current state, u : inputs
            obj.transition_to_R(u);
            obj.calc_v(E);
            obj.I(find(obj.x(obj.ti+1:obj.ti+2:end)))=0;
            obj.R(find(obj.x(obj.ti+1:obj.ti+2:end)))=1;
            obj.x = obj.A*obj.x+obj.B*obj.v;
            i=find(obj.v);
            obj.S(i) = 0;
            obj.I(i) = 1;
        end
        function figure=draw_state(obj,nx,ny,W)
            arguments
                obj SIR_model
                nx {mustBeInteger}
                ny {mustBeInteger}
                W = obj
            end
            clf
            hold on
            [X,Y]=meshgrid(1:nx+1,1:ny+1);
            if isfield(W,"S")||isprop(W(1),"S")%(length(W)==1)
                figure=surf(X,Y,[reshape(0*W.S+1*W.I+2*W.R,[nx,ny]),0*ones(ny,1);0*ones(1,nx+1)]);hold on;
                mycmap=[0 1 0;1 0 0;0.5 0.5 0.5]; %[Green;Red;Gray];
                cmin=0;
                cmax=2;
                caxis([cmin cmax]);
                colormap(mycmap);
                colorbar('Ticks',[0,1,2,3],'TickLabels',{'Not burn','Burning','Extinct'})
            else
                figure=surf(X,Y,[W,0*ones(ny,1);0*ones(1,nx+1)]);hold on;
            end
            view(2)
            xlabel('\sl x','FontSize',25);
            ylabel('\sl y','FontSize',25);
            xlim([1,nx+1]);
            ylim([1,ny+1]);
            set(gca,'FontSize',20);
            ax = gca;
            ax.Box = 'on';
            ax.GridColor = 'k';
            ax.GridAlpha = 0.4;
            axis square
            hold off
        end
        function F=draw_movie(obj,logger,nx,ny,output,filename)
            % draw/generate movie
            % logger : struct with fields S, I, R matrices
            % nx : x axis grid number 
            % ny : y axis grid number 
            % output(optional) : 1 means output file (default 0)
            % filename(optional) : output file name 
            arguments
                obj
                logger
                nx
                ny
                output = 0
                filename = "";
            end
            %make_gif(1:1:ke,1:N,@(k,span) draw_voronoi(arrayfun(@(i)  logger.Data.agent{k,regionp,i},span,'UniformOutput',false),span,[tmppos(k,span),tmpref(k,span)],Vertices),@() Env.draw,fig_param);
            %make_animation(find(logger.k),1,@(k,~) obj.draw_state(nx,ny,reshape(0*logger.S(:,k)+1*logger.I(:,k)+2*logger.R(:,k),[nx,ny])),@()[]);
            loggerk = @(k) struct("S",logger.S(:,k),"I",logger.I(:,k),"R",logger.R(:,k));
            if filename==""
                F=make_animation(find(logger.k),1,@(k,~) obj.draw_state(nx,ny,loggerk(k)),@()[],output);
            else
                F=make_animation(find(logger.k),1,@(k,~) obj.draw_state(nx,ny,loggerk(k)),@()[],output,filename);
            end
        end
    end
end

