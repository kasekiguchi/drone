classdef LSM9DS1 < SENSOR_CLASS
    % �X��IMU�Z���T�[(LSM9DS1)�p�N���X
    % Suppose the sensor mounted on espr implemented ESPr_UDP.ino.
    %  sensor.imu = LSM9DS1(self, ~)
    %       self : agent
    %  result = sensor.imu.do();
    %  result.state has fields
    %        q  :  euler angle : yaw does not correct
    %        w :  angular velocity
    %        a : acceleration
    %        mag : compass
    properties
        name      = "LSM9DS1";
        result
        espr
        self
        interface = @(x) x;
        old_time
        time
        init_state
    end
    
    methods
        function obj = LSM9DS1(self,~)
            obj.self = self;
            obj.espr = self.plant.espr;
            obj.result.state.state_list=["q","w","a","mag"];
            obj.result.state.num_list=[length(self.model.state.q),3,3,3]; % model�ƍ��킹��
            obj.result.state=STATE_CLASS(obj.result.state); % STATE_CLASS�Ƃ��ăR�s�[
        end
        function initialize(obj,varargin)
            % calibration
            if isempty(varargin)
                k=10;
            else
                k = varargin{1};
            end
            obj.init_state.q=0;
            obj.init_state.w=0;
            obj.init_state.a=0;
            obj.init_state.mag=0;
            i=0; j = 0;
            while i < k && j < 100% 10�v���̕��ς��Ƃ�D
                % �����炩��f�[�^�𑗂�Ȃ��ƃf�[�^�𑗂��Ă��Ȃ��D
                obj.espr.sendData(uint8([11,11,6,11,6,6,6,6,0,0,0,0,0,0,0,0]));
                pause(0.005);% wait 5ms
                dataR=obj.espr.getData()';
                if ~isempty(dataR)
                    dataS=arrayfun(@(i) char(dataR(i)),1:length(dataR));
                    obj.init_state.w = obj.init_state.w+[str2double(dataS(10:19));-str2double(dataS(21:30));str2double(dataS(32:41))];
                    obj.init_state.a = obj.init_state.a+10*[-str2double(dataS(43:52));str2double(dataS(54:63));-str2double(dataS(65:74))];
                    obj.init_state.mag = obj.init_state.mag+[str2double(dataS(76:85));str2double(dataS(87:96));str2double(dataS(98:107))];
                    obj.init_state.q = obj.init_state.q+[-str2double(dataS(109:118));str2double(dataS(120:129));-str2double(dataS(131:140))];
                    i = i+1;
                end
                j = j+1;
            end
            if j==100
                error("ACSL : LSM9DS1's initilization failure. \n Check the connection to ESPr");
            end
            obj.init_state.q = obj.init_state.q/i;
            obj.init_state.w = obj.init_state.w/i;
            obj.init_state.a = obj.init_state.a/i;%-[0;0;-9.80665];
            obj.init_state.mag = obj.init_state.mag/i;
        end
        function result=do(obj,varargin)
            % result=sensor.imu.do()
            %   result : dt and state = q,w,a,mag
            trial = 5; % ��M�����s�������ɌJ��Ԃ���
            while trial > 0
                if isempty(obj.init_state)
                    warning("ACSL : initialize first.");
                    obj.initialize();
                end
            dataR=obj.espr.getData()';
                if ~isempty(dataR)
                    dataS=arrayfun(@(i) char(dataR(i)),1:length(dataR));
                    obj.time=str2double(dataS(1:8));
                    obj.result.state.set_state('w',[str2double(dataS(10:19));-str2double(dataS(21:30));str2double(dataS(32:41))]-obj.init_state.w);
                    obj.result.state.set_state('a',10*[-str2double(dataS(43:52));str2double(dataS(54:63));-str2double(dataS(65:74))]);
                    obj.result.state.set_state('mag',[str2double(dataS(76:85));str2double(dataS(87:96));str2double(dataS(98:107))]);
                    obj.result.state.set_state('q',[-str2double(dataS(109:118));str2double(dataS(120:129));-str2double(dataS(131:140))]);
                    obj.result.dt=(obj.time-obj.old_time)/1000;% [s]
                    obj.old_time=obj.time;
                    obj.result.check = 1;% �ʐM����
                    trial = 0;
                else
                    trial=trial-1;
                    obj.self.plant.espr.sendData(obj.self.plant.msg);     % �Ō�ɑ������M���𑗂�Ȃ����D               
                    pause(0.001);% wait 1ms
                    obj.result.check = 0;% �ʐM���s
                end
            end
            if obj.result.check==0
                warning("ACSL : Receive udp data failed.");
            end
            result= obj.result;% ��M�Ɏ��s������ߋ��̒l���̂܂�
        end
        function show(obj,varargin)
            if ~isempty(obj.result)
            else
                disp("do measure first.");
            end
        end
    end
end
