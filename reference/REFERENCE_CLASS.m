classdef (Abstract) REFERENCE_CLASS < handle
    %UNTITLED9 ���̃N���X�̊T�v�������ɋL�q
    %   �ڍא����������ɋL�q
    
    properties
        %state % �ڕW���
        result % ��ԈȊO�̎Z�o����
    end
    
    methods (Abstract)
        do(obj,param);
        show(obj);
    end
end

