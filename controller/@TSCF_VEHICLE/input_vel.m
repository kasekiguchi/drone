function v = input_vel(obj,p,th,pr,thr,V,Vr,F1,F2,dt)
% if abs(V) < 0.01
%     v(2,1) = K(2)*Vr; % -K(2)*(V-Vr)
% else
%     v(2,1) = - K(2)*(V - (V*Vr*cos(th)*cos(thr) + V*Vr*sin(th)*sin(thr))/V) - (K(1)*(V*cos(th)*(p(1) - pr(1)) + V*sin(th)*(p(2) - pr(2))))/V;
% end
%v(1,1) = V + v(2,1)*dt;
%
p1 = p(1);
p2 = p(2);
pr1 = pr(1);
pr2 = pr(2);
v(1,1) = (2*Vr*sin(th - thr) + F1(1)*p2*cos(th - 2*thr) + F2(1)*p1*cos(th - 2*thr) - F1(1)*pr2*cos(th - 2*thr) - F2(1)*pr1*cos(th - 2*thr) + F1(1)*p1*sin(th - 2*thr) - F2(1)*p2*sin(th - 2*thr) - F1(1)*pr1*sin(th - 2*thr) + F2(1)*pr2*sin(th - 2*thr) + F1(1)*p2*cos(th) - F2(1)*p1*cos(th) - F1(1)*pr2*cos(th) + F2(1)*pr1*cos(th) - F1(1)*p1*sin(th) - F2(1)*p2*sin(th) + F1(1)*pr1*sin(th) + F2(1)*pr2*sin(th))/(2*p1*cos(th) - 2*pr1*cos(th) + 2*p2*sin(th) - 2*pr2*sin(th));
end
