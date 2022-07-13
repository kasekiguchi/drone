% -------------------------------------------------------------------------
% File : TrackObjectiveAutoGen
% Discription : Ganerating the evalation function and constraint automatically
% Environment : MATLAB 2021a
% Author : Sota Wada
% -------------------------------------------------------------------------
%% Global settings
% Initialize previous results and figures
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
[TT,tmp]=regexp(genpath('.'),'\.\\\old.*?;','match','split');
cellfun(@(xx) addpath(xx),tmp,'UniformOutput',false);
close all hidden; clear all; clc;
userpath('clear');
warning('off','all')
%% Parameters
Horizon = 10;
obj.stateNum = 8;
obj.inputNum = 2;
obj.totalNum = obj.stateNum + obj.inputNum;
obj.H = Horizon + 1;
%% Symbolic variables
params.X0   = sym('X0',  [obj.stateNum, 1], 'real');
params.A    = sym('A',   [obj.stateNum, obj.stateNum], 'real');
params.B    = sym('B',   [obj.stateNum, obj.inputNum], 'real');
params.Rl    = sym('Rl',   [obj.inputNum, obj.inputNum], 'real');
params.Ql    = sym('Ql',   [obj.stateNum, obj.stateNum], 'real');
params.Qfl   = sym('Qfl',  [obj.stateNum, obj.stateNum], 'real');
params.Xr   = sym('Xr',  [obj.stateNum, obj.H], 'real');
params.Slew    = sym('Sr', 'real');
params.D_lim  = sym('Dlim',[1,2],'real');
params.behind = sym('behind',[2,obj.H],'real');
x   = sym('x%d%d',[obj.totalNum, obj.H], 'real');
vec = reshape(x, 1, obj.totalNum * obj.H);
%-- MPCで用いる予測状態 Xと予測入力 Uを設定
X = x(1 : obj.stateNum, :);
U = x(obj.stateNum + 1 : obj.totalNum, :);
%% Equality and inequality constraints
%-- 初期状態が現在時刻と一致することと状態方程式に従うことを設定
assumeAlso(X(1,:)~=params.behind(1,:));
assumeAlso(X(5,:)~=params.behind(2,:));
ceqTEMP(1, :) = X(:, 1) - params.X0;
for L = 2:obj.H
    ceqTEMP(L, :) = X(:, L)  - (params.A * X(:, L-1) + params.B * U(:, L-1));
end
ceq = reshape(ceqTEMP, obj.stateNum * obj.H, 1);
%-- スルーレート
cineq(:, 1:(obj.H-1)) = arrayfun(@(L) abs(X(1,L+1)- X(1,L))-params.Slew, 1:obj.H - 1);
cineq(:, obj.H:2*(obj.H-1)) = arrayfun(@(L) abs(X(5,L+1)- X(5,L))-params.Slew, 1:obj.H - 1);
%--後方機体に対する制約
% cineq(:, 2*(obj.H-1)+1:3*(obj.H-1)) = arrayfun(@(L) norm([X(1,L),X(5,L)] - [params.behind(1,L),params.behind(2,L)]) - params.D_lim(1)  , 2:obj.H);
% cineq(:, 3*(obj.H-1)+1:4*(obj.H-1)) = arrayfun(@(L) -norm([X(1,L),X(5,L)] - [params.behind(1,L),params.behind(2,L)]) + params.D_lim(2)  , 2:obj.H);
dceq   = jacobian(ceq  , vec).'; % .' performs transpose
dcineq = jacobian(cineq, vec).'; % .' performs transpose
%% Evaluation function
% モデル予測制御の評価値を計算するプログラム
%-- 状態及び入力に対する目標状態や目標入力との誤差を計算
tildeX = X - params.Xr;
tildeU = U;
%-- 状態及び入力のステージコストを計算
stageState = arrayfun(@(L) tildeX(:, L)' * params.Ql * tildeX(:, L), 1:obj.H-1);
stageInput = arrayfun(@(L) tildeU(:, L)' * params.Rl * tildeU(:, L), 1:obj.H-1);
%-- 状態の終端コストを計算
terminalState = tildeX(:, end)' * params.Qfl * tildeX(:, end);
%-- 評価値計算
eval = sum(stageState + stageInput) + terminalState;
deval = simplify(jacobian(eval,  vec));
heval = simplify(jacobian(deval, vec));
%% Making m-file
% You may need to use currdir = pwd
currdir  = [pwd, filesep];
vars     = {x, params.Ql, params.Qfl, params.Rl, params.Xr};
outputs  = {'eval', 'deval'};
filename = [currdir, 'LautoEval.m'];
matlabFunction(eval, deval, 'file', filename, 'vars', vars, 'outputs', outputs);
vars     = {x, params.Ql, params.Qfl, params.Rl, params.Xr};
outputs  = {'heval'};
filename = [currdir, 'LautoHess.m'];
matlabFunction(heval, 'file', filename, 'vars', vars, 'outputs', outputs);
vars     = {x, params.X0, params.A, params.B, params.Slew, params.D_lim, params.behind};
outputs  = {'cineq', 'ceq', 'dcineq', 'dceq'};
filename = [currdir, 'LautoCons.m'];
matlabFunction(cineq, ceq, dcineq, dceq, 'file', filename, 'vars', vars, 'outputs', outputs);
movefile('LautoCons.m', 'src\gradient');
movefile('LautoHess.m', 'src\gradient');
movefile('LautoEval.m', 'src\gradient');