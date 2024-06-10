function data = ImportFromExpData_tutorial(expData_Filename,setting,datarange,range,IDX,phase2,vxyz)
%INPORTFROMEXPDATA ドローンの実験データから入出力を抜き出す関数
%   expData_Filename : 実験データの保存場所
%   Data     : 出力変数をまとめる構造体
%   > Data.X : 入力前の状態
%   > Data.U : 対象への入力
%   > Data.Y : 入力後の状態
%   X, U, Y はデータ数が同じである必要がある
%   X, Y の状態(Eular Angle) [px py pz roll pitch yaw vx vy vz V_roll V_pitch V_yaw] 順番の確認
%   setting  : データ結合の際の初期時刻の設定をするかのフラグ

    % 実験データ読み込み
    logger = load(expData_Filename);
    logger = logger.(string(fieldnames(logger)));
    clear data % 読み込んだファイル内のdataと同名の変数を初期化
    
    %データの個数をチェック
    data.N = find(logger.Data.t,1,'last');
    data.uN = 4; %入力の個数
    data.fExp = logger.fExp;
    
    %% Get data
    % 状態毎に分割して保存
    % XYに結合する際の都合で↓時系列,→状態
    %drone_phase  115:stop  97:arming  116:take off  102:flight  108:landing
    
    if logger.fExp==1 %fExp:1 実機データ
    %--------------------time----------------------
        data.t = logger.Data.t;
        data.phase = logger.Data.phase;
        if setting == 1
            datarange = input('\n＜使用するデータ範囲を選択してください＞\n1:take off～flight \n2:take off～landing \n3:flight～flight最後 \n4:flight～landing \n5:特定の範囲を設定\n選択された値：','s');
            data.datarange = str2double(datarange);
            data.IDX = 0;
            data.phase2 = 0;
            data.range = 0;
        
            if data.datarange == 1
                data.startIndex = find(data.phase==116,1,'first');
                data.endIndex = find(data.phase == 102,1,'last');
            elseif data.datarange == 2
                data.startIndex = find(data.phase==116,1,'first');
                data.endIndex = find(data.phase == 108,1,'last');
            elseif data.datarange == 3
                data.startIndex = find(data.phase==102,1,'first');
                data.endIndex = find(data.phase == 102,1,'last');
            elseif data.datarange == 4
                data.startIndex = find(data.phase==112,1,'first');
                data.endIndex = find(data.phase == 108,1,'last');
            else
                range = input('\n＜データ範囲の初めを設定してください＞\n 1:take off + idx 2:flight + idx：','s');
                data.range = str2double(range);
                IDX = input('\n＜idxを入力してください＞ ：','s');
                data.IDX = str2double(IDX);
                if data.range == 1
                    data.startIndex = find(data.phase==116,1,'first') + data.IDX;
                else 
                    data.startIndex = find(data.phase==102,1,'first') + data.IDX;
                end
                phase2 = input('\n＜データ範囲の最後を設定してください＞\n 1:flight 2:landing：','s');
                data.phase2 = str2double(phase2);
                if data.phase2 == 1
                    data.endIndex = find(data.phase == 102,1,'last');
                else
                    data.endIndex = find(data.phase == 108,1,'last');
                end
            end
        else
            if datarange == 1
                data.startIndex = find(data.phase==116,1,'first');
                data.endIndex = find(data.phase == 102,1,'last');
            elseif datarange == 2
                data.startIndex = find(data.phase==116,1,'first');
                data.endIndex = find(data.phase == 108,1,'last');
            elseif datarange == 3
                data.startIndex = find(data.phase==102,1,'first');
                data.endIndex = find(data.phase == 102,1,'last');
            elseif datarange == 4
                data.startIndex = find(data.phase==112,1,'first');
                data.endIndex = find(data.phase == 108,1,'last');
            else
                if range == 1
                    data.startIndex = find(data.phase==116,1,'first') + IDX;
                else 
                    data.startIndex = find(data.phase==102,1,'first') + IDX;
                end
                if phase2 == 1
                    data.endIndex = find(data.phase == 102,1,'last');
                else
                    data.endIndex = find(data.phase == 108,1,'last');
                end
            end
        end
        data.N = data.endIndex - data.startIndex + 1;
        data.t = logger.Data.t(data.startIndex:data.endIndex);
    
    %-------------------estimator----------------------
        data.est.p = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.p,data.startIndex:data.endIndex,'UniformOutput',false))';
        data.est.q = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.q,data.startIndex:data.endIndex,'UniformOutput',false))';
        data.est.v = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.v,data.startIndex:data.endIndex,'UniformOutput',false))';
        data.est.w = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.w,data.startIndex:data.endIndex,'UniformOutput',false))';
    %-----------------------input----------------------
        data.input = cell2mat(arrayfun(@(N)logger.Data.agent.input{N}(1:data.uN),data.startIndex:data.endIndex,'UniformOutput',false))';
        
        % 総推力+トルク入力 → 各プロペラの推力に分解したいときはコメントイン------------------------------
        % for i = 1:size(data.input,1) 
        %     data.input(i,:) = T2T(data.input(i,1),data.input(i,2),data.input(i,3),data.input(i,4));
        % end
        % plot(logger.Data.t(data.startIndex:data.endIndex),data.input) %入力の確認
        %---------------------------------------------------------------------------------------------
    
        % vzからzを計算して学習に使用する場合はコメントイン--------------------------------------------------
        %時間が無くて確認出来なかったが，zからvzを出すのでもよさそう(理解が進んで来たらやってみて！)
        if setting == 1
            % vz_z = input('\n＜zの速度からzを算出して学習に使用しますか？＞\n 0:使用しない 1:使用する：','s');
            % data.vz_z = str2double(vz_z);
            vxyz = input('\n＜速度からx,y,zを算出して学習に使用しますか？＞\n 0:zのみ 1:x,y,zで使用する：','s');
            data.vxyz = str2double(vxyz);
        else
            data.vxyz = vxyz;
        end

        if data.vxyz == 0 %zのみ
            data.est.z(1,1) = data.est.p(1,3); %位置の一時保管場所
            tmpv = data.est.v(:, 3);
        elseif data.vxyz == 1 %xyz
            data.est.z(1:3,1) = data.est.p(1,1:3); 
            tmpv = data.est.v(:, 1:3)';
        end
        %速度から算出
        for i = 1:data.N-1
            data.est.z(:,i+1) = data.est.z(:,i) + tmpv(i,:)'*(data.t(i+1,:)-data.t(i,:)); % z[k+1] = z[k] + vz[k]*(t[k+1]-t[k])
        end
        %---------------------------------------------------------------------------------------------------
    else
        %シミュレーションデータで線形化するときはこっちが実行される(特段いじる必要なし)
        data.startIndex = 1;
        data.endIndex = data.N;
    %--------------------time----------------------
        data.t = logger.Data.t(1:data.N);
    %-------------------estimator----------------------
        data.est.p = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.p,data.startIndex:data.endIndex,'UniformOutput',false))';
        data.est.q = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.q,data.startIndex:data.endIndex,'UniformOutput',false))';
        data.est.v = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.v,data.startIndex:data.endIndex,'UniformOutput',false))';
        data.est.w = cell2mat(arrayfun(@(N) logger.Data.agent.estimator.result{N}.state.w,data.startIndex:data.endIndex,'UniformOutput',false))';
    %-----------------------input----------------------
        data.input = cell2mat(arrayfun(@(N) logger.Data.agent.input{N}(1:data.uN),data.startIndex:data.endIndex,'UniformOutput',false))';
    
        %総推力+トルク入力 → 各プロペラの推力に分解するときはコメントイン------------------------------
        % for i = 1:size(data.input,1) 
        %     data.input(i,:) = T2T(data.input(i,1),data.input(i,2),data.input(i,3),data.input(i,4));
        % end
        % plot(logger.Data.t(data.startIndex:data.endIndex),data.input) %入力の確認
        %---------------------------------------------------------------------------------------------
    end
    %% Set Dataset and Input
    % クープマン線形化のためのデータセットに結合
    % 行：12状態, 列：時系列

    if data.vxyz == 0 %速度vzから位置zを算出してデータセットに使う場合
        for i=1:data.N-1
        data.X(:,i) = [data.est.p(i,1:2)';data.est.z(:,i);data.est.q(i,:)';data.est.v(i,:)';data.est.w(i,:)'];
        data.Y(:,i) = [data.est.p(i+1,1:2)';data.est.z(:,i+1);data.est.q(i+1,:)';data.est.v(i+1,:)';data.est.w(i+1,:)'];
        data.U(:,i) = [data.input(i,:)'];
        data.T(:,i) = [data.t(i,:)];
        end
    elseif data.vxyz == 1 % vx, vy, vzから位置を算出する
        for i=1:data.N-1
        data.X(:,i) = [data.est.z(:,i);data.est.q(i,:)';data.est.v(i,:)';data.est.w(i,:)'];
        data.Y(:,i) = [data.est.p(i+1,1:2)';data.est.z(:,i+1);data.est.q(i+1,:)';data.est.v(i+1,:)';data.est.w(i+1,:)'];
        data.U(:,i) = [data.input(i,:)'];
        data.T(:,i) = [data.t(i,:)];
        end
    else
        for i=1:data.N-1
        data.X(:,i) = [data.est.p(i,:)';data.est.q(i,:)';data.est.v(i,:)';data.est.w(i,:)'];
        data.Y(:,i) = [data.est.p(i+1,:)';data.est.q(i+1,:)';data.est.v(i+1,:)';data.est.w(i+1,:)'];
        data.U(:,i) = [data.input(i,:)'];
        data.T(:,i) = [data.t(i,:)];
        end
    end

end

