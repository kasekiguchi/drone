function ref = bezier_curve4(X0,te)
%%cp1,cp2,cp3 can be changed 
syms t real

P0 = X0;        % start point
P1 = X0 * 0.3;   % 
P2 = X0 * 0.2;    % 
P3 = X0 * 0.1;    % 
P4 = [0, 0, 0];   % 目标点    % control point1 z hovering  move in x y)
% P2 = [0.1, 0.1, 0.1];     % control point2 (slow down)
% P3 = [0.0, 0.0, 0.0];     % control point3 (speed down)
% P4 = [0,0,0];     %  end point
%if te.catchflag 
%T_total = te.catchtime;
%else
T_total = te.te-te.t;  % total time 
%end
dt=te.dt;       % sample period
N = round(T_total/dt);

ref = zeros(N,4);
% real time% dt=T/N

%tau = zeros(size(t));

% if t < 1
%     t = (t/T_total);  % time function for p1
% elseif t < 8
%     t = 0.1 + 0.7 * (t - 1) / 7;  %time fimction for p2
% else
%     t = 0.8 + 0.2 * (t - 8) / 2; %time function for p3
% end

tt = t-te.t;
tau=tt/T_total;
% bezier_curve4
% reftemp= ((1 - tau)^4 * P0 + 4 * (1 - tau)^3 * tau * P1 + 6 * (1 - tau)^2 * tau^2 * P2 + 4 * (1 - tau) * tau^3 * P3 + tau^4 * P4)';
% 
% x = reftemp(1);
% y = reftemp(2);
% z = reftemp(3);
Bx = (1 - tau)^4 * P0(1) + 4 * (1 - tau)^3 * tau * P1(1) + ...
     6 * (1 - tau)^2 * tau^2 * P2(1) + 4 * (1 - tau) * tau^3 * P3(1) + tau^4 * P4(1);

By =  (1 - tau)^4 * P0(2) + 4 * (1 - tau)^3 * tau * P1(2) + ...
     6 * (1 - tau)^2 * tau^2 * P2(2) + 4 * (1 - tau) * tau^3 * P3(2) + tau^4 * P4(2);

Bz =  (1 - tau)^4 * P0(3) + 4 * (1 - tau)^3 * tau * P1(3) + ...
     6 * (1 - tau)^2 * tau^2 * P2(3) + 4 * (1 - tau) * tau^3 * P3(3) + tau^4 * P4(3);

%ref = @(t)[double(subs(Bx, t, t)); double(subs(By, t, t)); double(subs(Bz, t, t)); 0];
ref = @(t)[Bx;By;Bz;0];
% v
%dt = T_total / (N - 1);
%V = diff(B) / dt;
%ref =[B, zeros(size(B,1), 1)];

end

% figure;
% plot3(B(:,1), B(:,2), B(:,3), 'b-', 'LineWidth', 2); hold on;
% plot3(P0(1), P0(2), P0(3), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
% plot3(P1(1), P1(2), P1(3), 'go', 'MarkerSize', 10, 'LineWidth', 2);
% plot3(P2(1), P2(2), P2(3), 'mo', 'MarkerSize', 10, 'LineWidth', 2);
% plot3(P3(1), P3(2), P3(3), 'co', 'MarkerSize', 10, 'LineWidth', 2);
% plot3(P4(1), P4(2), P4(3), 'ko', 'MarkerSize', 10, 'LineWidth', 2);
% grid on; xlabel('X'); ylabel('Y'); zlabel('Z');
% title('trajectory designed by bezier_curver4');
% legend('trajectory', 'start', 'cp1', 'cp2', 'cp3', 'end');
% axis equal;
% 
% figure;
% plot(t, B(:,3), 'b-', 'LineWidth', 2);
% xlabel('time t'); ylabel('height Z');
% title('Z-t');
% grid on;
% 
% 
% figure;
% plot(t(2:end), V_mag, 'r', 'LineWidth', 2);
% xlabel('time t'); ylabel(' |V|');
% title('v-t');
% grid on;