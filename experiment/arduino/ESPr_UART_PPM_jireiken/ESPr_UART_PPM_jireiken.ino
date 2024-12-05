//UART を利用して ESPWROOM にプロポ信号を送信し
// ESPWROOM から　FUTABA T10J にトレーナーコード経由でPPMを送るためのプログラム
// arduino の設定は
// http://trac.switch-science.com/wiki/esp_dev_arduino_ide
// CPU Frequency を 160 MHzにしないとFCにPPMを送れない．
// Arduino IDEの環境設定のほうもCPU Frequency を 160 MHz
// PPM は　Down pulse
#include <Arduino.h>
#define CPU_FRE 160 // CPUクロック周波数 [MHz]
#include <math.h>
uint8_t i;
unsigned int droneNumber = 252; //機体番号を入力
#define SIGNAL_TIMEOUT 200000 //[us] Matlabと通信が切断されてから信号がリセットされるまでの時間
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

// #define CH_OFFSET 1600 // 共通オフセット値
#define CH_OFFSET 1617 // 共通オフセット値


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
// 信号値をデフォルトに戻す関数
void setDefaultPulseWidth(){
  pw[0] = CH_OFFSET - CH_NEUTRAL; // roll 1620 - 500 =1120
  pw[1] = CH_OFFSET - CH_NEUTRAL; // pitch 1620 - 500 =1120
  pw[2] = CH_OFFSET - CH_MIN;     // throttle 1620 - 0 =1620
  pw[3] = CH_OFFSET - CH_NEUTRAL; // yaw 1620 - 500 =1120
  pw[4] = CH_OFFSET;              // AUX1 1620
  pw[5] = CH_OFFSET;              // AUX2 1620
  pw[6] = CH_OFFSET;              // AUX3 1620
  pw[7] = CH_OFFSET;              // AUX4 1620
  start_H = PPM_PERIOD - (8 * CH_OFFSET - 3 * CH_NEUTRAL - CH_MIN) - 9 * TIME_LOW;
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
  /////////////////// for UART ////////////////////
  if (Serial.available() >= 2 * TOTAL_CH) 
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

      pw[i] = CH_OFFSET - pw[i];
      TOTAL_CH_W -= pw[i];
    }
    start_H = TOTAL_CH_W - 9 * TIME_LOW;
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
  }
  else
  {
    digitalWrite(OUTPUT_PIN, HIGH);                            // PPM -> HIGH
    timer0_write(t_now + USEC2CLOCK((phw[n_ch]))); // 時間を指定
    n_ch++;
  }
}

// ==================================================================
void setup()
{
  Serial.begin(115200);
  /////////////////// PPM関係 ////////////////////
  setupPPM();
  last_received_time = micros();
}

void loop()
{
  receive();
}
