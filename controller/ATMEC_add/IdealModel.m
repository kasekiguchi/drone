function result = IdealModel(A,B,state,ref,F)
%AT-MEC �⏞�Q�C���`���[�j���O��FRIT�A���S���Y���̓��͕ϊ��֐�
%   ���z���f��M���܂ތv�Z
u = F * (ref - state);
state = A * state + B * u;
% state = A*state;
result = state;
end
