function Y = modelPredictions(net,X)
%MODELPREDICTIONS モデルの予測
%   学習済みネットワークを活用した出力の確認

Y = predict(net,X);

end

