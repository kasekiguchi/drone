classdef (Abstract) REFERENCE_CLASS < handle
    %UNTITLED9 このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        %state % 目標状態
        result % 状態以外の算出結果
    end
    
    methods (Abstract)
        do(obj,param);
        show(obj);
    end
end

