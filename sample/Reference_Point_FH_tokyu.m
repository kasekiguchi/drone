function Reference = Reference_Point_FH_tokyu(~)
%% 必須のリファレンス生成用
% Figure handleを使って a,t,f,l,s,q のキーボード入力によって動作を変えるために必要
% 単体ではfで目標点を生成
% 組み合わせることでf を押したときにこれより前に設定したリファレンスになる
clear Reference
Reference.type=["POINT_REFERENCE_FH_tokyu"];
Reference.name=["CeilingPoint"];
Reference.param=[];
end


