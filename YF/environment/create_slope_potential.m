function [allP,allCoef] = create_slope_potential(vertices,xd)
%UNTITLED2 この関数の概要をここに記述
%   詳細説明をここに記述

num_wall = length(vertices);
env = polyshape(vertices{1});
if num_wall>1
    for i = 2:num_wall
        env = union(env,polyshape(vertices{i}));
    end
end
outer_env = polybuffer(env,0.1);
Pw = cell2mat(vertices);
%組み合わせの生成
C = nchoosek(1:length(Pw),2);
s =[];t=[];weight=[];
%Pwが構成している四隅の点なので，それで構成される直線を利用して壁をまたいでいない直線を判断
for i=1:length(C)
    line = [Pw(C(i,1),:);Pw(C(i,2),:)];
    [~,out] = intersect(outer_env,line);
    if isempty(out)
        s = [s C(i,1)];
        t = [t C(i,2)];
        weight = [weight norm(Pw(C(i,1),:)-Pw(C(i,2),:))];
    end
end
%四隅と目標の距離を判別
disxd2Pw = arrayfun(@(i) norm(xd - Pw(i,:),2),1:length(Pw))';
[~,nearestPw] = min(disxd2Pw);
%最も近い四隅点空の距離をグラフノードで計算
G = graph(s,t,weight);
d = distances(G);
tmp = d(nearestPw,:);
%一つの板あたりの四隅の重さを計算
tmp = arrayfun(@(i) [1.5*sum(tmp(4*i-3:4*i)),i],1:num_wall,'UniformOutput',false)';
tmpp = sortrows(cell2mat(tmp));
allP = cell(1,num_wall);
allCoef= cell(1,num_wall);
[px,py] = meshgrid(-5:0.01:20,-5:0.01:20);
Fp = 10000.*ones(length(px),length(py));
for ii =1:num_wall
    if ii==15
        disp('')
    end
    [tmpP,tmpF,tmpCoef] = slope(vertices,tmpp(ii,1)-tmpp(1,1),tmpp,tmpp(ii,2),xd);
    allP{ii} = tmpP;
    F{ii} = tmpF;
    allCoef{ii} = tmpCoef;
    Fp = min(Fp,F{ii});
end
% potentialprint(1)
% check_diff(allP,allCoef)
% disp('')
    function [ret,fun,coef] = slope(Pw,offset,param,id,xd)
        % dir : direction in R^2 ー＞向きの決定，x方向に傾いてるのか，ｙに傾いてるのか
        % L : slope length
        % w : slope width
        % th : slope angle,傾き具合
        % ret : slope points
        %傾きを出すところ
        [Xx,Yy] = meshgrid(-5:0.01:20,-5:0.01:20);
        this_slope = polyshape(Pw{id});
        other_num = param(param(:,2)~=id,2);
        ClossTF = zeros(length(other_num),1);
        %交差しているやつの検出
        for www = 1:length(other_num)
            ClossTF(www) = intersect(this_slope,polyshape(Pw{other_num(www)})).NumRegions;
        end
        %交差している板の番号を算出
        Closs_region = other_num(ClossTF==1);
        %交差してgいるやつの板の重さを算出
        cellnum = zeros(1,length(Closs_region));
        for qqq=1:length(Closs_region)
            [row,~] = find(param(:,2)==other_num(qqq));
            cellnum(qqq)= param(row,1);
        end
        %交差している個体が複数の場合交差している重さが低いほうとの共通領域の削除．これで重心を任意の方向に追いやってる
        [~,num] = min(cellnum);
        polyout = subtract(this_slope,polyshape(Pw{Closs_region(num)}));
        %重さがthis_skopeの方が軽い場合には目標位置方向をにベクトルをするための工夫
        [Gx,Gy] = centroid(polyout);
        [Tx,Ty] = centroid(this_slope);
        %考えているスロープが最小なのであれば目標位置への入力とする
        [row,~] = find(param(:,2)==id);
        if row==1
            dir = cross([0 0 -1],[([Tx,Ty]-xd)/norm(([Tx,Ty]-xd)) 0]);
        else
            dir = cross([0 0 1],[([Tx,Ty]-[Gx,Gy])/norm(([Tx,Ty]-[Gx,Gy])) 0]);
        end
        %回転行列の算出？axang2rotmってのが，指定したベクトルをangreで回転させた結果の回転行列を出してくれる．
        R = axang2rotm([dir 0.1]);
        %平面の形成．四隅を回転させて，オフセット乗っけてる
        for qaz=1:4
            ret(qaz,:)=R*[Pw{id}(qaz,:) 0]'+[0 0 offset]';
        end
        %平面の方程式作成のために，3点のxyを抽出
        Mattt = [ret(1:3,1),ret(1:3,2),ones(3,1)];
        %平面の方程式の係数を算出
        coef=Mattt\ret(1:3,3);
        fun = @(x,y) coef(1)*x+coef(2)*y+coef(3)+...
            tan(pi/4*(tanh(5*(ret(1,1)-x).*(ret(3,1)-x))+1))+...
            tan(pi/4*(tanh(5*(ret(1,2)-y).*(ret(3,2)-y))+1));
        fun = fun(Xx,Yy);
    end
    function check_diff(Point,coef)
        x=4.8;
        y=9;
        num_slope = length(Point);
        Vp = zeros(1,num_slope);
        parfor o = 1:num_slope
            P1 = Point{o};
            coef1 = coef{o}
            Vp(o) = Cov_slope(x,y,coef1(1),coef1(2),coef1(3),P1(1,1),P1(3,1),P1(1,2),P1(3,2));
        end
        [~,id]= min(Vp);
        u = -1*[Cov_diffx_slope(x,y,coef{id}(1),coef{id}(2),coef{id}(3),Point{id}(1,1),Point{id}(3,1),Point{id}(1,2),Point{id}(3,2));...
            Cov_diffy_slope(x,y,coef{id}(1),coef{id}(2),coef{id}(3),Point{id}(1,1),Point{id}(3,1),Point{id}(1,2),Point{id}(3,2))]
    end
    function potentialprint(nnn)
        if nnn==1
            figure(4)
            f_1 = surf(px,py,Fp,'edgecolor','none');
            zlim([-4 200])
            caxis([-4 100])
            xlim([0 20])
            ylim([-2 20])
            % ylim([3 4])
            % plot(env)
            grid on
            xlabel('{\it x} [m]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')
            ylabel('{\it y} [m]','FontName','Times New Roman','FontSize',24,'Interpreter','latex')
            ax = gca;
            ax.FontSize = 24;
            fig = gcf;
            fig.PaperPositionMode = 'auto';
            fig_pos = fig.PaperPosition;
            fig.PaperSize = [fig_pos(3) fig_pos(4)];
            view(2)
%             exportsetupdlg
%             cd 'C:\Users\Tyasui\OneDrive - tcu.ac.jp\work2020\論文用\fig'
        end
    end
end

