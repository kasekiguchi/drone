function env = Env_FloorMap_sim_fromstl(id,filename)
%% environment class demo
% stlファイルを読み込みpolyshapeの点のリストを吐き出す
env_param.name = 'Floor';
env_param.type = "FloorMap_sim";
%% Get corner coordinates
STL = filename;
[TR,~,~,~] = stlread(STL);
Sp0 = TR.Points; % points list
St0 = TR.ConnectivityList; % triangles list
%% triangle poly
SS = zeros(3,2,length(St0));
for i = 1:length(St0)
    SS(:,:,i) = Sp0(St0(i,:),1:2);
end
PP = polyshape(SS(:,:,1));
for i = 2:length(St0)
    PP = union( PP,polyshape(SS(:,:,i)) );
end
PP = rotate(PP,90);
%% 縮尺変更
[~,idx] = min(PP.Vertices(:,1));
minpoint = PP.Vertices(idx,:);%[x,y]
Csize = 1;
Rpoint = Csize * (PP.Vertices - minpoint) + minpoint;
% RPoint = [Rpoint(:,1) - minpoint(1),Rpoint(:,2)- minpoint(2)];
% RPoint = Rpoint(:,2) - ;
% RPP = polyshape(Rpoint);
%%
env_param.Vertices(:,:,1) = Rpoint;
assignin('base',"env_param",env_param);
evalin('base',"Env = FloorMap_sim([],env_param);");

env.name = "Floor";
env.type = "FloorMap_sim";
env.param = env_param;
env.param.id=id;
end
