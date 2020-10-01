function param = getParameter(varargin)
% class�������ق����ǂ��D
mass = 0.2355;
length = 0.075;% ���[�^�[�Ԃ̋����F�����`�����肵�Ă���
jx = 0.002237568;
jy = 0.002985236;
jz = 0.00480374;
gravity = 9.81;
km1 = 0.03010685884691849; % ���[�^�萔
km2 = 0.03010685884691849; % ���[�^�萔
km3 = 0.03010685884691849; % ���[�^�萔
km4 = 0.03010685884691849; % ���[�^�萔
k1 = 0.000008048;          % ���͒萔
k2 = 0.000008048;          % ���͒萔
k3 = 0.000008048;          % ���͒萔
k4 = 0.000008048;          % ���͒萔
% T = k*w^2  
% T : thrust , w : angular velocity of rotor
% M = km * T = km* k * w^2
% M : zb moment  �F���̂��ߕ��ʂ̈Ӗ��ł̃��[�^�萔�Ƃ͈Ⴄ
param= [mass, length, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4];
if size(varargin) >= 1
    if strcmp(varargin{1},'Plant')% for Plant parameter
        param= [mass, length, jx, jy, jz, gravity, km1, km2, km3, km4, k1, k2, k3, k4];
    end
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

