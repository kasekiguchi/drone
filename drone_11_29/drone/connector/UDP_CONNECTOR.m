classdef UDP_CONNECTOR < CONNECTOR_CLASS
  % UDP通信用クラス
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
      % 通信する対象毎にインスタンスを作成する．
      %  param.IP : 通信対象のIPアドレス
      obj.IP=param.IP;
      if isfield(param,'port')
        obj.port=param.port;
      else
          %obj.port = 25000;% matlab dsp のdefault value
          obj.port = 8000;% 
      end
      obj.sender=dsp.UDPSender('RemoteIPAddress',char(obj.IP),'RemoteIPPort',obj.port);
      obj.receiver=dsp.UDPReceiver('RemoteIPAddress',char(obj.IP),'LocalIPPort',obj.port,'ReceiveBufferSize',140);
      setup(obj.receiver);
    end
    
    function result = getData(obj,~)
      % udp receiverでのデータ受信
      obj.result = obj.receiver();
      result=obj.result;
    end
    function sendData(obj,param)
      % udp senderでのデータ受信
      obj.sender(param);
    end
  end
end

