function Xd = gen_ref_for_take_off(Xd_old)
%% Setting
%離陸の目標速度
take_off_vz     = 0.7;% m/s 
dz = take_off_vz * 0.025;
%% Variable set
Xd  = zeros( 3, 1);
%% Set Xd
    Xd( 1, 1)   = Xd_old( 1);% ここで目標位置x
    Xd( 2, 1)   = Xd_old( 2);% ここで目標位置y
    Xd( 3, 1)   = Xd_old( 3);
    if Xd_old(3)<1 % ここで目標高度変えられる
        Xd( 3, 1)   = Xd_old(3) + dz;
    end
%     Xd( 3, 1)   = 1.5;
  %  Xd(4,1)=Xd_old(4);
end
