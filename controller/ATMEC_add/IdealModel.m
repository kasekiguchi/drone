function result = IdealModel(A,B,state,ref,F)
%AT-MEC 補償ゲインチューニングのFRITアルゴリズムの入力変換関数
%   理想モデルMを含む計算
u = F * (ref - state);
state = A * state + B * u;
% state = A*state;
result = state;
end
