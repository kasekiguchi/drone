function  [observe_fun,dobserve_fun,ProbabilityDensityFunction,EstParam] = DroneParam(param)
    EstParam.sigmaw      = param.sigmaw;
    EstParam.sigmav      = [8.0E-6;8.0E-6;8.0E-6;1.0E-6;1.0E-6;1.0E-6];     % VXemCYÌªUxNg
    EstParam.Q           = eye(6).*EstParam.sigmav;                         % VXemCYÌ¤ªUsñ
    EstParam.Ri          = eye(3).*EstParam.sigmaw;                         % 1ÂÌÁ¥_ÌÏªmCYÌ¤ªUsñ
    EstParam.InvRi       = inv(EstParam.Ri);                                % 1ÂÌÁ¥_ÌÏªmCYÌ¤ªUsñÌtsñ
    EstParam.R           = [];                                              % ÎÛÌSÁ¥_ÌÏªmCYÌ¤ªUsñ
    EstParam.PD          = 0.8;                                             % ^[Qbgom¦
    EstParam.PG          = 0.8;                                             % Q[gm¦
    EstParam.lambda      = 1;                                               % |A\ªzúÒl
    EstParam.gamma       = 1.0E0;                                           % LøÌæ
    EstParam.SNR         = 1.0E-5;                                          % ãë·¤ªUsñÌúl
    EstParam.P           = eye(12)*EstParam.SNR;
    
    %%
        %%% Symboric %%%
    syms h Dt real
    X_sym = sym('X_sym', [12,1]);
    mx    = sym('mx',    [3,1]);   
    OFfile="output_function_for_marker_position";                 % fÌg£ü`»
    if exist(OFfile,"file")
        observe_fun = str2func(OFfile);
        dobserve_fun = str2func(strcat("Jacobian_",OFfile));
    else
        % ñ]sñ
        Rotation_sym    = [cos(X_sym(6)),-sin(X_sym(6)),0;sin(X_sym(6)),cos(X_sym(6)),0;0,0,1]*...
            [cos(X_sym(5)),0,sin(X_sym(5));0,1,0;-sin(X_sym(5)),0,cos(X_sym(5))]*...
            [1,0,0;0,cos(X_sym(4)),-sin(X_sym(4));0,sin(X_sym(4)),cos(X_sym(4))];
        % 1ÂÌÁ¥_ÌÏªûö®({bgÀWnÌÁ¥_ÊuÆO[oÀWnÌÁ¥_ÊuÌ¯Ï·sñ)
        obsmodel_sub     = Rotation_sym * mx + X_sym(1:3);
        observe_fun  =matlabFunction(obsmodel_sub,'File',"estimator/ExtendedLinearization/output_function_for_marker_position.m",'Vars',{X_sym,mx},'Comments',"yInputsz\n\t pos ([1;1;1]): position of COG of the rigid body\n\t mx (=[1 2 3;1 1 1]): marker position w. r. t. pos");
        % Ïªûö®Ìg£ü`»
        dhi_sub          = pdiff(obsmodel_sub,X_sym);
        dobserve_fun     = matlabFunction(dhi_sub,'File',"estimator/ExtendedLinearization/Jacobian_output_function_for_marker_position.m",'Vars',{X_sym,mx});
    end
    % m¦§xÖ
    Z          = sym('Z',    [1, 3]);                                       % ÏªlÌV{bN
    hatZ       = sym('hatZ', [1, 3]);                                       % Ïª\ªlÌV{bN
    Cov        = sym('Cov',  [3, 3]);                                       % ë·¤ªUsñÌV{bN
    PDfunction = 1 / sqrt((2 * pi())^3* det(Cov)) * exp(-1/2 * (Z - hatZ) / (Cov) * (Z - hatZ)');
    ProbabilityDensityFunction = matlabFunction(PDfunction,'Vars',{Z,hatZ,Cov});

end
