%% 
function file = WhichLoadFile(tra, mode)
    % リファレンスを変える際の軌道を渡す関数
    % tra: 軌道名
    % mode: plotResult_any_time:1 か LinearByData:2　の判別
    switch tra
        case 'saddle'
            if mode == 1; file = 'EstimationResult_2024-05-27_Exp_Kiyama_code06_saddle';
            elseif mode == 2; file = 'experiment_9_5_saddle_estimatordata'; end 
        case 'P2Px'
            if mode == 1; file = 'EstimationResult_2024-05-24_Exp_Kiyama_code00_P2Px';
            elseif mode == 2; file = 'experiment_10_20_P2Px_estimator'; end
        case 'P2Py'
            if mode == 1; file = 'EstimationResult_2024-05-24_Exp_Kiyama_code00_P2Py';
            elseif mode == 2; file = 'experiment_10_25_P2Py_estimator'; end
        case 'hovering'
            if mode == 1; file = 'EstimationResult_2024-05-27_Exp_Kiyama_code01_hovering';
            elseif mode == 2; file = 'experiment_11_15_hovering'; end
    end
end