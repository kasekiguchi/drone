classdef MetaPlayer
    % Plant�̐^�l�ɃA�N�Z�X���O���t�쐬�̂��߂̏��𒊏o���邽�߂̃��[�U�[�N���X
    %   property�͂Ȃ�method��static�̂�
    methods (Static)
        function write(target,field,value)
            %   �ڍא����������ɋL�q
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
            %METHOD1 ���̃��\�b�h�̊T�v�������ɋL�q
            %   �ڍא����������ɋL�q
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

