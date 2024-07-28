function Reference = Reference_Agreement(N) 
    %% reference class demo
    % 合意制御の目標隊列
    % reference property をReference classのインスタンス配列として定義
    % 返し値は配置したい隊列
    pos = linspace(0,2*pi,N); %円形に配置
    Reference = zeros(3,N);
    r = 1; %隊列の半径
    for i=1:N
        Reference(:,i)=[r*cos(pos(i));r*sin(pos(i));0.0];
    end
end
