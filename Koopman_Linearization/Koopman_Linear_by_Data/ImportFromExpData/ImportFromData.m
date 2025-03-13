% データセットを結合する関数
function data = ImportFromData(filename, setting)
    % foldername : 実験データの保存場所
    % Data: 出力変数をまとめる構造体
    
    % 実験データ読み込み
    logger = LOGGER(filename);
    clear data % 読み込んだファイル内のdataと同名の変数を初期化
    
    % データの個数をチェック
    data.uN = 4; %入力の個数
    data.fExp = logger.fExp;
    t = logger.data(0, 't', []);

    % 読み込むデータの決定
    data.phase = logger.Data.phase;
    [data.startIndex, data.endIndex] = phase_decision(setting.datarange, data);

    % 読み込み
    data.N = data.endIndex - data.startIndex + 1;
    data.t = logger.data(0, 't', [], 'ranget', [t(data.startIndex), t(data.endIndex)]);
    data.est.p = logger.data(1, "p", "e", "ranget", [t(data.startIndex), t(data.endIndex)]);
    data.est.q = logger.data(1, "q", "e", "ranget", [t(data.startIndex), t(data.endIndex)]);
    data.est.v = logger.data(1, "v", "e", "ranget", [t(data.startIndex), t(data.endIndex)]);
    data.est.w = logger.data(1, "w", "e", "ranget", [t(data.startIndex), t(data.endIndex)]);
    data.input = logger.data(1, "input", [], "ranget", [t(data.startIndex), t(data.endIndex)]);

    tmpt = [diff(data.t); 0.025];
    if setting.vxyz == 0
        tmpp(:,1) = data.est.p(:,3); %位置の一時保管場所
        tmpv = data.est.v(:, 3); %速度の一時保管
    elseif setting.vxyz == 1 %xyz
        tmpp(:,:) = data.est.p(:,1:3); 
        tmpv = data.est.v(:, 1:3); % 3 * length(t)
    end
    data.est.z = tmpp + (tmpv.*tmpt);

    % 速度から求めたデータを位置に書き換え
    if setting.vxyz == 0 %速度vzから位置zを算出してデータセットに使う場合
        data.X = [data.est.p(1:end-1,1:2)';data.est.z(1:end-1,:)';data.est.q(1:end-1,:)';data.est.v(1:end-1,:)';data.est.w(1:end-1,:)'];
        data.Y = [data.est.p(2:end  ,1:2)';data.est.z(2:end  ,:)';data.est.q(2:end  ,:)';data.est.v(2:end  ,:)';data.est.w(2:end,:  )'];
        data.U = [data.input(1:end-1,:)'];
        data.T = [data.t];
    elseif setting.vxyz == 1 % vx, vy, vzから位置を算出する
        data.X = [data.est.z(1:end-1,:)';data.est.q(1:end-1,:)';data.est.v(1:end-1,:)';data.est.w(1:end-1,:)'];
        data.Y = [data.est.z(2:end  ,:)';data.est.q(2:end  ,:)';data.est.v(2:end  ,:)';data.est.w(2:end,:  )'];
        data.U = [data.input(1:end-1,:)'];
        data.T = [data.t];
    else
        data.X = [data.est.p(1:end-1,:)';data.est.q(1:end-1,:)';data.est.v(1:end-1,:)';data.est.w(1:end-1,:)'];
        data.Y = [data.est.p(2:end  ,:)';data.est.q(2:end  ,:)';data.est.v(2:end  ,:)';data.est.w(2:end  ,:)'];
        data.U = [data.input(1:end-1,:)'];
        data.T = [data.t(1:end-1,:)];
    end
end

function [idx1, idx2] = phase_decision(datarange,data)
    if datarange == 1
        idx1 = find(data.phase==116,1,'first');
        idx2 = find(data.phase == 102,1,'last');
    elseif datarange == 2
        idx1 = find(data.phase==116,1,'first');
        idx2 = find(data.phase == 108,1,'last');
    elseif datarange == 3
        idx1 = find(data.phase==102,1,'first');
        idx2 = find(data.phase == 102,1,'last');
    elseif datarange == 4
        idx1 = find(data.phase==112,1,'first');
        idx2 = find(data.phase == 108,1,'last');
    else
        range1 = str2double(input('\n＜データ範囲の初めを設定してください＞\n 1:take off + idx,   2:flight + idx：','s'));
        idx = str2double(input('\n＜idxを入力してください＞ ：','s'));
        if range1 == 1; idx1 = find(data.phase==116,1,'first') + idx; % takeoff + idx
        else;           idx1 = find(data.phase==102,1,'first') + idx; % flight + idx
        end
        range2 = str2double(input('\n＜データ範囲の最後を設定してください＞\n 1:flight - idx,   2:landing - idx：','s'));
        idx = str2double(input('\n＜idxを入力してください＞ ：','s'));
        if range2 == 1; idx2 = find(data.phase == 102,1,'last') - idx; % flight - idx
        else;           idx2 = find(data.phase == 108,1,'last') - idx; % landing - idx
        end
    end
end