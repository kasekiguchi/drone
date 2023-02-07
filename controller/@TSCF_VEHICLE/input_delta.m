function u = input_delta(obj,p,Vr,th,dth,pr,thr,dthr,F1,F2)
% p = [px;py;pz]
% V = [V;dV]
% pr = [prx;pry;prz]
% F = [F1(1) F2(1)]
% if abs(sin(thr))<0.1
%     statez(1,1) = (p(2) - pr(2))/cos(thr);
% else
%     statez(1,1) = -(p(1) - pr(1))/sin(thr);
% end
% statez(2,1) = -V(1)*sin(thr-th);
% u = -(V(2)*sin(th - thr) + V(1)*dth*cos(th - thr) - V(1)*dthr*cos(th - thr)) - F*statez;
% if abs(u) > 1
%     u = sign(u);
% end

%u = F1(1)*vecnorm(p-pr)*(sin(thr-th)+1);
p1 = p(1);
p2 = p(2);
pr1 = pr(1);
pr2 = pr(2);

u = -(F1(1)*p1^2 + F1(1)*p2^2 + F1(1)*pr1^2 + F1(1)*pr2^2 - 2*Vr*p2*sin(thr) + 2*Vr*pr2*sin(thr) - 2*F1(1)*p1*pr1 - 2*F1(1)*p2*pr2 - F1(1)*p1^2*cos(2*thr) + F1(1)*p2^2*cos(2*thr) - F1(1)*pr1^2*cos(2*thr) + F1(1)*pr2^2*cos(2*thr) - F2(1)*p1^2*sin(2*thr) + F2(1)*p2^2*sin(2*thr) - F2(1)*pr1^2*sin(2*thr) + F2(1)*pr2^2*sin(2*thr) - 2*Vr*p1*cos(thr) + 2*Vr*pr1*cos(thr) + 2*F2(1)*p1*p2*cos(2*thr) + 2*F1(1)*p1*pr1*cos(2*thr) - 2*F1(1)*p2*pr2*cos(2*thr) - 2*F2(1)*p1*pr2*cos(2*thr) - 2*F2(1)*p2*pr1*cos(2*thr) + 2*F2(1)*pr1*pr2*cos(2*thr) - 2*F1(1)*p1*p2*sin(2*thr) + 2*F1(1)*p1*pr2*sin(2*thr) + 2*F1(1)*p2*pr1*sin(2*thr) + 2*F2(1)*p1*pr1*sin(2*thr) - 2*F2(1)*p2*pr2*sin(2*thr) - 2*F1(1)*pr1*pr2*sin(2*thr))/(2*p1*cos(th) - 2*pr1*cos(th) + 2*p2*sin(th) - 2*pr2*sin(th));

 if abs(u) > 1
     u = sign(u);
 end

end
