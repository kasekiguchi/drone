function file = WhichLoadFile(tra)
    %リファレンスを変える際の軌道を渡す関数
    %tra: 軌道名
    switch tra
        case 'saddle'
            file = 'experiment_9_5_saddle_estimatordata'; 
        case 'P2Px'
            file = 'experiment_10_20_P2Px_estimator';
        case 'P2Py'
            file = 'experiment_10_25_P2Py_estimator';
        case 'hovering'
            file = 'experiment_11_15_hovering'; 
        otherwise
            error('File does not exist.');
    end
end