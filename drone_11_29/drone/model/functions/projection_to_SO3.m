function x = projection_to_SO3(state)
% field RをSO3に射影する
    x= state;
    if isfield(state,'R')
        x.R=R2v(M2SO3(v2R(state.R)));
    else % R を持たない場合は何もしない
        disp("projection_to_SO3 does nothing.")
    end
end

%% local functions
%% SO3への射影
function R=M2SO3(M)
[U,~,V]=svd(M);
R=U*diag([1,1,det(U*V)])*V';
% detM=det(M);
% if detM==0
%     R=eye(3);
% else
%     M=M/(detM^(1/3));
%     th=real(acos((tr(M)-1)/2));
%     if th==0
%         R=eye(3);
%     else
%         u=iSkew((M-M')/(2*sin(th)));
%         hatu=Skew(u/norm(u));
%         R=eye(3)+sin(th)*hatu+(1-cos(th))*hatu*hatu;
%     end
% end
end
function o= iSkew(Om)
tmpOm=(Om-Om')/2;
o=[-tmpOm(2,3),tmpOm(1,3),-tmpOm(1,2)]';
end
