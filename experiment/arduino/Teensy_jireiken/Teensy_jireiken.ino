// PPM は　Down pulse
// 各チャンネルは H (= CH_OFFSET - pw)と　L (= TIME_LOW)からなる
// REMAINING_W = sum(H[i]+L[i])
// PPM 1周期は start_H + TOTAL_CH_H + TIME_LOW からなる
#include <TimerOne.h>

uint8_t i;
#define LED_PIN 13
volatile boolean isEmergency = false;
boolean fReset = false;
boolean fInitial = true;
boolean fstarthalf = false;
/////////////////// PPM関係 ////////////////////
#define OUTPUT_PIN 2 // ppm output pin
char packetBuffer[255];
#define TOTAL_INPUT 4 // number of input channels
#define TOTAL_CH 8    // number of channels
// https://create-it-myself.com/research/study-ppm-spec/
// PPM信号の周期  [us] = 22.5 [ms] // オシロスコープでプロポ信号を計測した結果：上のリンク情報とも合致
#define PPM_PERIOD 22500 // PPMの周期判定はHIGHの時間が一定時間続いたら新しい周期の始まりと認知すると予想できるので、22.5より多少短くても問題無い＝＞これにより信号が安定した
#define TIME_LOW 360
#define CH_MIN 0
#define CH_NEUTRAL 500
#define CH_MAX 1000
#define CH_OFFSET 1659
#define TOTAL_CH_OFFSET 13272
volatile uint8_t n_ch = TOTAL_CH;
volatile uint16_t t_sum = 0;
volatile uint16_t pw[TOTAL_CH];
volatile uint16_t phw[TOTAL_CH];
volatile boolean isReceive_Data_Updated = false;
volatile uint16_t start_H = PPM_PERIOD;
volatile uint16_t start_Hh = PPM_PERIOD;
volatile uint16_t REMAINING_W;
volatile uint16_t plus = 0;
//////////// シリアル通信が途絶えたとき用 ////////////////////////////////
volatile unsigned long last_received_time;

// ==================================================================
void setup()
{
  Serial.begin(115200); // MATLABの設定と合わせる　パソコンとマイコンの通信速度を合わせている
  setupPPM();
  last_received_time = micros(); //micros():Arduinoボードがプログラムの実行を開始した時から現在までの時間をマイクロ秒単位で返す約70分で0に戻る　最後に受信されたメッセージが読み取られた時刻をast_received_timeに格納
}

void loop()
{
  receive_serial();  
}
//*********** local functions  *************************//
void receive_serial() // ---------- loop function : receive signal
{
  // ch : 0 - 1000 is converted to 1000 - 2000 throttle on FC
  if (Serial.available() > 0)
  {
    last_received_time = micros();
    Serial.println("received");
    Serial.readBytes(packetBuffer, 2 * TOTAL_CH); 
    Serial.println(micros() - last_received_time);
    if (packetBuffer)
    {
      REMAINING_W = PPM_PERIOD;
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
        REMAINING_W -= pw[i];
      }
      last_received_time = micros();
      isReceive_Data_Updated = true;
      start_H = REMAINING_W - 9 * TIME_LOW;// 9 times LOW time in each PPM period
      Serial.println(micros() - last_received_time);
    }
  }
  else if (micros() - last_received_time >= 200000) // Stop propellers after 0.2s signal lost.
  {
    pw[0] = CH_OFFSET - CH_NEUTRAL; // roll
    pw[1] = CH_OFFSET - CH_NEUTRAL; // pitch
    pw[2] = CH_OFFSET - CH_MIN;     // throttle
    pw[3] = CH_OFFSET - CH_NEUTRAL; // yaw
    pw[4] = CH_OFFSET;              // AUX1
    pw[5] = CH_OFFSET;              // AUX2
    pw[6] = CH_OFFSET;              // AUX3
    pw[7] = CH_OFFSET;              // AUX4
    start_H = PPM_PERIOD - (TOTAL_CH_OFFSET - 3 * CH_NEUTRAL - CH_MIN) - 9 * TIME_LOW;
  }
}

void Pulse_control() //★パルスの制御
{
  if (digitalRead(OUTPUT_PIN) == LOW)
  {
    Timer1.setPeriod(TIME_LOW);
    digitalWrite(OUTPUT_PIN, HIGH);
  }
  else if (n_ch == TOTAL_CH)
  {
    n_ch = 0;
    start_Hh = start_H;
    for (i = 0; i < TOTAL_CH; i++)
    {
      phw[i] = pw[i]; 
    }
    fstarthalf = true;
    Timer1.setPeriod(start_Hh); 
    digitalWrite(OUTPUT_PIN, LOW);
  }
  else //上記2つのどちらでもないとき
  {
    Timer1.setPeriod(phw[n_ch]); 
    digitalWrite(OUTPUT_PIN, LOW);
    n_ch++; //チャンネルを進める
  }
}

void setupPPM() // ---------- setup ppm signal configuration
{
  pinMode(OUTPUT_PIN, OUTPUT);
  digitalWrite(OUTPUT_PIN, LOW);
  pw[0] = CH_OFFSET - CH_NEUTRAL; // roll
  pw[1] = CH_OFFSET - CH_NEUTRAL; // pitch
  pw[2] = CH_OFFSET - CH_MIN;     // throttle
  pw[3] = CH_OFFSET - CH_NEUTRAL; // yaw
  pw[4] = CH_OFFSET;              // AUX1
  pw[5] = CH_OFFSET;              // AUX2
  pw[6] = CH_OFFSET;              // AUX3
  pw[7] = CH_OFFSET;              // AUX4
  start_H = PPM_PERIOD - (TOTAL_CH_OFFSET - 3 * CH_NEUTRAL - CH_MIN) - 9 * TIME_LOW;
  Timer1.initialize(PPM_PERIOD);
  Timer1.attachInterrupt(Pulse_control);
}