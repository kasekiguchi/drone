function Xd = gen_ref_for_take_off(Xd_old)
%% Setting
%—£—¤‚Ì–Ú•W‘¬“x
take_off_vz     = 0.40;
dz = take_off_vz * 0.025;
%% Variable set
Xd  = zeros( 3, 1);
%% Set Xd
    Xd( 1, 1)   = Xd_old( 1);
    Xd( 2, 1)   = Xd_old( 2);
    Xd( 3, 1)   = Xd_old( 3);
    if Xd_old(3)<0.5
        Xd( 3, 1)   = Xd_old(3) + dz;
    end
  %  Xd(4,1)=Xd_old(4);
end
