function  [observe_fun,dobserve_fun,ProbabilityDensityFunction,EstParam] = DroneParam(param)
    EstParam.sigmaw      = param.sigmaw;
    EstParam.sigmav      = [8.0E-6;8.0E-6;8.0E-6;1.0E-6;1.0E-6;1.0E-6];     % システムノイズの分散ベクトル
    EstParam.Q           = eye(6).*EstParam.sigmav;                         % システムノイズの共分散行列
    EstParam.Ri          = eye(3).*EstParam.sigmaw;                         % 1つの特徴点の観測ノイズの共分散行列
    EstParam.InvRi       = inv(EstParam.Ri);                                % 1つの特徴点の観測ノイズの共分散行列の逆行列
    EstParam.R           = [];                                              % 対象の全特徴点の観測ノイズの共分散行列
    EstParam.PD          = 0.8;                                             % ターゲット検出確率
    EstParam.PG          = 0.8;                                             % ゲート確率
    EstParam.lambda      = 1;                                               % ポアソン分布期待値
    EstParam.gamma       = 1.0E0;                                           % 有効領域
    EstParam.SNR         = 1.0E-5;                                          % 事後誤差共分散行列の初期値
    EstParam.P           = eye(12)*EstParam.SNR;
    
    %%
        %%% Symboric %%%
    syms h Dt real
    X_sym = sym('X_sym', [12,1]);
    mx    = sym('mx',    [3,1]);   
    OFfile="output_function_for_marker_position";                 % モデルの拡張線形化
    if exist(OFfile,"file")
        observe_fun = str2func(OFfile);
        dobserve_fun = str2func(strcat("Jacobian_",OFfile));
    else
        % 回転行列
        Rotation_sym    = [cos(X_sym(6)),-sin(X_sym(6)),0;sin(X_sym(6)),cos(X_sym(6)),0;0,0,1]*...
            [cos(X_sym(5)),0,sin(X_sym(5));0,1,0;-sin(X_sym(5)),0,cos(X_sym(5))]*...
            [1,0,0;0,cos(X_sym(4)),-sin(X_sym(4));0,sin(X_sym(4)),cos(X_sym(4))];
        % 1つの特徴点の観測方程式(ロボット座標系の特徴点位置とグローバル座標系の特徴点位置の同時変換行列)
        obsmodel_sub     = Rotation_sym * mx + X_sym(1:3);
        observe_fun  =matlabFunction(obsmodel_sub,'File',"estimator/ExtendedLinearization/output_function_for_marker_position.m",'Vars',{X_sym,mx},'Comments',"【Inputs】\n\t pos ([1;1;1]): position of COG of the rigid body\n\t mx (=[1 2 3;1 1 1]): marker position w. r. t. pos");
        % 観測方程式の拡張線形化
        dhi_sub          = pdiff(obsmodel_sub,X_sym);
        dobserve_fun     = matlabFunction(dhi_sub,'File',"estimator/ExtendedLinearization/Jacobian_output_function_for_marker_position.m",'Vars',{X_sym,mx});
    end
    % 確率密度関数
    Z          = sym('Z',    [1, 3]);                                       % 観測値のシンボリック
    hatZ       = sym('hatZ', [1, 3]);                                       % 観測予測値のシンボリック
    Cov        = sym('Cov',  [3, 3]);                                       % 誤差共分散行列のシンボリック
    PDfunction = 1 / sqrt((2 * pi())^3* det(Cov)) * exp(-1/2 * (Z - hatZ) / (Cov) * (Z - hatZ)');
    ProbabilityDensityFunction = matlabFunction(PDfunction,'Vars',{Z,hatZ,Cov});

end
