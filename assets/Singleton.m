classdef Singleton < handle
  % プログラムを実行するコンピュータ自身の仮想クラス
  %  singleton patternで構成
  
  properties (Access=private,Constant)
    %computer=Singleton();
  end
  properties %(Access=private)
    IP
    sampling
  end
  
  methods (Access=private)
    function obj = Singleton()
      % コンストラクタ：privateにすることでsingletonにする．
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
  methods % 必要ない
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

