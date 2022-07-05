// arduino の設定は
// http://trac.switch-science.com/wiki/esp_dev_arduino_ide
// CPU Frequency を 160 MHzにしないとFCにPPMを送れない．
// PPM は　Down pulse
#include <Arduino.h>
#include <ESP8266WiFi.h> //https://github.com/esp8266/Arduino
#include <WiFiUDP.h>
#define CPU_FRE 160 // CPUクロック周波数 [MHz]
#include <math.h>

uint8_t i;
unsigned int droneNumber = 132; //機体番号を入力

/////////////////// WiFi関係 ////////////////////
// ESPrのIPアドレスの設定
const char *ssid = "ACSLexperimentWiFi";
const char *password = "wifi-acsl-mse";
//const char *ssid = "ACSL-Drone-Hotspot";
//const char *password = "1qaz2wsx";
IPAddress myIP(192, 168, 50, droneNumber);  // 機体により下番号変更

IPAddress gateway(192, 168, 50, 1);// PCが接続されているネットワークのゲートウェイのIPアドレスを入力する（MATLABのPCのIP）
const int my_udp_port = 8000;        //開放する自ポート
IPAddress subnet(255, 255, 255, 0);

WiFiUDP udp;

boolean connected = false;

/////////////////// PPM関係 ////////////////////
char packetBuffer[255];
#define TOTAL_INPUT 4      // number of input channels
#define TOTAL_CH 8         // number of channels
// https://create-it-myself.com/research/study-ppm-spec/
#define PPM_PERIOD 22500  // PPM信号の周期  [us] = 22.5 [ms] // オシロスコープでプロポ信号を計測した結果：上のリンク情報とも合致
#define TIME_LOW 300       // PPM信号 LOW時の幅　 // 同上 Futaba はこちら
#define TIME_HIGH_MIN 0  // PPM幅の最小 [us] : MATLAB側のプログラムを変えないように最後に100を足すようにしている
#define TIME_HIGH_MAX 1000 // PPM幅の最大 [us] : MATLAB側のプログラムを変えないように最後に100を足すようにしている

#define CH_MIN 0  // PPM幅の最小 [us] 
#define CH_NEUTRAL 500 // PPM幅の中間 [us] 
#define CH_MAX 1000 // PPM幅の最大 [us] 

volatile uint16_t CH_OFFSET; // 共通オフセット値 2*CH_MAX - TIME_LOW + 20 = 2000 - 300 + 20

//（特にroll入力が他の値が増加することで必要なoffset値が一度変化するので、AUX5をMAX値にしておくことで変化した後の値で一定にした。）
volatile uint16_t TOTAL_CH_OFFSET = 0; // CH_OFFSETの合計
volatile uint8_t n_ch = TOTAL_CH;      // 現在の chを保存
volatile uint16_t t_sum = 0;     // us単位  1周期中の現在の使用時間
volatile uint16_t pw[TOTAL_CH];  // ch毎のパルス幅を保存
volatile uint16_t phw[TOTAL_CH]; // PPM周期を保つため、Pulse_control内のみで使用
volatile boolean isReceive_Data_Updated = false;
volatile uint16_t start_H = PPM_PERIOD;
volatile uint16_t start_Hh = PPM_PERIOD;
volatile uint16_t TOTAL_CH_W;

#define OUTPUT_PIN 2 // PPM出力のピン番号 加速度使うなら０

unsigned long t_now;
volatile unsigned long last_received_time;

// マイクロ秒をクロック数に換算 (@CPU_FREMHz)
#define USEC2CLOCK(us)    (us * CPU_FRE*1L)

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
  CH_OFFSET = 0;//2*CH_MAX - TIME_LOW + 20;// commom offset 
  TOTAL_CH_OFFSET = 8*CH_OFFSET;
  pw[0] = CH_OFFSET;// - CH_NEUTRAL; // roll
  pw[1] = CH_OFFSET;// - CH_NEUTRAL; // pitch
  pw[2] = CH_OFFSET;// - CH_MIN;     // throttle
  pw[3] = CH_OFFSET;// - CH_NEUTRAL; // yaw
  pw[4] = CH_OFFSET; // AUX1
  pw[5] = CH_OFFSET; // AUX2
  pw[6] = CH_OFFSET; // AUX3
  pw[7] = CH_OFFSET; // AUX4
  //start_H = PPM_PERIOD - (TOTAL_CH_OFFSET - 3 * CH_NEUTRAL - CH_MIN) - 9 * TIME_LOW;
  start_H = PPM_PERIOD - TOTAL_CH_OFFSET - 9 * TIME_LOW;
  // CPUのクロック周波数でPPM信号を制御
  noInterrupts();
  timer0_isr_init();
  timer0_attachInterrupt(Pulse_control);// timer 終了時に呼び出す関数の登録
  timer0_write(ESP.getCycleCount() + USEC2CLOCK(PPM_PERIOD)); // 22.5 msec (CPU_FRE*10^6 == 1sec) : 次の割り込み時間を設定
  interrupts();
  unsigned long last_received_time = ESP.getCycleCount();
}

void receiveUDP()// ---------- loop function : receive signal by UDP
{
  // ch : 0 - 1000 is converted to 1000 - 2000 throttle on FC
  int packetSize = udp.parsePacket();
  if (packetSize)
  {
    int len = udp.read(packetBuffer, packetSize);
    if (len > 0)
    {
      TOTAL_CH_W = PPM_PERIOD;    
      for (i = 0; i < TOTAL_CH; i++)
      {
        pw[i] = uint16_t(packetBuffer[i]) * 100 + uint16_t(packetBuffer[i + TOTAL_CH]);
        if (pw[i] < CH_MIN)
        {
          pw[i] = CH_MIN;
        }
        else if (pw[i] > CH_MAX)
        {
          pw[i] = CH_MAX;
        }
        
        //pw[i] = CH_OFFSET - pw[i];
        //pw[i] = TIME_LOW - pw[i];
        TOTAL_CH_W -= (pw[i] + TIME_LOW);        
        Serial.print("pw[ ");
        Serial.print(i);
        Serial.print(" ]");
        Serial.println(pw[i]);
      }

      last_received_time = ESP.getCycleCount();
      isReceive_Data_Updated = true;
      start_H = TOTAL_CH_W - TIME_LOW;// 9 times LOW time in each PPM period      
    }
  else if (ESP.getCycleCount() - last_received_time >= USEC2CLOCK(500000))// Stop propellers after 500000 us = 0.5s signal lost. 
    {
      pw[0] = CH_OFFSET;// - CH_NEUTRAL; // roll
      pw[1] = CH_OFFSET;// - CH_NEUTRAL; // pitch
      pw[2] = CH_OFFSET;// - CH_MIN;     // throttle
      pw[3] = CH_OFFSET;// - CH_NEUTRAL; // yaw
      pw[4] = CH_OFFSET; // AUX1
      pw[5] = CH_OFFSET; // AUX2
      pw[6] = CH_OFFSET; // AUX3
      pw[7] = CH_OFFSET; // AUX4
      start_H = PPM_PERIOD - (TOTAL_CH_OFFSET - 3 * CH_NEUTRAL - CH_MIN) - 9 * TIME_LOW;
    }
  }
}

void Pulse_control()
{
  t_now = ESP.getCycleCount(); // 現在の周波数のカウントを取得
  if (digitalRead(OUTPUT_PIN) == HIGH)
  {
    timer0_write(t_now + USEC2CLOCK(TIME_LOW)); // 次の割込み時間を指定
    digitalWrite(OUTPUT_PIN, LOW);                 // PPM -> LOW
    t_sum += TIME_LOW;
  }
  else if (n_ch == TOTAL_CH)
  {
    timer0_write(t_now + USEC2CLOCK(start_Hh));// start 判定の H 時間待つ
    digitalWrite(OUTPUT_PIN, HIGH); //PPM -> HIGH
    n_ch = 0;
    start_Hh = start_H;
//    memcpy(phw, pw, sizeof(pw));// PPM 1周期を22.5 msに保つため、途中で変更されたものには対応しない
    for(i = 0; i < TOTAL_CH; i++)// PPM 1周期を22.5 msに保つため、途中で変更されたものには対応しない
    {
      phw[i] =  pw[i];
    }
  }
  else
  {
    timer0_write(t_now + USEC2CLOCK(phw[n_ch]));// 時間を指定
    digitalWrite(OUTPUT_PIN, HIGH); //PPM -> HIGH
    n_ch++;
  }
}
/*  
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
        if (pw[n_ch] < TIME_HIGH_MIN)
        {
          pw[n_ch] = TIME_HIGH_MIN;
        }
        else if (pw[n_ch] > TIME_HIGH_MAX)
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
      timer0_write(t_now + (700+ pw[n_ch]) * CPU_FRE * 1L -10); //時間を指定
      t_sum += pw[n_ch];
      n_ch++;
    }
  }
}
*/

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
