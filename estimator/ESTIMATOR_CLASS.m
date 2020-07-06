classdef (Abstract) ESTIMATOR_CLASS < handle
    % Estimator用抽象クラス
    properties (Abstract)
%        state % 推定結果の状態
        result % 状態以外の推定値
        % sub classのコンストラクタ内で STATE_CLASS, RESULT_CLASSと定義する必要がある．
        % そうしないとすべてのインスタンスで共通のhandleを使い回すことになる．
        self
    end
    properties
        name
    end
    
    methods (Abstract)
        result=do(obj,param,~); % param = agent.sensor
        show(obj);
    end
end

