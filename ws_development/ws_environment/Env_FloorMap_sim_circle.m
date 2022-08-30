function env = Env_FloorMap_sim_circle(id)
%% environment class demo
% env property をEnv classのインスタンス配列として定義
env_param.name = 'Floor';
env_param.type = "FloorMap_sim";
% pout = [-5,-5;50,-5;50,50;-5,50];
% Poutpoly = polyshape(pout);
% pin = [-6,-6;51,-6;51,51;-6,51];
% Pinpoly = polyshape(pin);
% Poutwall = subtract(Pinpoly,Poutpoly);
% pwall = [0,0;45,0;45,45;0,45];
% pwallpoly = polyshape(pwall);
% Pwalls = union(Poutwall,pwallpoly);
% 
%%
pout = [-5,-5;15,-5;15,15;-5,15];
Poutpoly = polyshape(pout);
pin = [-6,-6;16,-6;16,16;-6,16];
Pinpoly = polyshape(pin);
Poutwall = subtract(Pinpoly,Poutpoly);
pwall = [0,0;10,0;10,10;0,10];
pwallpoly = polyshape(pwall);
Pwalls = union(Poutwall,pwallpoly);
% %%
% pout = [-10,-10;60,-10;60,60;-10,60];
% Poutpoly = polyshape(pout);
% pin = [-9,-9;59,-9;59,59;-9,59];
% Pinpoly = polyshape(pin);
% Poutwall = subtract(Poutpoly,Pinpoly);
% pwall = [0,0;50,0;50,50;0,50];
% pwallpoly = polyshape(pwall);
% Pwalls = union(Poutwall,pwallpoly);

%%
pout = [-5,-5;95,-5;95,95;-5,95];
Poutpoly = polyshape(pout);
pin = [-6,-6;96,-6;96,96;-6,96];
Pinpoly = polyshape(pin);
Poutwall = subtract(Pinpoly,Poutpoly);
pwall = [0,0;90,0;90,90;0,90];
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
