function [X,T] = preprocessMiniBatch(dataX,dataT)
% ミニバッチ前処理関数

% Preprocess predictors.
X = preprocessMiniBatchPredictors(dataX);

% Extract label data from cell and concatenate.
T = cat(2,dataT{1:end});

% One-hot encode labels.
T = onehotencode(T,1);

end

