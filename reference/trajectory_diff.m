function ref = trajectory_diff(varargin)
%%
if length(varargin) == 1
    param=varargin{1};
elseif length(varargin)==4
    param=varargin;
end

Tf = param{1};
in3 = param{2};
X = param{3};

Mq = in3(:,1);
jx = in3(:,3);
jy = in3(:,4);
jz = in3(:,5);
g = in3(:,6);
ml = in3(:,15);
L = in3(:,16);

J=[jx 0 0;
    0 jy 0;
    0 0 jz];

e3=[0;0;1];

xl_0    = X(1,1);
xl_Tf   = X(1,3);
xl_Tf2  = X(1,2);
yl_0    = X(2,1);
yl_Tf   = X(2,3);
yl_Tf2  = X(2,2);
zl_0    = X(3,1);
zl_Tf   = X(3,3);
zl_Tf2  = X(3,2);

%% 7th order polynomial basis function
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

xl = xl_0+cos(2*pi*t/2);%+X(1)*t^3+X(2)*t^4+X(3)*t^5+X(4)*t^6+X(5)*t^7;
% xl_dot = diff(xl);
xl_2dot = diff(xl,2);
    
yl = yl_0+0.5*sin(2*pi*t/2);%Y(1)*t^3+Y(2)*t^4+Y(3)*t^5+Y(4)*t^6+Y(5)*t^7;
% yl_dot = diff(yl);
yl_2dot = diff(yl,2);

zl = zl_0+Z(1)*t^3+Z(2)*t^4+Z(3)*t^5+Z(4)*t^6+Z(5)*t^7;
% zl_dot = diff(zl);
zl_2dot = diff(zl,2);

%%
Xl = [xl yl zl]';
% Xl_dot = [xl_dot yl_dot zl_dot]';
Xl_2dot = [xl_2dot yl_2dot zl_2dot]';
Tp = -ml*Xl_2dot-ml*g*e3;
p = Tp/(Tp(1)^2+Tp(2)^2+Tp(3)^2)^0.5;
Xq = Xl-L*p;
% Xq_dot = diff(Xq,t);
% Xq_2dot = diff(Xq,t,2);
% 
% troll = (Tp(2)-Mq*Xq_2dot(2))/sqrt((Mq*Xq_2dot(1)-Tp(1))^2+(Mq*(Xq_2dot(3)+g)-Tp(3))^2);
% roll = atan(troll);
% tpitch = (Mq*Xq_2dot(1)-Tp(1))/(Mq*(Xq_2dot(3)+g)-Tp(3));
% pitch = atan(tpitch);
yaw = 0;
% 
% % Omega = [diff(roll) diff(pitch) 0]';
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
ref = @(t)[Xl;
    yaw];
end