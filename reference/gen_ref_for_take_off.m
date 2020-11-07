function Xd = gen_ref_for_take_off(Xd_old,sp,d,te,t)
%% Setting
%離陸の目標速度
take_off_vz     = 0.2;% m/s
dz = take_off_vz * 0.025;
%%

%% Variable set
Xd  = zeros( 20, 1);
%% Set Xd
Xd( 1, 1)   = Xd_old( 1);% ここで目標位置x
Xd( 2, 1)   = Xd_old( 2);% ここで目標位置y
Xd( 3, 1)   = Xd_old( 3);
%if Xd_old(3)<d % ここで目標高度変えられる
%Xd( 3, 1)   = Xd_old(3) + dz;
%end
if t<=te
    tra=(126*d*t^5)/te^5 - (420*d*t^6)/te^6 + (540*d*t^7)/te^7 - (315*d*t^8)/te^8 + (70*d*t^9)/te^9;
    dtra = (630*d*t^4)/te^5 - (2520*d*t^5)/te^6 + (3780*d*t^6)/te^7 - (2520*d*t^7)/te^8 + (630*d*t^8)/te^9;
    ddtra = (2520*d*t^3)/te^5 - (12600*d*t^4)/te^6 + (22680*d*t^5)/te^7 - (17640*d*t^6)/te^8 + (5040*d*t^7)/te^9;
    d3tra = (7560*d*t^2)/te^5 - (50400*d*t^3)/te^6 + (113400*d*t^4)/te^7 - (105840*d*t^5)/te^8 + (35280*d*t^6)/te^9;
    d4tra = (15120*d*t)/te^5 - (151200*d*t^2)/te^6 + (453600*d*t^3)/te^7 - (529200*d*t^4)/te^8 + (211680*d*t^5)/te^9;
    Xd( 3, 1) = tra + sp(3);
    Xd(7,1) = dtra;
    Xd(11,1) = ddtra;
    Xd(15,1)=d3tra;
    Xd(19,1)=d4tra;
elseif t> te
    t= te;
    tra=(126*d*t^5)/te^5 - (420*d*t^6)/te^6 + (540*d*t^7)/te^7 - (315*d*t^8)/te^8 + (70*d*t^9)/te^9;
    dtra = (630*d*t^4)/te^5 - (2520*d*t^5)/te^6 + (3780*d*t^6)/te^7 - (2520*d*t^7)/te^8 + (630*d*t^8)/te^9;
    ddtra = (2520*d*t^3)/te^5 - (12600*d*t^4)/te^6 + (22680*d*t^5)/te^7 - (17640*d*t^6)/te^8 + (5040*d*t^7)/te^9;
    d3tra = (7560*d*t^2)/te^5 - (50400*d*t^3)/te^6 + (113400*d*t^4)/te^7 - (105840*d*t^5)/te^8 + (35280*d*t^6)/te^9;
    d4tra = (15120*d*t)/te^5 - (151200*d*t^2)/te^6 + (453600*d*t^3)/te^7 - (529200*d*t^4)/te^8 + (211680*d*t^5)/te^9;
end
%     Xd( 3, 1)   = 1.5;
%  Xd(4,1)=Xd_old(4);

end
