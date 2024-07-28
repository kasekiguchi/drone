function [Xd,vd] = gen_ref_for_take_off(Xd_old,sp,d,te,t)
%% Setting
% calc reference position and its higher time derivatives
% reference designed as a 9-degree polynomial function of time
% [Inputs] 
% Xd_old : reference calculated at previous time
% sp : initial offset
% d : reference altitude
% te : terminal time to reach d
% t : current time
% 
% [Output]
% Xd : reference [[p;yd], [p^(1);0], [p^(2);0], [p^(3);0], [p^(4);0]] as column vector 
%    : Xd in R^20
%    : yd is a yaw angle reference
% vd : reference velocity

%% Variable set
Xd  = zeros( 20, 1);
%% Set Xd
Xd( 1, 1)   = Xd_old( 1);% ref x
Xd( 2, 1)   = Xd_old( 2);% ref y
Xd( 4, 1)   = Xd_old( 4);% ref yaw angle
if t<=te
    tra=(126*d*t^5)/te^5 - (420*d*t^6)/te^6 + (540*d*t^7)/te^7 - (315*d*t^8)/te^8 + (70*d*t^9)/te^9;
    dtra = (630*d*t^4)/te^5 - (2520*d*t^5)/te^6 + (3780*d*t^6)/te^7 - (2520*d*t^7)/te^8 + (630*d*t^8)/te^9;
    ddtra = (2520*d*t^3)/te^5 - (12600*d*t^4)/te^6 + (22680*d*t^5)/te^7 - (17640*d*t^6)/te^8 + (5040*d*t^7)/te^9;
    d3tra = (7560*d*t^2)/te^5 - (50400*d*t^3)/te^6 + (113400*d*t^4)/te^7 - (105840*d*t^5)/te^8 + (35280*d*t^6)/te^9;
    d4tra = (15120*d*t)/te^5 - (151200*d*t^2)/te^6 + (453600*d*t^3)/te^7 - (529200*d*t^4)/te^8 + (211680*d*t^5)/te^9;
elseif t> te
    t= te;
    tra=d;
    dtra = 0;
    ddtra = 0;
    d3tra = 0;
    d4tra = 0;
end
    Xd( 3, 1) = tra + sp(3);
    Xd(7,1) = dtra;
    Xd(11,1) = ddtra;
    Xd(15,1)=d3tra;
    Xd(19,1)=d4tra;
    vd = [0;0;dtra;0];
end
