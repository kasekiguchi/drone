classdef Singleton < handle
  % �v���O���������s����R���s���[�^���g�̉��z�N���X
  %  singleton pattern�ō\��
  
  properties (Access=private,Constant)
    %computer=Singleton();
  end
  properties %(Access=private)
    IP
    sampling
  end
  
  methods (Access=private)
    function obj = Singleton()
      % �R���X�g���N�^�Fprivate�ɂ��邱�Ƃ�singleton�ɂ���D
      obj.IP="";
    end
  end
  methods (Static)
    function obj = getInstance()
      persistent uniqueInstance
      if isempty(uniqueInstance)
          obj=Singleton();
          uniqueInstance=obj;
      else
        obj=uniqueInstance;
      end
    end
  end
  methods % �K�v�Ȃ�
    function set_properties(obj,param)
      F = fieldnames(param);
      for i = 1:length(F)
        obj.(F{i})=param.(F{i});
      end
    end
    function ans=get_properties(obj,param)
      F = fieldnames(param);
      for i = 1:length(F)
        ans.(F{i})=obj.(F{i});
      end
    end
  end
end

