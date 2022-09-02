// arduino の設定は
// http://trac.switch-science.com/wiki/esp_dev_arduino_ide
// CPU Frequency を 160 MHzにしないとFCにPPMを送れない．
// PPM は　Down pulse
#include <Arduino.h>
#include <ESP8266WiFi.h> //https://github.com/esp8266/Arduino
#include <WiFiUDP.h>
#define CPU_FRE 160 // CPUクロック周波数 [MHz]

char packetBuffer[1];

/////////////////// WiFi関係 ////////////////////
unsigned int droneNumber = 131; //機体番号を入力
//const char *ssid = "ACSLexperimentWiFi";//"acsl-mse-arl-YAMAHA";
//const char *password = "wifi-acsl-mse";
const char *ssid = "ACSL-Drone-Hotspot";//"acsl-mse-arl-YAMAHA";
const char *password = "1qaz2wsx";
WiFiUDP udp;

// ESPrのIPアドレスの設定
IPAddress myIP(192, 168, 50, droneNumber); // 機体により下番号変更
IPAddress gateway(192, 168, 50, 1);// PCが接続されているネットワークのゲートウェイのIPアドレスを入力する（MATLABのPCのIP）
const int my_udp_port = 8000;        //開放する自ポート
IPAddress subnet(255, 255, 255, 0);

unsigned long last_received_time;

////////////// PWM ////////////////////
#define PWMA 2
#define PWM_FREQ 24000 // PWM frequency: 1000Hz(1kHz)
#define PWM_RANGE 100 // PWM range: 100
uint16_t SPEED = 0; //33;// arming のduty比


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
      SPEED = 70 * min(int(packetBuffer[0]), 100) / 100; 
      Serial.print("Received duty rate:[");
      Serial.print(" ");
      Serial.print(SPEED);
      Serial.print(" ");
      Serial.print("]\r\n");
      //Serial.printf("Received %d bytes from %s, port %d\n", packetSize, udp.remoteIP().toString().c_str(), udp.remotePort());

      last_received_time = ESP.getCycleCount();
      analogWrite(PWMA, SPEED);
    }
     else if (ESP.getCycleCount() - last_received_time >= 0.500 * CPU_FRE * 1000000L)// Stop propellers after 0.5s signal lost.
    {
      Serial.print("Set :[");
      Serial.print(" ");
      Serial.print(0);
      Serial.print(" ");
      Serial.print("]\r\n");
      analogWrite(PWMA, 0);
    }
  }
}


void setup() {
  Serial.begin(115200);
  connectToWiFi();

  // Initialize PWM
  analogWriteFreq(PWM_FREQ);
  analogWriteRange(PWM_RANGE);

  analogWrite(PWMA, 1);

  udp.begin(my_udp_port);
  unsigned long last_received_time = ESP.getCycleCount();
}

// the loop function runs over and over again forever
void loop() {
  receiveUDP();
}
