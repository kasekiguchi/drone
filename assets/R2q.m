function q=R2q(R)
% convert rotation matrix to quaternion
% 【Input】 R : rotation matrix
% 【Output】q : quaternion
%   R2q is equal to "rotm2quat" but faster than it.

%     if size(R)~=[3,3]
%         R=v2R(R);
%     end
% %    q=sign*sqrt([(1+tr(R))/4,(1+2*R(1,1)-tr(R))/4,(1+2*R(2,2)-tr(R))/4,(1+2*R(3,3)-tr(R))/4])';
%     th = acos((sum(diag(R))-1)/2); % sum(diag(R)) = tr(R)
%     if th == 0
%         su = zeros(3,3);
%     else
%         su = (R-R')/(2*sin(th));
%     end
%     q = [cos(th/2);iSkew(su)*sin(th/2)];
w = sqrt(R(1,1)+R(2,2)+R(3,3)+1)/2;
xp = sqrt(R(1,1)-R(2,2)-R(3,3)+1)/2;
yp = sqrt(-R(1,1)+R(2,2)-R(3,3)+1)/2;
zp = sqrt(-R(1,1)-R(2,2)+R(3,3)+1)/2;
[Ele,Id]=max([w,xp,yp,zp]); % max element
Ele = 4*Ele;
switch Id
    case 1
        q = [w;(R(3,2)-R(2,3))/Ele;(R(1,3)-R(3,1))/Ele;(R(2,1)-R(1,2))/Ele];
    case 2
        q = [(R(3,2)-R(2,3))/Ele;xp;(R(1,2)+R(2,1))/Ele;(R(3,1)+R(1,3))/Ele];
    case 3
        q = [(R(1,3)-R(3,1))/Ele;(R(1,2)+R(2,1))/Ele;yp;(R(2,3)+R(3,2))/Ele];
    case 4
        q = [(R(2,1)-R(1,2))/Ele;(R(3,1)+R(1,3))/Ele;(R(2,3)+R(3,2))/Ele;zp];
  otherwise
    q = [1;0;0;0];
end

end
% function o= iSkew(Om)
% tmpOm=(Om-Om')/2;
% o=[-tmpOm(2,3),tmpOm(1,3),-tmpOm(1,2)]';
% end
