%% GUI projectの情報を用いたパラメータ解析
% 2つの交点式から一括でパラメータ推定するやつ
%% Initialize settings
% set path
clear
cf = pwd;
if contains(mfilename('fullpath'),"mainGUI")
  cd(fileparts(mfilename('fullpath')));
else
  tmp = matlab.desktop.editor.getActive; 
  cd(fileparts(tmp.Filename));
end
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
% cd(cf); close all hidden; clear all; userpath('clear');

%% フラグ設定
illustration= 1; %1で図示，0で非表示

%% Log Dataの読み取りと格納
log = LOGGER('./Data/2wall_1015_Log(10-Jul-2023_14_31_32).mat');
% log = LOGGER('./Data/nomove_little_Log(14-Jul-2023_00_53_31).mat');

%% パラメータ真値
offset_true = [0.1;0.05;0.05];
Rs_true = Rodrigues([0.5,0.5,1],pi/12);
%% ログ
tspan = [0 ,100];
% tspan = [0 99];
robot_p  = log.data(1,"p","s")';
robot_pt  = log.data(1,"p","p")';
robot_vt  = log.data(1,"v","p")';
robot_q  = log.data(1,"q","s")';
robot_qt  = log.data(1,"q","p")';
sensor_data = (log.data(1,"length","s"))';
ref_p = log.data(1,"p","r")';
ref_q = log.data(1,"q","r")';

%% 不要データの除去
nanIndices = isnan(sensor_data(1,:));
ds = find(nanIndices==1);
sensor_data(:,ds) = [];

robot_p(:,ds) = [];
robot_pt(:,ds) = [];
robot_q (:,ds) = [];
robot_qt(:,ds) = [];


%% 解析(回帰分析)
end1=10000;
num = 3;%2本目センサのいっぽん目からの本数
% [A,X,At,Xt] = param_analysis(robot_pt(:,1:end1-1),robot_qt(:,1:end1-1),sensor_data(1,2:end1),eye(3));
% [A,X,At,Xt] = param_analysis2(robot_pt(:,1:end1-1),robot_qt(:,1:end1-1),sensor_data(1,2:end1),sensor_data(2,2:end1),Rodrigues([0,0,1],pi/20));

%% 一括でパラ推定
[A,X,At,Xt] = param_analysis2(robot_pt(:,1),robot_qt(:,1),sensor_data(1,1),sensor_data(2,1),Rodrigues([0,0,1],pi/20));
A_stack=[];
for i=1:length(robot_pt)
    qt = Eul2Quat(robot_qt(:,i));
    qt = qt./vecnorm(qt,2);
    A = Cf2_sens(robot_pt(:,i),qt,sensor_data(1,i),sensor_data(2,i),Rodrigues([0,0,1],pi/20));
    ds = find(A(2,:)==0);
    A(:,ds)=[];
    A_stack=[A_stack;A];
end
%% 疑似逆とパラ計算
X = pinv(A_stack)*(-1*ones(size(A_stack,1),1));
offset = pinv([X(1)*eye(3);X(2)*eye(3);X(3)*eye(3)])*[X(4:12)];
Rsx = pinv([X(1)*eye(3);X(2)*eye(3);X(3)*eye(3)])*[X(13:15);X(19:21);X(25:27)];
%% 一括でパラ推定逐次
[A,X,At,Xt] = param_analysis2(robot_pt(:,1),robot_qt(:,1),sensor_data(1,1),sensor_data(2,1),Rodrigues([0,0,1],pi/20));
P_stack = zeros(size(A,2),size(A,2),length(robot_pt));
[Xn,Pn] = param_analysis_eq(A',zeros(size(A,2),1),-1*ones(size(A,1),1),eye(size(A,2)));
P_stack(:,:,1) = Pn;
for j=2:1:size(P_stack,3)  
    qt = Eul2Quat(robot_qt(:,j));
    qt = qt./vecnorm(qt,2);
    A = Cf2_sens(robot_pt(:,j),qt,sensor_data(1,j),sensor_data(2,j),Rodrigues([0,0,1],pi/20));
    ds = find(A(2,:)==0);
    A(:,ds)=[];
    [Xn,Pn] = param_analysis_eq(A',Xn,-1*ones(size(A,1),1),Pn);
    P_stack(:,:,j) = Pn;
end

function [A,X,Cf,var] = param_analysis2(robot_p, robot_q, sensor_data,sensor_data2,R_num)
    syms p [3 1] real
    syms Rb [3 3] real
    syms y y2 real 
    syms Rs [3 3] real
    syms Rn [3 3] real
    syms psb [3 1] real
    syms a b c d real
    
    A = [a b c];
    X = p +Rb*psb + y*Rb*Rs*[1;0;0];
    X2 = p +Rb*psb + y2*Rb*Rs*Rn*[1;0;0];
    %%
    eq =[A d]*[X;1];
    eq2 =[A d]*[X2;1];
    var=[a.*psb',b.*psb',c.*psb',reshape(a*Rs,1,numel(Rs)),reshape(b*Rs,1,numel(Rs)),reshape(c*Rs,1,numel(Rs))];
    for i = 1:length(var)
    Cf(i) = subs(simplify(eq-subs(expand(eq),var(i),0)),var(i),1);
    end
    for i = 1:length(var)
    Cf2(i) = subs(simplify(eq2-subs(expand(eq2),var(i),0)),var(i),1);
    end
    Cf = [p1,p2,p3,Cf];
    Cf2 = [p1,p2,p3,Cf2];
    Cf12 =[Cf;Cf2];
    var = [a,b,c,var]/d;
    simplify([eq/d;eq2/d] - Cf12*var' ) 
    qt = Eul2Quat(robot_q);
    qt = qt./vecnorm(qt,2);
    A = Cf2_sens(robot_p,qt,sensor_data,sensor_data2,R_num);
    ds = find(A(2,:)==0);
    Cf(ds)=[];
    var(ds)=[];
    A(:,ds)=[];
    X = pinv(A)*(-1*ones(size(A,1),1));
end
