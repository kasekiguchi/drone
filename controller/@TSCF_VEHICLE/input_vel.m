function v = input_vel(obj,p,th,pr,thr,V,Vr,K,dt)
if abs(V) < 0.01
    v(2,1) = K(2)*Vr; % -K(2)*(V-Vr)
else
    v(2,1) = - K(2)*(V - (V*Vr*cos(th)*cos(thr) + V*Vr*sin(th)*sin(thr))/V) - (K(1)*(V*cos(th)*(p(1) - pr(1)) + V*sin(th)*(p(2) - pr(2))))/V;
end
v(1,1) = V + v(2,1)*dt;
end
