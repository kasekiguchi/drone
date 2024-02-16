function Reference = Reference_Point(agent,pmun)
    %pmun:任意の目標値の数 
    [p,ax] = mause_point(agent,pmun);
    % p(3,:)=0;
    % point(1).p = [1.5;0;0];
    % for inc = 1:pmun
    %     point(inc).p = p(:,inc);
    %     % point(inc).q = point_q(inc);
    %     point(inc).q = point_q(p(:,inc));
    % end
    % point.p=p;
    % calq=[agent.estimator.initialtform.Translation;p(1:end-1,:)];
    % qq=[p-calq];
    calq = p - [agent.estimator.initialtform.Translation;p(1:end-1,:)];
    % q = calq(:,1)/calq(:,2)
    for inc = 1:pmun
        point(inc).p = p(inc,:)';
        % point(inc).q=[0, 0, -atan(qq(inc,2)/qq(inc,1))]'
        % point(inc).q = point_q(inc);
        point(inc).q = [0;0;atan(calq(inc,2)/calq(inc,1))];
    end
    
    % point=struct("p",p,"q",[0 0 q]');

    Reference.point = point;
    Reference.num = pmun;
    Reference.threshold = 0.5;
    Reference.ax = ax;
end
function q = point_q(num)
% function q = point_q(prev_p)
prompt = "point "+num2str(num)+"' yaw (deg):";
yaw = input(prompt);
% yaw = atan(prev_p(2)/prev_p(1))
q = [0;0;deg2rad(yaw)];
end

function [p,ax] = mause_point(agent,pmun)
    figure
    ax = gca;
    map = agent.estimator.fixedSeg;
    scatter(map.Location(:,1),map.Location(:,2),2,"filled");
    hold on
    scatter(agent.estimator.result.state.p(1),agent.estimator.result.state.p(2),"filled")
    str_ini = sprintf('%f  %f',agent.estimator.result.state.p(1),agent.estimator.result.state.p(2));
    text(agent.estimator.result.state.p(1),agent.estimator.result.state.p(2),str_ini,'Clipping','off');
    for d = 1:pmun
        % ここで、ライン上をマウスで選択します。
        % この例では、WAITFORBUTTONPRESSコマンドを使い
        % 入力待ち状態にします。
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
    % hold off
    p=[Xp;Yp]';p(:,3)=0;
end