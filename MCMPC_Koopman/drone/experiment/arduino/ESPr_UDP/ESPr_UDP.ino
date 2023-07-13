// 2020/09/04 : 飛行を確認：UDPでの９軸センサー情報取得はオフ
// arduino の設定は
// http://trac.switch-science.com/wiki/esp_dev_arduino_ide
// CPU Frequency を 160 MHzにしないとFCにPPMを送れない．
// PPM は　Down pulse
#include <Arduino.h>
#include <ESP8266WiFi.h> //https://github.com/esp8266/Arduino
#include <WiFiUDP.h>
#include <Wire.h> //I2Cライブラリ
#include <SPI.h> // I2Cならいらないかも
#include <SparkFunLSM9DS1.h>
#define CPU_FRE 160 // CPUクロック周波数 [MHz]
#include <math.h>

uint8_t i;

unsigned int droneNumber = 25; //機体番号を入力

#define OUTPUT_PIN 2 // PPM出力のピン番号 加速度使うなら０

const char *ssid = "acsl-mse-arl-YAMAHA";
const char *password = "wifi-acsl-mse";

//アルディーノの値を受け取るMatlabを実行しているPCのIP(自分のPCのIPアドレスを入力する)
const char *to_udp_address = "192.168.50.72"; //送信先のアドレス
const int to_udp_port = 8000;               //送信相手のポート番号

/////////////////// WiFi関係 ////////////////////
// ESPrのIPアドレスの設定
IPAddress myIP(192, 168, 50, 100+droneNumber);  // 機体により下番号変更

IPAddress gateway(192, 168, 50, 1);// PCが接続されているネットワークのゲートウェイのIPアドレスを入力する（MATLABのPCのIP）
const int my_udp_port = 8000+droneNumber;        //開放する自ポート
IPAddress subnet(255, 255, 255, 0);

WiFiUDP udp;

boolean connected = false;
unsigned long tmptmp;
uint8_t old_receive_data = 0;
uint32_t now_time = 0;
int16_t interval = 100;    //UDPデータ送信間隔
boolean isReceive_Data_Updated = false;

/////////////////// PPM関係 ////////////////////
char packetBuffer[255];
#define TOTAL_INPUT 4      // number of input channels
#define TOTAL_CH 8         // number of channels
// https://create-it-myself.com/research/study-ppm-spec/
#define PPM_PERIOD 22500  // PPM信号の周期  [us] = 22.5 [ms] // オシロスコープでプロポ信号を計測した結果：上のリンク情報とも合致
#define TIME_LOW 400       // PPM信号 LOW時の幅　 // 同上 Futaba はこちら
#define TIME_HIGH_MIN 0  // PPM幅の最小 [us] : MATLAB側のプログラムを変えないように最後に100を足すようにしている
#define TIME_HIGH_MAX 1000 // PPM幅の最大 [us] : MATLAB側のプログラムを変えないように最後に100を足すようにしている

uint8_t n_ch = 0;      // 現在の chを保存
uint16_t t_sum = 0;     // us単位  1周期中の現在の使用時間
uint16_t pw[TOTAL_CH]; // ch毎のパルス幅を保存

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

void setupPPM()// ---------- setup ppm signal configuration
{
  udp.begin(my_udp_port);

  pinMode(OUTPUT_PIN, OUTPUT);
  digitalWrite(OUTPUT_PIN, LOW);

  pw[0] = 500; // roll
  pw[1] = 500; // pitch
  pw[2] = 0; // throttle
  pw[3] = 500; // yaw
  pw[4] = 0; // AUX1
  pw[5] = 0; // AUX2
  pw[6] = 0; // AUX3
  pw[7] = 0; // AUX4

  // CPUのクロック周波数でPPM信号を制御
  noInterrupts();
  timer0_isr_init();
  timer0_attachInterrupt(Pulse_control);// timer 終了時に呼び出す関数の登録
  timer0_write(ESP.getCycleCount() + 0.030 * CPU_FRE * 1000000L); // 30 msec (CPU_FRE*10^6 == 1sec) : 次の割り込み時間を設定
  interrupts();
  unsigned long last_received_time = ESP.getCycleCount();
}

void receiveUDP()// ---------- loop function : receive signal by UDP
{
  int packetSize = udp.parsePacket();
  if (packetSize)
  {
    int len = udp.read(packetBuffer, packetSize);
    if (len > 0)
    {
      for (i = 0; i < TOTAL_CH; i++)
      {
        pw[i] = uint16_t(packetBuffer[i]) * 100 + uint16_t(packetBuffer[i + TOTAL_CH]);
      }

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
    pw[0] = 500;
    pw[1] = 500;
    pw[2] = 0; // throttle
    pw[3] = 500;
    pw[4] = 0; // AUX1
    pw[5] = 0; // AUX2
    pw[6] = 0; // AUX3
    pw[7] = 0; // AUX4
  }
  }
}

void Pulse_control()
{
  t_now = ESP.getCycleCount(); // 現在の周波数のカウントを取得
  if (digitalRead(OUTPUT_PIN) == HIGH)
  {
    digitalWrite(OUTPUT_PIN, LOW);                 // PPM -> LOW
    timer0_write(t_now + TIME_LOW * CPU_FRE * 1L); // 次の割込み時間を指定
    t_sum += TIME_LOW;
  }
  else if (digitalRead(OUTPUT_PIN) == LOW)
  {
    digitalWrite(OUTPUT_PIN, HIGH); //PPM -> HIGH
    if (n_ch == TOTAL_CH)
    {
      timer0_write(t_now + (PPM_PERIOD - t_sum) * CPU_FRE * 1L); //PPM１周期分待つ
      t_sum = 0;
      n_ch = 0;
    }
    else
    {
//      if (n_ch == 0 || n_ch == 1 || n_ch == 3 || n_ch == 2)
      //{
        if (pw[n_ch]+100 < TIME_HIGH_MIN)
        {
          pw[n_ch] = TIME_HIGH_MIN;
        }
        else if (pw[n_ch]+100 > TIME_HIGH_MAX)
        {
          pw[n_ch] = TIME_HIGH_MAX;
        }
      //}
      if (n_ch == 6)
      {
        pw[n_ch] = TIME_HIGH_MIN;
      }
      if (n_ch == 7)
      {
        pw[n_ch] = TIME_HIGH_MAX;
      }
      timer0_write(t_now + (700+ pw[n_ch]) * CPU_FRE * 1L); //時間を指定
      t_sum += pw[n_ch];
      n_ch++;
    }
  }
}


// ==================================================================
void setup()
{
  Serial.begin(115200);
  connectToWiFi();

  /////////////////// PPM関係 ////////////////////
  setupPPM();
  
}

void loop()
{
  receiveUDP();
}
