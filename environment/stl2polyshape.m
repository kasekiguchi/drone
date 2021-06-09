%%
% Make polyshapes by slicing the stl file
% The target height is defined as hrange
% Result is a array of polyshape named "region"
% "region" is saved in the current folder.
%% Initialize
all clear
clc
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

%% Get corner coordinates
%STL = 'stl_model.stl';
%STL = '20210217_5F.stl';
STL = '20210217_ASCII_meshlab.stl';
%STL = '20210217_Binary_meshlab.stl';
[TR,fileformat,attributes,solidID] = stlread(STL);
Sp0 = TR.Points; % points list
St0 = TR.ConnectivityList; % triangles list
d = 0.0001;
hrange = min(Sp0(:,3))+d:0.5:max(Sp0(:,3))-d; % the height at which stl is cut.
FN = faceNormal(TR); % the list of the vector that normals to the triangle
h_tids = find(ismember(FN,[0 0 1],'rows'));% horizontal triangle indices
h_ht=Sp0(St0(h_tids,1),3); % height of the horizontal triangles
E = TR.edges;% edges list
%% slice
% main part to cut the stl
clc
for hi = 1:length(hrange) % カットする高さ毎に処理
    hi % インジケータ
    h = hrange(hi); %
    H_tids=h_tids(find(h_ht==h));% 高さh 平面上の三角形インデックス
    H_ids = find(Sp0(:,3)>h);% target より高い点のindex 集合
    L_ids = find(Sp0(:,3)<=h);% target より低い点のindex 集合
    
    tmp_eids=find(ismember(E,L_ids)); % targetより低い点を含むエッジのインデックス（線形インデックス）
    [tmp_eids,~]=ind2sub(size(E),tmp_eids); % targetより低い点を含むエッジのインデックス（行番号）
    tmp2_eids=find(ismember(E(tmp_eids,:),H_ids)); %  targetより高い点を含むエッジのインデックス（線形インデックス）
    [tmp2_eids,~]=ind2sub([length(tmp_eids),2],tmp2_eids); % targetより高い点を含むエッジのインデックス（行番号）
    
    HL_eids=tmp_eids(tmp2_eids);% H-Lを含むedgeのインデックス集合
    HL_tids=unique(cell2mat(edgeAttachments(TR,E(HL_eids,:))));% H-L edgeを含む三角形インデックス
    
    aa = ordered_cross_points(Sp0,St0(HL_tids,:),h); % h という高さの点群
    % ordered_cross_points : 高さｈと三角形の交点を活かした順番で並べる関数．詳細は関数本体参照
    
    % 確認用　：各平面上のエッジと点が描画される
    %     figure(3)
    %     daspect([1 1 1]);
    %     hold on
    %     trisurf(St0(HL_tids,:),Sp0(:,1),Sp0(:,2),Sp0(:,3),'FaceColor',[0.8 0.8 1.0]);
    %     plot3(aa(1,:),aa(2,:),aa(3,:),'ro')
    %     hold off
    
    oaa=aa(:,1:2:end); % aa の奇数番の点（エッジの始点）
    eaa=aa(:,2:2:end); % aa の偶数番の点（エッジの終点）
    tmpii = oaa-eaa; % エッジの長さを求める
    nullid=find(diag(tmpii'*tmpii)==0); % 始点＝終点：つまり同じ点
    if ~isempty(nullid) % エッジが長さを持たないときは削除
        oaa(:,nullid)=[];
        eaa(:,nullid)=[];
    end
    
    % 一筆書きとなるようインデックスを辿る
    % a (in oaa) を始点とすると，eaaの同じ列の点bがエッジの終点となる（つまり a-b in E）
    % 次いで b を始点として対応するeaa の点を探すということを繰り返す
    % 始点となる点をid に蓄積していく．
    % 終点b がid の中に既に存在する場合は一つの領域を一周したことになるのでNaNで区切り次の領域を探索する(setxorを利用)
    oaa=[oaa,[NaN; NaN; NaN]];% polyshapeの区切り用のNaNを指定できるよう追加
    i = 1; % i 初期化
    id=zeros(length(eaa),1); %
    id(1) = 1;
    ni = 0;
    while i < length(eaa) % i 番目のエッジ：
        if id(i+ni) > length(eaa)% nanの時
            ni = ni + 1;% nan index
            tmpid=setxor(1:length(oaa),id);% まだ出てきていない点を抽出
            id(i+ni) = tmpid(find(tmpid,1)); % 新しい領域の始点を設定
        else
            tmpp = eaa(:,id(i+ni));
            i = i + 1;
    %        tmpi = find(abs(sum(oaa(:,1:end-1)-tmpp))==0);% 始点側でtmppの位置 % ラフだが高速
      %      if length(tmpi)~=1 % 高速な方でちゃんと求まらない場合はしっかり求める
                tmpii=oaa(:,1:end-1)-tmpp;
                tmpi = find(diag(tmpii'*tmpii)==0,1);% 始点側でtmppの位置
        %    end
            if isempty(tmpi)% 終点に対応した点が無い => ここに入るときはバグが残っている可能性があるので，break pointは設定したままにしておく
                warning("ACSL:something wrong");
            else
                if isempty(find(id==tmpi))% id に未登録の点の場合：追加
                    id(i+ni) = tmpi;
                else
                    id(i+ni) = length(oaa);% id にある場合は一周したことになるので，nanを指定
                end
            end
        end
    end
    region(hi)=check_poly(oaa(1:2,id)');
    for i = 1:length(H_tids)% 高さh 平面上の三角形をマージ
        region(hi) = union(region(hi),polyshape(Sp0(St0(H_tids,:)',1:2)));
    end
end
%%
check_poly(oaa(1:2,id)')
plot(region(27))
%% stl そのままの表示
figure(11)
model = createpde;
importGeometry(model,STL);
%pdegplot(model,'FaceLabels','on')
pdegplot(model)
%mesh_default = generateMesh(model,'Hmax',20,'Hmin',0.5)
%% 三角形分割＋頂点の向き＋面の向き
% V=vertexNormal(TR);
% P = incenter(TR);
% F = faceNormal(TR);
% trisurf(TR,'FaceColor',[0.8 0.8 1.0]);
% axis equal
% hold on
% Xfb = TR.Points;
% quiver3(Xfb(:,1),Xfb(:,2),Xfb(:,3), ...
%     V(:,1),V(:,2),V(:,3),0.5,'Color','b');
% quiver3(P(:,1),P(:,2),P(:,3), ...
%     F(:,1),F(:,2),F(:,3),0.5,'color','r');
%% データ保存
save("regions.mat","region")
%load("regions.mat","region")
%%
load("regions.mat")
%% 動画生成
maxr=max(TR.Points(:,1:2));
minr=min(TR.Points(:,1:2));
make_animation(1:length(hrange),[1],@(k,span) fig(region(k),maxr,minr),@(h) [],1)

%% local functions
% 1直線状の点の簡略化
function [poly,q]=check_poly(points)
    % polyshape のwarning回避用 （これをやっても円柱などwarning が残ってしまう）
    % 並びがおかしいものはordered_cross_pointsで修正されているはず
    % ここでは１直線に並んでいるデータを削除していき角だけ残す．
    polyp = points;
    p = [points(2,:)-points(1,:),0];
    k = 0; % 飛ばすインデックス分
    q = [];% nan の位置を返すよう（debugのためでちゃんと動くなら必要ない）
    for i = 3:size(points,1)% points は一直線の場合削除していくが，初期points数でfor文は回る
        % i-2からi-1のベクトルp と　i-1からiへのベクトル t に対し，
        % p x t の外積計算をし，ｚ成分が０の時は一直線なので削除する．
        if i+k>size(points,1)
            break;
        end
        if isnan(points(i+k,1))% nan の時は次の領域へ
            q = [q,i+k];
            p = [points(i+k+2,:)-points(i+k+1,:),0];
            k = k+3;
        end
        if i+k > size(points,1) % nan の後に３点以上無い時に発生．なぜこんなことがあるのか謎．stlがうまく作れていない？
            break;
        end
        t=[points(i+k,:)-points(i-1+k,:),0];
        s=cross(p,t);
        if abs(s(3)) == 0 % 一直線上の場合
            points(i-1+k,:)= [];
            polyp(i-1+k,:)= [];
            t = [points(i-1+k,:)-points(i-2+k,:),0];
            k = k-1; % インデックスを調整するため
        end
        p = t;
    end
    %% 始線と終線が一直線の場合をケア
    t=[points(1,:)-points(end,:),0];
    s=cross(p,t);% [end-(end-1)] x [1-end]
    if abs(s(3)) == 0% 一直線上の場合
        points(end,:) = [];
        polyp(end,:)=[];
    end
    p = [points(2,:)-points(1,:),0];
    t = [points(1,:)-points(end,:),0];
    s = cross(p,t); % [2 - 1]x[1-end]
    if abs(s(3)) == 0 % 一直線上の場合
        points(1,:) = [];
        polyp(1,:)=[];
    end
    poly = polyshape(polyp);
end
% 平面との交点
function p=ordered_cross_points(Pt,Tr,h)
    % Pt : 候補となる点群
    % Tr : 点群インデックスで構成された三角形（各行が三角形）
    % h : 指定高さ
    % 三角形Tri = Pt(Tr',:)と高さhの平面の交点を縦ベクトルで返す．
    % 交点の順番はTriの頂点のうちｈ以上の最初の点から見た，三角形の向きと一致する順番
    % A, B, C : 三角形の頂点座標（縦ベクトル）この順に三角形の向きを表す．
    % 複数三角形の場合 Tri = [A1,B1,C1,A2,B2,C2,....]
    % h 平面の高さ
    % p ：平面との交点
    p = [];
    S= [0,0,1,-h];
    Tri = Pt(Tr',:)';
    for i = 1:size(Tr,1)
        [~,id] =max(Tri(3,3*i-2:3*i));
        A = Tri(:,3*(i-1)+mod(id-1,3)+1);
        B = Tri(:,3*(i-1)+mod(id,3)+1);
        C = Tri(:,3*(i-1)+mod(id+1,3)+1);
        p1 = crossp(S,A,[B,C]);
        if ~prod(sum(p1) ~= 0) % A-B, A-Cのどちらかが平面Sと交わらないとき || A点だけ平面上にある時
            p1= [p1(:,1),crossp(S,B,C),p1(:,2)];
        end
        p= [p,p1(:,sum(p1) ~= 0)];
    end
end
% 面と線分の交点
function p = crossp(plane,p1,P2)
    % plane = [a b c d] : a*x+b*y+c*z+d = 0 という平面
    % p1，p2：線分を構成する２点（縦ベクトル）
    % 交点がたまたま0となる場合はNaNがreturnされる
    p = zeros(size(P2));
    for i = 1:size(P2,2)
        p2 = P2(:,i);
        ax = p2-p1;
        den = -plane(1:3)*ax;
        if den ~=0 % 直線と平面が交わっているかの確認
            if den > 0
                tv = plane*[p1;1]/den;
                if 0<=tv && tv<=1 % 線分の中にあるか確認
                    p(:,i) = ax*tv+p1;
                end
            else
                tv = -plane*[p2;1]/den;
                if 0<=tv && tv<=1 % 線分の中にあるか確認
                    p(:,i) = -ax*tv+p2;
                end
            end
        elseif plane*[p1;1]==0 % 直線が平面上の場合
            p(:,i) = p1;
        end
    end
    if sum(p==0,'all') == numel(p)
        p = NaN;
    end
end
function flag = check_singular(A)
    % 使っていない
    % 3点が一直線状にあるかを判別 : 1 ：一直線上
    % y = a x + b
    %a = (A(1,2) - A(2,2))/(A(1,1) - A(2,1));
    %b = (A(1,1)*A(2,2) - A(2,1)*A(1,2))/(A(1,1) - A(2,1));
    %abs((A(1,2) - A(2,2))*A(3,1) + (A(1,1)*A(2,2) - A(2,1)*A(1,2)) - A(3,2)*(A(1,1) - A(2,1)))
    %if abs((A(1,2) - A(2,2))*A(3,1) + (A(1,1)*A(2,2) - A(2,1)*A(1,2)) - A(3,2)*(A(1,1) - A(2,1))) < 1e-10
    if abs((A(1,2) - A(2,2))*A(3,1) + (A(1,1)*A(2,2) - A(2,1)*A(1,2)) - A(3,2)*(A(1,1) - A(2,1))) ==0
        flag = 1;
    else
        flag = 0;
    end
end

% 動画作成用
function [] = make_animation(kspan,span,fig,base_fig,video_flag)
    % kspan : 時間
    % span : エージェント数
    %fig : fig(k,span) ：時刻ｋの図
    % base_fig : 背景
    h =figure;
    h;
    if video_flag
        FileName = strrep(strrep(strcat('Movie(',datestr(datetime('now')),')'),':','_'),' ','_');
        v=VideoWriter(FileName,'MPEG-4');
        v.Quality=100; % Quality o graphic
        open(v);
    end
    hold on
    for k = kspan
        base_fig(h);
        
        fig(k,span);
        %   update screen
        drawnow %limitrate
        if video_flag
            frame=getframe(gcf);
            writeVideo(v,frame);
        end
        hold off
    end
end
function fig(poly,maxr,minr)
    plot(poly);
    daspect([1 1 1]);
    xlabel( '{\it x} [m]');     ylabel( '{\it y} [m]');
    xlim([minr(1),maxr(1)]);
    ylim([minr(2),maxr(2)]);
    grid off;
end
