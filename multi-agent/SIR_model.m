classdef SIR_model < handle
    
    properties
        x
        A
        B
        Si % vector of S state = [1;0;...;0]
        Ii % vector of I1 state
        Ri % vector of R state
        U
        v
        v1
        v2
        map
        N % number of agent
        n % number of state
        ti % length of I
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
            obj.x = zeros(N*(ti+2),1); %全てのセルに(ti+2)のベクトルを用意
            obj.x(1:(ti+2):end,1) = 1;% 初期状態は全エージェントがS　＝　1列目だけ1
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
            obj.U = zeros(N,1);
        end
        function init(obj,I,R)
            obj.I = I;
            obj.R = R;
            obj.S(find(I+R))=0;
            obj.x = (obj.x & kron(~I,ones(obj.n,1))) + kron(I,obj.Ii);
            obj.x = sparse((obj.x & kron(~R,ones(obj.n,1))) + kron(R,obj.Ri));
            obj.U = sparse(obj.N,1);
        end
%         function calc_v(obj,E)
%             % E : edge matrix
%             % eij : (i,j) element of E
%             % eij > 0 if edge exists from j to i else eij = 0
%             % 重いので分解して適宜sparse化することで高速化した
%             sIt = (obj.I>0)';
%             Tsi = obj.S*sIt;% 向き注意！eij の感染の向きに従うように．具体的な数値で確認せよ
%             aa=E.*Tsi;% Iの拡散edge重み = Iの拡散確率行列
%             aaa = spones(aa)-aa; % I が拡散しないスパース確率行列
%             [i,~,v]=find(aaa);   % (非ゼロを探すfind)aaaの行の添え字をiに、要素の値をvに返す処理
%             [ui,~,ic] = unique(i,'stable');     % uiの値を、iと同じ順序にするための処理
%             bb = ones(size(ui));
%             for k = 1:length(v)
%                 bb(ic(k),1) = bb(ic(k),1)*v(k);
%             end
%             dd = rand(length(ui),1); % [0,1]乱数
%             cc = spones(bb)-bb; % Iになる確率
%             kk = sparse(size(aa,1),1);  % aaと同じ行数の0スパースベクトルを生成
%             kk(ui)=dd <= cc;
%             obj.v=kk;
%         end
        function calc_v1(obj,ES)
            % E : edge matrix
            % eij : (i,j) element of E
            % eij > 0 if edge exists from j to i else eij = 0
            sIt = (obj.I>0)';
            Tsi = obj.S*sIt;% 向き注意！eij の感染の向きに従うように．具体的な数値で確認せよ
            aa = ES.*Tsi;% Iの拡散edge重み = Iの拡散確率行列
            aaa = spones(aa)-aa; % I が拡散しないスパース確率行列
            [i,~,v] = find(aaa); % (非ゼロを探すfind)aaaの行の添え字をiに、要素の値をvに返す処理
            [ui,~,ic] = unique(i,'stable');     % uiの値を、iと同じ順序にするための処理
            bb = ones(size(ui));
            for k = 1:length(v)
                bb(ic(k),1) = bb(ic(k),1)*v(k);
            end
            dd = rand(length(ui),1); % [0,1]乱数
            cc = spones(bb)-bb; % Iになる確率
            kk = sparse(size(aa,1),1);  % aaと同じ行数の0スパースベクトルを生成
            kk(ui)=dd <= cc;    % dd(乱数)<=cc(延焼確率)の時にkkにロジカル1、不成立の時にロジカル0
            obj.v1=kk;
        end
        function calc_v2(obj,EF)
            % E : edge matrix
            % eij : (i,j) element of E
            % eij > 0 if edge exists from j to i else eij = 0
            sIt = (obj.I>0)';
            Tsi = obj.S*sIt;% 向き注意！eij の感染の向きに従うように．具体的な数値で確認せよ
            aa=EF.*Tsi;% Iの拡散edge重み = Iの拡散確率行列
            aaa = spones(aa)-aa; % I が拡散しないスパース確率行列
            [i,~,v] = find(aaa); % (非ゼロを探すfind)aaaの行の添え字をiに、要素の値をvに返す処理
            [ui,~,ic] = unique(i,'stable');     % uiの値を、iと同じ順序にするための処理
            bb = ones(size(ui));
            for k = 1:length(v)
                bb(ic(k),1) = bb(ic(k),1)*v(k);
            end
            dd = rand(length(ui),1); % [0,1]乱数
            cc = spones(bb)-bb; % Iになる確率
            kk = sparse(size(aa,1),1);
            kk(ui)=dd <= cc;
            obj.v2=kk;  % ここが1の場合に飛び火の発生を意味する
        end
        function transition_to_R(obj,U)
            % U = [u1; u2; ... ; uN];
            % ui = 0 or 1;
            R = (obj.I>0).*(U.*(rand(obj.N,1) <= obj.h)); % indices of agents to be R
            obj.x=sparse((obj.x & kron(~R,ones(obj.n,1))) + kron(R,obj.Ri));% transform to R
            % kron(R,obj.Ri) : a vector such that subvector corresponding to R-th agents position equals Ri
            % kron(~R,ones(n,1)) : a vector such that subvector
            % corresponding to ('not' R)-th agents position equals 1
            obj.S=obj.S & ~R;% update S agents
            obj.I=obj.I .* ~R;% update I agents % need "*" not "&" because I is a value in [0, ti]
            obj.R=obj.R | R;% update R agents
            obj.U = U;
        end
%         function next_step_func(obj,U,E)
%             %   next_step_func : function to calculate next state
%             %       [usage]
%             %          next_step_func(U, E);
%             %       where U : inputs, E : edge matrix
%             obj.transition_to_R(U);% h 以下の確率でUのある燃えているセルを消火（Rに遷移）
%             obj.calc_v(E);
%             obj.R(obj.I == obj.ti)=1;
%             obj.I(obj.I == obj.ti)=0;
%             obj.x = obj.A*obj.x+obj.B*obj.v;
%             obj.I = obj.I + (obj.I>0);% 火災の進行具合を1-tiの整数で表現
%             i=find(obj.v);
%             obj.S(i) = 0;
%             obj.I(i) = 1;
%         end
        function next_step_func(obj,U,ES,EF)
            %   next_step_func : function to calculate next state
            obj.transition_to_R(U);% h 以下の確率でUのある燃えているセルを消火（Rに遷移）
            obj.calc_v1(ES);
            obj.calc_v2(EF);
            obj.R(obj.I == obj.ti)=1;
            obj.I(obj.I == obj.ti)=0;
            obj.x = obj.A*obj.x+obj.B*(obj.v1+obj.v2);
            obj.I = obj.I + (obj.I>0);% 火災の進行具合を1-tiの整数で表現
            i=find(obj.v1+obj.v2);
            obj.S(i) = 0;
            obj.I(i) = 1;
        end
    end
    methods (Static)
        function figure=draw_state(nx,ny,W)
            arguments
%                obj SIR_model
                nx {mustBeInteger}
                ny {mustBeInteger}
                W = obj
            end
            clf
            hold on
            [X,Y]=meshgrid(1:nx+1,1:ny+1);
            if isfield(W,"S")||isprop(W(1),"S")%(length(W)==1)
                V = 2*W.S+5*(W.I>0)+3*(W.R.*~W.U)+4*W.U;
                cmin=2;
                colorbar('Ticks',[2,3,4,5],'TickLabels',{'Not burn','Extinct','Extincting','Burning'})
                if isfield(W,"P")||isprop(W(1),"P")
                    PU = W.P.*~W.U;
                    V = (V.* ~PU) + 1*PU;
                    cmin=2; % Pathを使うときは1
                    colorbar('Ticks',[2,3,4,5],'TickLabels',{'Not burn','Extinct','Extincting','Burning'})
%                     colorbar('Ticks',[1,2,3,4,5],'TickLabels',{'Path','Not burn','Extinct','Extincting','Burning'})
                end
                figure=surf(X,Y,[reshape(V,[nx,ny]),2*ones(ny,1);2*ones(1,nx+1)]);hold on;
                mycmap=[1 1 0; 0 1 0;0.5 0.5 0.5;0 0 1;1 0 0]; %[Blue;Green;Gray;Cyan;Red];
                cmax=5;
                caxis([cmin cmax]);
                colormap(mycmap(cmin:cmax,:));
            else
                figure=surf(X,Y,[W,0*ones(ny,1);0*ones(1,nx+1)]);hold on;
%               set(gca,'Zscale','log')

%                 jetCmap = hot;      % ここから下4行(colormapまで)でマップの色を変更
%                 jetCmap = flipud(jetCmap);
%                 newCmap = jetCmap(1:end,:);
%                 colormap(newCmap);

                colorbar;
            end
            view(2)
            % マップ範囲を決めている
            xlabel('\sl x','FontSize',25);
            ylabel('\sl y','FontSize',25);
            xlim([1,101]);  %nx+1
            ylim([1,101]);  %ny+1
            set(gca,'FontSize',20);
            ax = gca;
            ax.Box = 'on';
            ax.GridColor = 'k';
            ax.GridAlpha = 0.4;
            axis square
            hold off
        end
        function F=draw_movie(logger,nx,ny,output,filename)
            % draw/generate movie
            % logger : struct with fields S, I, R matrices
            % nx : x axis grid number
            % ny : y axis grid number
            % output(optional) : 1 means output file (default 0)
            % filename(optional) : output file name
            arguments
                %obj
                logger
                nx
                ny
                output = 0
                filename = "";
            end
            if filename==""
                F=make_animation(find(logger.k),1,@(k,~) SIR_model.draw_state(nx,ny,SIR_model.loggerk(logger,k)),@()[],output);
            else
                F=make_animation(find(logger.k),1,@(k,~) SIR_model.draw_state(nx,ny,SIR_model.loggerk(logger,k)),@()[],output,filename);
            end
        end
        function W=loggerk(logger,k)
            if isfield(logger,"P")||isprop(logger(1),"P")
                W = struct("S",logger.S(:,k),"I",logger.I(:,k),"R",logger.R(:,k),"U",logger.U(:,k),"P",logger.P(:,k));
            else
                W = struct("S",logger.S(:,k),"I",logger.I(:,k),"R",logger.R(:,k),"U",logger.U(:,k));
            end
        end
        function save(filename,logger)
            if isstruct(logger)
                myfield=fieldnames(logger);
                %tmp = logger(1);
                for n = 1:length(myfield)
                    tmp.(myfield{n}) = {logger.(myfield{n})};
                end
                save(filename,'-struct','tmp','-v7.3');
            else
                save(filename,'logger');
            end
        end
        function Logger=load(filename)
            data=load(filename);
            F = fieldnames(data);
            if length(F)==1
                Logger = data.(F{1});
            else
                for i = 1:numel(data.(F{1}))
                    for n = 1:length(F)
                        Logger(i).(F{n})=data.(F{n}){i};
                    end
                end
            end
        end
    end
end

