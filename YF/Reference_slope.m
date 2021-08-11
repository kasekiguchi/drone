function Reference = Reference_slope(~,param)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
clear Referenceh
Reference.type=["slope_input"];
Reference.name=["slope"];
id = param{2};
if strcmp('Like H',param{1}.txt)
    refP = [0 0;0 10;3 10;3 0]';
    select_probability = [0.25;0.25;0.25;0.25];
elseif strcmp('Like 6',param{1}.txt)
    refP = [1 10]';
    select_probability = [1];
elseif strcmp('straight',param{1}.txt)
    refP =[3 1;3 7]';
    if rem(param{2},2)==0
        select_probability = [1;0];
    else
        select_probability = [0;1];
    end
    
elseif strcmp('TCU 2F',param{1}.txt)
    refP = [3 5;15 5;5 -2;9 -2;13 -2;5 12;9 12;13 12]';
    [~,m] = size(refP);
select_probability = [1/m;1/m;1/m;1/m;1/m;1/m;1/m;1/m]; 
elseif strcmp('8widths straight',param{1}.txt)
    refP = [5 1;5 59]';
    [~,m] = size(refP);
select_probability = [1/m;1/m]; 
elseif strcmp('3widths straight',param{1}.txt)
    refP = [2 1;2 19]';
    if param{2}>param{3}/2
        select_probability = [0;1];
    else
        select_probability = [1;0];
    end
    elseif strcmp('十字路',param{1}.txt)
    refP = [-5 8;8 -5;21 8;8 21]';
    [~,m] = size(refP);
select_probability = [1/m;1/m;1/m;1/m]; 
end

Reference.param={[refP],[select_probability],id,param{1}};

end
