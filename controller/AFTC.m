classdef AFTC < CONTROLLER_CLASS
% クアッドコプター用階層型線形化を使った入力算出
properties
    self
    result
    param
    Q
    parameter_name = ["mass", "Lx", "Ly", "lx", "ly", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4"];
    Vf
    Vs
    Uthrust
    pdst 
    fRandn =0;%確率seedを指定．同じ確率の値でできる
end

methods
%
function obj = AFTC(self, param)
        obj.self = self;
        obj.param = param;
        obj.param.P = self.parameter.get(obj.parameter_name);
        obj.Q = STATE_CLASS(struct('state_list', ["q"], 'num_list', [4]));
%         obj.Vf = param.Vf; % 階層１の入力を生成する関数ハンドル
%         obj.Vs = param.Vs; % 階層２の入力を生成する関数ハンドル
        obj.Uthrust = param.Uthrust; % 階層２の入力を生成する関数ハンドル
    end

    function result = do(obj, param, ~)
        % param (optional) : 構造体：物理パラメータP，ゲインF1-F4
        model = obj.self.estimator.result;
        ref = obj.self.reference.result;
        xd = ref.state.get();%referenceとその微分[x,y,z,yaw]の順番
        
        F1 = obj.param.F1;
        F2 = obj.param.F2;
        F3 = obj.param.F3;
        F4 = obj.param.F4;
        
        ax = obj.param.ax;
        ay = obj.param.ay;
        az = obj.param.az;
        apsi = obj.param.apsi;
        
        xd = [xd; zeros(20 - size(xd, 1), 1)]; % 足りない分は０で埋める．

        %状態 (ドローンの状態 - refernce)
            p = model.state.p - xd(1:3)  ;%位置
            v = model.state.v - xd(5:7)  ;%速度
            q = model.state.q - [0;0;xd(4)] ;%角度
            w = model.state.w - [0;0;xd(8)] ;%角速度
        % サブシステムの状態            
            Xs = [p(1); v(1);q(2);w(2)];
            Ys = [p(2) ; v(2);q(1);w(1)];
            Zs = [p(3) ; v(3)];
            Psis = [q(3) ;w(3)];

        %% cariculate controller

         % Finite time settling controller
            uz = -F1*(sign(Zs).*abs(Zs).^az); % f throtl
            ux = -F2*(sign(Xs).*abs(Xs).^ax); %tau_theta roll
            uy = -F3*(sign(Ys).*abs(Ys).^ay); %tau_phi pitch
            upsi = -F4*(sign(Psis).*abs(Psis).^apsi);%tau_psi yaw

        % Linear state feedback controller
%             ux = -F2*Xs; %tau_theta roll
%             uy = -F3*Ys; %tau_phi pitch
%             uz = -F1*Zs; % f throtl
%             upsi = -F4*Psis;%tau_psi yaw
        %% setting disturbance
        dst=0;
%         t = param{1};
%         dst = 1;
%--------------------------------------------------
%確率的な外乱
% a = 1;%外乱の大きさの上限
% dst = 2*a*rand-a;
%                     if ~obj.fRandn%最初のループでシミュレーションで使う分の乱数を作成
%                           rng(42,"twister");%シミュレーション条件を同じにするために乱数の初期値を決めることができる
%                           a = 1;%標準偏差
%                           b = 0;%平均
%                           c = param{2}/obj.self.plant.dt +1 ;%ループ数を計算
%                           obj.pdst = a.*randn(c,1) + b;%ループ数分の値の乱数を作成
%                           obj.fRandn = 1;
%                     end
%                     dst = obj.pdst(obj.fRandn);
%                     obj.fRandn = obj.fRandn+1;%乱数の値を更新
%--------------------------------------------------        
%                     if t>=10 && t<=10.5
%                             dst=-3;
%                     end
        %% calc actual input
        
        tmp = obj.Uthrust(uz, ux, uy, upsi);
        obj.result.input = [tmp(1); tmp(2); tmp(3); tmp(4);dst];
        obj.self.input = obj.result.input;
%          %サブシステムの入力
        obj.result.uHL = [uz; ux; uy; upsi];
        result = obj.result;
    end

    function show(obj)
        obj.result
    end

end

end
