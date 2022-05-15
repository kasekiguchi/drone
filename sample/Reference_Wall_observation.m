function Reference = Reference_Wall_observation()
%% reference class demo
% reference property ��Reference class�̃C���X�^���X�z��Ƃ��Ē�`
clear Reference
Reference.type=["WALL_REFERENCE"];
Reference.name=["wall"];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���̃v���O�����ł� WALL_REFERENCE.m ��region0�Ƃ����z�����polyshape���쐬�D
% Reference.param �ɓ���C�n���܂��D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp("ACSL : First area should be outer frame.");
region0 = regions(0); %��U�C�����Ȍ`�����̊֐��ɓ���Ďg�p����
    function [region0] = regions(Q)
        if Q == 0 % �������p
          %% �c��
%             th=pi:-0.1:-0.1;
%             x1 = [4 0 0 2+2*cos(th) 4];
%             y1 = [0 0 4 4+2*sin(th) 4];
%             %  x1 = [10 0 0 10];
%             %  y1 = [0 0 10 10];
%             x2 = [1.75 1.75 2.25 2.25];
%             y2 = [2.75 3.25 3.25 2.75];
%             region0 = polyshape({x1},{y1}); %�h�[�i�c�`
%             %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
%           %% ����
%             th=pi/2:-0.1:-pi/2;
%             x1 = [0 0 4 4+2.5*cos(th) 4];
%             y1 = [0 5 5 2.5+2.5*sin(th) 0];
%             %  x1 = [10 0 0 10];
%             %  y1 = [0 0 10 10];
%             x2 = [2.75 2.75 3.25 3.25];
%             y2 = [2.25 2.75 2.75 2.25];
%             region0 = polyshape({x1,x2},{y1,y2}); %�h�[�i�c�`
%             %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
            %% ���� ������
%             th=pi/2:-0.1:-pi/2;
%             x1 = [-2 -2 2 2];
%             y1 = [-1.5 1.5 1.5 -1.5];
%             %  x1 = [10 0 0 10];
%             %  y1 = [0 0 10 10];
%             region0 = polyshape({x1},{y1}); %�h�[�i�c�`
%             %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
            %% ���� ���L��
            th=pi/2:-0.1:-pi/2;
            x1 = [-1 -1 2 2+2*cos(th) 2];
            y1 = [-2 2 2 2*sin(th) -2];
%             x1 = [-1 -1 3 3 ];
%             y1 = [-2 2 2 -2];
            x2 = [1.3 1.3 2.2 2.2]+0.25;
            y2 = [-0.25 0.25 0.25 -0.25];
            region0 = polyshape({x1,x2},{y1,y2}); %�h�[�i�c�`
        elseif Q == 1 % ����x.y���m�F�p
            th=pi/2:-0.1:-pi/2;
            x1 = [5+5*cos(th) 10 0 0 5];
            y1 = [5+5*sin(th) 0 0 10 10];
            %  x1 = [10 0 0 10];
            %  y1 = [0 0 10 10];
            x2 = [6 4 4 6];
            y2 = [4 4 6 6];
            region0 = polyshape({x1,x2},{y1,y2}); %�h�[�i�c�`
            %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
            xlim([-2 12]);ylim([-2 12])
            
        elseif Q == 2 % ���ƋȖ�
            th=pi/2:-0.1:-0.1;
            x1 = [5+5*cos(th) 10 0 0 5];
            y1 = [5+5*sin(th) 0 0 10 10];
            %  x1 = [10 0 0 10];
            %  y1 = [0 0 10 10];
            x2 = [6 4 4 6];
            y2 = [4 4 6 6];
            region0 = polyshape({x1,x2},{y1,y2}); %�h�[�i�c�`
            %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
            xlim([-2 12]);ylim([-2 12])
            
        elseif  Q == 3 % ����Ȋ�
            thh=0:0.1:2*pi;
            th=0:-0.1:-pi/2;
            x1 = [7 0 0 3 3 0 0 5 5 10 10 14 7+7*cos(th)];
            y1 = [0 0 9 9 10 10 14 14 16 16 14 14 7+7*sin(th)];
            % x2 = [5 3 3 5];
            % y2 = [3 3 5 5];
            x2 = [4.5+1*cos(thh)];%�~��
            y2 = [4.5+1*sin(thh)];%�~��
            x3 = [10 8 8 10];
            y3 = [8 8 10 10];
            region0 = polyshape({x1,x2,x3},{y1,y2,y3}); %�h�[�i�c�`
            %  region0 = polyshape([5+5*cos(th) 10 0 0 5],[5+5*sin(th) 0 0 10 10]);
            xlim([-2 16]);ylim([-2 18])
            
        elseif  Q == 4 % ���Q
            th=pi/2:-0.1:-0.1;
            x1 = [15 0 0 15];
            y1 = [0 0 15 15];
            x2 = [5 3 3 5];
            y2 = [3 3 5 5];
            x3 = [12 8 8 12];
            y3 = [8 8 12 12];
            region0 = polyshape({x1,x2,x3},{y1,y2,y3}); %�h�[�i�c�`
            xlim([-2 17]);ylim([-2 17]);
        end
    end
Reference.param.region0 = region0; % region0��WALL_REFERENCE�ɓ���܂�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end