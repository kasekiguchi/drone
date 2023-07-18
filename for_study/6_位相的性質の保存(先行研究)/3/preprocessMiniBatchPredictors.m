function X = preprocessMiniBatchPredictors(dataX)
% ミニバッチ予測子前処理関数

% Concatenate.
X = cat(4,dataX{1:end});

end



