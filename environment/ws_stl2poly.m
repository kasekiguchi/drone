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
axis off
% grid on
% xlabel('x [m]');ylabel('y [m]');
% plot(PP)
plot(RPP)
% exportgraphics(ax,strcat('check','.pdf'));
hold off
%% plot as robot and environments for final prezentation
v1 = RPP.Vertices;
vv = isnan(v1(:,1));
fvv = find(vv);
height = 30;
a1 = cell(height,length(fvv));
% a2 = cell(1,length(fvv));
rec = 1;
% Use alphaShape to add the Z dimension
for j = 1:height
    for i=1:length(fvv)
        vv1 = v1(rec:fvv(i)-1,:);
        a1{j,i} = alphaShape(vv1(:,1), vv1(:,2), 0.1*j*ones(size(vv1,1), 1));
        %     a2{1,i} = alphaShape(vv1(:,1), vv1(:,2), 0.2*ones(size(vv1,1), 1));
        rec = fvv(i)+1;
    end
end
%ground
fl1 = [-50,60;250,60;250,-60;-50,-60];
Gra = polyshape(fl1);
figure(2)
ax = gca;
hold on
axis equal
axis off
view(45,60)
% grid on
xlabel('x [m]');ylabel('y [m]');zlabel('z [m]');
% plot(PP)
plot(RPP,'FaceColor',[0.1490,0.1490,0.1490])
% Plot the three objects in the same 3D plot
for j=1:height
    arrayfun(@(N) plot3(a1{j,N}.Points(:,1),a1{j,N}.Points(:,2),a1{j,N}.Points(:,3),'Color',[0.1490,0.1490,0.1490],'LineWidth',0.1),1:length(fvv))
end
% plot(Gra,'FaceColor',[0.1490,0.1490,0.1490]);
% arrayfun(@(N) plot3(a2{1,N}.Points(:,1),a2{1,N}.Points(:,2),a2{1,N}.Points(:,3),'b'),1:length(fvv))
% exportgraphics(ax,strcat('check','.pdf'));
hold off
