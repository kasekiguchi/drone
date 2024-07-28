function Env=Env_ForestFire(agent,map)
%% environment class demo
clc
% env property をEnv classのインスタンス配列として定義
Env.param.name="firemap";
Env.param.D = 1;
Env.param.map_min = [-50 -50];%[x_min y_min]
Env.param.map_max = [50 50];%[x_min y_min]

if ~isempty(map) %グローバルマップ生成
    Env.param.v1=1;
    Env.param.v2=29;
    Env.param.w=(Env.param.v1+Env.param.v2)/2;
    Env.param.d=Env.param.v2-Env.param.v1;
    Env.param.Threshold=[1 30 100 1000];
    Env.param.mu = 0.5;
    Env.param.sigma = 0.25;
    Env.param.sigma = Env.param.sigma/3;
    env = Env;
    env.param.name = "GlobalMap";
    env.param.id = 0;
    map.set_env(env);
else
    for i = 1:length(agent)
        env(i) = Env;
        env(i).param.id=i;
        agent(i).set_env(env(i));
    end
end
end
