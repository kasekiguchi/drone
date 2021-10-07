function Reference = Reference_tracebirds(id,Nb)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
    if id>=Nb+1%ここはドローンの分岐
                clear Reference
                Reference.type=["trace_birds_drone"];
                Reference.name=["trace_drone"];
                Reference.param={""};
    else%ここは害鳥の分岐
                clear Reference
                Reference.type=["trace_birds_pestbirds"];
                Reference.name=["trace_pestbirds"];
                Reference.param={""};
    end
end
