function Reference = Reference_Point(agent,pmun)
    %pmun:任意の目標値の数．
    %%0     → tuning mode
    %%not 0 → mouse  mode
    if pmun ~= 0%mouseで目標値をクリック
    [p,ax] = mause_point(agent,pmun);
    calq = p - [agent.estimator.initialtform.Translation;p(1:end-1,:)];
    for inc = 1:pmun
        point(inc).p = p(inc,:)';
        % point(inc).q = point_q(inc);%姿勢角をプロンプトで直接指定
        point(inc).q = [0;0;atan2(calq(inc,2),calq(inc,1))];%姿勢角をatanで算出
    end
    else%チューニングした目標値をセット
    % %test1
    % point(1).p = [0.0470;6.2357;0];
    % point(1).q = [0;0;1.5316];
    % point(2).p = [0.0470;6.2357;0];
    % point(2).q = [0;0;0.0410];    
    % point(3).p = [31.2298;6.3955;0];
    % point(3).q = [0;0;0.0027];
    % point(4).p = [31.5658602150538;6.35559360730593;0];
    % point(4).q = [0;0;0.0266180634789414];
    % point(5).p = [31.6330645161290;7.95376712328767;0];
    % point(5).q = [0;0;1.52877039481479];
    % point(6).p = [31.1626344086021;9.43207762557078;0];
    % point(6).q = [0;0;1.87888509328053];
    % point(7).p = [30.0873655913978;9.47203196347032;0];
    % point(7).q = [0;0;3.10445220610787];
    
    % test2
    point(1).p = [0;6;0];           %y直進(floor)
    point(1).q = [0;0;deg2rad(90)]; %y直進(floor)
    point(2).p = [1.5;6;0];         %x方向転換(floor)
    point(2).q = [0;0;deg2rad(0)];  %x方向転換(floor)
    point(3).p = [31.5;6;0];        %x直進(floor)
    point(3).q = [0;0;rad2deg(0)];  %x直進(floor)
    point(4).p = [31.5;8;0];        %y方向転換+y直進(floor->elevetor hall)
    point(4).q = [0;0;rad2deg(90)]; %y方向転換+y直進(floor->elevetor hall)
    point(5).p = [30;9.5;0];        %(elevetor hall)
    point(5).q = [0;0;rad2deg(90)]; %(elevetor hall)
    point(6).p = [29.5;9.5;0];      %(elevetor hall)
    point(6).q = [0;0;rad2deg(90)]; %(elevetor hall)

    % %ホールに入るとき検証用
    % point(1).p = [31.5;6.2;0];
    % point(1).q = [0;0;deg2rad(0)];
    % point(2).p = [32;8;0];
    % point(2).q = [0;0;deg2rad(90)];
    % point(3).p = [33;9;0];
    % point(3).q = [0;0;deg2rad(135)];
    pmun = length(point);
    ax=gca;
    map = agent.estimator.fixedSeg;
    scatter(map.Location(:,1),map.Location(:,2),2,"filled");
    hold on
    end   
    for i = 1:length(point)
        point(i).v = 0.5;
    end
    Reference.point = point;
    Reference.num = pmun;
    Reference.threshold = 0.5;
    Reference.ax = ax;
end
function q = point_q(num)
%プロンプトで目標姿勢を入力
prompt = "point "+num2str(num)+"' yaw (deg):";
yaw = input(prompt);
q = [0;0;deg2rad(yaw)];
end

function [p,ax] = mause_point(agent,pmun)
    figure
    ax = gca;
    map = agent.estimator.fixedSeg;
    scatter(map.Location(:,1),map.Location(:,2),2,"filled");
    hold on
    pini=agent.estimator.result.state;
    scatter(pini.p(1),pini.p(2),"filled")
    str_ini = sprintf('%f  %f',pini.p(1),pini.p(2));
    text(pini.p(1),pini.p(2),pini.q(3),str_ini,'Clipping','off');
    for d = 1:pmun
        waitforbuttonpress; 
        % マウスの現在値の取得
        Cp = get(gca,'CurrentPoint');
        Xp(1,d) = Cp(2,1);  % X座標
        Yp(1,d) = Cp(2,2);  % Y座標
        X = [agent.estimator.result.state.p(1) Xp];
        Y = [agent.estimator.result.state.p(2) Yp];

        plot(X,Y)
        str = sprintf('%f  %f',Xp(1,d),Yp(1,d));
        ht = text(Xp(1,d),Yp(1,d),str,'Clipping','off');
    end
    p=[Xp;Yp]';p(:,3)=0;
end