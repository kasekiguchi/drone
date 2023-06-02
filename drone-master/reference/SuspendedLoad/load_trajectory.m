function ref = load_trajectory(varargin)
%%
if length(varargin) == 1
    param=varargin{1};
elseif length(varargin)==4
    param=varargin;
end

Tf = param{1};
in3 = param{2};
Xd = param{3};
%%
% Mq = in3(:,1);
% jx = in3(:,3);
% jy = in3(:,4);
% jz = in3(:,5);
% g = in3(:,6);
% ml = in3(:,15);
% L = in3(:,16);
% 
% J=[jx 0 0;
%     0 jy 0;
%     0 0 jz];
% 
% e3=[0;0;1];

%% new trajectory
% xl0=Xd(1,1);
% xl1=Xd(1,2);
% xl2=Xd(1,3);
% xl3=Xd(1,4);
% xl4=Xd(1,5);
% xl5=Xd(1,6);
% 
% yl0=Xd(2,1);
% yl1=Xd(2,2);
% yl2=Xd(2,3);
% yl3=Xd(2,4);
% yl4=Xd(2,5);
% yl5=Xd(2,6);
% 
% zl0=Xd(3,1);
% zl1=Xd(3,2);
% zl2=Xd(3,3);
% zl3=Xd(3,4);
% zl4=Xd(3,5);
% zl5=Xd(3,6);
% 
% t0=0;
% t1=1;
% t2=4;
% t3=6;
% t4=9;
% t5=12;
% 
% A_x = [t1^3 t1^4 t1^5 t1^6 t1^7 t1^8 t1^9;
%     t2^3 t2^4 t2^5 t2^6 t2^7 t2^8 t2^9;
%     t3^3 t3^4 t3^5 t3^6 t3^7 t3^8 t3^9;
%     t4^3 t4^4 t4^5 t4^6 t4^7 t4^8 t4^9;
%     t5^3 t5^4 t5^5 t5^6 t5^7 t5^8 t5^9;
%     3*t5^2 4*t5^3 5*t5^4 6*t5^5 7*t5^6 8*t5^7 9*t5^8;
%     3*2*t5 4*3*t5^2 5*4*t5^3 6*5*t5^4 7*6*t5^5 8*7*t5^6 9*8*t5^7];
% 
% B_x = [xl1 - xl0;
%     xl2 - xl0;
%     xl3 - xl0;
%     xl4 - xl0;
%     xl5 - xl0;
%     0;
%     0];
% 
% X = linsolve(A_x,B_x);
% 
% A_y = [t1^3 t1^4 t1^5 t1^6 t1^7 t1^8 t1^9;
%     t2^3 t2^4 t2^5 t2^6 t2^7 t2^8 t2^9;
%     t3^3 t3^4 t3^5 t3^6 t3^7 t3^8 t3^9;
%     t4^3 t4^4 t4^5 t4^6 t4^7 t4^8 t4^9;
%     t5^3 t5^4 t5^5 t5^6 t5^7 t5^8 t5^9;
%     3*t5^2 4*t5^3 5*t5^4 6*t5^5 7*t5^6 8*t5^7 9*t5^8;
%     3*2*t5 4*3*t5^2 5*4*t5^3 6*5*t5^4 7*6*t5^5 8*7*t5^6 9*8*t5^7];
% 
% B_y = [yl1 - yl0;
%     yl2 - yl0;
%     yl3 - yl0;
%     yl4 - yl0;
%     yl5 - yl0;
%     0;
%     0];
% 
% Y = linsolve(A_y,B_y);
% 
% A_z = [t1^3 t1^4 t1^5 t1^6 t1^7 t1^8 t1^9;
%     t2^3 t2^4 t2^5 t2^6 t2^7 t2^8 t2^9;
%     t3^3 t3^4 t3^5 t3^6 t3^7 t3^8 t3^9;
%     t4^3 t4^4 t4^5 t4^6 t4^7 t4^8 t4^9;
%     t5^3 t5^4 t5^5 t5^6 t5^7 t5^8 t5^9;
%     3*t5^2 4*t5^3 5*t5^4 6*t5^5 7*t5^6 8*t5^7 9*t5^8;
%     3*2*t5 4*3*t5^2 5*4*t5^3 6*5*t5^4 7*6*t5^5 8*7*t5^6 9*8*t5^7];
% 
% B_z = [zl1 - zl0;
%     zl2 - zl0;
%     zl3 - zl0;
%     zl4 - zl0;
%     zl5 - zl0;
%     0;
%     0];
% 
% Z = linsolve(A_z,B_z);
% 
% syms t real
% 
% xl = xl0+X(1)*t^3+X(2)*t^4+X(3)*t^5+X(4)*t^6+X(5)*t^7+X(6)*t^8+X(7)*t^9;
% % xl_dot = diff(xl);
% xl_2dot = diff(xl,2);
%     
% yl = yl0+Y(1)*t^3+Y(2)*t^4+Y(3)*t^5+Y(4)*t^6+Y(5)*t^7+Y(6)*t^8+Y(7)*t^9;
% % yl_dot = diff(yl);
% yl_2dot = diff(yl,2);
% 
% zl = zl0+Z(1)*t^3+Z(2)*t^4+Z(3)*t^5+Z(4)*t^6+Z(5)*t^7+Z(6)*t^8+Z(7)*t^9;
% % zl_dot = diff(zl);
% zl_2dot = diff(zl,2);

%% 7th order polynomial basis function
xl_0    = Xd(1,1);
xl_Tf   = Xd(1,3);
xl_Tf2  = Xd(1,2);
yl_0    = Xd(2,1);
yl_Tf   = Xd(2,3);
yl_Tf2  = Xd(2,2);
zl_0    = Xd(3,1);
zl_Tf   = Xd(3,3);
zl_Tf2  = Xd(3,2);

s = Tf;
A_x = [s^3 s^4 s^5 s^6 s^7;
        3*s^2 4*s^3 5*s^4 6*s^5 7*s^6;
        6*s 12*s^2 20*s^3 30*s^4 42*s^5;
        (s/2)^3 (s/2)^4 (s/2)^5 (s/2)^6 (s/2)^7;
        3*(s/2)^2 4*(s/2)^3 5*(s/2)^4 6*(s/2)^5 7*(s/2)^6];

B_x = [xl_Tf - xl_0;
        0;
        0;
        xl_Tf2 - xl_0;
        0];

X = linsolve(A_x,B_x);

A_y = [s^3 s^4 s^5 s^6 s^7;
        3*s^2 4*s^3 5*s^4 6*s^5 7*s^6;
        6*s 12*s^2 20*s^3 30*s^4 42*s^5;
        (s/2)^3 (s/2)^4 (s/2)^5 (s/2)^6 (s/2)^7;
        3*(s/2)^2 4*(s/2)^3 5*(s/2)^4 6*(s/2)^5 7*(s/2)^6];

B_y = [yl_Tf - yl_0;
        0;
        0;
        yl_Tf2 - yl_0;
        0];

Y = linsolve(A_y,B_y);

A_z = [s^3 s^4 s^5 s^6 s^7;
        3*s^2 4*s^3 5*s^4 6*s^5 7*s^6;
        6*s 12*s^2 20*s^3 30*s^4 42*s^5;
        (s/2)^3 (s/2)^4 (s/2)^5 (s/2)^6 (s/2)^7;
        3*(s/2)^2 4*(s/2)^3 5*(s/2)^4 6*(s/2)^5 7*(s/2)^6];

B_z = [zl_Tf - zl_0;
        0;
        0;
        zl_Tf2 - zl_0;
        0];

Z = linsolve(A_z,B_z);

syms t real

xl = xl_0+X(1)*t^3+X(2)*t^4+X(3)*t^5+X(4)*t^6+X(5)*t^7;%16*sin(t/2)^3;%
% xl_dot = diff(xl);
% xl_2dot = diff(xl,2);
    
yl = yl_0+Y(1)*t^3+Y(2)*t^4+Y(3)*t^5+Y(4)*t^6+Y(5)*t^7;%13*cos(t/2)-5*cos(2*t/2)-2*cos(3*t/2)-cos(4*t/2);%
% yl_dot = diff(yl);
% yl_2dot = diff(yl,2);

zl = zl_0+Z(1)*t^3+Z(2)*t^4+Z(3)*t^5+Z(4)*t^6+Z(5)*t^7;
% zl_dot = diff(zl);
% zl_2dot = diff(zl,2);
%%
Xl = [xl yl zl]';
yaw = 0;
ref = @(t)[Xl;
    yaw];
%%
% Xl_dot = [xl_dot yl_dot zl_dot]';
% Xl_2dot = [xl_2dot yl_2dot zl_2dot]';
% Tp = -ml*Xl_2dot-ml*g*e3;
% p = Tp/(Tp(1)^2+Tp(2)^2+Tp(3)^2)^0.5;
% Xq = Xl-L*p;
% Xq_dot = diff(Xq,t);
% Xq_2dot = diff(Xq,t,2);


% troll = (Tp(2)-Mq*Xq_2dot(2))/sqrt((Mq*Xq_2dot(1)-Tp(1))^2+(Mq*(Xq_2dot(3)+g)-Tp(3))^2);
% roll = atan(troll);
% tpitch = (Mq*Xq_2dot(1)-Tp(1))/(Mq*(Xq_2dot(3)+g)-Tp(3));
% pitch = atan(tpitch);
% Omega = [diff(roll) diff(pitch) 0]';

% Omega = [cos(roll)^2*diff((Tp(2)-Mq*Xq_2dot(2))/sqrt((Mq*Xq_2dot(1)-Tp(1))^2+(Mq*(Xq_2dot(3)+g)-Tp(3))^2));
%         cos(pitch)^2*diff((Mq*Xq_2dot(1)-Tp(1))/(Mq*(Xq_2dot(3)+g)-Tp(3)));
%         0];

% ref=@(t)[Xq;
%     yaw;
%     pitch;
%     roll;
%     Xq_dot;
%     Omega;
%     Xl];
end