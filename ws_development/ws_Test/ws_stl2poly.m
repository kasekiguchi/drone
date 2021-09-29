%%
% Make polyshapes by slicing the stl file
% The target height is defined as hrange
% Result is a array of polyshape named "region"
% "region" is saved in the current folder.
%% Initialize
all clear
clc
warning off all
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

%% Get corner coordinates
STL = '3F.stl';
[TR,fileformat,attributes,solidID] = stlread(STL);
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
%% 縮尺変更
[~,idx] = min(PP.Vertices(:,1));
minpoint = PP.Vertices(idx,:);%[x,y]
Csize = 1;
Rpoint = Csize * (PP.Vertices - minpoint) + minpoint;
% RPoint = [Rpoint(:,1) - minpoint(1),Rpoint(:,2)- minpoint(2)];
% RPoint = Rpoint(:,2) - ;
RPP = polyshape(Rpoint);
%% plot for check
figure(1)
ax = gca;
hold on
axis equal
grid on
xlabel('x [m]');ylabel('y [m]');
% plot(PP)
plot(RPP)
exportgraphics(ax,strcat('check','.pdf'));
hold off
