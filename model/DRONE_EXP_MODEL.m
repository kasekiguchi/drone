classdef DRONE_EXP_MODEL < MODEL_CLASS
  % Lizard 実験用モデル
  properties% (Access=private)
    ESPr_num
    connector
    flight_phase % q : quit, s : stop, a : arming, t : take-off, h : hovering, f : flight, l : landing
  end
  properties
    msg
    arming_msg = [500 500 0 500 1000 0 0 0];% [ uroll, upitch, uthr, uyaw, AUX_1, AUX_2, AUX_3, AUX_4];
    stop_msg = [500 500 0 500 0 0 0 0];
  end


  methods
    function obj = DRONE_EXP_MODEL(varargin)
      obj@MODEL_CLASS(varargin{:});      
      param=varargin{2}.param;
      obj.dt = 0.025;
      %% variable set
      obj.flight_phase        = 's';
      switch param.conn_type
        case "udp"
          obj.ESPr_num = param.num;
          param.IP = char("192.168." + obj.ESPr_num(1) + "." + obj.ESPr_num(2));
          param.port=8000;
          obj.connector=UDP_CONNECTOR(param);
          fprintf("Drone %s is ready\n",param.IP);
        case "serial"
          if isnumeric(param.port)
            % param.port = strcat("COM",string(param.port));
            param.port = string(param.port);
          else
            param.port = char(param.port);
          end
          obj.connector=SERIAL_CONNECTOR(param);
          fprintf("Drone %s is ready\n",param.port);
      end
    end
    function do(obj,varargin)
      %%u = gen_msg(varargin{5}.inner_input.result');
      u = varargin{5}.input_transform.result;
      cha = varargin{2};
      obj.flight_phase=cha;
      switch cha
        case 'q'  % quit
          obj.connector.sendData(gen_msg(obj.stop_msg));
          error("ACSL : quit experiment");
        case 's' % stop pro
          %                        uroll   = 500;     upitch  = 500;     uthr    =  0;     uyaw    = 500;
          %                        AUX_1   =  0;     AUX_2   =  0;     AUX_3   =  0;     AUX_4   = 0;
          msg(1,1:8) = obj.stop_msg;
        case 'a' % arming
          %                        uroll   = 500;     upitch  = 500;     uthr    =  0;     uyaw    = 500;
          %                        AUX_1   = 1000;     AUX_2   =  0;     AUX_3   =  0;     AUX_4   =  0;
          msg(1,1:8) = obj.arming_msg;
        case 'f' % flight
          msg(1,1:8) = u;
        case 'l' % landing
          msg(1,1:8) = u;
        case 't' % take off
          msg(1,1:8) = u
      end
      obj.connector.sendData(gen_msg(msg));
      obj.msg=msg;
    end
    function arming(obj)
      obj.connector.sendData(gen_msg(obj.arming_msg));
    end
    function stop(obj)
      obj.connector.sendData(gen_msg([500 500 0 500 0 0 0 0]));
    end
  end
end

