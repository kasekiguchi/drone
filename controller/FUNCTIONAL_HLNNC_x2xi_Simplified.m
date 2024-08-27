classdef FUNCTIONAL_HLNNC_x2xi_Simplified < handle
% クアッドコプター用階層型線形化を使った入力算出
% NNによる飛行
% 自明な仮想状態を学習に含めない
properties
    self
    result
    param
    parameter_name = ["mass", "Lx", "Ly", "lx", "ly", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4"];
    Vf
    Vs
    HLNN1
    HLNN2
    HLNN3
    IT
    xi_log
    p_log

end

methods

    function obj = FUNCTIONAL_HLNNC_x2xi_Simplified(self, param)
        obj.self = self;
        obj.param = param;
        obj.param.P = self.parameter.get(obj.parameter_name);
        obj.result.input = zeros(self.estimator.model.dim(2),1);
        obj.Vf = obj.param.Vf; % 階層１の入力を生成する関数ハンドル
        obj.Vs = obj.param.Vs; % 階層２の入力を生成する関数ハンドル
        % obj.xi_pre = [self.plant.state.p; model.state.q; model.state.v; model.state.w]; % [q, p, v, w]に並べ替え
        obj.p_log = self.plant.state.p;
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
        P = obj.param.P;
        F1 = obj.param.F1;
        F2 = obj.param.F2;
        F3 = obj.param.F3;
        F4 = obj.param.F4;
        xd = [xd; zeros(20 - size(xd, 1), 1)]; % 足りない分は０で埋める．
        std = load('./Data/mean_std_data.mat');

        Rb0 = RodriguesQuaternion(Eul2Quat([0; 0; xd(4)]));

        x = [R2q(Rb0' * model.state.getq("rotmat")); Rb0' * model.state.p; Rb0' * model.state.v; model.state.w]; % [q, p, v, w]に並べ替え
        
        % x = [model.state.getq("compact"); model.state.p; model.state.v; model.state.w]; % [q, p, v, w]に並べ替え
        % x = [model.state.getq("compact"); [0;0;0]; model.state.v; model.state.w]; % [q, p, v, w]に並べ替え
        
        xd(1:3) = Rb0' * xd(1:3);
        xd(4) = 0;
        xd(5:7) = Rb0' * xd(5:7);
        xd(9:11) = Rb0' * xd(9:11);
        xd(13:15) = Rb0' * xd(13:15);
        xd(17:19) = Rb0' * xd(17:19);

        %% calc Z
        z1 = Z1(x, xd', P);%z
        vf = obj.Vf(z1, F1);
        z2 = Z2(x, xd', vf, P);%x
        z3 = Z3(x, xd', vf, P);%y
        z4 = Z4(x, xd', vf, P);%yaw
        vs = obj.Vs(z2, z3, z4, F2, F3, F4);
        obj.result.z1 = z1;
        obj.result.z2 = z2;
        obj.result.z3 = z3;
        obj.result.z4 = z4;
        %% 
        % 
        my_xd = zeros([12, 1]);
        my_xd(1:2) = xd(1:2);
        my_xd(3:6) = xd(5:8);
        my_xd(7:10) = xd(9:12);
        my_xd(11:12) = xd(13:14);
       
        % my_xd = (x-ref_std(:,1))./ref_std(:,2);
        %%%%%%%%%%%%%%%%
        % x = my_standardization(x,std.x_qua_std)';
        %%%%%%%%%%%%%%%%

      

        %% NN1-3
        x = [Rb0' * model.state.p; Rb0' * model.state.q; Rb0' * model.state.v; model.state.w]; % [p, q, v, w]に並べ替え
        
        dxi1 = predict(obj.param.HLNN1,x(4:end))'; %NN1
        dxi1 = cast(dxi1, "double");
        xi1 = [x(3)-xd(1);dxi1];

        obj.result.xi_log = xi1;

        A1 = obj.param.Ad(1:2,1:2);
        B1 = obj.param.Bd(1:2,1:2);
        F1 = obj.param.F(1:2,1:2);

        v1   = -F1*xi1;
        dv1  = -F1*(A1 - B1*F1)*xi1;
        ddv1 = -F1*(A1 - B1*F1)^2*xi1;

        NN2_input = [x;v1;dv1;ddv1];

        xi234 = cast(predict(obj.param.HLNN2,NN2_input)', "double"); %NN2
        
        xi = [xi1;x(1)-xd(3);xi234(1:3);x(2)-xd(7);xi234(4:6);x(6)-xd(11);xi234(7)];

        v = obj.param.F*(xi-my_xd);
        xi_plus = obj.param.Ad*xi - obj.param.Bd*v;
        x = [x;xi;xi_plus;v;my_xd];

        prob = cast(predict(obj.param.HLNN3,x)', "double"); %NN3

        obj.p_log =  model.state.p;
        obj.p_log

        q_eul = Eul2Quat(prob(4:6));
        prob = [prob(1:7); q_eul;prob(8:16)];


        %% calc actual input
        tmp = prob(1:4);
        
        % tmp = obj.IT*tmp;
        
        %%%%%%%%%%%%%%%
        % tmp = inv_my_standardization(tmp,std.input_std);
        % disp(tmp);
        %%%%%%%%%%%%%%%
        
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