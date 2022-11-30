function [Xd,vd] = gen_ref_for_landing(Xd_old,dt)
%% Setting
% dz = 0.2 * dt; % 目標速度 * サンプリングタイム
dz = 0.01* dt; % 目標速度(20分の１) * サンプリングタイム
%% Set Xd
    Xd = Xd_old(1:3);
    if Xd_old(3) > 0
        Xd( 3, 1)   = Xd_old( 3) - dz;
    end
  %  Xd(4,1)=Xd_old(3);
  vd = [0;0;0];
end
