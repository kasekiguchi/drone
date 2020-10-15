classdef SERIAL_CONNECTOR < CONNECTOR_CLASS
  % UDP�ʐM�p�N���X
  %   
  
  properties
    result
    serial
    baudrate = 115200;
  end
  properties(SetAccess=private)
    port
  end
  methods
    function obj = SERIAL_CONNECTOR(param)
      % �ʐM����Ώۖ��ɃC���X�^���X���쐬����D
      % param.port : COM num
      % �K�v�ɉ�����Mac, Linux�ɑΉ�������D
      obj.port=strcat("COM",string(param.port));
      obj.serial = serialport(obj.port,obj.baudrate,'Timeout',1);
      configureTerminator(obj.serial,"CR/LF");
    end
    
    function result = getData(obj,~)
       % flush(obj.serial);
      obj.result = readline(obj.serial);
      result=obj.result;
    end
    function sendData(obj,param)
      obj.result=[char(param),';'];% ������̏I����z�Ɏw��Dterminator ��LF�ɂ���ΕK�v�Ȃ������i�ύX����ꍇ��ESPr_serial.ino���ύX���邱�Ɓj
      write(obj.serial,obj.result,'uint8');
    end
  end
end

