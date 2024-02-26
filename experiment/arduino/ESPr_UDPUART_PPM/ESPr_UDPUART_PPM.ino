// Wi-Fi または UART を利用して ESPWROOM にプロポ信号を送信し
// ESPWROOM から　FUTABA T10J にトレーナーコード経由でPPMを送るためのプログラム
// arduino の設定は
// http://trac.switch-science.com/wiki/esp_dev_arduino_ide
// CPU Frequency を 160 MHzにしないとFCにPPMを送れない．
// Arduino IDEの環境設定のほうもCPU Frequency を 160 MHz
// PPM は　Down pulse
#include <Arduino.h>
#include <ESP8266WiFi.h> //https://github.com/esp8266/Arduino
#include <WiFiUDP.h>
#define CPU_FRE 160 // CPUクロック周波数 [MHz]
#include <math.h>
uint8_t i;
unsigned int droneNumber = 252; //機体番号を入力
#define SIGNAL_TIMEOUT 200000 //[us] Matlabと通信が切断されてから信号がリセットされるまでの時間

/////////////////// WiFi関係 ////////////////////
// ESPrのIPアドレスの設定
// const char *ssid = "ACSLexperimentWiFi";
// const char *password = "wifi-acsl-mse";
const char *ssid = "aterm-b3cabe-g";
const char *password = "1ddd2634b2f3e";
IPAddress myIP(192, 168, 1, droneNumber); // 機体により下番号変更

IPAddress gateway(192, 168, 1, 1); // PCが接続されているネットワークのゲートウェイのIPアドレスを入力する（MATLABのPCのIP）
const int my_udp_port = 8000;       //開放する自ポート
IPAddress subnet(255, 255, 255, 0);

WiFiUDP udp;

boolean connected = false;
volatile unsigned long last_received_time; // 最後に信号を受信した時間[us]を格納
/////////////////// PPM関係 ////////////////////
char packetBuffer[255];
#define TOTAL_INPUT 4 // number of input channels
#define TOTAL_CH 8    // number of channels
// https://create-it-myself.com/research/study-ppm-spec/
#define PPM_PERIOD 22500   // PPM信号の周期  [us] = 22.5 [ms] // オシロスコープでプロポ信号を計測した結果：上のリンク情報とも合致
#define TIME_LOW 400       // PPM信号 LOW時の幅　 // 同上 Futaba はこちら
#define TIME_HIGH_MIN 0    // PPM幅の最小 [us] : MATLAB側のプログラムを変えないように最後に100を足すようにしている
#define TIME_HIGH_MAX 1000 // PPM幅の最大 [us] : MATLAB側のプログラムを変えないように最後に100を足すようにしている

#define CH_MIN 0       // PPM幅の最小 [us]
#define CH_NEUTRAL 500 // PPM幅の中間 [us]
#define CH_MAX 1000    // PPM幅の最大 [us]

#define CH_OFFSET 600 // 共通オフセット値


//（特にroll入力が他の値が増加することで必要なoffset値が一度変化するので、AUX5をMAX値にしておくことで変化した後の値で一定にした。）
volatile uint16_t TOTAL_CH_OFFSET = 0; // CH_OFFSETの合計
volatile uint8_t n_ch = TOTAL_CH;      // 現在の chを保存
volatile uint16_t pw[TOTAL_CH];        // ch毎のパルス幅を保存
volatile uint16_t phw[TOTAL_CH];       // PPM周期を保つため、Pulse_control内のみで使用
volatile uint16_t start_H = PPM_PERIOD;
volatile uint16_t start_Hh = PPM_PERIOD;
volatile uint16_t TOTAL_CH_W;

#define OUTPUT_PIN 2 // PPM出力のピン番号 加速度使うなら０

unsigned long t_now;

// マイクロ秒をクロック数に換算 (@CPU_FREMHz)
#define USEC2CLOCK(us) (us * CPU_FRE * 1L)

//*********** local functions  *************************//
void connectToWiFi() // ---- setup connection to wifi
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

// 信号値をデフォルトに戻す関数
void setDefaultPulseWidth(){
  pw[0] = CH_NEUTRAL; // roll
  pw[1] = CH_NEUTRAL; // pitch
  pw[2] = CH_MIN;     // throttle
  pw[3] = CH_NEUTRAL; // yaw
  pw[4] = CH_MIN;     // AUX1
  pw[5] = CH_MIN;     // AUX2
  pw[6] = CH_MIN;     // AUX3
  pw[7] = CH_MIN;     // AUX4
  start_H = PPM_PERIOD - 8 * CH_OFFSET - 3 * CH_NEUTRAL - 9 * TIME_LOW;
}

void setupPPM() // ---------- setup ppm signal configuration
{
  pinMode(OUTPUT_PIN, OUTPUT);
  digitalWrite(OUTPUT_PIN, LOW);
  setDefaultPulseWidth();
  // CPUのクロック周波数でPPM信号を制御
  noInterrupts();
  timer0_isr_init();
  timer0_attachInterrupt(Pulse_control);                      // timer 終了時に呼び出す関数の登録
  timer0_write(ESP.getCycleCount() + USEC2CLOCK(PPM_PERIOD)); // 22.5 msec (CPU_FRE*10^6 == 1sec) : 次の割り込み時間を設定
  interrupts();
}


void receive() // ---------- loop function : receive signal by UDP
{
  // ch : 0 - 1000 is converted to 1000 - 2000 throttle on FC
  int len = 0;
  /////////////////// for UDP ////////////////////
  int packetSize = udp.parsePacket();
  if (packetSize){
    len = udp.read(packetBuffer, packetSize);
  }
  /////////////////// for UART ////////////////////
  else if (Serial.available() >= 2 * TOTAL_CH) 
  { 
    len = Serial.readBytes(packetBuffer, 2 * TOTAL_CH);
  }
  /////////////////// COMMON 信号値の格納 ////////////////////
  if (len > 0){
    last_received_time = micros();
    TOTAL_CH_W = 0;
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

      TOTAL_CH_W += pw[i];
      /*Serial.print("pw[ ");
      Serial.print(i);
      Serial.print(" ]");
      Serial.println(pw[i]);*/
    }

    start_H = PPM_PERIOD - TOTAL_CH_W - 8 * CH_OFFSET - 9 * TIME_LOW; // 9 times LOW time in each PPM period
  /////////////////// for Failsafe ////////////////////
  }else if (micros() - last_received_time >= SIGNAL_TIMEOUT){
    setDefaultPulseWidth();
  }
}

void Pulse_control()
{
  t_now = ESP.getCycleCount(); // 現在の周波数のカウントを取得
  if (digitalRead(OUTPUT_PIN) == HIGH)
  {
    digitalWrite(OUTPUT_PIN, LOW);              // PPM -> LOW
    timer0_write(t_now + USEC2CLOCK(TIME_LOW)); // 次の割込み時間を指定
    // Serial.println(TIME_LOW);
  }
  else if (n_ch == TOTAL_CH)
  {
    n_ch = 0;
    start_Hh = start_H;
    for (i = 0; i < TOTAL_CH; i++) // PPM 1周期を22.5 msに保つため、途中で変更されたものには対応しない
    {
      phw[i] = pw[i];
    }
    digitalWrite(OUTPUT_PIN, HIGH);             // PPM -> HIGH
    timer0_write(t_now + USEC2CLOCK(start_Hh)); // start 判定の H 時間待つ
    // Serial.println(start_Hh);
  }
  else
  {
    digitalWrite(OUTPUT_PIN, HIGH);                            // PPM -> HIGH
    timer0_write(t_now + USEC2CLOCK((phw[n_ch] + CH_OFFSET))); // 時間を指定
    // Serial.print(phw[n_ch]);
    // Serial.print(" + ");
    // Serial.println(CH_OFFSET);
    n_ch++;
  }
}

// ==================================================================
void setup()
{
  Serial.begin(115200);
  connectToWiFi();
  udp.begin(my_udp_port);

  /////////////////// PPM関係 ////////////////////
  setupPPM();
  last_received_time = micros();
}

void loop()
{
  receive();
}
