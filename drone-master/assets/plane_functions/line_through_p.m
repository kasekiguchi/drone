function l = line_through_p(p,e)
% p : point 3x1
% e : direction : unit vector 3x1
% l : pl = (a,b,c,d), e = e
p = p(:);
e = e(:);
t = cross(p,e);
d = vecnorm(t);
if d == 0
    if e(1)
        t = [0;0;1] - e(3)*e;
        perp = t/vecnorm(t);
    else       
        perp = [1;0;0];
    end  
else
    t = t/vecnorm(t);
    perp = cross(e,t);
end
l.pl = [perp;-perp'*p];
l.e = e;
end