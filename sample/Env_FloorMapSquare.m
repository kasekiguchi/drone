function env_param = Env_FloorMapSquare()
env_param.name = 'floor';
env_param.type = "FLOOR_MAP";
%% environment class demo
% env property をEnv classのインスタンス配列として定義
% pout = [-5,-5;50,-5;50,50;-5,50];
% Poutpoly = polyshape(pout);
% pin = [-6,-6;51,-6;51,51;-6,51];
% Pinpoly = polyshape(pin);
% Poutwall = subtract(Pinpoly,Poutpoly);
% pwall = [0,0;45,0;45,45;0,45];
% pwallpoly = polyshape(pwall);
% Pwalls = union(Poutwall,pwallpoly);

%%
% pout = [-5,-5;15,-5;15,15;-5,15];
% Poutpoly = polyshape(pout);
% pin = [-6,-6;16,-6;16,16;-6,16];
% Pinpoly = polyshape(pin);
% Poutwall = subtract(Pinpoly,Poutpoly);
% pwall = [0,0;10,0;10,10;0,10];
% pwallpoly = polyshape(pwall);
% Pwalls = union(Poutwall,pwallpoly);

%%
pout = [-5, -5; 15, -5; 15, 15; -5, 15];
Poutpoly = polyshape(pout);
pin = [-6, -6; 16, -6; 16, 16; -6, 16];
Pinpoly = polyshape(pin);
Poutwall = subtract(Pinpoly, Poutpoly);
% pwall = [0,0;10,0;10,10;0,10];
% pwallpoly = polyshape(pwall);
Pwalls = union(Poutwall);

%%
% pout = [-10,-10;60,-10;60,60;-10,60];
% Poutpoly = polyshape(pout);
% pin = [-9,-9;29,-9;29,29;-9,29];
% Pinpoly = polyshape(pin);
% Poutwall = subtract(Poutpoly,Pinpoly);
% pwall = [0,0;20,0;20,20;0,20];
% pwallpoly = polyshape(pwall);
% Pwalls = union(Poutwall,pwallpoly);

%%
%
% pout = [-5,-5;95,-5;95,95;-5,95];
% Poutpoly = polyshape(pout);
% pin = [-6,-6;96,-6;96,96;-6,96];
% Pinpoly = polyshape(pin);
% Poutwall = subtract(Pinpoly,Poutpoly);
% pwall = [0,0;90,0;90,90;0,90];
% pwallpoly = polyshape(pwall);
% Pwalls = union(Poutwall,pwallpoly);

%%
% pout = [-3.5,-1.25;6,-1.25;6,8.75;-3.5,8.75];
% Poutpoly = polyshape(pout);
% pin = [-4.5,-2.25;7,-2.25;7,9.75;-4.5,9.75];
% Pinpoly = polyshape(pin);
% Poutwall = subtract(Pinpoly,Poutpoly);
% pwall = [-1.5,1.25;4,1.25;4,6.75;-1.5,6.75];
% pwallpoly = polyshape(pwall);
% Pwalls = union(Poutwall,pwallpoly);

%%
% pout = [-3.5,-1.25;26,-1.25;26,28.75;-3.5,28.75];
% Poutpoly = polyshape(pout);
% pin = [-4.5,-2.25;27,-2.25;27,29.75;-4.5,29.75];
% Pinpoly = polyshape(pin);
% Poutwall = subtract(Pinpoly,Poutpoly);
% pwall = [-1.5,1.25;24,1.25;24,26.75;-1.5,26.75];
% pwallpoly = polyshape(pwall);
% Pwalls = union(Poutwall,pwallpoly);
%%
pout = [-5, -5; 95, -5; 95, 95; -5, 95];
Poutpoly = polyshape(pout);
pin = [-6, -6; 96, -6; 96, 96; -6, 96];
Pinpoly = polyshape(pin);
Poutwall = subtract(Pinpoly, Poutpoly);
pwall = [0, 0; 90, 0; 90, 90; 0, 90];
pwallpoly = polyshape(pwall);
Pwalls = union(Poutwall, pwallpoly);
%%
pout = [-2, -2; 10, -2; 10, 5; -2, 5];
Poutpoly = polyshape(pout);
pin = [-2.5, -2.5; 10.5, -2.5; 10.5, 5.5; -2.5, 5.5];
Pinpoly = polyshape(pin);
Poutwall = subtract(Pinpoly, Poutpoly);
pwall = [0, 0; 8, 0; 8, 4; 0, 4];
pwallpoly = polyshape(pwall);
Pwalls = union(Poutwall, pwallpoly);

env_param.Vertices(:, :, 1) = Pwalls.Vertices;
%env_param.param = env_param;

end
