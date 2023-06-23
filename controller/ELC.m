classdef ELC < handle
% クアッドコプター用階層型線形化を使った入力算出
properties
    self
    result
    param
    Q
    parameter_name = ["mass", "Lx", "Ly", "lx", "ly", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4"];
    Vep
    finitial
    fRandn
    pdst
end

methods

    function obj = ELC(self, param)
        obj.self = self;
        obj.param = param;
        obj.param.P = self.parameter.get(obj.parameter_name);
        obj.Q = STATE_CLASS(struct('state_list', ["q"], 'num_list', [4]));
        % obj.Vls = param.Vepls; % 階層２の入力を生成する関数ハンドル
        % obj.Vft = param.Vepft; % 階層１の入力を生成する関数ハンドル
        obj.Vep = param.Vep; % 仮想入力を生成する関数ハンドル
        obj.result.input = zeros(self.estimator.model.dim(2),1);
        obj.result.u = zeros(self.estimator.model.dim(2),1);
        obj.finitial=1;
        obj.fRandn =0;
    end

    function result = do(obj ,varargin)
        % param (optional) : 構造体：物理パラメータP，ゲインF1-F4
        model = obj.self.estimator.result;
        ref = obj.self.reference.result;
        xd = ref.state.xd;
        xd0 =xd;
        P = obj.param.P;
        % F1 = obj.param.F1;
        % F2 = obj.param.F2;
        % F3 = obj.param.F3;
        % F4 = obj.param.F4;

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
        x = [R2q(Rb0' * model.state.getq("rotmat")); Rb0' * model.state.p; Rb0' * model.state.v; model.state.w;model.state.Trs]; % [q, p, v, w]に並べ替え
        xd(1:3) = Rb0' * xd(1:3);
        xd(4) = 0;
        xd(5:7) = Rb0' * xd(5:7);
        xd(9:11) = Rb0' * xd(9:11);
        xd(13:15) = Rb0' * xd(13:15);
        xd(17:19) = Rb0' * xd(17:19);

        %% calc Z
        z1 = Zep1(x, xd', P);
        z2 = Zep2(x, xd', P);
        z3 = Zep3(x, xd', P);
        z4 = Zep4(x, xd', P);
        
        %subsystem controller
        vep = obj.Vep(z1, z2, z3, z4);

        %% calc actual input
        tmp = Uep(x, xd', vep, P);
        % if obj.finitial
        %     tmp(2:4) =zeros(3,1);
        %     obj.finitial=0;
        % end
        %%
        dst = [zeros(6,1)];%[x,y,z,roll,pitch,yaw](加速次元)
        %-----------------------------------------------------------------
                    %確率の外乱
                    % t = param{1};
                    % rng("shuffle");
                    % a = 1;%外乱の大きさの上限
                    % dst = 2*a*rand-a;

                    % 平均b、標準偏差aのガウスノイズ
                     if ~obj.fRandn%最初のループでシミュレーションで使う分の乱数を作成
                          rng(42,"twister");%シミュレーション条件を同じにするために乱数の初期値を決めることができる
                          a = 1;%標準偏差
                          b = 0;%平均
                          c = varargin{1, 1}.te/obj.self.plant.dt +1 ;%ループ数を計算param{2}はシミュレーション時間
                          obj.pdst = a.*randn(c,3) + b;%ループ数分の値の乱数を作成
                          obj.fRandn = 1;
                    end
                    % dst(3) = obj.pdst(obj.fRandn,1);
                    % dst(4) = obj.pdst(obj.fRandn,2);
                    % dst(5) = obj.pdst(obj.fRandn,3);
                    obj.fRandn = obj.fRandn+1;%乱数の値を更新
         %サブシステムの入力
        obj.result.uHL =vep;
        %サブシステムの状態
        obj.result.z1 = z1;
        obj.result.z2 = z2;
        obj.result.z3 = z3;
        obj.result.z4 = z4;
        obj.result.u = [tmp;dst];
        % obj.result.input = [max(0,min(10,x(14)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];        
        obj.result.input = [max(0,min(10,x(14)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)));dst];        
        result = obj.result;
    end

    function show(obj)
        obj.result
    end

end

end
