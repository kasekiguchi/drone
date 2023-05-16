function [param] = FilteringStep(obj,param)
    % Update the state using the observation values existing in the validation region
    %【Input】 obj   : object of PDAF
    %          param : Structure of PDAF
    %【Output】param : Structure of PDAF
    
    % Observation vector against all object features
    ObservationVector = reshape(param.AssociatedObservation',[3*obj.param.on_feature_num,1]);
    MhatbarVector     = reshape(param.Mhatbar',[3*obj.param.on_feature_num,1]);
    InnovationVector  = ObservationVector - MhatbarVector;
    
    %%% Considering occlusion %%%
    % Delete the vector and matrix corresponding to the feature point of the occlusion target and change the size
    dhEKF       = cell2mat(param.dh');
    deletecount = 0;
    for s = 1:obj.param.on_feature_num
        if param.OcclusionDetermineFlag(s,1) == 0.0
            del1 = 3*(s-1)+1 - 3*deletecount;
            del2 = 3*s       - 3*deletecount;
            InnovationVector(del1:del2,:) = [];
            dhEKF(del1:del2 ,:)            = [];
            param.S(del1:del2 ,:)          = [];
            param.S(:,del1:del2 )          = [];
            deletecount = deletecount + 1;
        end
    end
    
    %%% State update %%%
    K  = param.Pbar * dhEKF'/ param.S;                                      % Kalman gain
    param.Xh = param.Xhbar + K * InnovationVector;                        % Posterior estimation
    param.P = param.Pbar - K * param.S * K';                                % Posterior error covariance matrix 

end
