%% Initialize settings
% set path
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
[~,tmp]=regexp(genpath('.'),'\.\\\.git.*?;','match','split');
cellfun(@(xx) addpath(xx),tmp,'UniformOutput',false);
close all hidden; clear all; clc;
userpath('clear');
%%
clc
clear all
[X,Y] = meshgrid(-1:0.1:4,0:0.1:10);
%% スロープ
Fs = cell(3,1);
Rs = cell(3,1);
[Fs{1},Rs{1}] = slope([0,1],10,1,0.1,[0,0,1]);
[Fs{2},Rs{2}] = slope([1,0],4.1,1,-0.1,[-.5,7,0.35]);
[Fs{3},Rs{3}] = slope([0,1],7.5,1,0.1,[3,0,1.5]);
Zt1=plot_potential(Fs{1},Rs{1},X,Y);Zt1(Zt1==0)=100;
Zt2=plot_potential(Fs{2},Rs{2},X,Y);Zt2(Zt2==0)=100;Zt2=min(Zt1,Zt2);
Zt1= plot_potential(Fs{3},Rs{3},X,Y);Zt1(Zt1==0)=100;Z=min(Zt1,Zt2);
Z(Z>=100)=-0.1;
h = surf(X,Y,Z);
%zlim([0.01,10]);
zlim([0,2]);
grid on
daspect([1 1 1])
%view(0,0)
%% 壁
%vertices = [-0.5,0;.5,0;.5,6.5;2.5,6.5;2.5,0;3.5,0;3.5,7.5;.5,7.5;.5,10;-0.5,10;-0.5,0];
%vertices = [-0.5,0;-0.5,10;.5,10;.5,7.5;3.5,7.5;3.5,0;2.5,0;2.5,6.5;.5,6.5;.5,0;-0.5,0];
%vertices = [-0.5,0;-0.5,10;.5,10;.5,7.5;3.5,7.5;3.5,0;2.5,0;2.5,6.5;.5,6.5;.5,0;-0.5,0];
vertices = [-.5,0;-2,0;-2,10;-.5,10;-.5,0;NaN,NaN;.5,0;.5,6.5;2.5,6.5;2.5,0;.5,0;NaN,NaN;3.5,0;3.5,7.5;.5,7.5;.5,10;5,10;5,0;3.5,0];
%vertices= [-.5,0;-2,0;-2,10;-.5,10;-.5,0];
env = polyshape(vertices);
plot(env)
%wall_edge_id = [2,3,4,6,7,8,10];
%wall_edge_id = [1,3,4,5,7,8,9];
wall_edge_id = [1,2,3,4,7,8,9,10,13,14,15,16,17,18];
%wall_edge_id = [1,2,3,4];
%Z = 0*X;
Fw=cell(length(wall_edge_id),1);
Rw=cell(length(wall_edge_id),1);
for i = wall_edge_id
    [Fw{i},Rw{i}] = wall_potential(vertices(i,:),vertices(i+1,:),0.2);
    Z=Z + plot_potential(Fw{i},Rw{i},X,Y);
end
h = surf(X,Y,Z);
%zlim([0.01,10]);
zlim([0,2]);
grid on
daspect([1 1 1])

%% local functions 
function Z=plot_potential(F,R,X,Y)
    S = polyshape(R(:,1:2));
    x = reshape(X,[prod(size(X)),1]);
    y = reshape(Y,[prod(size(Y)),1]);
    In = reshape(isinterior(S,x,y),size(X));
    Z = In.*F(X,Y);
end

function [fun,reg] = wall_potential(varargin)
    % p1 = arg1 , p2 = arg2 : wall edge
    % path area is the left of line p1 to p2
    % arg3 : optional : potential width 
    if (nargin==2)
        [fun,reg]=wall_potential_org(varargin{1},varargin{2},0.5);
    else
        [fun,reg]=wall_potential_org(varargin{1},varargin{2},varargin{3});
    end
end
function [fun,reg] = wall_potential_org(p1,p2,d)
    t0 = p2(:)-p1(:);
    n0 = norm(t0);
    t = cross([0;0;1],[t0;0]);
    a=d*t(1:2)/norm(t(1:2));
    reg = [p1(:),p2(:),p2(:)+a,p1(:)+a]';
%    h = 1.1;% tan(h) : potential value at the wall 
%    fun = @(x,y) tan(h-h*(t0(1)*(y-p1(2))-t0(2)*(x-p1(1)))/(d*n0));% 
    fun = @(x,y) 10./(1+exp(-10*((1 - (t0(1)*(y-p1(2))-t0(2)*(x-p1(1)))/(d*n0))-1)));
    % matrix 入力に対応するよう外積計算をべた書きしている．
    % 外積結果の長さは２本のベクトルの平行四辺形の面積になるので，n0で割ることで壁からの距離が出る
end

function [fun,reg] = slope(dir,L,w,th,offset)
    % dir : direction in R^2 
    % L : slope length
    % w : slope width
    % th : slope angle
    % reg : slope points
    points = [0,-w/2,0;L,-w/2,0;L,w/2,0;0,w/2,0];
    ang = atan2(dir(2),dir(1));
    R = axang2rotm([0 0 1 ang])*axang2rotm([0 1 0 th]);
    reg=points*R'+offset;
    Mattt = [reg(1:3,1),reg(1:3,2),ones(3,1)];
    coef=Mattt\reg(1:3,3);
    fun = @(x,y) coef(1)*x+coef(2)*y+coef(3);
    %[X,Y] = meshgrid(ret(:,1),ret(:,2));
    %@(x) ang*x+offset;
    
end
