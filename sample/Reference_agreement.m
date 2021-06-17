function Reference = Reference_agreement(agent,N)
    %% reference class demo
    % reference property をReference classのインスタンス配列として定義
    clear Reference
    Reference.type=["consensus_agreement"];
    Reference.name=["agreement"];
    pos = linspace(0,2*pi,N+1);
    Reference.param = zeros(3,N);
    r = 3;
    for i=1:N
        Reference.param(:,i)=N*[r*cos(pos(i));r*sin(pos(i));0.0];
    end
end
