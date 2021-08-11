function yasui = yasui_SAVE_state_ref(agent,yasui)
%初期化
N=length(agent);
    if yasui.main_roop_count==1
        yasui.save.cog_est = [];
        yasui.save.cog_P = [];
        yasui.save.del_p=[];
        for i =1:length(agent)
            yasui.save.agent{i}.u = [];
            yasui.save.agent{i}.tmp2=[];
            yasui.save.agent{i}.tmp1=[];
yasui.save.agent{i}.tmp4=[];

        end
    end
    for i =1:N
           if agent(i).plant.name=='dog_Model'
            yasui.save.agent{i}.state = [yasui.save.agent{i}.state,[agent(i).estimator.result.state.p]];
            yasui.save.agent{i}.tmp2 = [yasui.save.agent{i}.tmp2,[agent(i).reference.result.tmp2]];
            yasui.save.agent{i}.tmp1 = [yasui.save.agent{i}.tmp1,[agent(i).reference.result.tmp1]];
            yasui.save.agent{i}.tmp4 = [yasui.save.agent{i}.tmp4,[agent(i).reference.result.tmp4]];

           else
               if agent(1).model.name == 'sheep_Model'
                      yasui.save.agent{i}.state = [yasui.save.agent{i}.state,[agent(i).estimator.result.state.p;agent(i).estimator.result.state.v]];
               else
                      yasui.save.agent{i}.state = [yasui.save.agent{i}.state,[agent(i).estimator.result.state.p]];
                   
               end
           end
%            yasui.save.agent{i}.v = [yasui.save.agent{i}.v,[agent(i).estimator.result.state.v]];
%            yasui.save.agent{i}.w = [yasui.save.agent{i}.w,[agent(i).estimator.result.state.w]];
%            yasui.save.agent{i}.q = [yasui.save.agent{i}.q,[agent(i).estimator.result.state.q]];
           yasui.save.agent{i}.u = [yasui.save.agent{i}.u,[agent(i).reference.result.state.u]];
           yasui.save.agent{i}.ref   = [yasui.save.agent{i}.ref,[agent(i).reference.result.state.p;agent(i).reference.result.state.v]];       
    end
    %% その他情報
%     yasui.save.cog_est = [yasui.save.cog_est,param{1}.state'];
%     yasui.save.cog_P = [yasui.save.cog_P,param{1}.P];
%     yasui.save.del_p = [yasui.save.del_p,yasui.tmp.P];

   
end

