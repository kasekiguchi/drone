% -------------------------------------------------------------------------
% File : mpcMain.m
% Discription : Program for demonstration of model predctive control
% Author : Ryuichi Maki
% Editor : Shunsuke Irisawa (2022-10-13)
% -------------------------------------------------------------------------
%% Setup
    % 初期化
        tmp = matlab.desktop.editor.getActive;
        cd(fileparts(tmp.Filename));
        clc;disp('Setup for simulation...');
        tmp = matlab.desktop.editor.getActive;warning('off','all');
        cd(fileparts(tmp.Filename)); close all; userpath('clear');addpath(genpath('./src'));

    % 自動保存用フォルダ作成
        ntime = char(datetime('now', 'Format', 'MMdd_HHmmSS'));
        Name = 'test';                         % 自分で名前を変更すること 
        saveFolderName = [Name, '_',ntime ];
        pathname = '/Plot_data/';
        currentfolder = pwd;
        folderName = strcat(currentfolder,pathname,saveFolderName);
        mkdir(folderName);
        mkdir('.fig')
        mkdir('.pdf')
        mkdir('.eps')
        movefile('.fig', folderName);
        movefile('.pdf', folderName);
        movefile('.eps', folderName);

    % パラメータ
%         Td = 0.05;                              % 離散時間幅,ホライゾンの幅,システムに印加する時間幅
        Td = 0.1;                               % 離散時間幅,ホライゾンの幅,システムに印加する時間幅
        Te = 5;	                            % シミュレーション時間
        x0 = [0.; 1.];                          % 初期状態
        u0 = [0.; 0.];                          % 初期状態，入力
        ur = [0.5;0.];                          % 目標速度
        Xo = [3;1];                             % 障害の位置　(静止障害物)

    % 制御対象のシステム行列
        [Ad, Bd, Cd, Dd] = MassModel(Td);
        Params.Ad = Ad;
        Params.Bd = Bd;
        Params.Cd = Cd;
        Params.Dd = Dd;

        [~, state_size] = size(Ad);
        [~, input_size] = size(Bd);
        total_size = state_size + input_size;

    % MPC 定義
        options.Algorithm = 'sqp';
        options.Display = 'iter';
        problem.solver = 'fmincon';
        problem.options = options;              % ソルバー

    % パラメータ設定
        MPC_H  = 25;                            % モデル予測制御のホライゾン
        Params.H= MPC_H + 1;
        Params.dt = 0.05;                       % モデル予測制御の刻み時間，制御周期
        Params.Xo = Xo*ones(1, Params.H);       % 障害物の座標をホライゾン分
        
    % 評価関数重み
        Params.Weight.Qf = diag([1.; 1.]);      % モデル予測制御の状態に対する終端コスト重み，diagは対角行列を表す
        Params.Weight.Q  = diag([1.; 1.]);      % モデル予測制御の状態に対するステージコスト重み
        Params.Weight.R  = diag([1.; 1.]);      % モデル予測制御の入力に対するステージコスト重み
        Params.Weight.Qapf = 0.4;               % 人工ポテンシャル場法に対する重み
        
% 重みのチューニング %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        Params.Weight.Q(2,2) = 1;       % yの追従に対する重み

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 予測モデルのシステム行列
        [MPC_Ad, MPC_Bd, MPC_Cd, MPC_Dd] = MassModel(Params.dt);
        Params.A = MPC_Ad;
        Params.B = MPC_Bd;
        Params.C = MPC_Cd;
        Params.D = MPC_Dd;

dataNum= 10; 
%% main
    %- データ配列初期化
    x = x0;
    u = u0;
    previous_state  = zeros(state_size + input_size, Params.H);
    data.state      = zeros(round(Te / Td + 1), dataNum); 
    data.state(1,1) = 0.;       % 初期時刻
    data.state(1,2) = x(1);     % 初期状態 x(1) = x
    data.state(1,3) = x(2);     % 初期状態 x(2) = y
    data.state(1,4) = 0.;       % 初期入力 u(1) = v_x
    data.state(1,5) = 0.;       % 初期入力 u(2) = v_y
    data.state(1,6) = x(1);     % 初期目標状態 xr(1)
    data.state(1,7) = x(2);     % 初期目標状態 xr(2)
    data.state(1,8) = 0.;       % 初期目標入力 ur(1)
    data.state(1,9) = 0.;       % 初期目標入力 ur(2)
    idx = 1;                    % roop index
%- main ループ %スライドのブロック線図
while x(1)<5
    idx = idx + 1;
%% 前処理
	% 実行状態の表示
        disp(['Time: ', num2str(idx * Td, '%.2f'), ' s, state: ', num2str(x','[%.2f\t]'), ', input: ', num2str(u','[%.2f\t]')]);
        % time:t state:x y input:v_x v_y
    
    % 観測方程式
        y = Cd*x;
    
	% 目標軌道生成
%        [xr,flag] = Reference(Params.H, ur, y, Params.dt,x0);             % 目標経路 1
       [xr,flag] = Reference2(Params.H, ur, y, Params.dt,x0);            % 目標経路 2
     
       if flag ==1
           data.state(1,7) = 0.5;
       else
           data.state(1,7) = 1.0;
       end
    
    % MPCでパラメータを配列に格納
        Params.Ur= ur;
        Params.Xr= xr;
        Params.X0= x;
        Params.input_size = input_size;
        Params.state_size = state_size;
   
%% モデル予測制御
        % MPC設定
            problem.x0		  = previous_state;                         % 現在状態
            problem.objective = @(x) Objective(x, Params);              % 評価関数
%             problem.objective = @(x) Objective2(x, Params);             % 評価関数 人工ポテンシャルあり
%             problem.nonlcon   = @(x) Constraints(x, Params);            % 制約条件
            problem.nonlcon   = @(x) Constraints2(x, Params);           % 制約条件 位置制約あり
                
        % 最適化計算
            [var, fval, exitflag, output, lambda, grad, hessian] = fmincon(problem);
            
        % 制御入力の決定
            previous_state    = var;                                    % 最適化した結果を一時的に保存
            u = var(state_size + 1:total_size, 1);                      % 最適化計算での現在時刻の入力を制御対象に印可する入力として採用
        
%% 後処理
    % データ保存
        data.state(idx,1) = idx * Td;   % 現在時刻
        data.state(idx,2) = x(1);       % 状態 x(1)
        data.state(idx,3) = x(2);       % 状態 x(2)
        data.state(idx,4) = u(1);       % 入力 u(1)
        data.state(idx,5) = u(2);       % 入力 u(2)
        data.state(idx,6) = xr(1,1);    % 目標状態 xr(1)
        data.state(idx,7) = xr(2,1);    % 目標状態 xr(2)
        data.state(idx,8) = ur(1,1);    % 目標入力 ur(1)
        data.state(idx,9) = ur(2,1);    % 目標入力 ur(2)
        data.state(idx,10)= fval;       % 評価値
        data.exitflag(idx)= exitflag;   % 最適化計算収束判定
        data.output(idx)  = output;     % 最適化プロセスに関する情報
        data.lambda(idx)  = lambda;     % 解におけるラグランジュ乗数
        data.grad(idx)	  = {grad};     % 最適化計算における勾配
        data.hessian(idx) = {hessian};  % 最適化計算におけるヘッセ行列
        data.var(idx)     = {var};      % 最適化計算における決定変数
        data.Xopt(idx,:)    = var(1,:); % 最適化計算で算出されたxの解
        data.Yopt(idx,:)    = var(2,:); % 最適化計算で算出されたyの解
        
    % 制御対象 状態更新
        x = Ad*x + Bd*u;
        
end

%% PLOT
figNum = 0;
% X-Y平面
figNum = figNum + 1;
figure(figNum)
figName = 'Time_change_of_position';
fig = gcf;
fig.Color= [1., 1., 1.];
hold on;
% plot(data.state(:,2),data.state(:,3),'-','LineWidth',1.75);
% plot(data.state(:,6),data.state(:,7),'-','LineWidth',1.75);
plot(data.state(:,1),data.state(:,2),'-','LineWidth',1.75);
plot(data.state(:,1),data.state(:,3),'-','LineWidth',1.75);
% plot(data.state(:,1),data.state(:,6),'-','LineWidth',1.75);
% plot(data.state(:,1),data.state(:,7),'-','LineWidth',1.75);
grid on; axis equal; hold off; box on;
set(gca,'FontSize',16);
% ylabel('$$Y$$ [m]', 'Interpreter', 'latex')
% xlabel('$$X$$ [m]', 'Interpreter', 'latex')
ylabel('$$X, Y$$ [m]', 'Interpreter', 'latex')
xlabel('$$t$$ [s]', 'Interpreter', 'latex')
lgd = legend("X", "Y");
lgd.NumColumns = 2;
xlim([min(data.state(:,1)), max(data.state(:,1))]);
save_n_move(figNum,figName,folderName)
%% 時間に対する状態変化
figNum = figNum + 1;
figure(figNum)
figName = 'Trajectoryt&Reference';
fig = gcf;
fig.Color= [1., 1., 1.];
hold on;
plot(data.state(:,1),data.state(:,2),'-','LineWidth',1.75);
plot(data.state(:,1),data.state(:,3),'-','LineWidth',1.75);
plot(data.state(:,1),data.state(:,6),'--','LineWidth',1.75);
plot(data.state(:,1),data.state(:,7),'--','LineWidth',1.75);
plot(Xo(1), Xo(2), '.', 'MarkerSize', 50);
grid on; hold off; box on;
set(gca,'FontSize',16);
ylabel('$$X, Y$$ [m]', 'Interpreter', 'latex')
xlabel('$$t$$ [s]', 'Interpreter', 'latex')
xlim([0.,Te]);
lgd = legend('$$x$$','$$y$$','$$x_{ref}$$','$$y_{ref}$$', 'Interpreter', 'latex','Location','southoutside');
lgd.NumColumns = 4;% 時間に対する入力変化
save_n_move(figNum,figName,folderName)

figNum = figNum + 1;
figure(figNum)
figName = 'Velocity';
fig = gcf;
fig.Color= [1., 1., 1.];
hold on;
plot(data.state(:,1),data.state(:,4),'-','LineWidth',1.75);
plot(data.state(:,1),data.state(:,5),'-','LineWidth',1.75);
grid on; hold off; box on;
set(gca,'FontSize',16);
ylabel('$$U_1, U_2$$ [m/s]', 'Interpreter', 'latex')
xlabel('$$t$$ [s]', 'Interpreter', 'latex')
xlim([0.,Te]);
lgd = legend('$$v_x$$','$$v_y$$', 'Interpreter', 'latex','Location','southoutside');
lgd.NumColumns = 2;
save_n_move(figNum,figName,folderName)

% 時間に対する評価値変化
figNum = figNum + 1;
figure(figNum)
figName = 'Evaluation_value';
fig = gcf;
fig.Color= [1., 1., 1.];
hold on;
plot(data.state(:,1),data.state(:,10),'-','LineWidth',1.75);
grid on; hold off; box on;
set(gca,'FontSize',16);
ylabel('$$J$$ [-]', 'Interpreter', 'latex')
xlabel('$$t$$ [s]', 'Interpreter', 'latex')
xlim([0.,Te]);
legend('Evaluation value','Location','southoutside')
save_n_move(figNum,figName,folderName)

%% 動画
figure(6)
timestamp= datestr(now,'yyyymmdd_HHMM_ss');
v=VideoWriter(timestamp,'MPEG-4');
v.FrameRate=20;
open(v);
    fig = gcf;
    fig.Color= [1., 1., 1.];
    for k=1:size(data.state-1,1)
        % 目標経路
            p1=plot(data.state(3:end,6),data.state(3:end,7),'-','LineWidth',1.75);
            hold on;
        % 状態
            p2=plot(data.state(k,2),data.state(k,3),'s','LineWidth',1.75);
        % 予測点
            plot(data.Xopt(k,:),data.Yopt(k,:),'.','LineWidth',1.75);
        %位置制約
%             plot(Xo(1), Xo(2), '.', 'MarkerSize', 20);
    %    p3=yline(0.4,'--','LineWidth',1.7);
          
        % set Params
            grid on; axis equal; hold off;
            set(gca,'FontSize',16);
            legend([p2 p1],{'State','Target'},'Location','best','Interpreter', 'Latex','FontSize',12);
%             legend([p2 p1 p3],{'State','Target','Constraint'},'Location','best','Interpreter', 'Latex','FontSize',12);
            xlabel('X [m]','Interpreter', 'Latex');ylabel('Y [m]','Interpreter', 'Latex');
            xlim([0.,5]);ylim([-0.5 2]);
            
        drawnow
        frame=getframe(gcf);
        writeVideo(v,frame)
        pause(0.1)
    end
    close(v);
    movefile([timestamp,'.mp4'], folderName);
    
    

%% モデルの記述
    function [Ad, Bd, Cd, Dd]  = MassModel(Td)          % 状態：[x,y],　制御入力 [vx,vy]
    %% 連続系システム
            Ac = [0.0, 0.0;
                     0.0, 0.0];
            Bc = [1.0, 0.0;
                     0.0, 1.0];
            Cc = diag([1,1]);
            Dc = 0;
            sys =ss(Ac,Bc,Cc,Dc);

    %% 離散系システム
            dsys=c2d(sys,Td); % 連続系から離散系への変換
            [Ad,Bd,Cd,Dd]=ssdata(dsys);

    end
    

%% 目標経路
    function [xr,Flag1] = Reference(H, Ur, Y, dT, X_ref)
        % 参照軌道を計算するプログラム
        % 入力引数: ホライゾン H, 目標入力 Ur, 現在時刻で得られた観測値 Y, モデル予測制御の刻み幅 dT
        xr = ones(2, H).*X_ref;
        Flag1 = 1;
        % 予測したX座標が2.5 m以上であるときY座標を1 mに設定
            for L = 1:H
                xr(:, L) = [Y(1) + Ur(1)*(L-1)*dT; 0.5];
            end
    end
    
    function [xr,Flag2] = Reference2(H, Ur, Y, dT, X_ref)
        % 参照軌道を計算するプログラム
        % 入力引数: ホライゾン H:Params.H, 目標入力 Ur:ur, 現在時刻で得られた観測値 Y:y, モデル予測制御の刻み幅
        % dT:Params.dt 初期値: X_ref:x0
        xr = ones(2, H).*X_ref;
        Flag2 = 2;
        % 予測したX座標が2.5 m以上であるときY座標を0 mに設定
            for L = 1:H
                if Y(1) + Ur(1)*(L-1)*dT >= 2.5
                    xr(:, L) = [Y(1) + Ur(1)*(L-1)*dT; 0.];
                else
                    xr(:, L) = [Y(1) + Ur(1)*(L-1)*dT; 1.];
                end
            end
    end
    
    
%% 評価関数
    function [eval] = Objective(x, params) % 人工ポテンシャル場なし
        % モデル予測制御の評価値を計算するプログラム
            total_size = params.state_size + params.input_size;
        %-- MPCで用いる予測状態 Xと予測入力 Uを設定
            X = x(1:params.state_size, :);
            U = x(params.state_size+1:total_size, :);
            Qapf = params.Weight.Qapf;
        %-- 状態及び入力に対する目標状態や目標入力との誤差を計算
            tildeX = X - params.Xr;
            tildeU = U - params.Ur;
            tildeXo = X - params.Xo;
        %-- 状態及び入力のステージコストを計算
            stageState = arrayfun(@(L) tildeX(:, L)' * params.Weight.Q * tildeX(:, L), 1:params.H-1);
            stageInput = arrayfun(@(L) tildeU(:, L)' * params.Weight.R * tildeU(:, L), 1:params.H-1);
        %-- 状態の終端コストを計算
            terminalState = tildeX(:, end)' * params.Weight.Qf * tildeX(:, end);
        %-- 評価値計算
            eval = sum(stageState + stageInput) + terminalState;
    end
    
    function [eval] = Objective2(x, params) % 人工ポテンシャル場あり
    % モデル予測制御の評価値を計算するプログラム
        total_size = params.state_size + params.input_size;
    %-- MPCで用いる予測状態 Xと予測入力 Uを設定
        X = x(1:params.state_size, :);
        U = x(params.state_size+1:total_size, :);
    %-- 状態及び入力に対する目標状態や目標入力との誤差を計算
        tildeX = X - params.Xr;
        tildeU = U - params.Ur;
        tildeXo = X - params.Xo;
    %-- 状態及び入力のステージコストを計算
        stageState = arrayfun(@(L) tildeX(:, L)' * params.Weight.Q * tildeX(:, L), 1:params.H-1);
        stageInput = arrayfun(@(L) tildeU(:, L)' * params.Weight.R * tildeU(:, L), 1:params.H-1);
    %-- 状態の終端コストを計算
        terminalState = tildeX(:, end)' * params.Weight.Qf * tildeX(:, end);
    %-- 人工ポテンシャル場
        APF = arrayfun(@(L) params.Weight.Qapf /((tildeXo(1, L))^2+(tildeXo(2, L))^2) , 1:params.H-1);
    %-- 評価値計算
        eval = sum(stageState + stageInput + APF) + terminalState;
end




%% 制約条件
    function [c, ceq] = Constraints(x, params)
        % モデル予測制御の制約条件を計算するプログラム
            total_size = params.state_size + params.input_size;
            c  = zeros(params.state_size, 1*params.H);

        %-- MPCで用いる予測状態 Xと予測入力 Uを設定
            X = x(1:params.state_size, :);
            U = x(params.state_size+1:total_size, :);

        %-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定　非線形等式を計算します．
            ceq = [X(:, 1) - params.X0, cell2mat(arrayfun(@(L) X(:, L)  - (params.A * X(:, L-1) + params.B * U(:, L-1)), 2:params.H, 'UniformOutput', false))];
            c(1,:) = [];
    end
    
    function [c, ceq] = Constraints2(x, params)
        % モデル予測制御の制約条件を計算するプログラム
            total_size = params.state_size + params.input_size;
            c  = zeros(params.state_size, 1*params.H);

        %-- MPCで用いる予測状態 Xと予測入力 Uを設定
            X = x(1:params.state_size, :);
            U = x(params.state_size+1:total_size, :);

        %-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定　非線形等式を計算します．
            ceq = [X(:, 1) - params.X0, cell2mat(arrayfun(@(L) X(:, L)  - (params.A * X(:, L-1) + params.B * U(:, L-1)), 2:params.H, 'UniformOutput', false))];
            c(1,:) = arrayfun(@(L) -x(2,L)+0.4, 1:params.H);
    end
%% 自動保存
function saveFig(fig,figname)
    set(gca,'Fontsize',14);
    % Black out 
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(3) fig_pos(4)];
    % save
    print(fig,figname,'-dpdf','-r300','-bestfit');
    exportgraphics(fig,[figname,'.pdf'],'ContentType','vector');
end
function saveFig2eps(fig,figname)
    set(gca,'Fontsize',14);
    % Black out 
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(3) fig_pos(4)];
    % save
    exportgraphics(fig,[figname,'.eps'],'ContentType','vector');
end
function save_n_move(figNum,figName,folderName)
    %.figの保存
    savefig(figure(figNum),figName); 
    movefile([figName,'.fig'], [folderName, '/.fig']);
    %.pdfの保存
    saveFig(figure(figNum),figName); 
    movefile([figName,'.pdf'], [folderName, '/.pdf']);
    % epsの保存
    saveFig2eps(figure(figNum),figName);
    movefile([figName,'.eps'], [folderName, '/.eps']); 
end
    