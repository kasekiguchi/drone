% function ref = generate_spline_curve_ref(loadedRef)
function ref = generate_spline_curve_ref(loadedRef,fcmd)
%% スプライン曲線
    while 1
        isUsed = input("Use loaded reference : '1' \nCreat now : '0' \nFill in : ");
        if isempty(isUsed)
            isUsed=1;
            disp("1")
            break
        elseif isUsed==0||isUsed==1
            break
        end
    end
    if isUsed
        if fcmd
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
        n = input("Order of spline curve : ");%スプライン曲線の次数(寄関数の方がいいよ)
        ref=MY_WAY_POINT_REFERENCE.way_point_ref(loadedRef,n,1,0);
    else
        %example
        % pointN = 3;%点の数
        % n = 5;%スプライン曲線の次数(寄関数の方がいいよ)
        % dt = 3;%各点の間の移動時間
        % ticksDelta = 0.15; %格子の間隔(m)
        % t = 0:dt:dt*(pointN-1);
    
        pointN = input("Number of point : ");%点の数
        n = input("Order of spline curve : ");%スプライン曲線の次数(寄関数の方がいいよ)
        dt = input("Time between points (s) : ");%各点の間の移動時間
        ticksDelta = input("Grid span (m) : "); %格子の間隔(m)
        time = (0:dt:dt*(pointN-1))';
        
        %x-y平面を描画
        i=1;
        f(i)=figure(i);
        f(i).WindowState = 'maximized';
        grid on
        xticks(-1.5:ticksDelta:1.5)
        yticks(-1.5:ticksDelta :1.5)
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
        
        rxy=MY_WAY_POINT_REFERENCE.way_point_ref([time,posi],n,1,0);
        
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
        xticks(-1.5:ticksDelta:1.5)
        yticks(-0.1:ticksDelta:2)
        xlim([-1.5 1.5])
        ylim([-0.1 2])
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
        text(posi(:,k),zeros(pointN,1),str)
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
        ref=MY_WAY_POINT_REFERENCE.way_point_ref([time,posi],n,1);
        while 1
            isSaved = input("Save spline curve : '1'\nNo save : '0'\nFill in : ");
            if isSaved==0||isempty(isSaved)
                disp("No save")
                break
            elseif isSaved==1
                T = table(time,posi);
                filename = fullfile(pwd,"reference\functions\spline_curve\waypoint.xlsx");
                sheetname = input("White sheet name : ","s");
                writetable(T,filename,'Sheet',sheetname);
                break
            end
        end
    end
end