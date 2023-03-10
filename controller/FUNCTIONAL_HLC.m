classdef FUNCTIONAL_HLC < CONTROLLER_CLASS
% クアッドコプター用階層型線形化を使った入力算出
properties
    self
    result
    param
    Q
    parameter_name = ["mass", "Lx", "Ly", "lx", "ly", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4"];
    Vf
    Vs
    pdst 
    fRandn =0;%確率seedを指定．同じ確率の値でできる
end

methods

    function obj = FUNCTIONAL_HLC(self, param)
        obj.self = self;
        obj.param = param;
        obj.param.P = self.parameter.get(obj.parameter_name);
        obj.Q = STATE_CLASS(struct('state_list', ["q"], 'num_list', [4]));
        obj.Vf = param.Vf; % 階層１の入力を生成する関数ハンドル
        obj.Vs = param.Vs; % 階層２の入力を生成する関数ハンドル
    end

    function result = do(obj, param, ~)
        % param (optional) : 構造体：物理パラメータP，ゲインF1-F4
        model = obj.self.estimator.result;
        ref = obj.self.reference.result;
        x = [model.state.getq('compact'); model.state.p; model.state.v; model.state.w]; % [q, p, v, w]に並べ替え
        xd = ref.state.get();
        
        P = obj.param.P;
        F1 = obj.param.F1;
        F2 = obj.param.F2;
        F3 = obj.param.F3;
        F4 = obj.param.F4;
        %     xd=Xd.p;
        %     if isfield(Xd,'v')
        %         xd=[xd;Xd.v];
        %         if isfield(Xd,'dv')
        %             xd=[xd;Xd.dv];
        %         end
        %     end
        xd = [xd; zeros(20 - size(xd, 1), 1)]; % 足りない分は０で埋める．

        % yaw 角についてボディ座標に合わせることで目標姿勢と現在姿勢の間の2pi問題を緩和
        % TODO : 本質的にはx-xdを受け付ける関数にして，x-xdの状態で2pi問題を解決すれば良い．
        Rb0 = RodriguesQuaternion(Eul2Quat([0; 0; xd(4)]));
        x = [R2q(Rb0' * model.state.getq("rotmat")); Rb0' * model.state.p; Rb0' * model.state.v; model.state.w]; % [q, p, v, w]に並べ替え
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

        %%
        dst=0;
        t = param{1};
%         dst = 1;
        %確率的な外乱
%         rng("shuffle");
%                     a = 1;%外乱の大きさの上限
%                     dst = 2*a*rand - a;
                    %平均b、標準偏差aのガウスノイズ
                    if~obj.fRandn %最初のループでシミュレーションで使う分の乱数を作成
                          rng(42,"twister");%シミュレーション条件を同じにするために乱数の初期値を決めることができる
                          a = 1;%標準偏差
                          b = 0;%平均
                          c = param{2}/obj.self.plant.dt +1 ;%スープ数を計算
                          obj.pdst = a.*randn(c,1) + b;%ループ数分の値の乱数を作成
                          obj.fRandn = 1;
                    end
                    dst = obj.pdst(obj.fRandn);
                    obj.fRandn = obj.fRandn+1;%乱数の値を更新
%                     if t>=10 && t<=10.5
%                             dst=-3;
%                     end
%              ts = 2 ; te =5.33;
%              T2 = 2*(te - ts);
%             if t>=ts && t<= te
% %                     dst=0.6;
%                     dst=0.4*sin(2*pi*(t-ts)/T2)+0.6;
%             end

% dst=-1*sin(2*pi*t/1);
 %特定の位置で外乱を与える
%                     dst=0;xxx0=0.5;TT=0.5;%TT外乱を与える区間
%                     xxx=model.state.p(1)-xxx0;
%                     if xxx>=0 && xxx<=TT
%                             dst=-5*sin(2*pi*xxx/(TT*2));
%                     end
%             if t>=4 && t<=5.33
%                     dst=0.6;
%             end
        %% calc actual input
        tmp = Uf(x, xd', vf, P) + Us(x, xd', vf, vs, P);
        obj.result.input = [tmp(1); tmp(2); tmp(3); tmp(4);dst];
        obj.self.input = obj.result.input;
%         obj.result.state.set_state('p', data.rigid(id).p);
         %サブシステムの入力
        obj.result.uHL = [vf(1);vs];
        %サブシステムの状態
        obj.result.z1 = z1;
        obj.result.z2 = z2;
        obj.result.z3 = z3;
        obj.result.z4 = z4;
        obj.result.vf = vf;
        result = obj.result;
    end

    function show(obj)
        obj.result
    end

end

end
