function Param = getParameter(varargin)
% class化したほうが良い．
% M, L, J x3, g, km x4, k x4
%mass = 0.266;
mass = 0.269;% DIATONE
Length = 0.1;% モーター間の距離：正方形を仮定している
Lx = 0.1;
Ly = 0.1;
lx = 0.05;
ly = 0.05;
% Length = 0.075;% モーター間の距離：正方形を仮定している
% Lx = 0.075;
% Ly = 0.075;
% lx = Lx/2;
% ly = Ly/2;
jx = 0.002237568;
jy = 0.002985236;
jz = 0.00480374;
gravity = 9.81;
km1 = 0.03010685884691849; % ロータ定数
km2 = 0.03010685884691849; % ロータ定数
km3 = 0.03010685884691849; % ロータ定数
km4 = 0.03010685884691849; % ロータ定数
k1 = 0.000008048;          % 推力定数
k2 = 0.000008048;          % 推力定数
k3 = 0.000008048;          % 推力定数
k4 = 0.000008048;          % 推力定数
% T = k*w^2  
% T : thrust , w : angular velocity of rotor
% M = km * T = km* k * w^2
% M : zb moment  ：そのため普通の意味でのロータ定数とは違う
param.mass = mass;%[mass, Length, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4];
%param.Length = Length;
param.Lx = Lx;
param.Ly = Ly;
param.lx = lx;
param.ly = ly;
param.jx = jx;
param.jy = jy;
param.jz = jz;
param.gravity = gravity;
param.km1 = km1;
param.km2 = km2;
param.km3 = km3;
param.km4 = km4;
param.k1 = k1;
param.k2 = k2;
param.k3 = k3;
param.k4 = k4;
if size(varargin) >= 1
    if strcmp(varargin{1},'Plant')% for Plant parameter
%        Param= [mass, Length, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4];
%        Param= [mass, Length,Lx,Ly,lx,ly, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4];
        Param= [mass,Lx,Ly,lx,ly, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4];
%         Param = cell2mat(struct2cell(param))';
    else
        F = varargin{1};
        Param = zeros(1,length([F]));
        for i = 1:length(F)
            Param(i) = param.(F{i});
        end
    end
else
    Param = cell2mat(struct2cell(param))';
end

% if size(varargin) >= 1
%s     if contains(varargin,'m')
%         mass = varargin.m;
%         Length = varargin.l;
%         jx = varargin.jx;
%         jy = varargin.jy;
%         jz = varargin.jz;
%         km1 = varargin.km1;
%         km2 = varargin.km2;
%         km3 = varargin.km3;
%         km4 = varargin.km4;
%         k1 = varargin.k1;
%         k2 = varargin.k2;
%         k3 = varargin.k3;
%         k4 = varargin.k4;
%         param= [mass, Length, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4];
%     else
%         param = varargin;
%     end
% end
end

