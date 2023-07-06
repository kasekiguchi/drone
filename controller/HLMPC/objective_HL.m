function [eval] = objective_HL(obj_HL, x, inputref)   % obj.~とする
            X = x(1:12, :);       % 12 * 10 * N
            U = x(13:16,:);                % 4  * 10 * N
            %% Referenceの取得、ホライズンごと
            Xd = obj_HL.reference;
            %       Z = X;% - obj.state.ref(1:12,:);
            %% ホライズンごとに実際の誤差に変換する（リファレンス(1)の値からの誤差）
            Xh = X + Xd;
            %% それぞれのホライズンのリファレンスとの誤差を求める
            Z = Xd - Xh;
            % Z = X;

            tildeUpre = U - obj_HL.input;          % agent.input 　前時刻入力との誤差
            tildeUref = U - inputref;  % 目標入力との誤差 0　との誤差

            indL = size(Z,2);

            %-- 状態及び入力のステージコストを計算 pagemtimes サンプルごとの行列計算

%             stageStateZ = arrayfun(@(L) Z(:,L)' * obj.Weight * Z(:,L), 1:obj.param.H-1);
%             stageInputPre = arrayfun(@(L) tildeUpre(:,L)' * obj.WeightR * tildeUpre(:,L), 1:obj.param.H-1);
%             stageInputRef = arrayfun(@(L) tildeUref(:,L)' * obj.WeightRp * tildeUref(:,L), 1:obj.param.H-1);

            stageStateZ = diag(Z(:,1:indL)'* obj_HL.Weight * Z(:,1:indL))';
            stageInputPre = diag(tildeUpre(:,1:indL)'* obj_HL.WeightRp * tildeUpre(:,1:indL))';
            stageInputRef = diag(tildeUref(:,1:indL)'* obj_HL.WeightR  * tildeUref(:,1:indL))';

            % stageStateZ = sum(Z(:,1:end-1,:).*pagemtimes(obj.Weight(:,:,obj.N),Z(:,1:end-1,:)),[1,2]);%
            % stageInputPre  = sum(tildeUpre(:,1:end-1,:).*pagemtimes(obj.WeightR(:,:,obj.N),tildeUpre(:,1:end-1,:)),[1,2]);%sum(tildeUpre' * obj.param.RP.* tildeUpre',2);
            % stageInputRef  = sum(tildeUref(:,1:end-1,:).*pagemtimes(obj.WeightRp(:,:,obj.N),tildeUref(:,1:end-1,:)),[1,2]);%sum(tildeUref' * obj.param.R .* tildeUref',2);

            %-- 状態の終端コストを計算 状態だけの終端コスト
            terminalState = Z(:, end)' * obj_HL.Weight * Z(:,end);
            % terminalState = sum(Z(:,end,:).*pagemtimes(obj.Weight(:,:,obj.N),Z(:,end,:)),[1,2]);

            %-- 評価値計算
            eval = sum(stageStateZ,"all") + sum(stageInputPre, [1,2]) + sum(stageInputRef, [1,2]) + terminalState;  % 全体の評価値
        end