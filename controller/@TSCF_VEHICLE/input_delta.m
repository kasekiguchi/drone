function u = input_delta(obj,p,V,th,dth,pr,thr,dthr,F)
% p = [px;py;pz]
% V = [V;dV]
% pr = [prx;pry;prz]
% F = [F1 F2]
if abs(sin(thr))<0.1
    statez(1,1) = (p(2) - pr(2))/cos(thr);
else
    statez(1,1) = -(p(1) - pr(1))/sin(thr);
end
statez(2,1) = -V(1)*sin(thr-th);
u = -(V(2)*sin(th - thr) + V(1)*dth*cos(th - thr) - V(1)*dthr*cos(th - thr)) - F*statez;
if abs(u) > 1
    u = sign(u);
end

u = F(1)*vecnorm(p-pr)*(sin(thr-th)+1);
end
