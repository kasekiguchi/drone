function file = WhichLoadFile(tra, script, mode)
    %リファレンスを変える際の軌道を渡す関数
    %tra: 軌道名
    %script: plotResult_any_time:1 か LinearByData:2　の判別
    %mode: 読み込むファイルの設定
    if isempty(mode) % modeが空のとき
        switch tra
            case 'saddle'
                if script == 1; file = 'EstimationResult_2024-05-27_Exp_Kiyama_code06_saddle';
                elseif script == 2; file = 'experiment_9_5_saddle_estimatordata'; end 
            case 'P2Px'
                if script == 1; file = 'EstimationResult_2024-05-24_Exp_Kiyama_code00_P2Px';
                elseif script == 2; file = 'experiment_10_20_P2Px_estimator'; end
            case 'P2Py'
                if script == 1; file = 'EstimationResult_2024-05-24_Exp_Kiyama_code00_P2Py';
                elseif script == 2; file = 'experiment_10_25_P2Py_estimator'; end
            case 'hovering'
                if script == 1; file = 'EstimationResult_2024-05-27_Exp_Kiyama_code01_hovering';
                elseif script == 2; file = 'experiment_11_15_hovering'; end
        end
    else
        % mode.code = '00';
        % mode.training_data = 'Kiyama';
        % Kiyama = 'Kiyama';
        % KiyamaX20 = 'KiyamaX20';
        switch mode.code
            case '00'
                if mode.training_data == 'Kiyama'; file = 'EstimationResult_2024-05-02_Exp_Kiyama_code00_1';
                elseif mode.training_data == 'KiyamaX20'; file = 'EstimationResult_2024-06-04_Exp_KiyamaX_20data_code00_saddle'; end
            case '01'
                file = 'EstimationResult_2024-05-02_Exp_Kiyama_code01';
            case '02'
                file = 'EstimationResult_2024-05-02_Exp_Kiyama_code02';
            case '03'
                file = 'EstimationResult_2024-05-03_Exp_Kiyama_code03_2';
            case '04'
                file = 'EstimationResult_2024-05-13_Exp_Kiyama_code04_1';
            case '05'
                file = 'EstimationResult_2024-05-17_Exp_Kiyama_code05_1';
            case '06'
                file = 'EstimationResult_2024-05-27_Exp_Kiyama_code06_saddle';
            otherwise
                error('リストにない！！');
        end
        % file = 'EstimationResult_2024-05-27_Exp_Kiyama_code06_saddle';
    end
end