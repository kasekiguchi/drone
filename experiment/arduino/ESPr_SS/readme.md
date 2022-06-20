# 使い方

ライブラリマネージャーでEspSoftwareSerialをインストールし実行する．

以下のプログラム
１．設定したIP経由のUDP通信で送られてきた信号をシリアルモニターに描画し，Software シリアルにそのまま流す．
２．Software シリアルで受信したデータをシリアルモニターに表示する．

２台のESPr のIO12とIO14をクロスするように接続し，それぞれ別々のIPでESPr_SSを書き込み，それぞれのシリアルモニターを立ち上げる．

MATLAB共通プログラムにパスが通った状態で以下を実行（IP1,IP2は上で設定したIP）
agent1 = DRONE(Model_Drone_Exp([],[],"udp",[IP1]),DRONE_PARAM("DIATONE"));
agent2 = DRONE(Model_Drone_Exp([],[],"udp",[IP2]),DRONE_PARAM("DIATONE"));

agent1.plant.connector.sendData(int8([10]));

両方のシリアルモニターに10が表示される
シリアルモニターに何も表示されない場合はESPrのリセットボタンを押す．
