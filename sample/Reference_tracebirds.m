function Reference = Reference_tracebirds(id,Nb,tex,N,fp,want_falm,position,distance)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
%1機目はwaypoint，2機目以降はボロノイとか
if tex==1
        if id>=Nb+1%最終機体は犬になる予定なのでsheep_refはない
            clear Reference
            Reference.type=["trace_birds_drone"];
            Reference.name=["trace_drone"];
            Reference.param{1}=N;
            Reference.param{2}=Nb;
            Reference.param{3}=distance;
            Reference.param{4}=fp;
            Reference.param{5}=want_falm(id);
            Reference.param{6}=position;
%             agent(i).set_reference(Reference);
        else
            clear Reference
            Reference.type=["trace_birds_pestbirds"];
            Reference.name=["trace_pestbirds"];
            Reference.param{1}=N;
            Reference.param{2}=Nb;
            Reference.param{3}=distance;
            Reference.param{4}=fp;
            Reference.param{5}=want_falm(id);
            Reference.param{6}=position;
%             agent(i).set_reference(Reference);
        end
elseif tex==2
        if id>=Nb+1%最終機体は犬になる予定なのでsheep_refはない
            clear Reference
            Reference.type=["trace_birds_drone"];
            Reference.name=["trace_drone"];
            Reference.param{1}=N;
            Reference.param{2}=Nb;
            Reference.param{3}=distance;
            Reference.param{4}=fp;
            Reference.param{5}=want_falm(id);
            Reference.param{6}=position;
%             agent(i).set_reference(Reference);
        else
            clear Reference
            Reference.type=["trace_birds_pestbirds_Dis"];
            Reference.name=["trace_pestbirds"];
            Reference.param{1}=N;
            Reference.param{2}=Nb;
            Reference.param{3}=distance;
            Reference.param{4}=fp;
            Reference.param{5}=want_falm(id);
            Reference.param{6}=position;
%             agent(i).set_reference(Reference);
        end
elseif tex==3
        if id>=Nb+1%最終機体は犬になる予定なのでsheep_refはない
            clear Reference
            Reference.type=["trace_birds_drone"];
            Reference.name=["trace_drone"];
            Reference.param{1}=N;
            Reference.param{2}=Nb;
            Reference.param{3}=distance;
            Reference.param{4}=fp;
            Reference.param{5}=want_falm(id);
            Reference.param{6}=position;
%             agent(i).set_reference(Reference);
        else
            clear Reference
            Reference.type=["wheelchair_trace_birds_pestbirds_Dis"];
            Reference.name=["trace_pestbirds"];
            Reference.param{1}=N;
            Reference.param{2}=Nb;
            Reference.param{3}=distance;
            Reference.param{4}=fp;
            Reference.param{5}=want_falm(id);
            Reference.param{6}=position;
%             agent(i).set_reference(Reference);
        end
end
end
