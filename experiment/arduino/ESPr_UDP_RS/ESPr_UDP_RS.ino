// UDP 通信テンプレート
// receive and send
// arduino の設定は
// http://trac.switch-science.com/wiki/esp_dev_arduino_ide
// CPU Frequency を 160 MHzにしないとFCにPPMを送れない．
// PPM は　Down pulse
#include <Arduino.h>
#include <ESP8266WiFi.h> //https://github.com/esp8266/Arduino
#include <WiFiUDP.h>
#define CPU_FRE 160 // CPUクロック周波数 [MHz]
#include <math.h>

uint16_t msg;
char packetBuffer[1];

/////////////////// WiFi関係 ////////////////////
unsigned int droneNumber = 132; //機体番号を入力

const char *ssid = "ACSLexperimentWiFi";
const char *password = "wifi-acsl-mse";
// ESPrのIPアドレスの設定
IPAddress myIP(192, 168, 50, droneNumber);  // 機体により下番号変更

IPAddress gateway(192, 168, 50, 1);// PCが接続されているネットワークのゲートウェイのIPアドレスを入力する（MATLABのPCのIP）
const int my_udp_port = 8000;        //開放する自ポート
IPAddress subnet(255, 255, 255, 0);

// 値を受け取るMatlabを実行しているPCのIP(自分のPCのIPアドレスを入力する)
const char *to_udp_address = "192.168.50.17"; //送信先のアドレス
const int to_udp_port = my_udp_port;               //送信相手のポート番号

WiFiUDP udp;

boolean connected = false;
boolean isReceive_Data_Updated = false;

unsigned long t_now;
unsigned long last_received_time;

//*********** local functions  *************************//
void connectToWiFi()// ---- setup connection to wifi
{
  WiFi.begin(ssid, password);
  WiFi.config(myIP, gateway, subnet);
  Serial.println("start_connect");
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println("CONNECTED!");

  Serial.println("WiFi connected");
  Serial.print("Local IP address: ");
  Serial.println(myIP);
  Serial.println(WiFi.localIP());
}

void receiveUDP()// ---------- loop function : receive signal by UDP
{
   int incomingByte = 0;
    // データを受信した場合にのみ，データを送信する
    if (Serial.available() > 0) {
         // 受信したデータの1バイトを読み取る
        incomingByte = Serial.read();
        udp.send(incomingByte);
    }


}

void sendUDP()// ---------- loop function : send signal by UDP
{
  int packetSize;
  Serial.read
  if (packetSize)
  {
    int len = udp.read(packetBuffer, packetSize);
    if (len > 0)
    {
        msg = uint16_t(packetBuffer[0]);

        Serial.print("Received :[");
        for (i = 0; i < TOTAL_CH; i++)
        {
          Serial.print(" ");
          Serial.print(pw[i]);
          Serial.print(" ");
        }
        Serial.print("]\r\n");
      //Serial.printf("Received %d bytes from %s, port %d\n", packetSize, udp.remoteIP().toString().c_str(), udp.remotePort());

      last_received_time = ESP.getCycleCount();
      isReceive_Data_Updated = true;
    }
  else if (ESP.getCycleCount() - last_received_time >= 2.000 * CPU_FRE * 1000000L)// Stop propellers after 0.5s signal lost. 
  {
    // time out case 
  }
  }
}


// ==================================================================
void setup()
{
  Serial.begin(115200);
  connectToWiFi();
  udp.begin(my_udp_port);
}

void loop()
{
  receiveUDP();
  sendUDP();
}
