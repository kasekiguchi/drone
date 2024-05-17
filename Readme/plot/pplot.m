function [ p ] = pplot(x,y,z)
%PPLOT Draw line as patch
% 京大丸太先生作

if nargin==2
    z=0*x;
end

x=reshape(x,[],1);
y=reshape(y,[],1);
z=reshape(z,[],1);

p=patch([x;flipud(x)],[y;flipud(y)],[z;flipud(z)],'b');%,z*ones(2*size(x,1),1),'b');

end