function env = Env_FloorMap_sim(id)
%% environment class demo
% env property をEnv classのインスタンス配列として定義
env_param.name = 'Floor';
env_param.type = "FloorMap_sim";
% fl1 = [-50,10;200,10;200,20;-50,20];
% fl2 = [-50,-10;200,-10;200,-20;-50,-20];%x譁ケ蜷代↓髟キ縺?

% fl1 = [-50,10;35,10;35,40;30,40;30,20;-50,20;-50,10];
% fl3 = [55,10;100,10;100,20;60,20;60,40;55,40;55,10];
% fl5 = [-50,-10;100,-10;100,-20;-50,-20;-50,-10;100,-10;100,-20];

% fl1 = [-50,35;50,35;50,45;-50,45];
% fl2 = [-50,-35;50,-35;50,-45;-50,-45];%x譁ケ蜷代↓髟キ縺?
% fl3 = [50,-45;55,-45;55,45;50,45];

% fl1 = [-50,20;200,20;200,25;-50,25];
% fl2 = [-50,-20;200,-20;200,-25;-50,-25];%x direction long passage

long = 100;
fl1 = [-long/sqrt(2),-long/sqrt(2)-10 ; long/sqrt(2),long/sqrt(2)-10 ; long/sqrt(2),long/sqrt(2)-15 ; -long/sqrt(2),-long/sqrt(2)-15];
fl2 = [-long/sqrt(2),-long/sqrt(2)+10 ; long/sqrt(2),long/sqrt(2)+10 ; long/sqrt(2),long/sqrt(2)+15 ; -long/sqrt(2),-long/sqrt(2)+15];

% fl1 = [20,-50;20,200;25,200;25,-50];
% fl2 = [-20,-50;-20,200;-25,200;-25,-50];%y direction long passage

% fl1 = [];

% fl1 = [-10,-10;-10,20;-9,20;-9,-10;-10,-10];
% fl2 = [-10,-10;20,-10;20,-9;-10,-9;-10,-10];
% fl3 = [20,-10;20,20;19,20;19,-10;20,-10];
% fl4 = [20,20;20,19;-10,19;-10,20;20,20];%mini square room env

% fl1 = [-10,-10;-10,50;-9,50;-9,-10;-10,-10];
% fl2 = [-10,-10;50,-10;50,-9;-10,-9;-10,-10];
% fl3 = [50,-10;50,50;49,50;49,-10;50,-10];
% fl4 = [50,50;50,49;-10,49;-10,50;50,50];% big square room env

env_param.Vertices(:,:,1)=fl1;
env_param.Vertices(:,:,2)=fl2;
% env_param.Vertices(:,:,3)=fl3;
% env_param.Vertices(:,:,4)=fl4;
assignin('base',"env_param",env_param);
evalin('base',"Env = FloorMap_sim([],env_param);");

    env.name = "Floor";
    env.type = "FloorMap_sim";
    env.param = env_param;
    env.param.id=id;
end
