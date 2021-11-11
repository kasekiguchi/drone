function env = Env_FloorMap_sim_circle(id)
%% environment class demo
% env property をEnv classのインスタンス配列として定義
env_param.name = 'Floor';
env_param.type = "FloorMap_sim";
pout = [-10,-10;60,-10;60,60;-10,60];
Poutpoly = polyshape(pout);
pin = [-9,-9;59,-9;59,59;-9,59];
Pinpoly = polyshape(pin);
Poutwall = subtract(Poutpoly,Pinpoly);
pwall = [0,0;50,0;50,50;0,50];
pwallpoly = polyshape(pwall);
Pwalls = union(Poutwall,pwallpoly);

env_param.Vertices(:,:,1) = Pwalls.Vertices;
assignin('base',"env_param",env_param);
evalin('base',"Env = FloorMap_sim([],env_param);");
env.name = "Floor";
env.type = "FloorMap_sim";
env.param = env_param;
env.param.id=id;
end
