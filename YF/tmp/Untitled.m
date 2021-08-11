%論文の多層最小適応ほ
clear all
close all
grid_x = -2:0.1:5;
% grid_y = -180*pi/180:1*pi/180:180*pi/180;
grid_y = 0:0.1:5;
syms hat_r hat_psi
grid_z = grid_y;
G_pillar = zeros(length(grid_x),length(grid_y));
G_bamp = zeros(length(grid_x),length(grid_y));
%   allphi =zeros(length(grid_x),length(grid_y));
G_human = zeros(length(grid_x),length(grid_y));
[GX,GY] = meshgrid(grid_x,grid_y);%%χ
[hat_GX,hat_GY,hat_GZ]=meshgrid(grid_x,grid_y,grid_z);
[sizeX,~,~]=size(hat_GX);
[~,sizeY,~]=size(hat_GY);
[~,~,sizeZ]=size(hat_GZ);
phi = zeros(sizeX,sizeY,sizeZ);

saveX = [];
%%%%
pd =10;rd=5;%pd 障害物位置，rd障害物の直系
for n =1:1%sizeX
%         for m=1:sizeY
%             for k =1:sizeZ
%                 hat_r = hat_GX(n,m);
%                 hat_psi = hat_GY(n,m);
%                 hat_theta = hat_GZ(n,m,k);
%     
%     
%             x(1) = GX(n,m);
%             x(2) = GY(n,m);
%             rm = frm(x(1),x(2),pd,rd);
%             psi_m = fpsi_m(x(1),x(2),pd);
%     %         if norm([pd 0]-x,2)<=rd/2
%     %         Vp(n,m) = 10;
%     %         else
%     %         Vp(n,m) = (rm^2+psi_m^2);
%     %         end
%     
%     %         aaa = diff(hat_Vp,hat_r)
%             s_r = rm;
%             s_psi = psi_m;
%             r_polar = fp_polar(hat_r,pd,rd);
%             if s_r>=0
%                 r_polar = r_polar.A;
%             else
%                 r_polar = r_polar.B;
%             end
%             phi_x = fphix(r_polar,hat_psi,pd);
%             phi_y = fphiy(r_polar,hat_psi,pd);
%             phi_z = k;
% %             phi(n,m,k) = [phi_x, phi_y,phi_z];
%             scatter3(phi_x,phi_y,phi_z);
%             hold on
% %             calc_diff = fdiff_hat_x(phi_x,phi_y,hat_r,hat_psi);
%     
%     %         s_theta = ;
% %             V{n,m} =-double( vpa(subs(calc_diff,[hat_r hat_psi],[s_r,s_psi])));
% % % %             V_x = V(1);
% % % %             V_y = V(2);
% % % %             V_theta = V(3);
% % %             x = eye(2)*x + eye(2)*[V_x;V_y];
% %             hat_Vp(n,m) = (s_r^2+s_psi^2)/2;
% %             xxx = subs(phi_x,[hat_r hat_psi],[s_r,s_psi]);
% %             yyy = subs(phi_y,[hat_r hat_psi],[s_r,s_psi]);
% %             AAA(n,m) = norm([xxx yyy],2);
%     %         end
%             end
%         end
end
%%
% kkk = vpa(AAA)
% sss = double(kkk)
% mesh(hat_Vp)
% zlim([0 10])
%%
x = [-24;5;0];
for n =1:0.1:40
    rm = frm(x(1),x(2),pd,rd);
    psi_m = fpsi_m(x(1),x(2),pd);
    s_r = rm;
    s_psi = psi_m;
    r_polar = fp_polar(hat_r,pd,rd);
    if s_r>=0
        r_polar = r_polar.A;
    else
        r_polar = r_polar.B;
    end
    phi_x = fphix(r_polar,hat_psi,pd);
    phi_y = fphiy(r_polar,hat_psi,pd);
    calc_diff = fdiff_hat_x(phi_x,phi_y,hat_r,hat_psi);
    
    %         s_theta = ;
    V = -double(vpa(subs(calc_diff,[hat_r hat_psi],[s_r,s_psi])));
    V_x = V(1);
    V_y = V(2);
    V_theta = V(3);
    u1 = 0.1*(V_x*cos(x(3))+V_y*sin(x(3)));
    e = angle((V_x+V_y*1i)*exp(-x(3)*1i));
    if e>=(-pi/2)&&e<=(pi/2)
        u2 = 0.1*e;
    else
        u2 = 0.1*angle((V_x+V_y*1i)*exp(-x(3)*1i)*exp(pi*1i));
    end
%     x = ode45(@(x,t) 1*[cos(x(3)) 0;sin(x(3)) 0;0 1]*[u1;u2],[0 0.1],x);
    x = eye(3)*x+1*[cos(x(3)) 0;sin(x(3)) 0;0 1]*1*[u1;u2];

    %     x = ode45(@(x,t) 0.1*eye(2)*[V_x;V_y],[0 0.1],x(1:2));
%     x = x.y(:,end);
%     eye(2)*x(1:2) + 0.1*eye(2)*[-V_x;V_y];

    saveX = [saveX,x];
end
%%
% Genv =(G_bamp+G_pillar+G_human);
% mesh(Vp)
%%
figure
plot(saveX(1,:),saveX(2,:))
hold on 
 viscircles([-pd 0],rd/2)
 axis equal
% figure(4)
% surf(GX,GY,Genv,'EdgeColor','none');
%     figure(5)
%   surf(GX,GY,allphi,'EdgeColor','none');
%             contour(GX,GY,Genv);

%%%%関数たち
function result = fphix(r_polar,hat_psi,pd)
result = r_polar*cos(hat_psi)-pd;
end
function result = fphiy(r_polar,hat_psi,pd)
result = r_polar*sin(hat_psi);
end
function result = fphi_thita(hat_thita)
result = hat_thita;
end
function result = fp_polar(hat_r,pd,rd)

result.A = hat_r+pd;
result.B = 2*(pd-rd)*atan((pi*hat_r)/(2*pd-rd))/pi + pd;
end
function result = fV(psi_m,r_m)
result = (psi_m^2+r_m^2);
end
function result = frm(x,y,pd,rd)
dp = sqrt((x+pd)^2+y^2);
% if pd <=dp
%     result = dp - pd;
% else
%     result = 2*tan( (pi*(dp-pd))/(2*(pd-rd)) )/pi;
%     
% end
if pd <=dp
    result = dp - pd;
elseif rd<dp&&dp<pd
    result = 2*tan( (pi*(dp-pd))/(2*(pd-rd)) )/pi;
else
    result=102;
end
end
function result = fpsi_m(x,y,pd)

result = angle(x+pd-y*1i);

end
function result = fdiff_hat_x(phi_x,phi_y,hat_r,hat_psi)
rdiff_phi_x = diff(phi_x,hat_r);
rdiff_phi_y = diff(phi_y,hat_r);
psidiff_x = diff(phi_x,hat_psi);
psidiff_y = diff(phi_y,hat_psi);

result = [hat_r,hat_psi,0]/([rdiff_phi_x,rdiff_phi_y,0;psidiff_x,psidiff_y,0;0,0,1]);



end
