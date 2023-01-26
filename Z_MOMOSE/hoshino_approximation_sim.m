% Hoshino approximation drone
% Physical constants
    % m = 0.716; %kg
    m = 0.269; %kg
    Ixx = 0.007;%kg m^2
    Iyy = 0.007;%kg m^2
    Izz = 0.012;%kg m^2
    g = 9.81;

    lx = 0.06; %重心位置
    ly = 0.06; %重心位置
    k1 = 0.0301; % ロータ定数
    k2 = 0.0301; % ロータ定数
    k3 = 0.0301; % ロータ定数
    k4 = 0.0301; % ロータ定数

    % m = 1; %kg
    % Ixx = 1;%kg m^2
    % Iyy = 1;%kg m^2
    % Izz = 1;%kg m^2
    % g = 1;
    
% Matrix
    Ax = diag([1,g,1],1);
    Ay = diag([1,-g,1],1);
    Az = diag(1,1);
    Apsi = diag(1,1);

    Bx = [zeros(3,1);1/Iyy];
    By = [zeros(3,1);1/Ixx];
    Bz = [zeros(1,1);1/m];
    Bpsi = [zeros(1,1);1/Izz];

% Time
    t=20;        %symuration time
    dt=0.01; %sampling time
    time=(0:dt:t);
    tspan = length(time);
    %distrbance time
    disf=0/dt;%start
    dise=10/dt;%finish

% Objective trajectory
    %reference
%     ref = @(t) [cos(2*pi*t/12)*cos(2*pi*t/0.1), cos(2*pi*t/12)*sin(2*pi*t/0.1), t*0+tanh(t/7)*1+0*sin(2*pi*t/(22))^1];    %x,y,z
ref = @(t) [7,-5,2];    %x,y,z    
% r = 0.2;
    % T =15;
    % ref = @(t) [r*cos(2*pi*t/T), r*sin(2*pi*t/T), 1];    %x,y,z

    %diff reference
    syms t real
    dref = matlabFunction(diff(ref,t),"Vars",t);

    %initial 
    xid = ref(time(1));
    dxid = dref(time(1));
    Xidk = xid; %keep
    dXidk = dxid; %keep

% Initial state
    xi1 = 0 - xid(1);    %x
    xi2 = 0 - xid(2);    %y
    xi3 = 0 - xid(3);    %z
    dxi1 = 0 - dxid(1);
    dxi2 = 0 - dxid(2);
    dxi3 = 0 - dxid(3);
    theta = 0; %roll 
    phi = 0;    %pitch 
    psi = 0;    %yaw 
    dtheta = 0;
    dphi = 0;
    dpsi = 0;

    ux = zeros(1,tspan);
    uy = zeros(1,tspan);
    uz = zeros(1,tspan);
    upsi = zeros(1,tspan);
    U =  zeros(4,tspan-1);

% State
    Xs = [xi1; dxi1; theta; dtheta];
    Ys = [xi2; dxi2; phi; dphi];
    Zs = [xi3; dxi3];
    Psis = [psi; dpsi];

% Keep (save)
    Xk = [xi1 + xid(1); dxi1; theta; dtheta];
    Yk = [xi2 + xid(2); dxi2; phi; dphi];
    Zk = [xi3 + xid(3); dxi3];
    Psik = [psi; dpsi];

% Feedback gain
    Kx = 0.01*[3.16 6.79 40.54 12.27];
    Ky = 0.01*[-3.16 -6.79 40.54 12.27];
    Kz = [2.23 2.28];
    Kpsi = [1.41 1.35];

    Kx = place(Ax,Bx,[-1,-1.2,-10,-1.5]);
    Ky = place(Ay,By,[-1,-1.2,-10,-1.5]);
    Kz = lqrd(Az,Bz,diag([100,10]),0.1,dt);
    Kpsi = lqrd(Apsi,Bpsi,diag([100,10,]),0.1,dt);
    
%     Kx = lqrd(Ax,Bx,diag([100,10,10,1]),0.01,dt);
%     Ky = lqrd(Ay,By,diag([100,10,10,1]),0.01,dt);
%     Kz = lqrd(Az,Bz,diag([100,10]),0.1,dt);
%     Kpsi = lqrd(Apsi,Bpsi,diag([100,10,]),0.1,dt);

    %発散する
    % Kx = lqr(Ax,Bx,diag([100,10,10,1]),0.01);
    % Ky = lqr(Ay,By,diag([100,10,10,1]),0.01);
    % Kz = lqr(Az,Bz,diag([100,10]),0.1);
    % Kpsi = lqr(Apsi,Bpsi,diag([100,10,]),0.1);

% Homogenious paramater Alpha
    anum = 4; %変数の数
    alpha = zeros(anum + 1, 1);
    alpha(anum + 1) = 1;
    alp=0.9;
    alpha(anum) = alp; %alphaの初期値
    for a = anum - 1:-1:1
        alpha(a) = (alpha(a + 2) * alpha(a + 1)) / (2 * alpha(a + 2) - alpha(a + 1));
    end

%Transform input to thrust
    invG = inv([ones(1,4); ly*[-1 1 -1 1]; lx*[-1 -1 1 1];[k1 -k2 -k3 k4]]);

%% Main loop
a = 2;%外乱の大きさの上限
for i = 1:tspan-1
    % distrbance
         dist1 = 0; dist2 = 0; dist3 = 0; dist4 = 0;%2*a*rand(1)-a;
         dist21 = 0; dist22 = 1*dist4;
    
    % Subsystem input
        % Finite time settling controller
            ux(i) = -Kx*(sign(Xs).*abs(Xs).^alpha(1:4)); %tau_theta roll
            uy(i) = -Ky*(sign(Ys).*abs(Ys).^alpha(1:4)); %tau_phi pitch
            uz(i) = -Kz*(sign(Zs).*abs(Zs).^alpha(1:2)); % f throtl
            upsi(i) = -Kpsi*(sign(Psis).*abs(Psis).^alpha(1:2));%tau_psi yaw

        % Linear state feedback controller
%             ux(i) = -Kx*Xs; %tau_theta roll
%             uy(i) = -Ky*Ys; %tau_phi pitch
%             uz(i) = -Kz*Zs; % f throtl
%             upsi(i) = -Kpsi*Psis;%tau_psi yaw
    
    % Thrust input
        U(:,i) =  invG*[uz(i) + m*g; uy(i); ux(i); upsi(i)];

    % Cariculate     
        if disf<i&&i<dise
            [~,Xs]=ode45(@(t,x) Ax*x + Bx*ux(i) + [dist1;dist2;dist3;dist4], [0 dt], Xs);
            [~,Ys]=ode45(@(t,y) Ay*y + By*uy(i) + [dist1;dist2;dist3;dist4], [0 dt], Ys);
            [~,Zs]=ode45(@(t,z) Az*z + Bz*uz(i) + [dist21;dist22], [0 dt], Zs);
            [~,Psis]=ode45(@(t,psi) Apsi*psi + Bpsi*upsi(i) + [dist21;dist22], [0 dt], Psis);
        else

            [~,Xs]=ode45(@(t,x) Ax*x + Bx*ux(i), [0 dt], Xs);
            [~,Ys]=ode45(@(t,y) Ay*y + By*uy(i), [0 dt], Ys);
            [~,Zs]=ode45(@(t,z) Az*z + Bz*uz(i), [0 dt], Zs);
            [~,Psis]=ode45(@(t,psi) Apsi*psi + Bpsi*upsi(i), [0 dt], Psis);

        end
        
    % real place
        X = Xs(end,:)' + [xid(1); dxid(1); zeros(2,1)];
        Y = Ys(end,:)' + [xid(2); dxid(2); zeros(2,1)];
        Z = Zs(end,:)' + [xid(3); dxid(3)];
        Psis = Psis(end,:)';
    
    % update
        xid = ref(time(i+1));
        dxid = dref(time(i+1));
        Xs = X - [xid(1); dxid(1); zeros(2,1)];    %x
        Ys = Y - [xid(2); dxid(2); zeros(2,1)];    %y
        Zs = Z - [xid(3); dxid(3)];    %z
    
    % keep
        Xk = [Xk, X];
        Yk = [Yk, Y];
        Zk = [Zk, Z];
        Psik = [Psik, Psis];
        Xidk = [Xidk; xid];
        dXidk = [dXidk; dxid];
 end
%% Figure
j=1;
figure(j)
hold on
grid on
plot3(Xk(1,:),Yk(1,:),Zk(1,:))
plot3(Xidk(:,1),Xidk(:,2),Xidk(:,3))
title('\xi 3D');
% legend('\xi1','\xi2','\xi3')
hold off
j=j+1;

figure(j)
hold on
grid on
plot(time,[Xk(1,:);Yk(1,:);Zk(1,:)])
plot(time,Xidk)
title('\xi');
legend('\xi1','\xi2','\xi3')
hold off
j=j+1;

figure(j)
hold on
grid on
plot(time,[Xk(2,:);Yk(2,:);Zk(2,:)])
plot(time,dXidk)
title('d\xi');
legend('d\xi1','d\xi2','d\xi3')
hold off
j=j+1;

figure(j)
hold on
grid on
plot(time,[Yk(3,:);Xk(3,:);Psik(1,:)])
title('angle');
legend('\theta roll','\phi pitch','\psi yaw')
hold off
j=j+1;

figure(j)
hold on
grid on
plot(time',[ux;uy;upsi])
title('\tau');
legend('\tau_\theta','\tau_\phi','\tau_\psi')
hold off
j=j+1;

figure(j)
hold on
grid on
plot(time',uz)
title('F');
hold off
j=j+1;
% 
figure(j)
hold on
grid on
plot(time',Xk)
title('X');
legend('\xi1','d\xi1','\theta','d\theta')
hold off
% 
j=j+1;
figure(j)
hold on
grid on
plot(time',Yk)
legend('\xi2', 'd\xi2', '\phi', 'd\phi')
title('Y');
hold off

j=j+1;
figure(j)
hold on
grid on
plot(time',Zk)
legend('\xi3','d\xi3')
title('Z');
hold off

j=j+1;
figure(j)
hold on
grid on
plot(time',Psik)
legend('\psi','d\psi')
title('\Psi');
hold off

j=j+1;
figure(j)
hold on
grid on
plot(time(1,1:end-1),U)
title('U');
legend('1','2','3','4')
hold off

%%

% eAx = exp(Ax*dt);
%  inAx = inv(Ax);
%  I4 = eye(4);
%  intx = inAx*(eAx - I4)*Bx;
% 
%  eAy = exp(Ay*dt);
%  inAy = int(Ay);
%  inty = inAy*(eAy - I4)*By;
%  
%  eAz = exp(Az*dt);
%  inAz = int(Az);
%  I2 = eye(2);
%  intz = inAz*(eAz - I2)*Bz;
%  
%  eApsi = exp(Apsi*dt);
%  inApsi = int(Apsi);
%  I2 = diag([1,1]);
%  intpsi = inApsi*(eApsi - I2)*Bpsi;
%         X = eAx*X +intx*ux(i);
%         Y = eAy*Y +inty*uy(i);
%         Z = eAz*Z +intz*uz(i);
%         Psi = eApsi*Psi +intpsi*upsi(i);
%%
B1 = [diag([1E-5,1E-5,1E-5,1E-3,1E-3,1E-3]);...
                                        diag([1E-1,1E-1,1E-1,1E-1,1E-1,1E-1])]; 
Q1=diag([1E3,1E3,1E3,1E5,1E5,1E5]);
V=B1*Q1*B1'

B=[eye(6)*0.01;eye(6)*0.1];
Q=pinv(B,1e-9)*V*pinv(B',1e-9)
% Q =1e0* diag([1E-5,1E-5,1E-5,1E5,1E5,1E5]);
V2=B*Q*B';
V-V2
%%
syms x [6,6]
f = V - B*x*B' ;
 [x, fval] = fmincon(f, ones(12));
% S = solve(eqn,x)