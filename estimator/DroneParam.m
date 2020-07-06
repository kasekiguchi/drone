function  [observe_fun,dobserve_fun,ProbabilityDensityFunction,EstParam] = DroneParam(param)
    EstParam.sigmaw      = param.sigmaw;
    EstParam.sigmav      = [8.0E-6;8.0E-6;8.0E-6;1.0E-6;1.0E-6;1.0E-6];     % �V�X�e���m�C�Y�̕��U�x�N�g��
    EstParam.Q           = eye(6).*EstParam.sigmav;                         % �V�X�e���m�C�Y�̋����U�s��
    EstParam.Ri          = eye(3).*EstParam.sigmaw;                         % 1�̓����_�̊ϑ��m�C�Y�̋����U�s��
    EstParam.InvRi       = inv(EstParam.Ri);                                % 1�̓����_�̊ϑ��m�C�Y�̋����U�s��̋t�s��
    EstParam.R           = [];                                              % �Ώۂ̑S�����_�̊ϑ��m�C�Y�̋����U�s��
    EstParam.PD          = 0.8;                                             % �^�[�Q�b�g���o�m��
    EstParam.PG          = 0.8;                                             % �Q�[�g�m��
    EstParam.lambda      = 1;                                               % �|�A�\�����z���Ғl
    EstParam.gamma       = 1.0E0;                                           % �L���̈�
    EstParam.SNR         = 1.0E-5;                                          % ����덷�����U�s��̏����l
    EstParam.P           = eye(12)*EstParam.SNR;
    
    %%
        %%% Symboric %%%
    syms h Dt real
    X_sym = sym('X_sym', [12,1]);
    mx    = sym('mx',    [3,1]);   
    OFfile="output_function_for_marker_position";                 % ���f���̊g�����`��
    if exist(OFfile,"file")
        observe_fun = str2func(OFfile);
        dobserve_fun = str2func(strcat("Jacobian_",OFfile));
    else
        % ��]�s��
        Rotation_sym    = [cos(X_sym(6)),-sin(X_sym(6)),0;sin(X_sym(6)),cos(X_sym(6)),0;0,0,1]*...
            [cos(X_sym(5)),0,sin(X_sym(5));0,1,0;-sin(X_sym(5)),0,cos(X_sym(5))]*...
            [1,0,0;0,cos(X_sym(4)),-sin(X_sym(4));0,sin(X_sym(4)),cos(X_sym(4))];
        % 1�̓����_�̊ϑ�������(���{�b�g���W�n�̓����_�ʒu�ƃO���[�o�����W�n�̓����_�ʒu�̓����ϊ��s��)
        obsmodel_sub     = Rotation_sym * mx + X_sym(1:3);
        observe_fun  =matlabFunction(obsmodel_sub,'File',"estimator/ExtendedLinearization/output_function_for_marker_position.m",'Vars',{X_sym,mx},'Comments',"�yInputs�z\n\t pos ([1;1;1]): position of COG of the rigid body\n\t mx (=[1 2 3;1 1 1]): marker position w. r. t. pos");
        % �ϑ��������̊g�����`��
        dhi_sub          = pdiff(obsmodel_sub,X_sym);
        dobserve_fun     = matlabFunction(dhi_sub,'File',"estimator/ExtendedLinearization/Jacobian_output_function_for_marker_position.m",'Vars',{X_sym,mx});
    end
    % �m�����x�֐�
    Z          = sym('Z',    [1, 3]);                                       % �ϑ��l�̃V���{���b�N
    hatZ       = sym('hatZ', [1, 3]);                                       % �ϑ��\���l�̃V���{���b�N
    Cov        = sym('Cov',  [3, 3]);                                       % �덷�����U�s��̃V���{���b�N
    PDfunction = 1 / sqrt((2 * pi())^3* det(Cov)) * exp(-1/2 * (Z - hatZ) / (Cov) * (Z - hatZ)');
    ProbabilityDensityFunction = matlabFunction(PDfunction,'Vars',{Z,hatZ,Cov});

end
