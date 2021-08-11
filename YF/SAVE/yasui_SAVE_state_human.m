function [yasui,respone_flag] = yasui_SAVE_state_human(agent,yasui,respone_flag,Nh,Nob)
%初期化
N=length(agent);
if yasui.main_roop_count==1
    yasui.save.cog_est = [];
    yasui.save.cog_P = [];
    yasui.save.del_p=[];
    yasui.save.env = agent(1).env.huma_load.param.poly;
    yasui.Number.Nh = Nh;
    yasui.Number.Nob = Nob;
    for i =1:length(agent)
        if i<=Nh
            yasui.save.agent{i}.ref=[];
            yasui.away_u{i} = [];
            yasui.other_u{i} = [];
            
            yasui.save.agent{i}.u = [];
            yasui.save.agent{i}.tmp2=[];
            yasui.save.agent{i}.optimalV=[];
            yasui.save.agent{i}.tmp4=[];
            yasui.save.agent{i}.v=[];
            yasui.save.agent{i}.rerativepotential=[];
            yasui.save.agent{i}.separateu=[];
            yasui.save.agent{i}.RefarenceLabels=agent(i).reference.slope.xd;
            yasui.save.ViewPoint{i} = [];
            yasui.save.Dencity = [];
            yasui.save.DencityInoutLabels = [];
            yasui.save.ObservationLabel = [];
            yasui.dencity.flow= 0;
        else
        end
    end
end
for i =1:N
    if i<=Nh
        if respone_flag(i)
            %リスポーンしたタイミングが分かるように値系にはnanを入れる
            yasui.save.agent{i}.state = [yasui.save.agent{i}.state,[nan;nan]];
            yasui.save.agent{i}.v = [yasui.save.agent{i}.v,[nan;nan]];
            yasui.save.agent{i}.u = [yasui.save.agent{i}.u,[nan;nan;nan;nan;nan;nan]];
            yasui.save.agent{i}.optimalV = [yasui.save.agent{i}.optimalV,nan];
            yasui.save.agent{i}.ref   =[yasui.save.agent{i}.ref,[nan;nan]];
            %視野領域は絶対に使わないと
            yasui.save.ViewPoint{i} = [yasui.save.ViewPoint{i},agent(i).reference.result.View_range];
            respone_flag(i) = 0;
        end
        
        yasui.save.agent{i}.state = [yasui.save.agent{i}.state,[agent(i).estimator.result.state.p]];
        yasui.save.agent{i}.v = [yasui.save.agent{i}.v,[agent(i).estimator.result.state.v]];
        yasui.save.agent{i}.separateu=[yasui.save.agent{i}.separateu,[agent(i).reference.result.separateu]];
        
        
        
        %            yasui.save.agent{i}.v = [yasui.save.agent{i}.v,[agent(i).estimator.result.state.v]];
        %            yasui.save.agent{i}.w = [yasui.save.agent{i}.w,[agent(i).estimator.result.state.w]];
        %            yasui.save.agent{i}.q = [yasui.save.agent{i}.q,[agent(i).estimator.result.state.q]];
        yasui.save.agent{i}.u = [yasui.save.agent{i}.u,[agent(i).reference.result.state.u]];
        yasui.save.agent{i}.rerativepotential = [yasui.save.agent{i}.rerativepotential,[agent(i).reference.result.rerativepotential]];
        yasui.save.agent{i}.optimalV = [yasui.save.agent{i}.optimalV,[agent(i).reference.result.OPV]];
        % yasui.agent{i}.map{yasui.main_roop_count} =agent(i).reference.result.map;
        
        yasui.save.agent{i}.ref   = [yasui.save.agent{i}.ref,agent(i).reference.result.ref_point(1:2)];
        yasui.save.ViewPoint{i} = [yasui.save.ViewPoint{i},agent(i).reference.result.View_range];
    else
        yasui.save.agent{i}.state = [yasui.save.agent{i}.state,[agent(i).estimator.result.state.p]];
        
    end
end
%% その他情報
%     yasui.save.cog_est = [yasui.save.cog_est,param{1}.state'];
%     yasui.save.cog_P = [yasui.save.cog_P,param{1}.P];
%     yasui.save.del_p = [yasui.save.del_p,yasui.tmp.P];
yasui.save.Dencity = [ yasui.save.Dencity,yasui.dencity.Dencity];
yasui.save.DencityInoutLabels =[yasui.save.DencityInoutLabels,yasui.dencity.InoutLabel];
yasui.save.ObservationLabel = [yasui.save.ObservationLabel,yasui.dencity.InoutLabel];
yasui.dencity.flow= yasui.dencity.flow;

end

