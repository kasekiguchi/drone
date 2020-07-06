function [] = make_trajectory_animation(tspan,X,ref,Reference_obj,N,plot_range)
r=0.2;
dt = 0.1;
[fx,fy,fz]=cylinder([r,r]);
fz=fz/50;
PT=tspan(rem(tspan,dt)==0);
if iscell(X)
    PX=[X{rem(tspan,dt)==0,:}];
else
    PX.q=[X(rem(tspan,dt)==0,1:4)'];
    PX.p=[X(rem(tspan,dt)==0,5:7)'];
end

%% plot setting
daspect([1 1 1])
axis([0 2 -1 1])
% for check
ke=length(PT);
%figure(1)
xlabel('x','FontSize',14);
ylabel('y','FontSize',14);
zlabel('z','FontSize',14);
axis vis3d equal;
view([-37.5,30]);
%camlight;
grid on;
% xlim([-1,9]);
% ylim([-1,9]);
% zlim([-1,5]);
xlim(plot_range.x);
ylim(plot_range.y);
zlim(plot_range.z);
%daspect([1 1 1]) %equal‚Æ“¯‚¶
xlabel('x')
ylabel('y')
zlabel('z')
grid on
hold on
%%
if contains(Reference_obj.name,'FM')
    refp=Reference_obj.param.offset.p(:,1);
else
    if iscell(ref)
        nf = length(ref{1,1});
        ref = [ref{:,1}];
        ref=reshape(ref,[nf,length(ref)/nf])';
        refp=[ref(rem(tspan,dt)==0,1:3)'];
    else
        refp=[ref(rem(tspan,dt)==0,1:3)'];
    end
end
plot3(refp(1,:),refp(2,:),refp(3,:),'LineWidth',1)
[x, y, z] = sphere;
pos=[PX.p];
if isfield(PX,"R")
    Rv=[PX.R];
else
    qv=[PX.q];
end
for k = 1:ke
    for i = 1:N
        if isfield(PX,"R")
            Ro=v2R(Rv(:,k+(i-1)*ke));
        else
            Ro=quat2rotm(qv(:,k+(i-1)*ke)');
        end
        Pb1=pos(:,k+(i-1)*ke)+Ro*[fx(1,:);fy(1,:);fz(1,:)];
        Pb2=pos(:,k+(i-1)*ke)+Ro*[fx(2,:);fy(2,:);fz(2,:)];
        surf([Pb1(1,:);Pb2(1,:)],[Pb1(2,:);Pb2(2,:)],[Pb1(3,:);Pb2(3,:)]);
        %scatter3(pos(1)-paramFMControl.offset(5,i),pos(2)-paramFMControl.offset(6,i),pos(3)-paramFMControl.offset(7,i),i);
    end
    % reference position for agent 1
    X=0.1*x+(refp(1,k));
    Y=0.1*y+(refp(2,k));
    Z=0.1*z+(refp(3,k));
    surface(X, Y, Z, 'EdgeColor', 'none');
    % update screen
    drawnow limitrate
end
end

