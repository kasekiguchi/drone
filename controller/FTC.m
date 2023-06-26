classdef FTC < handle
% クアッドコプター用階層型線形化を使った入力算出
properties
    self
    result
    param
    Q
    parameter_name = ["mass", "Lx", "Ly", "lx", "ly", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4"];
    Vf
    Vs
    fzapr
    fRandn
    pdst
end

methods

    function obj = FTC(self, param)
        obj.self = self;
        obj.param = param;
        obj.param.P = self.parameter.get(obj.parameter_name);
        obj.Q = STATE_CLASS(struct('state_list', ["q"], 'num_list', [4]));
        obj.result.input = zeros(self.estimator.model.dim(2),1);
        obj.Vf = obj.param.Vf; % 階層１の入力を生成する関数ハンドル
        obj.Vs = obj.param.Vs; % 階層２の入力を生成する関数ハンドル
        obj.fzapr = param.fzapr;
        obj.fRandn =0;
    end

    function result = do(obj,varargin)
        % param (optional) : 構造体：物理パラメータP，ゲインF1-F4       
        model = obj.self.estimator.result;
        ref = obj.self.reference.result;
        x = [model.state.getq('compact'); model.state.p; model.state.v; model.state.w]; % [q, p, v, w]に並べ替え
        xd = ref.state.get();

        P = obj.param.P;

        xd = [xd; zeros(20 - size(xd, 1), 1)]; % 足りない分は０で埋める．

        Rb0 = RodriguesQuaternion(Eul2Quat([0; 0; xd(4)]));
        x = [R2q(Rb0' * model.state.getq("rotmat")); Rb0' * model.state.p; Rb0' * model.state.v; model.state.w]; % [q, p, v, w]に並べ替え
        xd(1:3) = Rb0' * xd(1:3);
        xd(4) = 0;
        xd(5:7) = Rb0' * xd(5:7);
        xd(9:11) = Rb0' * xd(9:11);
        xd(13:15) = Rb0' * xd(13:15);
        xd(17:19) = Rb0' * xd(17:19);
        
        %z方向:FT
        z1 = Z1(x, xd', P);%z
        vf = obj.Vf(z1); 
        %x,y,psiの状態変数の値
        z2 = Z2(x, xd', vf, P); %x方向
        z3 = Z3(x, xd', vf, P); %y方向
        z4 = Z4(x, xd', vf, P); %yaw
        vs = obj.Vs(z2,z3,z4);
        %検証用
%      vf(1)=-F1*(sign(z1).*abs(z1).^az(1:2));%z近似なし
        % vs(3) = -F4 * z4; %yaw:LS
        %% 外乱(加速度で与える)
        
        %=======================================
        %定常外乱：並進方向は0.2m/s^2くらい，回転方向は3rad/s^2(180deg/s^2)
        %=======================================
                    dst = [zeros(6,1)];%[x,y,z,roll,pitch,yaw](加速次元)
        %-----------------------------------------------------------------
                    %確率の外乱
                    % t = param{1};
%                     rng("shuffle");
%                     a = 1;%外乱の大きさの上限
%                     dst = 2*a*rand-a;
%
                    %平均b、標準偏差aのガウスノイズ
                     if ~obj.fRandn%最初のループでシミュレーションで使う分の乱数を作成
                          rng(42,"twister");%シミュレーション条件を同じにするために乱数の初期値を決めることができる
                          a = 1;%標準偏差
                          b = 0;%平均
                          c = varargin{1, 1}.te/obj.self.plant.dt +1 ;%ループ数を計算param{2}はシミュレーション時間
                          obj.pdst = a.*randn(c,3) + b;%ループ数分の値の乱数を作成
                          obj.fRandn = 1;
                    end
                    dst(4) = obj.pdst(obj.fRandn,1);
                    dst(5) = obj.pdst(obj.fRandn,2);
                    dst(3) = obj.pdst(obj.fRandn,3);
                    obj.fRandn = obj.fRandn+1;%乱数の値を更新
        %-----------------------------------------------------------------
                    %一時的な外乱
%         t = param{1};
%         dst = 0;
%                     if t>=2 && t<=5.33
%                             dst= 0.6;
%                     end
        %特定の位置で外乱を与える
     
%                     dst=0;xxx0=0.5;TT=0.5;%TT外乱を与える区間
%                     xxx=model.state.p(1)-xxx0;
%                     if xxx>=0 && xxx<=TT
%                             dst=-5*sin(2*pi*xxx/(TT*2));
%                     end
        %%
        tmp = Uf(x, xd', vf, P) + Us(x, xd', vf, vs, P);
        % obj.result.input = [tmp(1); tmp(2); tmp(3); tmp(4); dst];
        % obj.self.input = obj.result.input;
        %サブシステムの入力
        obj.result.uHL = [vf(1); vs];
        %サブシステムの状態
        obj.result.z1 = z1;
        obj.result.z2 = z2;
        obj.result.z3 = z3;
        obj.result.z4 = z4;
        obj.result.vf = vf;
        % obj.result.input = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
        obj.result.input =[max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)));dst];%外乱用
        result = obj.result;
    end

    function show(obj)
        obj.result
    end

end

end
