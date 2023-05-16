function [t,y] = euler_approximation(dxdt,tspan,init,option)
% 状態更新用method : オイラー近似
    if isfield(option,'dt')
        dt = option.dt
        ts=tspan(1)
        te=tspan(2)
        t = ts:dt:te
    else
        dt = tspan(2)-tspan(1);
        t = tspan;
    end
    
    y = zeros(length(t),length(init));
    y(1,:) = init';
    dxdt(t(1),init)
    for i = 1:length(t)
        y(i+1,:) = y(i,:) + dt * dxdt(t(i),y(i,:))';
    end
end

