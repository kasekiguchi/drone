classdef (Abstract) ESTIMATOR_CLASS < handle
    % Estimator�p���ۃN���X
    properties (Abstract)
%        state % ���茋�ʂ̏��
        result % ��ԈȊO�̐���l
        % sub class�̃R���X�g���N�^���� STATE_CLASS, RESULT_CLASS�ƒ�`����K�v������D
        % �������Ȃ��Ƃ��ׂẴC���X�^���X�ŋ��ʂ�handle���g���񂷂��ƂɂȂ�D
        self
    end
    properties
        name
    end
    
    methods (Abstract)
        result=do(obj,param,~); % param = agent.sensor
        show(obj);
    end
end

