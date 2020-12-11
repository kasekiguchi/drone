   function result = IdealModel(A,B,state,ref,F)
        % AT-MEC 補償ゲインチューニングのFRITアルゴリズムの理想モデルMを含む計算
        % IdealModel(A,B,state,ref,F)
        % A,B : 離散化した状態空間表現係数
        % state : 更新したい出力
        % ref : 目標値 M*ref
        % F : ノミナルコントローラ
        u = F * (ref - state);
        state = A * state + B * u;
        result = state;
    end