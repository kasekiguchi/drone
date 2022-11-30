function Reference = Reference_ceiling(f_name,param)
% list: 1:N etc
% f_name : functin name
% reference property をReference classのインスタンス配列として定義
clear Reference
Reference.type=["ceiling_reference"];
Reference.name=["ceiling"];
Reference.param={f_name,param,"HL"};
end
