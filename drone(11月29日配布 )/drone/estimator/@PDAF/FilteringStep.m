function [param] = FilteringStep(obj,param)
    % Update the state using the observation values existing in the validation region
    %【Input】 obj   : object of PDAF
    %          param : Structure of PDAF
    %【Output】param : Structure of PDAF
    
    Vi            = cell(1,obj.param.on_feature_num);                       % Initialize innovation for one feature point of interest
    VSumVector    = zeros(3*obj.param.on_feature_num,1);                    % Initialization of weighted innovation for all feature points of interest
    for k = 1:obj.param.on_feature_num
        VProb = zeros(3,param.ValidationNum(1,k));
        for s = 1:param.ValidationNum(1,k)
            Vi{1,k}(:,s) = param.ValidatedObservation{1,k}(s,:)' - param.Mhatbar(k,:)'; % Error in Euclidean distance between observed and predicted values(innovation)
            VProb(:,s)  = param.p{1,k}(s) * Vi{1,k}(:,s);                               % Weighted innovation
        end
        VSumVector(3*(k-1)+1:3*k,1) = sum(VProb,2);                         % Vector of weighted innovation for all feature points of interest
    end
    VSumPowMatrix = zeros(3 * obj.param.on_feature_num,3 * obj.param.on_feature_num);
    for s = 2:param.MaxNum
        ViPowVector   = zeros(3 * obj.param.on_feature_num,1);              % Initialize vector summarizing innovation
        PVector       = zeros(3 * obj.param.on_feature_num,1);              % Initialization of vector summarizing weighting factors
        for k = 1:obj.param.on_feature_num
            if s <= param.ValidationNum(1,k)
                ViPowVector(3*(k-1)+1:3*k,:)  = Vi{1,k}(:,s);               % Vector summarizing innovation
                PVector(3*(k-1)+1:3*k,:)      = param.p{1,k}(s);            % Vector summarizing weighting factors
            end
        end
        ViPowMatrix    = (sqrt(PVector) .* ViPowVector) * (sqrt(PVector) .* ViPowVector)'; % Squared weighted innovation
        VSumPowMatrix  = VSumPowMatrix + ViPowMatrix;                                      % Sum of squared weighted innovations
    end
    
    %%% Considering occlusion %%%
    % Delete the vector and matrix corresponding to the feature point of the occlusion target and change the size
    dhPDA       = cell2mat(param.dh');
    deletecount = 0;
    for s = 1:obj.param.on_feature_num
        if param.p{1,s}(1) == 1.0
            del1 = 3*(s-1)+1 - 3*deletecount;
            del2 = 3*s       - 3*deletecount;
            VSumVector(del1:del2,:)     = [];
            VSumPowMatrix(del1:del2 ,:) = [];
            VSumPowMatrix(:,del1:del2 ) = [];
            dhPDA(del1:del2 ,:)         = [];
            param.S(del1:del2 ,:)     = [];
            param.S(:,del1:del2 )     = [];
            deletecount = deletecount + 1;
        end
    end
    
    %%% State update %%%
    K  = param.Pbar * dhPDA'/ param.S;                                      % Kalman gain
    param.Xh = param.Xhbar + K * VSumVector;                                % Posterior estimation
    
    %%% Update posterior error covariance matrix %%%
    VMatrixError       = VSumPowMatrix - VSumVector * VSumVector';
    Pch                = K * VMatrixError * K';
    [sizePch,~]        = size(Pch);
    [eigvector,eigsub] = eig(Pch);
    eigenvalue         = real(eigsub);
    offset             = eigenvalue(1,1);
    for i = 2:sizePch
        if offset > eigenvalue(i,i)
           offset = eigenvalue(i,i);
        end
    end
    if offset < 0
        for i = 1:sizePch
            eigenvalue(i,i) = eigenvalue(i,i) + abs(offset*1.001);
        end
        Pch = real(eigvector*eigenvalue/eigvector);
    end
    param.P = param.Pbar - K * param.S * K' + Pch;
    for k = 1:obj.param.on_feature_num
        param.p{1,k}(1) = 0;
    end
end
