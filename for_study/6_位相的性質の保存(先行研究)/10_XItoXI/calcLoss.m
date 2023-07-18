function loss = calcLoss(Y,T)
%CALCLOSS この関数の概要をここに記述
%   詳細説明をここに記述

% loss = immse(Y,T);
loss = 2*mse(Y,T);

end

