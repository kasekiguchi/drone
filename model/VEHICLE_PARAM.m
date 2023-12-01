classdef VEHICLE_PARAM < PARAMETER_CLASS
    % 車両モデルのパラメータ管理用クラス
    properties
        mass % DIATONE
        Lx
        Ly
        lx
        ly
        jx
        jy
        jz
        gravity
    end

    methods
        function obj = VEHICLE_PARAM(name,type,param)
            arguments
                name %
                type = "row"; % row : 列ベクトル or struct : 構造体
                param.mass = 0.269;
                param.Lx = -0.006; %角速度の偏差
                param.Ly = 0.0932;
                param.lx = 0.117/2;%0.05;
                param.ly = 0.0932/2;%0.05;
                param.jx = 0.02237568;
                param.jy = 0.02985236;
                param.jz = 0.0480374;
                param.gravity = 9.81;
                param.additional = []; % プロパティに無いパラメータを追加する場合
            end
            obj = obj@PARAMETER_CLASS(name,type,param)
        end
    end
end