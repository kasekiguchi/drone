classdef (Abstract) CONNECTOR_CLASS < handle
    % Connector �N���X
    %   �Z���T�[�Ƃ̈Ⴂ�̓f�[�^�̑���M�����邩�ǂ����D�FROS��Wifi�Ȃǂ͑o�����ʐM
    %   �@�̈ˑ����ǂ����@�FPrime ��global���ŋ@�̈ˑ��ł͂Ȃ�
    %  �T�u�N���X�ł�getData(packet), sendData(packet) �ǂ��炩�C�܂��͗�������������K�v������D
    properties
       % data
    end
    
    methods (Abstract)
       % getData(obj);
       % sendData(obj);
    end
end
