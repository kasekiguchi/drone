classdef UDP_CONNECTOR < CONNECTOR_CLASS
  % UDP�ʐM�p�N���X
  %   
  
  properties
    sender
    receiver
    result
  end
  properties(SetAccess=private)
    IP
    port
  end
  methods
    function obj = UDP_CONNECTOR(param)
      % �ʐM����Ώۖ��ɃC���X�^���X���쐬����D
      %  param.IP : �ʐM�Ώۂ�IP�A�h���X
      obj.IP=param.IP;
      if isfield(param,'port')
        obj.port=param.port;
      else
          %obj.port = 25000;% matlab dsp ��default value
          obj.port = 8000;% 
      end
      obj.sender=dsp.UDPSender('RemoteIPAddress',char(obj.IP),'RemoteIPPort',obj.port);
      obj.receiver=dsp.UDPReceiver('RemoteIPAddress',char(obj.IP),'LocalIPPort',obj.port,'ReceiveBufferSize',140);
      setup(obj.receiver);
    end
    
    function result = getData(obj,~)
      % udp receiver�ł̃f�[�^��M
      obj.result = obj.receiver();
      result=obj.result;
    end
    function sendData(obj,param)
      % udp sender�ł̃f�[�^��M
      obj.sender(param);
    end
  end
end

