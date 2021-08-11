function result = Cov_randspone(xmax,xmin,ymax,ymin,agent,SponeType,AllSateP)
%エリアを指定してランダムに場所指定
AgentArea = agent.env.huma_load.param.spone_area;
R_name = agent.reference.name{1};
Rxd = agent.reference.(R_name).xd;
buff = -0.3;
area2 = polybuffer(AgentArea,buff,'JointType','miter','MiterLimit',2);
switch SponeType
    case 'Alignment'
        FealdIn = 0;KeepDestance = 0;
        maxx = max(area2.Vertices(:,1));minx = min(area2.Vertices(:,1));maxy = max(area2.Vertices(:,2));miny = min(area2.Vertices(:,2));
        [X,Y] = meshgrid(minx:0.5:maxx,miny:0.5:maxy);
        [n,m] = size(X);
        for i = 1:n
            for j = 1:m
                xr = X(i,j);
                yr = Y(i,j);
                if isinterior(area2,xr,yr)
                    FealdIn = 1;
                end
                AllDestance = cell2mat(arrayfun(@(i) Cov_distance([xr;yr],AllSateP{i},2),1:length(AllSateP),'Uniformoutput',false));
                KeepDestance = sum(AllDestance>=0.4)==length(AllSateP);
                if KeepDestance==1&&FealdIn==1
                    break;
                else
                    continue;
                end
            end
            if KeepDestance==1&&FealdIn==1
                break;
            end
        end
    case'SeparateAlignment'
        FealdIn = 0;KeepDestance = 0;
        
        Corners = area2.Vertices;
        [n,~] = size(Corners);
        DisCorner2Corner = zeros(n,n);
        parfor i = 1:n
            for j = 1:n
                if (Corners(i,1)-Corners(j,1))==0||(Corners(i,2)-Corners(j,2))==0
                    DisCorner2Corner(i,j) = Cov_distance(Corners(i,:)',Corners(j,:)',2);
                else
                    DisCorner2Corner(i,j) = 0;
                end
            end
        end
        [mi,mj] = MatrixLabels(DisCorner2Corner,1);
        XroYLabel = find(Corners(mi,:)-Corners(mj,:));
        if XroYLabel  ==1
            tmp = linspace(Corners(mi,XroYLabel),Corners(mj,XroYLabel),5);
        else
            tmp = linspace(Corners(mi,XroYLabel),Corners(mj,XroYLabel),5);
            Rxd2tmp = cell2mat(arrayfun(@(i) Cov_distance(Rxd,[Corners(mi,2);tmp(i)],2),1:length(tmp),'Uniformoutput',false));
            [~,MaxDistanceLabel] = max(Rxd2tmp(2:end-1));
            if MaxDistanceLabel==1
                MaxDistanceLabel = 2;
                AAA = min(Corners(:,1));
                BBB = max(Corners(:,1));
                CutArea = polyshape([AAA,tmp(MaxDistanceLabel);BBB,tmp(MaxDistanceLabel);BBB,tmp(5);AAA,tmp(5)]);
            elseif MaxDistanceLabel==3
                MaxDistanceLabel = 4;
                AAA = min(Corners(:,1));
                BBB = max(Corners(:,1));
                CutArea = polyshape([AAA,tmp(MaxDistanceLabel);BBB,tmp(MaxDistanceLabel);BBB,tmp(1);AAA,tmp(1)]);
            end
        end
        %直線の3分の1のエリアの生成
        polyout1 = subtract(area2,CutArea);
        %三分の一エリアを基にマス目上に並ばせている
        maxx = max(polyout1.Vertices(:,1));minx = min(polyout1.Vertices(:,1));maxy = max(polyout1.Vertices(:,2));miny = min(polyout1.Vertices(:,2));
        [X,Y] = meshgrid(minx:0.5:maxx,miny:0.5:maxy);
        [n,m] = size(X);
        for i = 1:n
            for j = 1:m
                xr = X(i,j);
                yr = Y(i,j);
                if isinterior(area2,xr,yr)
                    FealdIn = 1;
                end
                AllDestance = cell2mat(arrayfun(@(i) Cov_distance([xr;yr],AllSateP{i},2),1:length(AllSateP),'Uniformoutput',false));
                KeepDestance = sum(AllDestance>=0.4)==length(AllSateP);
                if KeepDestance==1&&FealdIn==1
                    break;
                else
                    continue;
                end
            end
            if KeepDestance==1&&FealdIn==1
                break;
            end
        end
    case 'Random'
        while 1
            FealdIn = 0;KeepDestance = 0;
            
            xr = ((xmax-buff)-(xmin+buff)).*rand(1,1) + (xmin);
            yr = ((ymax-buff)-(ymin+buff)).*rand(1,1) + (ymin);
            if isinterior(area2,xr,yr)
                FealdIn = 1;
            end
            AllDestance = cell2mat(arrayfun(@(i) Cov_distance([xr;yr],AllSateP{i},2),1:length(AllSateP),'Uniformoutput',false));
            KeepDestance = sum(AllDestance>0.5)==length(AllSateP);
            if KeepDestance==1&&FealdIn==1&&norm([xr;yr]-Rxd,2)>5
                break;
            end
        end
    case 'SeparateRandom'
        Corners = area2.Vertices;
        [n,~] = size(Corners);
        DisCorner2Corner = zeros(n,n);
        parfor i = 1:n
            for j = 1:n
                if (Corners(i,1)-Corners(j,1))==0||(Corners(i,2)-Corners(j,2))==0
                    DisCorner2Corner(i,j) = Cov_distance(Corners(i,:)',Corners(j,:)',2);
                else
                    DisCorner2Corner(i,j) = 0;
                end
            end
        end
        [mi,mj] = MatrixLabels(DisCorner2Corner,1);
        XroYLabel = find(Corners(mi,:)-Corners(mj,:));
        if XroYLabel  ==1
            tmp = linspace(Corners(mi,XroYLabel),Corners(mj,XroYLabel),5);
        else
            tmp = linspace(Corners(mi,XroYLabel),Corners(mj,XroYLabel),5);
            Rxd2tmp = cell2mat(arrayfun(@(i) Cov_distance(Rxd,[Corners(mi,2);tmp(i)],2),1:length(tmp),'Uniformoutput',false));
            [~,MaxDistanceLabel] = max(Rxd2tmp(2:end-1));
            if MaxDistanceLabel==1
                MaxDistanceLabel = 2;
                AAA = min(Corners(:,1));
                BBB = max(Corners(:,1));
                CutArea = polyshape([AAA,tmp(MaxDistanceLabel);BBB,tmp(MaxDistanceLabel);BBB,tmp(5);AAA,tmp(5)]);
            elseif MaxDistanceLabel==3
                MaxDistanceLabel = 4;
                AAA = min(Corners(:,1));
                BBB = max(Corners(:,1));
                CutArea = polyshape([AAA,tmp(MaxDistanceLabel);BBB,tmp(MaxDistanceLabel);BBB,tmp(1);AAA,tmp(1)]);
            end
        end
        %直線の3分の1のエリアの生成
        polyout1 = subtract(area2,CutArea);
        while 1
            FealdIn = 0;KeepDestance = 0;
            
            xr = ((xmax-buff)-(xmin+buff)).*rand(1,1) + (xmin);
            yr = ((ymax-buff)-(ymin+buff)).*rand(1,1) + (ymin);
            if isinterior(polyout1,xr,yr)
                FealdIn = 1;
            end
            AllDestance = cell2mat(arrayfun(@(i) Cov_distance([xr;yr],AllSateP{i},2),1:length(AllSateP),'Uniformoutput',false));
            KeepDestance = sum(AllDestance>0.5)==length(AllSateP);
            if KeepDestance==1&&FealdIn==1
                break;
            end
        end
    otherwise
end
r.x =xr;r.y=yr;
result = r;
end
function [result,result2] = MatrixLabels(Val,flag)
if flag ==1
    [C, I] = max(Val(:));
else
    [C, I] = min(Val(:));
end
[result,result2] = ind2sub(size(Val), I);
end
