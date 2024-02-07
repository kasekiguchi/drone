function ref = generate_spline_curve_ref(loadedRef,order,fcmd)
%% スプライン曲線
%loadedRef : あらかじめ決めておいたreference
%fcmd : 入力引数にいれたシートを使うときは1,コマンドでシートを選びたいときは0にする
%order : 関数の次数を設定
%Excelシートに記録しておいたwaypointを使う場合と新しく作成する場合の2パターンに分かれている
%===新しく作る場合の初期設定の例===
% pointN = 3;%点の数
% order = 5;%スプライン曲線の次数(寄関数の方がいいよ)
% dt = 3;%各点の間の移動時間(point間の移動距離で決める)
% ticksDelta = 0.15; %プロットに用いる座標の格子の間隔(m)
%-------------------------------------------------------------------------------------
% MY_WAY_POINT_REFERENCE.way_point_ref(val,n,fconfirm,fdrowfig)
% val         %時間とwaypoint
% n           %多項式次数
% fdrowfig=1  %図を描画するか

%手動で値を設定するとき(使わないときコメントアウトする)
isManualSetting = 1;%手動でwaypointを作るとき1
pointN = 5; %waypointの数
dt = 2;%waypoint間の時間
time =  (0:dt:dt*(pointN-1))';
% wp = [0,0,0;0.5*round(1*randn(pointN-1,3),3)];%waypointの設定初めは初期値0
% wp = round(0.5*randn(pointN,3),3);%waypointの設定

min_z = 0.5;
max_z = 1.5;
min_xy = 0;
max_xy = 0;
wp_xy = round((max_xy-min_xy).*rand(pointN,2) + min_xy,2);%waypointの設定
wp_z = round((max_z-min_z).*rand(pointN,1) + min_z,1);%waypointの設定
% wp_z = ones(5,1);
wp_xy(1,1:2) = 0; %初期値の固定
max_z1 = 1.2;
min_z1 = 0.8;
wp_z(1,1) = round((max_z1 - min_z1).*rand + min_z1,2); %初期値の固定
waypoints = [time, wp_xy, wp_z];

    while 1
        if isManualSetting
            isUsed = 0;
        else
            isUsed = input("Use loaded reference : '1' \nCreat now : '0' \nFill in : ");
        end
        if isempty(isUsed)
            isUsed=1;
            disp("1")
            break
        elseif isUsed==0||isUsed==1
            break
        end
    end
    if isUsed && ~isManualSetting
        if ~fcmd
            disp("Choose a sheet from the following")
            loadedSheet = sheetnames('waypoint.xlsx')
            while 1
                loadedSheetName = input("Fill in sheet name : ","s");
                    if ismember(loadedSheetName, loadedSheet)
                        break
                    else
                        disp("No applicable sheet")
                    end
            end
            loadedRef = readmatrix("waypoint.xlsx",'Sheet',loadedSheetName);
        end     
            ref=MY_WAY_POINT_REFERENCE.way_point_ref(loadedRef,order,1);
    else
        if isManualSetting
            ref = MY_WAY_POINT_REFERENCE.way_point_ref(waypoints,order,1); %手動で設定したときはここで軌道が生成される       
        else
            %example
            % pointN = 3;%点の数
            % n = 5;%スプライン曲線の次数(寄関数の方がいいよ)
            % dt = 3;%各点の間の移動時間
            % ticksDelta = 0.15; %格子の間隔(m)
        
            pointN = input("Number of point : ");%点の数
            % n = input("Order of spline curve : ");%スプライン曲線の次数(寄関数の方がいいよ)
            ticksDelta = input("Grid span (m) : "); %格子の間隔(m)
            while 1
                isSameTime = input("Use same time span '1'\nUse difference time span '0'\nFill in : ");
               if isempty(isSameTime)
                    isSameTime = 1;
                    disp("1")
                    break
                elseif isSameTime==0||isSameTime==1
                    break
                end
            end
    
            if isSameTime
                dt = input("Time between points (s) : ");%各点の間の移動時間
                time = (0:dt:dt*(pointN-1))';
            else
                while 1
                    fprintf("The number of spans is '%d'\n",pointN - 1)
                    disp("Example (number of span is 5): [2,4,2,3,1] or [2;4;2;3;1]")
                    dt = input("Time spans (s) : ");%各点の間の移動時間
                    if pointN == length(dt) + 1
                        tmp_t = dt;
                        time =  zeros(pointN,1);
                        for i = 1:length(tmp_t)
                            time(i+1) = time(i) + tmp_t(i);
                        end
                        break
                    else 
                        disp("The number of spans is not correct.")
                    end
                end
            end
            
            %x-y平面を描画
            i=1;
            f(i)=figure(i);
            f(i).WindowState = 'maximized';
            grid on
            axisPositive = 0:ticksDelta:1.5;
            axisNegative = -flip(axisPositive(2:end));
            xticks([axisNegative,axisPositive])
            yticks([axisNegative,axisPositive])
            xlim([-1.5 1.5])
            ylim([-1.5 1.5])
            xline(0);
            yline(0);
            xlabel('$x$ (m)','Interpreter','latex',"FontSize",18)
            ylabel('$y$ (m)','Interpreter','latex',"FontSize",18)
            set(gca,"TickLabelInterpreter","latex")
            daspect([1 1 1]);
            hold on
            posi = zeros(pointN,3);
            for j = 1:pointN
                [gx,gy] = ginput(1);
                gx=max(min(gx,1.5),-1.5);
                gy=max(min(gy,1.5),-1.5);
                gxy = [gx,gy];
                %どちらの隣の格子点に判別して最も近い格子点に配置
                qb = ticksDelta*fix(gxy./ticksDelta);%商を求める
                r = gxy - qb;%余りを求める
                posi(j,1:2) = qb + ticksDelta*round(r./ticksDelta);%余りをticksDeltaで割って四捨五入し，ticksDelta倍したものを商に加える
            
                % posi(j,1:2) = round([gx,gy],1);
                plot(posi(j,1),posi(j,2),'Marker','.','MarkerSize',12);
                str = ['  p',num2str(j),' (',num2str(posi(j,1)),', ',num2str(posi(j,2)),')'];
                text(posi(j,1),posi(j,2),str)
            end
            i=i+1;
            
            rxy=MY_WAY_POINT_REFERENCE.way_point_ref([time,posi],order,0);
            
            f(i)=figure(i);
            f(i).WindowState = 'maximized';
            tiledlayout("horizontal")
            nexttile
            plot(rxy.xyz(1,:),rxy.xyz(2,:))
            xlabel('$x$ (m)','Interpreter','latex',"FontSize",18)
            ylabel('$y$ (m)','Interpreter','latex',"FontSize",18)
            daspect([1,1,1])
            pbaspect( [1,0.78084714548803,0.78084714548803]);
            hold on
            plot(posi(:,1),posi(:,2),'Marker','o','LineStyle','none')
            set(gca,"TickLabelInterpreter","latex")
            grid on
            nexttile
            plot(rxy.xyz(1,:),rxy.xyz(3,:))
            xlabel('$x$ (m)','Interpreter','latex',"FontSize",18)
            ylabel('$z$ (m)','Interpreter','latex',"FontSize",18)
            daspect([1,1,1])
            pbaspect( [1,0.78084714548803,0.78084714548803]);
            hold on
            plot(posi(:,1),posi(:,3),'Marker','o','LineStyle','none')
            set(gca,"TickLabelInterpreter","latex")
            grid on
            nexttile
            plot(rxy.xyz(2,:),rxy.xyz(3,:))
            xlabel('$y$ (m)','Interpreter','latex',"FontSize",18)
            ylabel('$z$ (m)','Interpreter','latex',"FontSize",18)
            daspect([1,1,1])
            pbaspect( [1,0.78084714548803,0.78084714548803]);
            hold on
            plot(posi(:,2),posi(:,3),'Marker','o','LineStyle','none')
            set(gca,"TickLabelInterpreter","latex")
            grid on
            i=i+1;
            while 1
                k = input("If you use 'x-z' codinate, push '1' \nIf you use 'y-z' codinate, push '2' \nFill in : ");
                if isempty(k)
                    k=1;
                    disp("1")
                    break
                elseif k==1||k==2
                    break
                end
            end
            f(i)=figure(i);
            f(i).WindowState = 'maximized';
            grid on
            xticks([axisNegative,axisPositive])
            axisPositive2 = 0:ticksDelta:2;
            axisNegative2 = -flip(ticksDelta:ticksDelta:0.2);
            yticks([axisNegative2,axisPositive2])
            xlim([-1.5 1.5])
            ylim([-0.2 2])
            xline(0);
            yline(0);
            if k==1
                xlabel('$x$ (m)','Interpreter','latex',"FontSize",18)
            else
                xlabel('$y$ (m)','Interpreter','latex',"FontSize",18)
            end
            ylabel('$z$ (m)','Interpreter','latex',"FontSize",18)
            set(gca,"TickLabelInterpreter","latex")
            daspect([1 1 1]);
            hold on
            plot(posi(:,k),zeros(pointN,k),'Marker','.','MarkerSize',12,'LineStyle','none');
            str = "  px" + num2str((1:pointN)') + " (" + num2str(posi(:,k)) + ")";
            text(posi(:,k),zeros(pointN,1),str,"Rotation",-90)
            for j = 1:pointN
                [~,gz] = ginput(1);
                gz=max(min(gz,2),0);
                %どちらの隣の格子点に判別して最も近い格子点に配置
                qb = ticksDelta*fix(gz./ticksDelta);%商を求める
                r = gz - qb;%余りを求める
                posi(j,3) = qb + ticksDelta*round(r./ticksDelta);%余りをticksDeltaで割って四捨五入し，ticksDelta倍したものを商に加える
            
                plot(posi(j,k),posi(j,3),'Marker','.','MarkerSize',12);
                str = ['  p',num2str(j),' (',num2str(posi(j,k)),', ',num2str(posi(j,3)),')'];
                text(posi(j,k),posi(j,3),str)
            end
            fprintf("If you confirmed points, push the Enter key.");
            input("");
            ref=MY_WAY_POINT_REFERENCE.way_point_ref([time,posi],order,1);
        end
        % while 1
        %     isSaved = input("Save spline curve : '1'\nNo save : '0'\nFill in : ");
        %     if isSaved==0||isempty(isSaved)
        %         disp("No save")
        %         break
        %     elseif isSaved==1
        %         T = table(time,posi);
        %         filename = fullfile(pwd,"reference\functions\spline_curve\waypoint.xlsx");
        %         sheetname = input("White sheet name : ","s");
        %         writetable(T,filename,'Sheet',sheetname);
        %         break
        %     end
        % end
    end
end