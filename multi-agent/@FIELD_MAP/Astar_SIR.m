%% Astar_SIR
function [k,logger] = Astar_SIR(obj,ke,h,unum,X,Xm,vi,w1,w2)
% simulate
% [input]
% N : number of node = nx*ny
% ke : simulation max step
% nx, ny : grid size
% obj : SIR_model
% unum : number of agents
% FF : 消防隊の消火ノズル状況
% E : graph edge
% W : node weight
% fMethod : "APR" or "Weight"
% Il : length of I state
% vi : agents skip size
% p : initial position of agents
% [output] 
% k : simulation step <= ke
% logger : simulation result
Il = obj.ti;
nx = obj.nx;
ny = obj.ny;
N = nx*ny;
logger.k=zeros(1,ke);
logger.S(:,1) = obj.S(:);
logger.I(:,1) = obj.I(:);
logger.R(:,1) = obj.R(:);
logger.U(:,1) = obj.U(:);
logger.P = sparse(N,ke);
p = obj.arranged_position([nx,ny],unum,2,0);
p = (p(1,:)'-1)*ny + p(2,:)';% init position indices
pt = zeros(unum,1);
k = 1;
while (k <= ke) && sum(find(obj.I))
  wi = obj.wind_time(1);
  E = obj.EF{wi} + obj.ES{wi};
    Eenum = ceil(k/20);
    E1 = E>0;
    fi= find(obj.I);% 燃えているマップのインデックス
    if 1%fDynamics=="Direct"
        tmpX = X(fi)+(Il-obj.I(fi));% 燃えているマップの重要度：X = V, Wどちらでも縦ベクトルになる．
        
        % target point t 選択：重要度の高い順にtunum個選択
        tunum = min(unum,length(fi));
        u = zeros(tunum,1);% extinguish input indices
        for iu=1:tunum
            [~,I]= max(tmpX);
            u(iu) = fi(I);%
            tmpX(I)=Xm;% 選択済みのものを最低rankに設定
        end
    else % Astar
        % target point t 選択：重要度の高い順にtunum個選択
        tunum = min(unum,length(fi)); % 燃えている部分が少なくなってきたときのケア
        if k == 1
            t = zeros(tunum,1);% target position indices
            fi2 = fi;
            lt = 0;
        else
            tI = find(obj.I(t) > 0);
            t = t(tI,1);% 一度注目した点は燃え尽きるまで追いかける．
            fi2 = find(obj.I&~sparse(t,1,1,N,1)); % tのcellを重複して選ばないように．
            lt = length(t);
        end
        tmpX = X(fi2)+(Il-obj.I(fi2));
        % 燃えているマップの重要度：燃えはじめの方が重要度が高い
        % X = V, Wどちらでも縦ベクトルになる．
        
        u = zeros(tunum,1);% extinguish input indices
        for iu=lt+1:tunum
            [~,I]= max(tmpX);
            t(iu,1) = fi2(I);%
            tmpX(I)=Xm;% 選択済みのものを最低rankに設定
        end
        
        % 対応点選択：距離が近いものから選択
        % このあたりまだまだ改善の余地あり！target pointの選択と合わせて工夫したいところ
        Dpt = zeros(tunum);
        for j = 1:tunum
            Dpt(:,j) = grid_distance(p(j),t,nx,ny);
            % distance matrix from p to t
            % i-th row : i-th t
            % j-th col : j-th p
        end
        mD = max(Dpt,[],'all')+1;% 一番遠い距離
        for i = 1:tunum
            [~,I]=min(Dpt,[],'all','linear');
            [row,col]=ind2sub([tunum,tunum],I);% 最小距離のpとtを求める：p(col)-t(row)
            pt(col) = row;% pとtの対応を記録：p(i)とt(pt(i)) が対応
            Dpt(row,:)=mD;% 選択済みの行を全て最遠に設定
            Dpt(:,col)=mD;% 選択済みの列を全て最遠に設定
        end
        
        % A star アルゴリズム (上のfor文とくっつけられるが分けたほうが見やすそう)
        for i = 1:tunum
            c=p(i);
            path = aster(c,t(pt(i)),E1,@(c,t)grid_distance(c,t,nx,ny),@(Z) performance(X,Xm,obj.I,Z),w1,w2);    %cにp(i)
            logger.P(:,k) = logger.P(:,k) | sparse(path,1,1,N,1);
            u(i) = path(1);% 実際の消化点
            if length(path)>1
                p(i) = path(min(vi,find(sum(fi'==path,2),1)));% 次時刻の位置 viより近い燃えている点
            end
        end
    end
    U = sparse(u,1,1,N,1);

    % if E0 ~= 0
    %     obj.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});% obj 更新
    % elseif Ee == 0
    %   obj.next_step_func(U,E);% obj 更新
    % end
    obj.next_step_func(U,wi);% obj 更新
    % log
    logger.k(k)=k;
    logger.S(:,k) = obj.S(:);
    logger.I(:,k) = obj.I(:);
    logger.R(:,k) = obj.R(:);
    logger.U(:,k) = obj.U(:);
    logger.UF(:,k) = obj.vf(:); % 飛び火の発生回数の保存 Logger(i).UFで確認
    k = k+1;

        if k == 9
            unum = unum + 16;
        elseif k == 25
            unum = unum + 7;
        elseif k == 33
            unum = unum + 19;
        elseif  k == 42
            unum = unum + 4;
        elseif  k == 69
            unum = unum + 3;
        elseif  k == 120
            unum = unum + 12;
        end
end
end