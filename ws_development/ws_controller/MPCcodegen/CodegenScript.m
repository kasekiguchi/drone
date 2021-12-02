%codegen script
%codegenを使用してmexファイルを吐き出すためのプログラム

cfg = coder.config('mex');
% argInputValue = {problem.x0,obj.param};
inputArgs=[ {'fminconMEX_Fimobjective'};                     % ファイル名
                {'-config'};{cfg};              % 作成された設定を指定
                {'-report'};                    % 出力結果レポートを作成
%                 {'-args'};{argInputValue};    % assertを使用しない場合にはargInputValueに入れる
%                 {'-o'};{outName};             % 出力ファイル名を指定する場合にはoutNameに入れる
%                 {'-profile'};                 % プロファイラを使用する場合には有効化(遅くなるので非推奨)
              ];
    codegen(inputArgs{:})
