classdef POINT_MASS_PARAM < PARAMETER_CLASS
    % 質点モデルの物理パラメータ管理用クラス

    properties
        A
        B
        C
        D
    end

    methods
        function obj = POINT_MASS_PARAM(name,type,param)
            arguments
                name
                type = "struct";            
                param.additional = [];
                param.A = [zeros(3) eye(3);zeros(3,6)];
                param.B = [zeros(3);eye(3)];
                param.C = [eye(3),zeros(3)];
                param.D = zeros(3);
            end
            obj = obj@PARAMETER_CLASS(name,type,param);
        end        
    end
end