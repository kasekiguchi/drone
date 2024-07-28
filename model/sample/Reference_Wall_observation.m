function Reference = Reference_Wall_observation()
%% reference class demo
% reference property をReference classのインスタンス配列として定義

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ↓説明 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% このプログラムでは WALL_REFERENCE.m にregion0という想定環境のpolyshapeを作成．
% Reference に入れ，渡します．
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ↓環境項 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp("ACSL : First area should be outer frame.");
region0 = regions(0); %一旦，いろんな形を下の関数に入れて使用する
    function [region0] = regions(Q)
        if Q == 0 % 実験室用
          %% 縦長
%             th=pi:-0.1:-0.1;
%             x1 = [4 0 0 2+2*cos(th) 4];
%             y1 = [0 0 4 4+2*sin(th) 4];
%             %  x1 = [10 0 0 10];
%             %  y1 = [0 0 10 10];
%             x2 = [1.75 1.75 2.25 2.25];
%             y2 = [2.75 3.25 3.25 2.75];
%             region0 = polyshape({x1},{y1}); %ドーナツ形
%             %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
%           %% 横長
%             th=pi/2:-0.1:-pi/2;
%             x1 = [0 0 4 4+2.5*cos(th) 4];
%             y1 = [0 5 5 2.5+2.5*sin(th) 0];
%             %  x1 = [10 0 0 10];
%             %  y1 = [0 0 10 10];
%             x2 = [2.75 2.75 3.25 3.25];
%             y2 = [2.25 2.75 2.75 2.25];
%             region0 = polyshape({x1,x2},{y1,y2}); %ドーナツ形
%             %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
            %% 横長 柱無し
%             th=pi/2:-0.1:-pi/2;
%             x1 = [-2 -2 2 2];
%             y1 = [-1.5 1.5 1.5 -1.5];
%             %  x1 = [10 0 0 10];
%             %  y1 = [0 0 10 10];
%             region0 = polyshape({x1},{y1}); %ドーナツ形
%             %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
            %% 横長 柱有り
            th=pi/2:-0.1:-pi/2;
            x1 = [-1 -1 2 2+2*cos(th) 2];
            y1 = [-2 2 2 2*sin(th) -2];
%             x1 = [-1 -1 3 3 ];
%             y1 = [-2 2 2 -2];
            x2 = [1.3 1.3 2.2 2.2]+0.25;
            y2 = [-0.25 0.25 0.25 -0.25];
            region0 = polyshape({x1,x2},{y1,y2}); %ドーナツ形
        elseif Q == 1 % 実験x.y軸確認用
            th=pi/2:-0.1:-pi/2;
            x1 = [5+5*cos(th) 10 0 0 5];
            y1 = [5+5*sin(th) 0 0 10 10];
            %  x1 = [10 0 0 10];
            %  y1 = [0 0 10 10];
            x2 = [6 4 4 6];
            y2 = [4 4 6 6];
            region0 = polyshape({x1,x2},{y1,y2}); %ドーナツ形
            %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
            xlim([-2 12]);ylim([-2 12])
            
        elseif Q == 2 % 柱と曲面
            th=pi/2:-0.1:-0.1;
            x1 = [5+5*cos(th) 10 0 0 5];
            y1 = [5+5*sin(th) 0 0 10 10];
            %  x1 = [10 0 0 10];
            %  y1 = [0 0 10 10];
            x2 = [6 4 4 6];
            y2 = [4 4 6 6];
            region0 = polyshape({x1,x2},{y1,y2}); %ドーナツ形
            %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
            xlim([-2 12]);ylim([-2 12])
            
        elseif  Q == 3 % 特殊な環境
            thh=0:0.1:2*pi;
            th=0:-0.1:-pi/2;
            x1 = [7 0 0 3 3 0 0 5 5 10 10 14 7+7*cos(th)];
            y1 = [0 0 9 9 10 10 14 14 16 16 14 14 7+7*sin(th)];
            % x2 = [5 3 3 5];
            % y2 = [3 3 5 5];
            x2 = [4.5+1*cos(thh)];%円柱
            y2 = [4.5+1*sin(thh)];%円柱
            x3 = [10 8 8 10];
            y3 = [8 8 10 10];
            region0 = polyshape({x1,x2,x3},{y1,y2,y3}); %ドーナツ形
            %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
            xlim([-2 16]);ylim([-2 18])
            
        elseif  Q == 4 % 柱２
            th=pi/2:-0.1:-0.1;
            x1 = [15 0 0 15];
            y1 = [0 0 15 15];
            x2 = [5 3 3 5];
            y2 = [3 3 5 5];
            x3 = [12 8 8 12];
            y3 = [8 8 12 12];
            region0 = polyshape({x1,x2,x3},{y1,y2,y3}); %ドーナツ形
            xlim([-2 17]);ylim([-2 17]);
        end
    end
Reference.fShow = 1;
Reference.region0 = region0; % region0をWALL_REFERENCEに入れます
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end