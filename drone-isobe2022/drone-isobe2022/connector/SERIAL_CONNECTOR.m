classdef SERIAL_CONNECTOR < CONNECTOR_CLASS
  % Serial通信用クラス
  % getData()     : 受信
  % sendData(msg) : msg を送信
  
  properties
    result
    serial
    baudrate
  end
  properties(SetAccess=private)
    port
  end
  methods
    function obj = SERIAL_CONNECTOR(param,option)
      % 通信する対象毎にインスタンスを作成する．
      % param.port : COM num
      % 必要に応じてMac, Linuxに対応させる．
      arguments
        param {mustBeSpecifiedStructure}
        option.baudrate = 115200 % Arduinoと合わせる
      end
      obj.port=param.port;
      obj.baudrate = option.baudrate;
      obj.serial = serialport(obj.port,obj.baudrate,'Timeout',1);
      configureTerminator(obj.serial,"CR/LF");
    end
    
    function result = getData(obj,~)
       % flush(obj.serial);
      obj.result = readline(obj.serial);
      result=obj.result;
    end
    function sendData(obj,param)
      obj.result=[char(param),';'];% 文字列の終わりを陽に指定．terminator をLFにすれば必要ないかも（変更する場合はArduino_serial.inoも変更すること）
      write(obj.serial,obj.result,'uint8');
    end
  end
end

function mustBeSpecifiedStructure(s)
    if ~(isfield(s, 'port'))
        eidType = 'mustBeStructure:notStructure';
        msgType = 'ACSL : Input must be a structure with specified fields.';
        throwAsCaller(MException(eidType, msgType))
    end
end