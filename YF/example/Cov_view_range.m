function [result1,result2,result3,result4] = Cov_view_range(xp,v,range,wall,L,num,other_state,ViewRange)
if range ==360
    th = cell2mat(arrayfun(@(i) xp+[cos((i));sin((i))] ,1*pi/180:10*pi/180:360*pi/180,'uniformoutput',false));
    AgentCircle = polyshape(th(1,:),th(2,:));
    polyout = AgentCircle;
else
    %姿勢を決定するようなベクトルを入れれば視野角っぽいものを出す。
    th_xp = atan2(v(2),v(1));
    bth = zeros(2,range-1);
    for i = 1:range-1
        bth(1,range-i) = th_xp+(range*i/2/range*pi/180);
        bth(2,range-i) = th_xp-(range*i/2/range*pi/180);
    end
    %進行方向から+-range/2の角度を算出
    bth = sort([bth(1,:),bth(2,:)]);
    %扇形の円周部分を作成
    tmp = zeros(2,length(bth));
    Ppointwall = zeros(length(bth),2);
    for j=1:length(bth)
        if bth(j)>pi
            bth(j) = bth(j)-2*pi;
        end
        if bth(j)<-pi
            bth(j) = bth(j)+2*pi;
        end
        tmp(:,j) = xp+L*[cos(bth(j));sin(bth(j))];
        linesegA2Circle = [ xp';tmp(:,j)'];
        [~,out] = intersect(wall.poly,linesegA2Circle);
        if ~isempty(out)
            [n,~] = size(out);
            DDD = zeros(n,1);
            for k= 1:n
                DDD(k) = norm(xp(1:2)-out(k,:)',2);
                if DDD(k)<=0.2
                    DDD(k) = inf;
                end
            end
            [~,mm] = min(DDD);
            Ppointwall(j,:) = out(mm,:);
        else
            Ppointwall(j,:) = tmp(:,j);
        end
    end
    tmp = [xp tmp];
    %        cutwall = xp+L*[cos(bth(:));sin(bth(:))];
    varExists = sum(sum(find(Ppointwall)),2);
    if varExists==0
        Ppointwall = tmp';
    else
        idx = Ppointwall(:,1)==0&Ppointwall(:,2)==0;
        Ppointwall = Ppointwall(~idx,:);
    end
    Ppointwall = [Ppointwall;xp'];
    ViewRegion = polyshape(Ppointwall(:,1),Ppointwall(:,2));
    polyout = ViewRegion;
    
    %人を検知したらその向こう側を見えないように使用と考えてる．
    %自己位置と領域の端点間の線を作成
%     lineseg = cell(1,length(polyout.Vertices));
%     for i =1:length(polyout.Vertices)
%         lineseg{i} = [ xp(1:2)';polyout.Vertices(i,:)];
%     end
%     count = 1;
%     for i=1:length(other_state)
%         %         if i~=num
%         agentG = other_state{i}(1:2);
%         th = cell2mat(arrayfun(@(i) agentG+0.2*[cos((i));sin((i))] ,1*pi/180:10*pi/180:360*pi/180,'uniformoutput',false));
%         if i==1
%             AgentCircle = polyshape(th(1,:),th(2,:));
%         else
%             AgentCircle = union(AgentCircle,polyshape(th(1,:),th(2,:)));
%         end
%         %         end
%     end
%     AllObject = union(wall.poly,AgentCircle);
%     parfor j=1:length(Ppointwall)
%         linesegA2all = [ xp';Ppointwall(j,:)];
%         [~,out] = intersect(AgentCircle,linesegA2all);
%         if ~isempty(out)
%             [n,~] = size(out);
%             DDD = zeros(n,1);
% %             DDC = DDD;
%             for k= 1:n
%                 DDD(k) = norm(xp(1:2)-out(k,:)',2);
%                 if DDD(k)<=0.3
%                     DDD(k) = inf;
%                 end
%             end
%             [~,mm] = min(DDD);
%             Ppoint(j,:) = out(mm,:);
%             count = count+1;
%         else
%             Ppoint(j,:) =Ppointwall(j,:);
% %             disp('a')
%         end
%     end
%     Ppoint = [Ppoint;xp'];
%     polyout2 = polyshape(Ppoint(:,1),Ppoint(:,2));
    result1 = polyout;
    result2 = 1;
    
    
%% 視野角のほう
%姿勢を決定するようなベクトルを入れれば視野角っぽいものを出す。
    th_xp = atan2(v(2),v(1));
    bth = zeros(2,ViewRange-1);
    for i = 1:ViewRange-1
        bth(1,ViewRange-i) = th_xp+(ViewRange*i/2/ViewRange*pi/180);
        bth(2,ViewRange-i) = th_xp-(ViewRange*i/2/ViewRange*pi/180);
    end
    %進行方向から+-ViewRange/2の角度を算出
    bth = sort([bth(1,:),bth(2,:)]);
    %扇形の円周部分を作成
    tmp = zeros(2,length(bth));
    Ppointwall = zeros(length(bth),2);
    parfor j=1:length(bth)
        if bth(j)>pi
            bth(j) = bth(j)-2*pi;
        end
        if bth(j)<-pi
            bth(j) = bth(j)+2*pi;
        end
        tmp(:,j) = xp+L*[cos(bth(j));sin(bth(j))];
        linesegA2Circle = [ xp';tmp(:,j)'];
        [~,out] = intersect(wall.poly,linesegA2Circle);
        if ~isempty(out)
            [n,~] = size(out);
            DDD = zeros(n,1);
            for k= 1:n
                DDD(k) = norm(xp-out(k,:)',2);
                if DDD(k)<=0.2
                    DDD(k) = inf;
                end
            end
            [~,mm] = min(DDD);
            Ppointwall(j,:) = out(mm,:);
        else
            Ppointwall(j,:) = tmp(:,j);
        end
    end
    tmp = [xp tmp];
    %        cutwall = xp+L*[cos(bth(:));sin(bth(:))];
    varExists = sum(sum(find(Ppointwall)),2);
    if varExists==0
        Ppointwall = tmp';
    else
        idx = Ppointwall(:,1)==0&Ppointwall(:,2)==0;
        Ppointwall = Ppointwall(~idx,:);
    end
    Ppointwall = [Ppointwall;xp'];
    ViewRegion = polyshape(Ppointwall(:,1),Ppointwall(:,2));
    polyout = ViewRegion;
    
    %人を検知したらその向こう側を見えないように使用と考えてる．
    %自己位置と領域の端点間の線を作成
    lineseg = cell(1,length(polyout.Vertices));
    for i =1:length(polyout.Vertices)
        lineseg{i} = [ xp(1:2)';polyout.Vertices(i,:)];
    end
    count = 1;
    for i=1:length(other_state)
        %         if i~=num
        agentG = other_state{i}(1:2);
        th = cell2mat(arrayfun(@(i) agentG+0.2*[cos((i));sin((i))] ,1*pi/180:10*pi/180:360*pi/180,'uniformoutput',false));
        if i==1
            AgentCircle = polyshape(th(1,:),th(2,:));
        else
            AgentCircle = union(AgentCircle,polyshape(th(1,:),th(2,:)));
        end
        %         end
    end
%     AllObject = union(wall.poly,AgentCircle);
    parfor j=1:length(Ppointwall)
        linesegA2all = [ xp';Ppointwall(j,:)];
        [~,out] = intersect(AgentCircle,linesegA2all);
        if ~isempty(out)
            [n,~] = size(out);
            DDD = zeros(n,1);
%             DDC = DDD;
            for k= 1:n
                DDD(k) = norm(xp(1:2)-out(k,:)',2);
                if DDD(k)<=0.3
                    DDD(k) = inf;
                end
            end
            [~,mm] = min(DDD);
            Ppoint(j,:) = out(mm,:);
            count = count+1;
        else
            Ppoint(j,:) =Ppointwall(j,:);
%             disp('a')
        end
    end
    Ppoint = [Ppoint;xp'];
    polyout2 = polyshape(Ppoint(:,1),Ppoint(:,2));
    result3 = polyout2;
    result4 = polyout;
    
    
    
end
end
function result = SortVertices(base,Points)
Tpoint = Points-base;
[n,~] = size(Points);
th =zeros(n,1);
for i=1:n
    th(i) = atan2(Tpoint(i,2),Tpoint(i,1));
end
tmp = [Points,th];
result = sortrows(tmp,3);

end