function env = Env_FloorMap_sim_circle(id)
%% environment class demo
% env property をEnv classのインスタンス配列として定義
env_param.name = 'Floor';
env_param.type = "FloorMap_sim";
pout = [-5,-5;50,-5;50,50;-5,50];
Poutpoly = polyshape(pout);
pin = [-6,-6;51,-6;51,51;-6,51];
Pinpoly = polyshape(pin);
Poutwall = subtract(Pinpoly,Poutpoly);
pwall = [0,0;45,0;45,45;0,45];
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
