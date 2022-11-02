// arduino の設定は
// http://trac.switch-science.com/wiki/esp_dev_arduino_ide
// CPU Frequency を 160 MHzにしないとFCにPPMを送れない．
// Cristal frequency 26 MHz
// PPM は　Down pulse
#include <Arduino.h>
#define CPU_FRE 160 // CPUクロック周波数 [MHz]

/////////////////// WiFi関係 ////////////////////
#include <ESP8266WiFi.h> //https://github.com/esp8266/Arduino
#include <WiFiUDP.h>
char packetBuffer[1023];
unsigned int droneNumber = 33; //機体番号を入力
const char *ssid = "ACSLexperimentWiFi";//"acsl-mse-arl-YAMAHA";
const char *password = "wifi-acsl-mse";
WiFiUDP udp;

// ESPrのIPアドレスの設定
IPAddress myIP(192, 168, 50, 100 + droneNumber); // 機体により下番号変更
IPAddress gateway(192, 168, 50, 1);// PCが接続されているネットワークのゲートウェイのIPアドレスを入力する（MATLABのPCのIP）
const int my_udp_port = 8000;        //開放する自ポート
IPAddress subnet(255, 255, 255, 0);

uint8_t old_receive_data = 0;
boolean isReceive_Data_Updated = false;

unsigned long last_received_time;

uint16_t msg;

////////////////// Software Serial /////////////////////////
#include <SoftwareSerial.h>
#define TX (12)
#define RX (14)

SoftwareSerial SSerial(RX,TX,false);//(14, 12, false, 256);
//#define SSerial SoftwareSerial
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
      Serial.print("UDP Received message ");
      Serial.print(" ");
      Serial.print(msg);
      Serial.print(" ");
      Serial.print("\r\n");
      //Serial.printf("Received %d bytes from %s, port %d\n", packetSize, udp.remoteIP().toString().c_str(), udp.remotePort());
      SSerial.println(msg);

      last_received_time = ESP.getCycleCount();
      isReceive_Data_Updated = true;
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
  SSerial.begin(9600);
  SSerial.setTimeout(2000);
  connectToWiFi();
  udp.begin(my_udp_port);
  unsigned long last_received_time = ESP.getCycleCount();

  Serial.println("\nSoftware serial test started");
}

void loop() {
  String aa;
  int f;
  receiveUDP();    
  while (SSerial.available()) {
   // aa = SSerial.readStringUntil('\n');
    //aa = SSerial.read();
    Serial.println("Received from SS : " + SSerial.readStringUntil('\n'));
    if (SSerial.overflow())
    {
      f = 1;
    }else{
      f = 0;
      }
    
    Serial.println("Overflow : " + String(f));
    yield();
  }
}
