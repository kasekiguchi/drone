function typical_Reference_sheep(agent,Na,num)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
%1機目はwaypoint，2機目以降はボロノイとか
if num==1
    for i = 1:length(agent)
        if i>=length(agent)-Na+1%最終機体は犬になる予定なのでsheep_refはない
            clear Reference
            Reference.type=["example_waypoint"];
            Reference.name=["point"];
            Reference.param={[]};
            agent(i).set_reference(Reference);
        else
            clear Referenceh
            Reference.type=["sheep_input"];
            Reference.name=["sheep"];
            Reference.param={[]};
            agent(i).set_reference(Reference);
        end
    end
elseif num==2
    for i = 1:length(agent)
        if i>=length(agent)-Na+1%最終機体は犬になる予定なのでsheep_refはない
            clear Reference
            Reference.type=["example_waypoint"];
            Reference.name=["point"];
            Reference.param={[]};
            agent(i).set_reference(Reference);
        else
            clear Reference
            Reference.type=["sheep_Dis_input"];
            Reference.name=["sheep"];
            Reference.param={[]};
            agent(i).set_reference(Reference);
        end
    end
elseif num==3
    for i = 1:length(agent)
        if i>=length(agent)-Na+1%最終機体は犬になる予定なのでsheep_refはない
            clear Reference
            Reference.type=["example_waypoint"];
            Reference.name=["point"];
            Reference.param={[]};
            agent(i).set_reference(Reference);
        else
            clear Reference
            Reference.type=["wheelchair_sheep_Dis_input"];
            Reference.name=["sheep"];
            Reference.param={[]};
            agent(i).set_reference(Reference);
        end
    end
    
end
end
