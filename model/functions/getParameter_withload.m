function Param = getParameter_withload(varargin)
% class化したほうが良い．
mass = 0.2655;
Length = 0.075;% モーター間の距離：正方形を仮定している
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
loadmass = 0.0556;            % 牽引物体の重さ
L = 0.57;                   % 紐の長さ
ex = 0.0;                  % 紐の取り付け位置
ey = 0.00;                  % 紐の取り付け位置
ez = 0.045;                  % 紐の取り付け位置0.078 0.045
% T = k*w^2  
% T : thrust , w : angular velocity of rotor
% M = km * T = km* k * w^2
% M : zb moment  ：そのため普通の意味でのロータ定数とは違う
Param= [mass, Length, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4 ,loadmass, L, ex, ey, ez];
if size(varargin) >= 1
    if strcmp(varargin{1},'Plant')% for Plant parameter
        Param= [mass, Length, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4, loadmass, L, ex+0.001, ey, ez];
    end

% if size(varargin) >= 1
%     if contains(varargin,'m')
%         mass = varargin.m;
%         length = varargin.l;
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
%         param= [mass, length, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4];
%     else
%         param = varargin;
%     end
% end
end

