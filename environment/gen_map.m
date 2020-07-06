function [grid_density,map_max,map_min,xq,yq] = gen_map(Vertex,d,q,sigma)
% Vertex : �Ώۗ̈�
% d : �O���b�h��
% q : �d�v�x�̈ʒu [xi yi] ���c�ɕ��ׂ�
% map : ���X�P�[���}�b�v
% grid : �s��}�b�v  grid(1,1)=map(0,0),  grid(end,1)=map(map_max(1),1)
% �O���t�\������Ƃ��ɍH�v����
map_max=max(Vertex); % �̈���͂������`�̉E����W
map_min=min(Vertex); % �̈���͂������`�̍������W
[xq,yq]=meshgrid(map_min(1):d:map_max(1),map_min(2):d:map_max(2)); %
% �̈悪 (-1,-1) ����(2,1)�̏ꍇ
% xq = [-1,0,1,2;-1,0,1,2;-1,0,1,2],  yq = [-1,-1,-1,-1;0,0,0,0;1,1,1,1];
xq=xq';
yq=yq';
[row,col]=size(xq);
xv=Vertex(:,1); % �̈� ���_x���W
yv=Vertex(:,2); % �̈� ���_y���W
in= inpolygon(xq,yq,xv,yv); % map ���W���̈�Ɋ܂܂�邩�̔���  �F�̈��1 �̈�O0
%% �d�v�x
if isempty(q) % q = []  => ��l���z
    grid_density= ones(size(xq));
else
normal_k = sigma/d; % �d�ݗp���K���z��exp���̌W��  0.04
normal_mat = exp(-normal_k*((reshape(xq,[row*col,1])-q(:,1)').^2+(reshape(yq,[row*col,1])-q(:,2)').^2)); % �e�d�v�x�i��j�̊e�O���b�h�i�s�j�ւ̉e���i�l�j
normal_map = reshape(sum(normal_mat,2),[row,col]).*in; % �e�O���b�h�i�s�j�̏d�v�x���s��ɕό`�Fin�������̈�O�͂O
%grid_density = 255*normal_map/(max(normal_map,[],'all'))+1-50*(~in); % ���K����1�`256�̒l�ցD�̈�O�� -50
grid_density = 255*normal_map/(max(normal_map,[],'all'))-50*(~in); % ���K����0�`255�̒l�ցD�̈�O�� -50
end
end