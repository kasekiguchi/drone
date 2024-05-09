fExp = 1;
% initialも設定しておく
agent = Drone(Model_Lizard_exp(dt,'plant',initial,"serial",[COM3])); 
	% COM：機体番号（ArduinoのCOM番号）
msg=gen_msg([500,500,0,500,0,0,0,0]);
agent.plant.connector.sendData(msg);
