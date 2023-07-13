function [param] = CalculateWeightting(obj,param)
    % Calculating weightting factor against observation in validation region
    %【Input】 obj   : object of PDAF
    %          param : Structure of PDAF
    %【Output】param : Structure of PDAF
    for k = 1:obj.param.on_feature_num
        % Likelihood ration for occlusion in line 1
        Lr{1,k} = 0;
        % Calculating likelihood ration against observation
        for s = 2:param.ValidationNum(1,k)
            Lr{1,k}(s) = obj.PD / obj.lambda * obj.ProbabilityDensityFunction(param.ValidatedObservation{1,k}(s,:),param.Mhatbar(k,:),param.Si{k});
        end
        % Calculating weightting factor
        % Weightting factor for occlusion in line 1
        param.p{1,k}(1) = (1 - obj.PD * obj.PG) / (1 - obj.PD * obj.PG + sum(Lr{1,k}));
        % Calculating weightting factor against observation
        for s = 2:param.ValidationNum(1,k)
            param.p{1,k}(s) = Lr{1,k}(s) / (1 - obj.PD * obj.PG + sum(Lr{1,k}));
        end
        % The sum of the weightting factor against observation in validation region
        param.pSum(1,k) = sum(param.p{1,k}(2:param.ValidationNum(1,k)));
    end
end