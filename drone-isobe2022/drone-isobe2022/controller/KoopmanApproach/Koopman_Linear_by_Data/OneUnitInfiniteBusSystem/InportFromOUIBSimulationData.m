function data = InportFromOUIBSimulationData()
%INPORTFROMOUIBSIMULATIONDATA 一機無限大母線系統のシミュレーションデータから入出力を抜き出す関数
% data = InportFromOUIBSimulationData()
%   expData_Filename : シミュレーションデータの保存場所
%   data     : 出力変数をまとめる構造体

% 実験データ読み込み
% 読み込むファイル名を指定
expData_Filename = 'OUIBSResult_seedU.mat'

load(expData_Filename);
data.N = data.setting.DataN;

end

