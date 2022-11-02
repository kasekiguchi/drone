function [cp,varargout] = l2pl_cross_point(l,pl)
% l : line : pl = (a,b,c,d), e : 3x1
% pl : plane (a,b,c,d)
% cp : 3x1
perpl = l.pl(1:3); % perpendicular of line
perpp = pl(1:3); % perpendicular of plane
perpp = perpp(:);
if abs(perpp'*l.e(:)) > 1e-12
    e1 = perpl - (perpl'*perpp)*perpp;
    e1 = e1/vecnorm(e1);
    e2 = cross(perpp,e1);
    tmp = [e1,e2,-l.e]\(pl(4)*perpp-l.pl(4)*perpl);
    cp = tmp(3)*l.e - l.pl(4)*perpl;
    nout = max(nargout,1) - 1;
    s = {tmp(1:2),e1,e2};
    for k = 1:nout
        varargout{k} = s{k};
    end
else % perpp and l.e are normal 
    cp = nan(3,1); % l and pl are parallel
end

end