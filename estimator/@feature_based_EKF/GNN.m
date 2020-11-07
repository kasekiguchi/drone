function param = GNN(obj,param)
    % Determining observations within the validation region
    %【Input】 obj   : object of EKF
    %          param : Structure of EKF
    %【Output】param : Structure of EKF
    
    % Feature point prediction of estimated object
    param.Mhatbar                = cell2mat(arrayfun(@(k) obj.H(param.Xhbar,obj.local_feature(k,:)'),1:obj.param.on_feature_num,'UniformOutput',false))';
    % Initialize the observation matrix in validation region
    param.AssociatedObservation  = zeros(obj.param.on_feature_num,3);
    param.OcclusionDetermineFlag = ones(obj.param.on_feature_num,1);
    
    % Association of observation
    for k = 1:obj.param.on_feature_num
       error        = sqrt(sum(power(obj.feature - param.Mhatbar(k,:),2),2)); % Error of Euclidean distance
       MinimumError = min(error);                                             % Find the minimum distance
       [row,~]      = find(error == MinimumError);                            % Find row number with minimum distance
       param.AssociatedObservation(k,:)  = obj.feature(row,:);                % Nearest observation is set as the observation
       if MinimumError > obj.param.gamma                                      % Determine the occlusion
           param.OcclusionDetermineFlag(k,1) = 0.0;
       end
    end
    %param.OcclusionDetermineFlag'
end
