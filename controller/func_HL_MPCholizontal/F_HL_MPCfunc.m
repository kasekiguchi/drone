function funcresult = F_HL_MPCfunc(MPCparam,MPCprevious_variables,MPCslack)%#codegen

             %options_setting
            options = optimoptions('fmincon');
            options   = optimoptions(options,'UseParallel',false);
            % options.Display                = 'none';
            options = optimoptions(options,'Diagnostics','off');
            options = optimoptions(options,'MaxFunctionEvaluations',1.e+12);     % 評価関数の最大値
            options = optimoptions(options,'MaxIterations',         1.e+9);     % 最大反復回数
            % options.StepTolerance          = optimoptions(options,'StepTolerance',1.e-12);%xに関する終了許容誤差
            options = optimoptions(options,'ConstraintTolerance',1.e-3);%制約違反に対する許容誤差
            % options    = optimoptions(options,'OptimalityTolerance',1.e-12);%1 次の最適性に関する終了許容誤差。
            % options                = optimoptions(options,'PlotFcn',[]);
            options = optimoptions(options,'SpecifyConstraintGradient',true);   
            options = optimoptions(options,'SpecifyObjectiveGradient',true);
            options = optimoptions(options,'Algorithm','sqp');     % SQPアルゴリズムの指定      これが一番最後にいないとcodegen時にエラーが吐かれる

            
%MPC
            MPCobjective = @(x) objective(x, MPCparam);  % 評価関数
            nonlcon   = @(x) constraints(x, MPCparam);% 制約条件
            x0		  = [MPCprevious_variables;MPCslack];
            %     problem.x0		  = [previous_vurtualstate;previous_input{N}]; % 初期状態
            %[var, fval, exitflag, output, lambda, grad, hessian] = fmincon(problem);
            [var, ~, exitflag, ~, ~, ~, ~] = fmincon(MPCobjective,x0,[],[],[],[],[],[],nonlcon,options);
            disp(exitflag);
%             disp(output);

            
            
            funcresult = var;

end

 function [eval,deval] = objective(x, param)
%             % モデル予測制御の評価値を計算するプログラム
%             total_size = param.state_size + param.input_size;
% %             %-- MPCで用いる予測状態 Xと予測入力 Uを設定
            X = x(1:param.state_size, :);
%             U = x(param.state_size+1:total_size, :);
%             S = x(total_size+1:end,:);%スラック変数[slew;r]
            param.Cdis = arrayfun(@(L) Linedistance(X(1,L),X(5,L),param.sectionpoint,param.Section_change(2)),1:11,'UniformOutput',true);%1:11はホライゾン+1の値．Line_Yも同様
%             FCdis = param.FLD - Cdis;%一機前の機体との経路上距離
%             BCdis = Cdis- param.BLD;%後ろ機体との経路上の距離
%             MiddleDisF =  (FCdis - BCdis).^2;
%             %参照軌道と自機体との距離　pchip区分多項式を生成　ホライゾン内における区分多項式のｙ座標
            param.Line_Y = arrayfun(@(L) pchip(param.P_chips(1,:),param.P_chips(2,:),X(1,L)),1:11,'UniformOutput',true);
%             
%             
%             tildeT = sqrt((X(5,:) - Line_Y).^2);
%             %入力と参照入力の差(目標0)
%             tildeU = U;
%             %自機体の速度
%             v = [X(2,:);X(6,:)];
% %             -- 機体間距離及び参照軌道との偏差および入力のステージコストを計算
%             stageMidF =  arrayfun(@(L) MiddleDisF(:,L)' * param.Qm * MiddleDisF(:,L),1:param.H);
%             stageTrajectry = arrayfun(@(L) tildeT(:,L)' * param.Qt * tildeT(:,L),1:param.H);
%             stageInput = arrayfun(@(L) tildeU(:, L)' * param.R * tildeU(:, L), 1:param.H);
%             stageSlack_s = arrayfun(@(L) S(1,L)' * param.W_s * S(1,L),1:param.H);%スルーレートのスラック変数
%             stageSlack_r = arrayfun(@(L) S(2,L)' * param.W_r * S(2,L),2:param.Num);%最終まで　ケーブルと壁
%             stagevelocity = arrayfun(@(L) v(:,L)' * param.V * v(:,L),1:param.H);
%             %-- 状態の終端コストを計算
%             terminalMidF = MiddleDisF(:,end)' * param.Qmf * MiddleDisF(:,end);
%             terminalTrajectry = tildeT(:,end)' * param.Qtf * tildeT(:,end);
%             terminalvelocity = v(:,end)' * param.V * v(:,end);
%             -- 評価値計算
%             eval = sum(stageMidF + stageTrajectry + stageInput + stageSlack_s + stageSlack_r + stagevelocity) + terminalTrajectry + terminalvelocity +  terminalMidF;
            
            [eval,deval] = autoEval(x, param.V,param.Qm,param.Qmf,param.Qt,param.Qtf,param.R,param.W_s,param.W_r,param.Cdis,param.FLD,param.BLD,param.Line_Y);

            
        end

        function [cineq, ceq, gcineq, gceq] = constraints(x, param)%ceq等式制約，cineq不等式制約，
            X = x(1:param.state_size,:);
            % モデル予測制御の制約条件を計算するプログラム
            %セクション点の定義
            prev_sp = param.sectionpoint(param.Section_change(1),:);%previous section
            now_sp = param.sectionpoint(param.Section_change(2),:);%now section
            next_sp = param.sectionpoint(param.Section_change(3),:);%next section
            n_next_sp = param.sectionpoint(param.Section_change(4),:);%nextnext section　point
            f_prev_sp = param.sectionpoint(param.S_front(1),:);%previous section
            f_now_sp = param.sectionpoint(param.S_front(2),:);%now section
            f_next_sp = param.sectionpoint(param.S_front(3),:);%next section
            f_n_next_sp = param.sectionpoint(param.S_front(4),:);%nextnext section　point
            %     %前機体のセクション判別
            f_prev_r = arrayfun(@(L) abs(det([[f_prev_sp]-[f_now_sp];[param.front(1,L),param.front(2,L)]-[f_now_sp]]))/norm([f_prev_sp]-[f_now_sp]),1:param.Num,'UniformOutput',true);
            f_now_r = arrayfun(@(L) abs(det([[f_now_sp]-[f_next_sp];[param.front(1,L),param.front(2,L)]-[f_next_sp]]))/norm([f_now_sp]-[f_next_sp]),1:param.Num,'UniformOutput',true);
            f_next_r = arrayfun(@(L) abs(det([[f_next_sp]-[f_n_next_sp];[param.front(1,L),param.front(2,L)]-[f_n_next_sp]]))/norm([f_next_sp]-[f_n_next_sp]),1:param.Num,'UniformOutput',true);
            [~,FSCP] = min([f_prev_r;f_now_r;f_next_r]);
            % %      ケーブルに対する制約
            % %      min([params.Sectionpoint(params.S_front(2),:);params.Sectionpoint(params.S_front(3),:)]);
%             param.Sectionconect = param.sectionpoint(param.S_front(2) + FSCP-2,:);
            param.Sectionconect = param.sectionpoint(param.S_front(2)*ones(1,11) + FSCP-2*ones(1,11),:);%MEX化するときに右辺が可変と認識されるのを防ぐためにめんどくさい記述方法を取る

            %     %自機体のセクション判別
            prev_r = arrayfun(@(L) abs(det([[prev_sp]-[now_sp];[X(1,L),X(5,L)]-[now_sp]]))/norm([prev_sp]-[now_sp]),1:param.Num,'UniformOutput',true);% 前のセクションポイントとの距離
            now_r = arrayfun(@(L) abs(det([[now_sp]-[next_sp];[X(1,L),X(5,L)]-[next_sp]]))/norm([now_sp]-[next_sp]),1:param.Num,'UniformOutput',true);% 今のセクションポイントとの距離
            next_r = arrayfun(@(L) abs(det([[next_sp]-[n_next_sp];[X(1,L),X(5,L)]-[n_next_sp]]))/norm([next_sp]-[n_next_sp]),1:param.Num,'UniformOutput',true);% 次のセクションポイントとの距離
            [~,SCP] = min([prev_r;now_r;next_r]);
            %    %今の経路の番号を出す
            SN = param.Section_change(2)*ones(1,11) + SCP -2*ones(1,11);
            param.wall_width_xx = [param.wall_width_x(SN,1),param.wall_width_x(SN,2)];
            param.wall_width_yy = [param.wall_width_y(SN,1),param.wall_width_y(SN,2)];
%---------------------------------------------------------------------------------------------%            

            

            
            
            [cineq, ceq, gcineq, gceq] = autoCons(x, param.X0, param.A, param.B, param.Slew, param.D_lim, param.front, param.behind, param.Sectionconect, param.wall_width_xx, param.wall_width_yy, param.r_limit);
        end
