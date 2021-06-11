function Reference = Reference_agreement(agent,N)
    %% reference class demo
    % reference property をReference classのインスタンス配列として定義
    clear Reference
    Reference.type=["consensus_agreement"];
    Reference.name=["agreement"];
    Reference.param.N=N;
    if N==3
    Reference.param.offset=3*[-2*cos(pi/6),2*cos(pi/6),0.0;
                              -2*sin(pi/6),-2*sin(pi/6),2.0;
                               0.0,0.0,0.0,];
    end
    if N==4
    Reference.param.offset=4*[-5.0,-5.0,5.0,5.0;
                              -5.0,5.0,-5.0,5.0;
                               0.0,0.0,0.0,0.0];
    end
end
