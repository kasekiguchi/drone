classdef MetaPlayer
    % Plantの真値にアクセスしグラフ作成のための情報を抽出するためのユーザークラス
    %   propertyはなくmethodもstaticのみ
    methods (Static)
        function write(target,field,value)
            %   詳細説明をここに記述
            target.(field)=value;
        end
        function write_subfield(target,field,subfield,value)
            %   
            tmp=target.(field);
            for i = 1:length(subfield)
                tmp.(subfield(i))=value{i};
            end
        end
        
        function output=read(target,field)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            output=target.(field);
        end
        function do(target,method,args)
            target.(method)(args);
        end
        function do_field_method(target,method,args)
            tmp = target.(method(1));
            for i = 2:length(method)-1
                tmp=tmp.(method(i));
            end
            tmp.(method(end))(args);
        end
    end
end

