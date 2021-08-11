function Reference = Reference_human(agent)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
%1機目はwaypoint，2機目以降はボロノイとか
    for i = 1:length(agent)
        clear Referenceh
        Reference.type=["human_input"];
        Reference.name=["human"];
        Reference.param={[]};
        agent(i).set_reference(Reference);
    end
end
