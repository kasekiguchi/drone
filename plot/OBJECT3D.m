classdef OBJECT3D
    %UNTITLED3 このクラスの概要をここに記述
    %   詳細説明をここに記述

    properties
        X
        Y
        Z
        C
        shape
        alpha=0.8;           % transparency (max=1=opaque)
    end

    methods
        function obj = OBJECT3D(shape,param)
            %
            %
            arguments
                shape
                param
            end
            obj.shape = shape;
            switch shape
                case "cube"
            xc=param.cog(1); yc=param.cog(2); zc=param.cog(3);    % coordinated of the center
            L=param.length;                 % cube size (length of an edge)
X = [0 0 0 0 0 1; 1 0 1 1 1 1; 1 0 1 1 1 1; 0 0 0 0 0 1];
Y = [0 0 0 0 1 0; 0 1 0 0 1 1; 0 1 1 1 1 1; 0 0 1 1 1 0];
Z = [0 0 1 0 0 0; 0 0 1 0 0 0; 1 1 1 0 1 1; 1 1 1 0 1 1];

obj.X = L(1)*(X-0.5) + xc;
obj.Y = L(2)*(Y-0.5) + yc;
obj.Z = L(3)*(Z-0.5) + zc; 
obj.C = ones(size(obj.X));
                case "cuboid"
                case "sphere"
            end
        end

        function outputArg = plot(obj,args)
            arguments
                obj
                args.alpha = obj.alpha
                args.color = 'b'
            end
            fill3(obj.X,obj.Y,obj.Z,obj.C,'FaceAlpha',args.alpha);
            axis equal
        end
    end
end