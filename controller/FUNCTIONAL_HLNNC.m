classdef FUNCTIONAL_HLNNC < handle
% クアッドコプター用階層型線形化を使った入力算出
properties
    self
    result
    param
    parameter_name = ["mass", "Lx", "Ly", "lx", "ly", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4"];
    Vf
    Vs
    HLNN1
    HLNN2
    IT

end

methods

    function obj = FUNCTIONAL_HLNNC(self, param)
        obj.self = self;
        obj.param = param;
        obj.param.P = self.parameter.get(obj.parameter_name);
        obj.result.input = zeros(self.estimator.model.dim(2),1);
        % obj.Vf = obj.param.Vf; % 階層１の入力を生成する関数ハンドル
        % obj.Vs = obj.param.Vs; % 階層２の入力を生成する関数ハンドル
        Lx = self.parameter.Lx;
        Ly = self.parameter.Ly;
        lx = self.parameter.lx;
        ly = self.parameter.ly;
        km1 = self.parameter.km1;           
        km2 = self.parameter.km2;           
        km3 = self.parameter.km3;           
        km4 = self.parameter.km4;           
        obj.IT = [1 1 1 1;-ly, -ly, (Ly - ly), (Ly - ly); lx, -(Lx-lx), lx, -(Lx-lx); km1, -km2, -km3, km4];          
        
        
    end

    function result = do(obj,varargin)
        model = obj.self.estimator.result;
        ref = obj.self.reference.result;
        xd = ref.state.xd;
        % P = obj.param.P;
        % F1 = obj.param.F1;
        % F2 = obj.param.F2;
        % F3 = obj.param.F3;
        % F4 = obj.param.F4;
        xd = [xd; zeros(20 - size(xd, 1), 1)]; % 足りない分は０で埋める．
        std = load('./Data/mean_std_data.mat');

        Rb0 = RodriguesQuaternion(Eul2Quat([0; 0; xd(4)]));

        x = [R2q(Rb0' * model.state.getq("rotmat")); Rb0' * model.state.p; Rb0' * model.state.v; model.state.w]; % [q, p, v, w]に並べ替え
        % x = [model.state.p; model.state.q; model.state.v; model.state.w]; % [q, p, v, w]に並べ替え
        
        xd(1:3) = Rb0' * xd(1:3);
        xd(4) = 0;
        xd(5:7) = Rb0' * xd(5:7);
        xd(9:11) = Rb0' * xd(9:11);
        xd(13:15) = Rb0' * xd(13:15);
        xd(17:19) = Rb0' * xd(17:19);
        % 
        my_xd = zeros([12, 1]);
        my_xd(1:2) = xd(1:2);
        my_xd(3:6) = xd(5:8);
        my_xd(7:10) = xd(9:12);
        my_xd(11:12) = xd(13:14);
       
        % my_xd = (x-ref_std(:,1))./ref_std(:,2);
        x = my_standardization(x,std.x_qua_std)';

        xi = predict(obj.param.HLNN1,x)' ;
        xi = cast(xi, "double");

        v = obj.param.F*(xi-my_xd);
        xi_plus = obj.param.Ad*xi - obj.param.Bd*v;

        % ref=gen_ref_saddle(obj.param);
        ref = zeros(12,1);
        x = [x;xi;xi_plus;v;ref];
        
        prob = cast(predict(obj.param.HLNN2,x)', "double");

        %% calc actual input
        tmp = prob(1:4);

        tmp = obj.IT*tmp;

        tmp = inv_my_standardization(tmp,std.input_std);

        % obj.result.input = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
        obj.result.input = [tmp(1);tmp(2);tmp(3);tmp(4)];
        result = obj.result;

        function data_ = my_standardization(data, std)
            for i = 1:length(data')
                
                if std(i,2) == 0.0
                    data_(i) = data(i);
                else
                    data_(i) = (data(i) - std(i,1))./std(i,2);
                end
            end
        end
        function data_ = inv_my_standardization(data, std)
            for i = 1:length(data')
                
                if std(i,2) == 0.0
                    data_(i) = data(i);
                else
                    data_(i) = data(i)*std(i,2) + std(i,1);
                    
                end
            end
        end
    end
    

    function show(obj)
        obj.result
    end

end

end