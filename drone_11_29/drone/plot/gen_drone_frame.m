%% ドローンのフレーム
clear all
% propeller
[px,py,pz]=cylinder(0.06); 
prop = patch('XData',px(1,:)','YData',py(1,:)','ZData',pz(1,:)'); 
l1=length(prop.Vertices(:,1)); % 円柱の頂点の数
L = 0.1;% motor 間の距離/2
H = 0.5;
p1 = L*[1 1 H];
p2 = L*[-1 1 H];
p3 = L*[-1 -1 H];
p4 = L*[1 -1 H];
Prop.Vertices = [prop.Vertices+p1;[0 0 0];prop.Vertices+p2;[0 0 0];prop.Vertices+p3;[0 0 0];prop.Vertices+p4];
Prop.Faces=[prop.Faces;prop.Faces+l1+1;prop.Faces+2*(l1+1);prop.Faces+3*(l1+1)];
Prop.FaceVertexCData=ones(length(Prop.Faces(:,1)),1);

% body
pvnum = 0;%length(Frame.Vertices(:,1));
Frame.Vertices = [p1;p1.*[1 1 0];p3.*[1 1 0];p3;0 0 0;p2;p2.*[1 1 0];p4.*[1 1 0];p4];
pfnum = 0;%length(Frame.Faces(1,:));
Frame.Faces = [pvnum+[1 2 3 4 NaN(1,pfnum-4)];pvnum+5+[1 2 3 4 NaN(1,pfnum-4)]];
Frame.FaceVertexCData=zeros(length(Frame.Vertices),1);
fig =[Prop;Frame];
%save('plot/frame/drone_frame_01_05.mat','fig','-nocompression');

%%
close all 
figure;hold on; grid on; xlim([-2,2]);ylim([-2,2]);zlim([0,2]);view([1 2 1]);daspect([1 1 1]);
pp =patch(Prop,'FaceAlpha',0.3);
pf =patch(Frame,'EdgeColor','flat','FaceColor','none','LineWidth',0.2);
colorbar;
%%
syms dir [1 3] real
syms deg real
syms model
matlabFunction(rotate([pp;pf],dir,deg),'File','drone_frame.m',"Vars",{dir deg});
%matlabFunction(rotate(model,dir,deg),'File','drone_frame.m',"Vars",{model dir deg});
%%
close all
hold on; 
pp =patch(Prop,'FaceAlpha',0.3);
pf =patch(Frame,'EdgeColor','flat','FaceColor','none','LineWidth',0.2);
drone = [pp;pf];
obj_plot(drone,[0 0 0],Rodrigues([0 pi/2 0]))
grid on; daspect([1 1 1]);view([1 1 1])
%%
function pobj = obj_plot(obj,trans,rotm)
    %rad = norm(rot);
    %dir = rot/rad;
    pobj=obj;
    for i = 1:length(pobj)
        pobj(i).Vertices = (rotm*pobj(i).Vertices')'+trans;
    end
    %rotate(obj,dir,180*rad/pi,orig+trans);
end
