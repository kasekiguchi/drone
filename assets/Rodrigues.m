function R= Rodrigues(u,varargin)
    % �yInput�zu, th
    % u : unit vector,  th : angle (rad)
    % th =[] �̂Ƃ��� u�̒�������]�p�ƂȂ�   th = norm(u);
    if isempty(varargin)
        th = norm(u);
        u = u/th;
    else
        u = u(:)/norm(u); % �P�ʏc�x�N�g���ɕϊ�
        th = varargin;
    end
    R = u*u'+cos(th)*(eye(3)-u*u')+sin(th)*Skew(u);
end
