// arduino の設定は
// http://trac.switch-science.com/wiki/esp_dev_arduino_ide
// CPU Frequency を 160 MHzにしないとFCにPPMを送れない．
// Cristal frequency 26 MHz
#define CPU_FRE 160 // CPUクロック周波数 [MHz]

/////////////////// SBUS ////////////////////
#include <FUTABA_SBUS_ESPr.h>
#include <Streaming.h>

/////////////////// WiFi関係 ////////////////////
#include <ESP8266WiFi.h> //https://github.com/esp8266/Arduino
#include <WiFiUDP.h>
char packetBuffer[1];
unsigned int droneNumber = 133; //機体番号を入力
const char *ssid = "ACSLexperimentWiFi";//"acsl-mse-arl-YAMAHA";
const char *password = "wifi-acsl-mse";
WiFiUDP udp;

// ESPrのIPアドレスの設定
IPAddress myIP(192, 168, 50, droneNumber); // 機体により下番号変更
IPAddress gateway(192, 168, 50, 1);// PCが接続されているネットワークのゲートウェイのIPアドレスを入力する（MATLABのPCのIP）
const int my_udp_port = 8000;        //開放する自ポート
IPAddress subnet(255, 255, 255, 0);

unsigned long last_received_time;

uint16_t msg;

////////////////// Software Serial /////////////////////////
#include <SoftwareSerial.h>
#define TX (12)
#define RX (14)

//SoftwareSerial SSerial(RX,TX,false);//(14, 12, false, 256);

FUTABA_SBUS sBus;



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
  Serial.println(WiFi.localIP());
  Serial.println(my_udp_port);
}


void receiveUDP()// ---------- loop function : receive signal by UDP
{
  int packetSize = udp.parsePacket();
  if (packetSize)
  {
    int len = udp.read(packetBuffer, packetSize);
    if (len > 0)
    {
      msg = int(packetBuffer[0]); 
      Serial.print("Received message ");
      Serial.print(" ");
      Serial.print(msg);
      Serial.print(" ");
      Serial.print("\r\n");
      //Serial.printf("Received %d bytes from %s, port %d\n", packetSize, udp.remoteIP().toString().c_str(), udp.remotePort());
      //SSerial.println(msg);

      last_received_time = ESP.getCycleCount();
    }
     else if (ESP.getCycleCount() - last_received_time >= 0.500 * CPU_FRE * 1000000L)// Stop propellers after 0.5s signal lost.
    {
      Serial.print("Set :[ ");
      Serial.print(0);
      Serial.print(" ]\r\n");
    }
  }
}


void setup() {
  Serial.begin(115200);
  //sBus.begin(SSerial);
  sBus.begin();

//  connectToWiFi();
//  udp.begin(my_udp_port);
  unsigned long last_received_time = ESP.getCycleCount();

  Serial.println("\nSoftware serial test started");
}

void loop() {
//  receiveUDP();
    sBus.FeedLine();
    delay(500);
    Serial.print(".");
  if (sBus.toChannels == 1){
//    sBus.UpdateServos();
    sBus.UpdateChannels();
    sBus.toChannels = 0;
    Serial<<sBus.channels[0]<<","<<sBus.channels[1]<<","<<sBus.channels[2]<<"\r\n";
  }
  
/*  while (SSerial.available() > 0) {
    Serial.println("Received from SS : " + SSerial.readStringUntil('\n'));
    yield();
  }
  */
}
