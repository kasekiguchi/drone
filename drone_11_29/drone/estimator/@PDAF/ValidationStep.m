function param = ValidationStep(obj,param)
    % Determining observations within the validation region
    %【Input】 obj   : object of PDAF
    %          param : Structure of PDAF
    %【Output】param : Structure of PDAF
    
    % Feature point prediction of estimated object
    param.Mhatbar              = cell2mat(arrayfun(@(k) obj.H(param.Xhbar,obj.local_feature(k,:)'),1:obj.param.on_feature_num,'UniformOutput',false))';
    param.ValidatedObservation = cell(1,obj.param.on_feature_num);          % Initialize the observation matrix in validation region
    param.ValidationNum        = zeros(1,obj.param.on_feature_num);         % Initialize the number of observation vector in validation region
    
    for k = 1:obj.param.on_feature_num
        % Substitute the observed predicted value in the first row of the observed value matrix in validation region
        param.ValidatedObservation{1,k} = param.Mhatbar(k,:);
    end
    % Validation of observation
    for k = 1:obj.param.on_feature_num
       ValidationCount = 2;
       error           = obj.feature - param.Mhatbar(k,:);                  % Error between observed and predicted values at Euclidean distance
       nyu             = 1000*ones(obj.param.feature_num,1);                % Prepare Mahalanobis distance vector in advance
       for s = 1:obj.param.feature_num
           nyu(s,1) = error(s,:) * inv(param.Si{k}) * error(s,:)';          % Calculating Mahalanobis distance
       end
       [row,~]      = find( nyu <= obj.gamma);                        % Determine observations within validation region
       [valnum,~]   = size(row);                                            % The number of observation in validation region(include feature point prediction)
       for s = 1:valnum
            % Observation matrix in validation region
            param.ValidatedObservation{1,k}(ValidationCount,:) = obj.feature(row(s),:);
            ValidationCount = ValidationCount + 1;
       end
       [param.ValidationNum(1,k),~] = size(param.ValidatedObservation{1,k}); % The number of observation in validation region(include feature point prediction)
    end
    param.MaxNum = max(param.ValidationNum(1,:));                           % Maximum number of observation in all validation region of estimated object
end
