function R= Rodrigues(u,varargin)
    % yInputzu, th
    % u : unit vector,  th : angle (rad)
    % th =[] ‚Ì‚Æ‚«‚Í u‚Ì’·‚³‚ª‰ñ“]Šp‚Æ‚È‚é   th = norm(u);
    if isempty(varargin)
        th = norm(u);
        u = u/th;
    else
        u = u(:)/norm(u); % ’PˆÊcƒxƒNƒgƒ‹‚É•ÏŠ·
        th = varargin;
    end
    R = u*u'+cos(th)*(eye(3)-u*u')+sin(th)*Skew(u);
end
