function [Xd,vd] = gen_ref_for_landing_speed(Xd_old,dt,v)
%% Setting
% dz = 0.2 * dt; % 目標速度 * サンプリングタイム
dz = v* dt; % 目標速度(5分の１) * サンプリングタイム
%% Set Xd
    Xd = Xd_old(1:3);
    if Xd_old(3) > 1
        Xd( 3, 1)   = Xd_old( 3) - dz;
    end
  %  Xd(4,1)=Xd_old(3);
  vd = [0;0;0];
end

