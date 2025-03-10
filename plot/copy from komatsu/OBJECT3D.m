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
            xc=param.cog(1); yc=param.cog(2); zc=param.cog(3);    % coordinated of the center
            L=param.length;                 % cube size (length of an edge)
            switch shape
                case {"cube","cuboid"}
                    X = [0 0 0 0 0 1; 1 0 1 1 1 1; 1 0 1 1 1 1; 0 0 0 0 0 1];
                    Y = [0 0 0 0 1 0; 0 1 0 0 1 1; 0 1 1 1 1 1; 0 0 1 1 1 0];
                    Z = [0 0 1 0 0 0; 0 0 1 0 0 0; 1 1 1 0 1 1; 1 1 1 0 1 1];

                    X = L(1)*(X-0.5) + xc;
                    Y = L(2)*(Y-0.5) + yc;
                    Z = L(3)*(Z-0.5) + zc;
                    C = ones(size(X));
                case "cylinder"
                    [X,Y,Z] = cylinder();
                    X = L(1)*X + xc;
                    Y = L(2)*Y + yc;
                    Z = L(3)*(Z-0.5) + zc;  
                    C = ones(size(X));
                case {"sphere", "ellipse"}
                    [X,Y,Z] = sphere;
                    X = L(1)*(X-0.5) + xc;
                    Y = L(2)*(Y-0.5) + yc;
                    Z = L(3)*(Z-0.5) + zc;
                    C = ones(size(X));
            end
            obj.X = X;
            obj.Y = Y;
            obj.Z = Z;
            obj.C = C;
        end

        function plot(obj,args)
            arguments
                obj
                args.alpha = obj.alpha
                args.color = 'b'
            end
            switch obj.shape
                case {"cube", "cuboid"}
                    fill3(obj.X,obj.Y,obj.Z,obj.C,'FaceAlpha',args.alpha);
                case {"sphere", "ellipse", "cylinder"}
                    surf(obj.X,obj.Y,obj.Z,obj.C,'FaceAlpha',args.alpha);
            end
            axis equal
        end
    end
end