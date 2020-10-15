function typical_Reference_2DCoverage(agent,Env)
%% reference class demo
% reference property ��Reference class�̃C���X�^���X�z��Ƃ��Ē�`
clear Reference
Reference.type=["VoronoiBarycenter"];
Reference.name=["covering"];
Reference.param.void=0.3;
for i = 1:length(agent)
            if isfield(agent(i).sensor,'rdensity'); Reference.param.r = agent(i).sensor.rdensity.r;  end
            if isfield(agent(i).sensor,'rpos'); Reference.param.R = agent(i).sensor.rpos.r;  end
            if isfield(Env.param,'d'); Reference.param.d = Env.param.d;  end
    
    agent(i).set_reference(Reference);
end
end
