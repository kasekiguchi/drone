function Xd = gen_ref_for_take_off(Xd_old)
%% Setting
%�����̖ڕW���x
take_off_vz     = 0.7;% m/s 
dz = take_off_vz * 0.025;
%% Variable set
Xd  = zeros( 3, 1);
%% Set Xd
    Xd( 1, 1)   = Xd_old( 1);% �����ŖڕW�ʒux
    Xd( 2, 1)   = Xd_old( 2);% �����ŖڕW�ʒuy
    Xd( 3, 1)   = Xd_old( 3);
    if Xd_old(3)<1 % �����ŖڕW���x�ς�����
        Xd( 3, 1)   = Xd_old(3) + dz;
    end
%     Xd( 3, 1)   = 1.5;
  %  Xd(4,1)=Xd_old(4);
end
