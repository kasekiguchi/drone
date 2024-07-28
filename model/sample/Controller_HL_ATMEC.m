function Controller=Controller_HL_ATMEC(dt)
%% controller class demo (1) : construct
% controller property ��Controller class�̃C���X�^���X�z��Ƃ��Ē�`
%% ====HL_Controller====
% %-------------��ʌ덷��-------------
% Controller.F1=lqrd([0 1;0 0],[0;1],diag([10,1]),[1],dt);                                % z 
% Controller.F2=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([1000,10,10,1]),[1],dt); % xdiag([100,10,10,1])
% Controller.F3=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([1000,10,10,1]),[1],dt); % ydiag([100,10,10,1])
% Controller.F4=lqrd([0 1;0 0],[0;1],diag([100,1]),[1],dt);                       % ���[�p 
%-----------------��ʌ덷��------------
Controller.F1=lqr([0 1;0 0],[0;1],diag([1,1]),[1]);
Controller.F2=lqr([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,10,10,1]),[0.1]);
Controller.F3=lqr([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,10,10,1]),[0.1]);
Controller.F4=lqr([0 1;0 0],[0;1],diag([1,1]),[1]);
%------------�ŏ����Ɏg���Ă����Q�C��----------
% Controller.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),[1],dt);
% Controller.F2=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[1],dt);
% Controller.F3=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[1],dt);
% Controller.F4=lqrd([0 1;0 0],[0;1],diag([1,1]),[1],dt);

Controller.dt = dt;
 eig(diag([1,1,1],1)-[0;0;0;1]*Controller.F2)

%% ====�T�u�V�X�e�����f��====
Controller.A2 = [0 1;0 0];
Controller.B2 = [0;1];
Controller.A4 =diag([1 1 1],1);
Controller.B4 = [0;0;0;1];

%% ====MEC �⏞�Q�C��====
%-------dt = 0.1 s �����I�ɋ��߂��œK�l-------
% Kz = [450 0];
% Kx = [50 0 0 0];
% Ky = [50 0 0 0];

%---------w/o MEC--------
Kz = [0 0];
Kx = [0 0 0 0];
Ky = [0 0 0 0];
 
Controller.K = [Kz Kx Ky];

%% ====FRIT,RLS �p�����[�^�[====
%---------����, �X�V�J�n����----------
Controller.FRIT_begin = 5;%�⏞�Q�C���̐�����n�߂鎞��
Controller.RLS_begin = 10;%�⏞�Q�C���̂��X�V�n�߂鎞��
%------------------z------------------
Controller.gamma.z = 1; %�������֌W��
Controller.alpha.z = 0.01; %���[�p�X�t�B���^���x
% Controller.alpha.z = 0; %100%�Â����ōX�V->�X�V���Ȃ�
Controller.lambda.z = 0.99; %�Y�p�W��
%------------------x----------------
Controller.gamma.x = 1; %�������֌W��
Controller.alpha.x = 0.01; %���[�p�X�t�B���^���x
Controller.lambda.x = 0.99; %�Y�p�W��
%------------------y-----------------
Controller.gamma.y = 1; %�������֌W��
Controller.alpha.y = 0.01; %���[�p�X�t�B���^���x
Controller.lambda.y = 0.99; %�Y�p�W��

end
