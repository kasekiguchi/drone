function funcresult = L_HL_MPCfunc(MPCparam,linear_model,MPCprevious_variables) %#codegen
%高速化のため，do controllerの中のfminconの部分のみ関数化
%  


            %MPC
            
             %options_setting
            options = optimoptions('fmincon');
%             options.UseParallel            = false;
            % options.Display                = 'none';
            options = optimoptions(options,'Diagnostics','off');
            options = optimoptions(options,'MaxFunctionEvaluations',1.e+12);     % 評価関数の最大値
            options = optimoptions(options,'MaxIterations',         1.e+9);     % 最大反復回数
            % options.StepTolerance          = optimoptions(options,'StepTolerance',1.e-12);%xに関する終了許容誤差
            options = optimoptions(options,'ConstraintTolerance',1.e-3);%制約違反に対する許容誤差
            % options    = optimoptions(options,'OptimalityTolerance',1.e-12);%1 次の最適性に関する終了許容誤差。
            % options                = optimoptions(options,'PlotFcn',[]);
            options  = optimoptions(options,'SpecifyObjectiveGradient',true);
            options = optimoptions(options,'SpecifyConstraintGradient',true);   
            options = optimoptions(options,'Algorithm',             'sqp');     % SQPアルゴリズムの指定      これが一番最後にいないとcodegen時にエラーが吐かれる

            
            
            
%             problem.objective = @(x) Lobjective(x, obj.param);  % 評価関数
%             problem.nonlcon   = @(x) constraints(x, obj.param);% 制約条件
            objective = @(x) LautoEval(x, MPCparam.Q, MPCparam.Qf, MPCparam.R, MPCparam.Xr);  % 評価関数
            nonlcon   = @(x) LautoCons(x, MPCparam.X0, linear_model.A, linear_model.B, MPCparam.Slew, 1, 1);% 制約条件
            x0		  = MPCprevious_variables;
            %     problem.x0		  = [previous_vurtualstate;previous_input{N}]; % 初期状態
            %[var, fval, exitflag, output, lambda, grad, hessian] = fmincon(problem);
            [var, ~, ~, ~, ~, ~, ~] = fmincon(objective,x0,[],[],[],[],[],[],nonlcon,options);
%             obj.previous_variables = var;
%             disp(exitflag);
            
            
            
            funcresult = var;

end

