classdef WALL_REFERENCE < handle
    % 既知である環境に対し，目標位置(x,y)，目標姿勢角(yaw)を生成するクラス
    % obj = WALL_REFERENCE()
    properties % objの中に何が欲しいか決める所
        param
        func % 時間関数のハンドル
        self
        area_params
        region0
        region1
        region2
        area1
        area2
        fShow
        vrtx_len_limit
        result
    end
    methods % リファレンスクラス
        function obj = WALL_REFERENCE(self,pparam) % doへの橋渡し，中身を計算したりして決める．1次的な部分
            % 【Input】ref_gen, param, "HL"
            % ref_gen : reference function generator
            % param : parameter to generate the reference function
            % "HL" : flag to decide the reference for HL
            obj.self = self; % selfは現在の機体位置が入る
            % obj.self.state.q = quat2eul(obj.self.state.q');
            
            % regionの説明 = regionは壁面，柱など既知とする全ての環境情報
            % [regionはまず0を作り，0を基に1,2を作成する．1は飛行経路，2は姿勢角の目標点を出す際に使用] %
            % region0 : 観測する部屋の壁面や柱の形状(2次元 x,y) <=これだけ自分で作る
            % region2 : region0からd[m]内側にregion0と同じ形状を作成する(これが機体の飛行経路となる)
            % region1 : region2からd[m]外側にregion2と同じ形状を作成(これが機体姿勢角の目標点を作成する経路他なる)
            
            % pparamはReference_Wall_observationから引っ張ってきたものが入る.pparam=region0となる.
            obj.region0 = pparam.region0;
            obj.vrtx_len_limit = 1.5;
            d = 0.5; %壁面と機体の距離をどのくらい離すか入力してください.           
            region2 = polybuffer(obj.region0,-d,'JointType','miter','MiterLimit',2); %想定環境においてd [m]内側に移動経路用ポリバッファ作成　飛行経路
            if isempty(region2.Vertices)
                error("ACSL : the region is too narrow to flight.");%狭すぎるとこのエラー
            end
            region1 = polybuffer(region2,d,'JointType','miter','MiterLimit',2); % Vertices の数をregion1,2 で揃えるため　姿勢角のカメラのためのもの
            if length(region1.Vertices(:,1))~=length(region2.Vertices(:,1))
                error("ACSL : The number of vertices is different between regions 1 and 2.");%頂点の数が違うエラー
            end
            obj.result.state = STATE_CLASS(struct('state_list',["p","xd"],'num_list',[4,20]));
            
            %             obj.func=str2func(varargin{1}{1});
            %             obj.func=obj.func(varargin{1}{2});
            %             if length(varargin{1})>2
            %                 if strcmp(varargin{1}{3},"HL")
            %                     obj.func = gen_ref_for_HL(obj.func);
            %                     obj.result.state=STATE_CLASS(struct('state_list',["xd","p"],'num_list',[20,3]));
            %                 end
            %             else
            %                 obj.result.state=STATE_CLASS(struct('state_list',["xd","p"],'num_list',[length(obj.func(0)),3]));
            %             end
            
            %入力%
            PlotColor=['r';'b';'g'];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%% ↓入力項 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Angle = 115; % 機体の視野角[°/deg]を入力してください．全体ではなく使用できそうな真ん中部分のみの方が良いかも
            Cover = 60;  % 写真の重複率[%] Lをどの程度被せるか．
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%% ↓計算項 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%一部使わないかも
            area_params.Angle = (Angle/(180/pi))/2; % Angleの角度をラジアンに直す計算を行っている．
            L = d * tan(area_params.Angle); % 2Lが観測可能な横幅．Lは半分
            Cover = Cover * 0.01; % ％を少数に変換
            D = (2 * L) - ((2 * L)*Cover); % Dは機体が1ステップで移動する距離．停止pointから次の目標位置までの距離．
            vrtx_idx = 6; % フラッグ管理用．特に角を目標位置に設定するために使用．
            P_flag = 1; % 特に機体の動作を切り替える役割として使用．いらないかも
            counter = 1;% 停止のために時間を計算するよう
            area_params.LRS.Range = d/cos(area_params.Angle);% 扇形の半径
            %%%%%%%%%%%%%%%%%%%%↓計算に必要な要素を設定 %%%%%%%%%%%%%%%%%
            area_params.vrtx_idx = 1;%旧flag
            area_params.fCCW = 0; % 観測する移動方向 0:時計回り．1:反時計回り
            area_params.curv_limit_num = 10;%曲面を移動する際に飛ばす点の最大数
            area_params.D = D; % 上記のD
            area_params.counter = 10; % 目標位置にいる時間を数えるよう
            area_params.stoptime = 40; % 目標位置に停止する時間設定．
            area_params.area_idx = 0; % 見ているものの切り替え用　壁と柱など
            area_params.fAreaComplete = 2; % 見終わったか判別するよう
            area_params.update = 1; % 目標位置を変えるかどうかの判断
            area_params.didx = 1; % 曲面上で壁面を1周し終えた時のケア
            area_params.ka = 1; % 画面記録用.showで使用
            nan_indices=find(isnan(region2.Vertices(:,1)));%nanの位置づけ nanの行が入る
            obj.fShow = pparam.fShow;
            %% area の並び換え
            area_num = length(nan_indices)+1;% エリアの数
            if area_num ~= 1 % 複数エリアがある場合
                tmp = [0;nan_indices;length(region2.Vertices(:,1))+1];
                [~,perm] = sort(arrayfun(@(i) min(vecnorm(obj.self.model.state.p(1:2)'-region2.Vertices(tmp(i)+1:tmp(i+1)-1,:),2,2)),1:area_num));% 各エリア頂点への最短距離で昇順にソートするためのpermutation
                tmp1 = [];
                tmp2 = [];
                for i = 1:area_num
                    tmp1 = [tmp1;NaN NaN;region1.Vertices(tmp(perm(i))+1:tmp(perm(i)+1)-1,:)];% areaを並び変えたregion
                    tmp2 = [tmp2;NaN NaN;region2.Vertices(tmp(perm(i))+1:tmp(perm(i)+1)-1,:)];
                end
                region1.Vertices = tmp1(2:end,:);% 頭のNaN削除
                region2.Vertices = tmp2(2:end,:);
                area1.Vertices=region1.Vertices(1:nan_indices(1)-1,:);% 壁面
                area2.Vertices=region2.Vertices(1:nan_indices(1)-1,:);% 飛行経路
            else % 領域が単一エリアの場合
                area1=region1;
                area2=region2;
            end
            nan_indices=find(isnan(region2.Vertices(:,1)));%nanの位置を再設定
            area_params.nan_indices = [0;nan_indices]; % 先頭に０を追加：emptyのときも同様に扱えるよう
            
            %% 初期化ポリシー修正後直す：obj.self
            [obj.area1,obj.area2,obj.area_params] = obj.target_area_gen(obj.self.model,region1,region2,area1,area2,area_params);%
            obj.region1 = region1;
            obj.region2 = region2;
            obj.result.region0 = obj.region0;
            obj.result.region1 = obj.region1;
            obj.result.region2 = obj.region2;
            obj.result.area_params = area_params;
            if isempty(obj.result.state.p)
                % obj.result.state.p = [obj.self.estimator.result.state.p;0];
                obj.result.state.p = [0;0;0;0];
            end
        end
        function result = do(obj,target_height) %ここから本体
            %%%%%%%%%%%%%% 以下に目標位置を算出する流れを記述 %%%%%%%%%%%%%%%%%%%
            % 1. 外壁に近い領域は外壁にマージしarea1, area2を生成
            % 2. フラグ情報をもとにarea2 上に目標位置rpos 設定
            % 3. ２の位置とフラグ情報からarea1上に視線の向きAposを設定
            % 4. フラグ情報の更新
            
            [obj.area1,obj.area2,obj.area_params] = obj.target_area_gen(obj.self.estimator.result,obj.region1,obj.region2,obj.area1,obj.area2,obj.area_params); %１
            obj.area_params = obj.reference_position_gen(obj.self.estimator.result,obj.area1,obj.area2,obj.area_params); %２
            obj.area_params = obj.set_target_direction(obj.area1,obj.area_params); %３
            obj.area_params = obj.update_flags(obj.self.estimator.result,obj.area_params); %４
            % リファレンス設定
            obj.result.area_params = obj.area_params;
            obj.result.state.p  = [obj.area_params.rpos;target_height{1};atan2(obj.area_params.Apos(2)-obj.area_params.rpos(2),obj.area_params.Apos(1)-obj.area_params.rpos(1))];
            obj.result.state.xd = [obj.area_params.rpos;target_height{1};atan2(obj.area_params.Apos(2)-obj.area_params.rpos(2),obj.area_params.Apos(1)-obj.area_params.rpos(1))];
            result = obj.result;
            if obj.fShow
                obj.show();
            end
        end
        function show(obj,param) % mainでwhile回すたびにplot表示させる部分
            %             if (obj.area_params.fAreaComplete==2 && obj.area_params.update==1)  || obj.fShow == 1
            clf(figure(2));
            %%%%%%%%%%%%%%%%%%%%%%%% ↓グラフで目標位置を設定  %%%%%%%%%%%%%%%%%%%%%%%%
            %       plot(Target.Point(1,:),Target.Point(2,:),'k:o', 'MarkerSize',20,'MarkerEdgeColor','black','MarkerFaceColor','green','DisplayName','Target Point');
            %%%%%%%%%%%%%%%%%%%%%%%% ↓グラフでoを作成する  %%%%%%%%%%%%%%%%%%%%%%%%%%%
            hold on;
            set( gca, 'FontSize', 26); % 文字の大きさ設定
            axis equal;
            axis([0 6 0 6]);
            daspect([1 1 1])
            %if wall.flag==1
            d  = 2; % ここのdは下のpgonのみで利用
            pgon = polybuffer(obj.region0,d,'JointType','square');
            frame=[min(pgon.Vertices);max(pgon.Vertices)];
            plot(obj.region0);
            xlim(frame(:,1)');
            ylim(frame(:,2)');
            hold on
            % xlim([min(obj.region0.Vertices(:,1))-2 max(obj.region0.Vertices(:,1))+2]);ylim([min(obj.region0.Vertices(:,2))-2 max(obj.region0.Vertices(:,2))+2]);
            plot (obj.region2,'FaceColor','w');
            %%%%%%%%%%%%%%%%%%%%%%%%% ↓目標位置表示(緑) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            plot (obj.area_params.Apos(1,1),obj.area_params.Apos(2,1),'k:o', 'MarkerSize',19,'MarkerEdgeColor','black','MarkerFaceColor','yello','DisplayName','Target Point');
            plot (obj.area_params.vpos(1,1),obj.area_params.vpos(2,1),'k:x', 'MarkerSize',19,'MarkerEdgeColor','black','MarkerFaceColor','yello','DisplayName','Target Point');
            plot (obj.area_params.vppos(1,1),obj.area_params.vppos(2,1),'k:x', 'MarkerSize',19,'MarkerEdgeColor','black','MarkerFaceColor','yello','DisplayName','Target Point');
            plot (obj.area_params.Vpos(1,1),obj.area_params.Vpos(2,1),'k:x', 'MarkerSize',19,'MarkerEdgeColor','black','MarkerFaceColor','yello','DisplayName','Target Point');
            plot (obj.area_params.Vppos(1,1),obj.area_params.Vppos(2,1),'k:x', 'MarkerSize',19,'MarkerEdgeColor','black','MarkerFaceColor','yello','DisplayName','Target Point');
            plot(obj.result.state.p(1,:),obj.result.state.p(2,:),'k:o', 'MarkerSize',19,'MarkerEdgeColor','black','MarkerFaceColor','red','DisplayName','Target Point');
            plot(obj.self.model.state.p(1,1),obj.self.model.state.p(2,1),"k:.", 'MarkerSize',40,'DisplayName','State of obj.self');%機体位置の表示
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % yaw = quat2eul(obj.self.model.state.q');%オイラー角にして方向を変化できているか確認する．
            OUGI = obj.arc(obj.area_params.LRS.Range,obj.self.model.state.p(1,1),obj.self.model.state.p(2,1),obj.area_params.Angle,obj.self.model.state.q(3));%観測方向の表示(扇形の半径,機体X,機体Y,扇形の角度,機体yaw,色(赤))
            %     xticklabels({'0','20','40','60','80','100'})
            %     yticklabels({'0','20','40','60','80','100'})
            xlabel('{\sl x} [m]','FontSize',18);ylabel('{\sl y} [m]','FontSize',18);
            grid on;
            hold off;
            % M(obj.area_params.ka) = getframe(gcf);
            % obj.area_params.ka = obj.area_params.ka + 1;
            obj.fShow = 1;
            %             end
        end
        function draw_movie(obj,logger) % 動画を部分（未完成）
            %%%%%%%%%%%%%%%%%%%%%%%以下動画や画像作成用保存項%%%%%%%%%%%%%%%%%%%%%%%%
            SAVE.k(:,ka) = ka;
            %SAVE.obj.self.input(:,ka) = obj.self.input;
            SAVE.AngleTarget(:,ka) = area_params.Apos;
            SAVE.obj.self.model.state.q(:,ka) = obj.self.model.state.q;%機体位置を重ねて画像に使用とした．
            SAVE.obj.self.model.state.p(:,ka) = obj.self.model.state.p;%機体位置を重ねて画像に使用とした．
            SAVE.obj.self.reference.point.result.state.p(:,ka) = obj.self.reference.point.result.state.p;%機体位置を重ねて画像に使用とした．
            M(ka) = getframe(gcf);%動画作成用
            ka = ka + 1;
        end
        %% ↓[doなどで使う関数定義]
        function D = arc(obj,r,xc,yc,omega,alpha) % showで使用する扇形プロット用function
            %%観測方向の表示(扇形の半径,機体X,機体Y,扇形の角度,機体yaw)
            % r  : radius of obj.arc
            % xc : position x
            % yc : position y
            gamma=alpha-omega;%yaw-扇の角度
            theta = linspace(0,omega*2);
            x = r*cos(theta+gamma) + xc;
            y = r*sin(theta+gamma) + yc;
            D=fill(x,y,'r');
            set(D,'FaceColor','red','FaceAlph',0.1,'EdgeColor','none');
            hold on;
            D=plot(x,y,'r');
            hold on;
            X=[xc x(1,1) xc x(1,end)];
            Y=[yc y(1,1) yc y(1,end)];
            D=plot(X,Y,'red');
            hold on;
            X=[xc x(1,1) x(1,end)];
            Y=[yc y(1,1) y(1,end)];
            D=fill(X,Y,'red');
            set(D,'FaceColor','red','FaceAlph',0.1,'EdgeColor','none');
        end
        function d = angle_diff(obj,a,b)
            % d : 向きa,b のベクトルの内積
            d = cos(a)*cos(b)+sin(a)*sin(b);
        end
        function pos = projection_point(obj,p1,p2,p3)
            %  pos = p1-p2　線分へのp3から下ろした垂線の足
            a = p1(1);
            b = p1(2);
            c = p2(1);
            d = p2(2);
            X = p3(1);
            Y = p3(2);
            %%
            % syms a b c d x y X Y al be ga la s real
            % A=[a;b];
            % B=[c;d];
            % O=[X;Y];
            % H = [x;y];
            % ans0=solve([(A-B)'*(H-O)==0;H == s*A+(1-s)*B],[x,y,s]);
            % % J = (X-x)^2+(Y-y)^2  - la*(al*x+be*y + ga); の最適解条件
            % Jx=2*(X-x)+la*al==0;
            % Jy=2*(Y-y)+la*be ==0;
            % Jla = al*x+be*y + ga==0;
            % inner_prod = [(c-a), (d-b)]*[(X-x);(Y-y)]==0;
            % ans0=solve([al*a+be*b + ga==0;al*c+be*d + ga==0;inner_prod;Jx;Jy;Jla],[al,be,ga,x,y,la]);
            %%
            if (a^2 - 2*a*c + b^2 - 2*b*d + c^2 + d^2)~=0
                pos=[(X*a^2 - a*b*d + Y*a*b - 2*X*a*c + a*d^2 - Y*a*d + b^2*c - b*c*d - Y*b*c + X*c^2 + Y*c*d);       (a^2*d - a*b*c + X*a*b - a*c*d - X*a*d + Y*b^2 + b*c^2 - X*b*c - 2*Y*b*d + X*c*d + Y*d^2)]/(a^2 - 2*a*c + b^2 - 2*b*d + c^2 + d^2);
            else
                pos=[X;Y];
            end
            
            %%
        end
        function [area1,area2,area_params] = target_area_gen(obj,agent,region1,region2,area1,area2,area_params)
            % 条件一覧：エリアを見終わった，目標地点更新
            if area_params.fAreaComplete==2 && area_params.update==1
                area_idx = area_params.area_idx;
                nan_indices = area_params.nan_indices;
                fCCW = area_params.fCCW;
                
                if area_idx+1 == length(nan_indices)
                    area1.Vertices=region1.Vertices(nan_indices(area_idx+1)+1:end,:);
                    area2.Vertices=region2.Vertices(nan_indices(area_idx+1)+1:end,:);
                    area_idx=area_idx+1;
                else
                    if area_idx == length(nan_indices)
                        area_idx=1;
                    else
                        area_idx=area_idx+1;
                    end
                    %        if length(nan_indices)>2
                    if sum(nan_indices ~= [0])
                        area1.Vertices=region1.Vertices(nan_indices(area_idx)+1:nan_indices(area_idx+1)-1,:);
                        area2.Vertices=region2.Vertices(nan_indices(area_idx)+1:nan_indices(area_idx+1)-1,:);
                    end
                end
                %% area2, vpos, vpposの設定：agent 位置に応じてarea を再配置（agent最近傍vertexをCWで１にCCWでXに）
                apos=agent.state.p(1:2); % agent position
                X = length(area2.Vertices(:,1));
                [~,vrtx_idx]=min(vecnorm(apos'-area2.Vertices,2,2)); % 自己位置に近い点を選択
                if fCCW
                    area2.Vertices = [area2.Vertices(vrtx_idx+1:end,:);area2.Vertices(1:vrtx_idx,:)];
                    vppos = area2.Vertices(1,:)';
                    area1.Vertices = [area1.Vertices(vrtx_idx+1:end,:);area1.Vertices(1:vrtx_idx,:)];
                    Vppos = area1.Vertices(1,:)';
                    vrtx_idx = X;
                else
                    area2.Vertices = [area2.Vertices(vrtx_idx:end,:);area2.Vertices(1:vrtx_idx-1,:)];
                    vppos = area2.Vertices(X,:)';
                    area1.Vertices = [area1.Vertices(vrtx_idx:end,:);area1.Vertices(1:vrtx_idx-1,:)];
                    Vppos = area1.Vertices(X,:)';
                    vrtx_idx = 1;
                end
                vpos = area2.Vertices(vrtx_idx,:)';
                Vpos = area1.Vertices(vrtx_idx,:)';
                
                area_params.rpos = vpos;
                area_params.Apos = Vpos;
                area_params.area_idx  = area_idx;
                area_params.vpos = vpos;
                area_params.vppos = vppos;
                area_params.Vpos = Vpos;
                area_params.Vppos = Vppos;
                area_params.vrtx_idx = vrtx_idx;
                area_params.X = X;
                area_params.fAreaComplete = 0;
                area_params.update = 1;
            end
        end
        function area_params = reference_position_gen(obj,agent,area1,area2,area_params)
            if area_params.update % 目標地点更新
                apos = agent.state.p(1:2);
                rpos=area_params.rpos;
                vpos=area_params.vpos;
                vppos=area_params.vppos;
                Vpos=area_params.Vpos;
                Apos=area_params.Apos;
                D=area_params.D;
                vrtx_idx=area_params.vrtx_idx;
                X=area_params.X;
                fCCW = area_params.fCCW;
                didx = 1;
                curv_limit_num = area_params.curv_limit_num;
                % 目標が角で角を見ているとき
                if prod([vpos;Apos] == [rpos;Vpos])
                    tmp = vrtx_idx;
                    [vrtx_idx,fLoop] = obj.vrtx_idx_func(vrtx_idx,1,X,fCCW);
                    % 目標位置が近すぎる場合のケア：曲面対策
                    
                    while norm(area2.Vertices(vrtx_idx,:)'-area2.Vertices(tmp,:)')<obj.vrtx_len_limit && abs(vrtx_idx-tmp) < curv_limit_num
                        [vrtx_idx,fLoop] = obj.vrtx_idx_func(vrtx_idx,1,X,fCCW);
                        didx = didx+1;
                    end
                    vppos = vpos;
                    vpos = area2.Vertices(vrtx_idx,:)';
                    area_params.Vppos = Vpos;
                    area_params.Vpos = area1.Vertices(vrtx_idx,:)';
                    if fLoop == 1
                        area_params.fAreaComplete = 1;
                    end
                else
                    if norm(vpos-apos) < D
                        area_params.rpos = vpos;
                    else
                        area_params.rpos = apos + D*(vpos-vppos)/norm(vpos-vppos);
                    end
                end
                area_params.didx= didx;
                area_params.vpos = vpos;
                area_params.vppos = vppos;
                area_params.vrtx_idx = vrtx_idx;
            end
        end
        function area_params = set_target_direction(obj,area1,area_params)
            if area_params.update % 目標地点更新
                rpos=area_params.rpos;
                Vpos=area_params.Vpos;
                Vppos=area_params.Vppos;
                Apos=area_params.Apos;
                area_params.Apos = obj.projection_point(Vpos,Vppos,rpos);
                % 角にいて，角を見ていない場合
                if prod(area_params.Apos == Apos) && ~prod(Vpos == Apos)
                    area_params.Apos=Vpos;
                end
                if prod(Vpos == Vppos)
                    vrtx_idxn = obj.vrtx_idx_func(find(sum(area1.Vertices==Vpos',2)==2),1,area_params.X,area_params.fCCW);
                    area_params.Vnpos=area1.Vertices(vrtx_idxn,:)';
                    area_params.Apos= obj.projection_point(area_params.Vnpos,Vpos,rpos);
                end
            end
        end
        function area_params = update_flags(obj,agent,area_params)
            % update : 目標地点の更新
            % fAreaComplete : エリアを見終わったかの判別
            rpos=area_params.rpos;
            vppos=area_params.vppos;
            update = area_params.update;
            fAreaComplete = area_params.fAreaComplete;
            vrtx_idx = area_params.vrtx_idx;
            X = area_params.X;
            counter = area_params.counter;
            stoptime = area_params.stoptime;
            fCCW = area_params.fCCW;
            didx=area_params.didx;
            if update == 1
                if vppos == rpos % 目標が角にある時
                    [~,fLoop] = obj.vrtx_idx_func(obj.vrtx_idx_func(vrtx_idx,-didx-1,X,fCCW),didx,X,fCCW);
                    if fLoop == 1  && fAreaComplete == 1
                        area_params.fAreaComplete = 2;
                    end
                end
                update = 0;% 目標位置の更新をするか
            end
            %% update counterer
            Lra = obj.result.state.p(1:2) - agent.state.p(1:2);
            %                          yaw = quat2eul(obj.self.model.state.q');
            if norm(Lra) < 0.15 %&& obj.angle_diff(yaw(3),obj.result.state.p(4))>0.85
                counter = counter+1;
                if counter > stoptime %停止時間
                    update = 1;
                    counter = 0;
                end
            end
            area_params.counter = counter;
            area_params.update = update;
        end
        function [idx,flag]  = vrtx_idx_func(obj,idx,num,X,fCCW)
            if fCCW
                idx = idx - num;
            else
                idx = idx + num;
            end
            flag = 1;
            if idx < 1
                idx = X+idx;
            elseif idx > X
                idx = idx-X;
            else
                flag = 0;
            end
        end
        function [region0] = regions(Q)
            if Q == 0 % 実験室用
                th=pi/2:-0.1:-0.1;
                x1 = [5+5*cos(th) 10 0 0 5];
                y1 = [5+5*sin(th) 0 0 10 10];
                %  x1 = [10 0 0 10];
                %  y1 = [0 0 10 10];
                x2 = [6 4 4 6];
                y2 = [4 4 6 6];
                region0 = polyshape({x1,x2},{y1,y2}); %ドーナツ形
                %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
                xlim([-2 12]);ylim([-2 12])
                
            elseif Q == 1 % 柱と曲面
                th=pi/2:-0.1:-0.1;
                x1 = [5+5*cos(th) 10 0 0 5];
                y1 = [5+5*sin(th) 0 0 10 10];
                %  x1 = [10 0 0 10];
                %  y1 = [0 0 10 10];
                x2 = [6 4 4 6];
                y2 = [4 4 6 6];
                region0 = polyshape({x1,x2},{y1,y2}); %ドーナツ形
                %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
                xlim([-2 12]);ylim([-2 12])
                
            elseif  Q == 2 % 特殊な環境
                thh=0:0.1:2*pi;
                th=0:-0.1:-pi/2;
                x1 = [7 0 0 3 3 0 0 5 5 10 10 14 7+7*cos(th)];
                y1 = [0 0 9 9 10 10 14 14 16 16 14 14 7+7*sin(th)];
                % x2 = [5 3 3 5];
                % y2 = [3 3 5 5];
                x2 = [4.5+1*cos(thh)];%円柱
                y2 = [4.5+1*sin(thh)];%円柱
                x3 = [10 8 8 10];
                y3 = [8 8 10 10];
                region0 = polyshape({x1,x2,x3},{y1,y2,y3}); %ドーナツ形
                %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
                xlim([-2 16]);ylim([-2 18])
                
            elseif  Q == 3 % 柱２
                th=pi/2:-0.1:-0.1;
                x1 = [15 0 0 15];
                y1 = [0 0 15 15];
                x2 = [5 3 3 5];
                y2 = [3 3 5 5];
                x3 = [12 8 8 12];
                y3 = [8 8 12 12];
                region0 = polyshape({x1,x2,x3},{y1,y2,y3}); %ドーナツ形
                xlim([-2 17]);ylim([-2 17]);
            end
        end
    end
end