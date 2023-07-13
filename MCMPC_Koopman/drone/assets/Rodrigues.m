function R= Rodrigues(u,varargin)
    % 【Input】u, th
    % u : unit vector,  th : angle (rad)
    % th =[] のときは uの長さが回転角となる   th = norm(u);
    u = u(:);
    if isempty(varargin)
        th = norm(u);
        u = u/th;
    else
        u = u(:)/norm(u); % 単位縦ベクトルに変換
        th = varargin{1};
    end
    R = u*u'+cos(th)*(eye(3)-u*u')+sin(th)*Skew(u);
end
