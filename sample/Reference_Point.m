function Reference = Reference_Point(agent,pmun)
    %pmun:任意の目標値の数 
    [p,ax] = mause_point(agent,pmun);
    calq = p - [agent.estimator.initialtform.Translation;p(1:end-1,:)];
    for inc = 1:pmun
        point(inc).p = p(inc,:)';
        % point(inc).q = point_q(inc);
        point(inc).q = [0;0;atan2(calq(inc,2),calq(inc,1))];
    end
    
    Reference.point = point;
    Reference.num = pmun;
    Reference.threshold = 0.5;
    Reference.ax = ax;
end
function q = point_q(num)
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