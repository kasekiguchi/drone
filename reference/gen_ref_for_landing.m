function Xd = gen_ref_for_landing(Xd_old)
%% Setting
dz = 0.4 * 0.025; % �ڕW���x * �T���v�����O�^�C��
%% Set Xd
    Xd = Xd_old(1:3);
    if Xd_old(3) > 0
        Xd( 3, 1)   = Xd_old( 3) - dz;
    end
  %  Xd(4,1)=Xd_old(3);
end
