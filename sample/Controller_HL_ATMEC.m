function Controller=Controller_HL_ATMEC(dt)
%% controller class demo (1) : construct
% controller property ��Controller class�̃C���X�^���X�z��Ƃ��Ē�`
Controller_param.P=getParameter();

% HL_Controller
% %��ʌ덷��
% Controller_param.F1=lqrd([0 1;0 0],[0;1],diag([10,1]),[1],dt);                                % z 
% Controller_param.F2=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([1000,10,10,1]),[1],dt); % xdiag([100,10,10,1])
% Controller_param.F3=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([1000,10,10,1]),[1],dt); % ydiag([100,10,10,1])
% Controller_param.F4=lqrd([0 1;0 0],[0;1],diag([100,1]),[1],dt);                       % ���[�p 
%��ʌ덷��
Controller_param.F1=lqr([0 1;0 0],[0;1],diag([1,1]),[1]);
Controller_param.F2=lqr([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,10,10,1]),[0.1]);
Controller_param.F3=lqr([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,10,10,1]),[0.1]);
Controller_param.F4=lqr([0 1;0 0],[0;1],diag([1,1]),[1]);

Controller_param.dt = dt;
 eig(diag([1,1,1],1)-[0;0;0;1]*Controller_param.F2)
 
Controller.type="HLController_ATMEC";
Controller.name="hlcontrollerATMEC";


%% �T�u�V�X�e�����f��
Controller_param.A2 = [0 1;0 0];
Controller_param.B2 = [0;1];
Controller_param.A4 =diag([1 1 1],1);
Controller_param.B4 = [0;0;0;1];

%���f���𗣎U�� x[i+1] = Ad*x[i] + Bd*u[i]
sys = ss(Controller_param.A2,Controller_param.B2,zeros(2),[0;0]);
d2 = c2d(sys,dt);
Controller_param.A2d = d2.A;
Controller_param.B2d = d2.B;
sys = ss(Controller_param.A4,Controller_param.B4,zeros(4),[0;0;0;0]);
d4 = c2d(sys,dt);
Controller_param.A4d = d4.A;
Controller_param.B4d = d4.B;

% c2d���g��Ȃ�1�K�����܂ł̋ߎ��v�Z��
% A2d = eye(2)+obj.A2*dt;
% B2d = dt*obj.B2;
% A4d = eye(4)+obj.A4*dt;
% B4d = dt*obj.B4;

%% MEC_param.
Kz = [200 50];
% Kz = [100,0];
% % Kz = [65.5882 61.2427];
Kx = [50, 0 ,0, 0];
Ky = [50, 0, 0, 0];

%w/o MEC
% Kz = [0 0];
% Kx = [0 0 0 0];
% Ky = [0 0 0 0];
 
Controller_param.K = [Kz Kx Ky];

%% RLS_param.
%����J�n����
Controller_param.FRIT_begin = 0;
Controller_param.RLS_begin = 20;
%z
Controller_param.gamma_z = 10; %�������֌W��
% Controller_param.alpha_z = 0.01; %���[�p�X�t�B���^���x
Controller_param.alpha_z = 0; %100%�Â����ōX�V->�X�V���Ȃ�
Controller_param.lambda_z = 0.99; %�Y�p�W��
% Controller_param.lambda_z = 1;
%x
Controller_param.gamma_x = 1.0; %�������֌W��
Controller_param.alpha_x = 1.0; %���[�p�X�t�B���^���x
Controller_param.lambda_x = 0.9999; %�Y�p�W��
%y
Controller_param.gamma_y = 1.0; %�������֌W��
Controller_param.alpha_y = 1.0; %���[�p�X�t�B���^���x
Controller_param.lambda_y = 0.9999; %�Y�p�W��

%assignin('base',"Controller_param",Controller_param);

Controller.param=Controller_param;

end
