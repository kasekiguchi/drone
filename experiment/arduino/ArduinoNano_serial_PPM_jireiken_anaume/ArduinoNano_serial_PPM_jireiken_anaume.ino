// PPM は　Down pulse
// 各チャンネルは H (= CH_OFFSET - pw)と　L (= TIME_LOW)からなる
// REMAINING_W = sum(H[i]+L[i])
// PPM 1周期は start_H + TOTAL_CH_H + TIME_LOW からなる
#include <TimerOne.h>

uint8_t i;
volatile boolean isEmergency = false;
boolean fReset = false;
boolean fInitial = true;
boolean fstarthalf = false;
/////////////////// PPM関係 ////////////////////
#define OUTPUT_PIN 2
char packetBuffer[255];
#define TOTAL_INPUT 4 // number of input channels
#define TOTAL_CH 8    // number of channels
// https://create-it-myself.com/research/study-ppm-spec/
// PPM信号の周期  [us] = 22.5 [ms] // オシロスコープでプロポ信号を計測した結果：上のリンク情報とも合致
//問題1.PPM_PERIODのあとに入る数字は？//
#define PPM_PERIOD  // PPMの周期
/////////////////////////////////////
#define TIME_LOW 360
//問題2.それぞれの値は？//    
#define CH_MIN     //　MATLABからの入力の最低値   
#define CH_NEUTRAL  // MATLABからの入力の中間値
#define CH_MAX   // MATLABからの入力の最高値
/////////////////////////////////////     
#define CH_OFFSET 1659    
#define TOTAL_CH_OFFSET 13272 //  8*CH_OFFSET 
volatile uint8_t n_ch = TOTAL_CH; 
volatile uint16_t t_sum = 0;     
volatile uint16_t pw[TOTAL_CH];
volatile uint16_t phw[TOTAL_CH];
volatile boolean isReceive_Data_Updated = false; 
volatile uint16_t start_H = PPM_PERIOD; 
volatile uint16_t start_Hh = PPM_PERIOD; 
volatile uint16_t REMAINING_W; 
//////////// シリアル通信が途絶えたとき用 ////////////////////////////////
volatile unsigned long last_received_time;

// ==================================================================
void setup()
{
  //問題3.()の中の数値は？//
  Serial.begin(); // MATLABの設定と合わせる
  ////////////////////////
  Serial.println("Start"); 
  setupPPM();

  // 緊急停止
  while (Serial.available() <= 0) 
  {
  }
  last_received_time = micros();
}

void loop()
{
  receive_serial(); //ここは半透明となっているため動かない　信号を受信した場合
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
    //問題4.それぞれの関数に何を入れる？//
    pw[0] = ; // roll
    pw[1] = ; // pitch
    pw[2] = ;     // throttle
    pw[3] = ; // yaw
    pw[4] = ;              // AUX1
    pw[5] = ;              // AUX2
    pw[6] = ;              // AUX3
    pw[7] = ;              // AUX4
    start_H = ;
    ////////////////////////////////////////
  }
}

void Pulse_control() //★パルスの制御
{
  if(fstarthalf == true)
  {
    fstarthalf = false;
    Timer1.setPeriod(start_Hh);
    digitalWrite(OUTPUT_PIN, HIGH);
  }
  else if (digitalRead(OUTPUT_PIN) == HIGH)
  {
    Timer1.setPeriod(TIME_LOW);
    digitalWrite(OUTPUT_PIN, LOW);
  }
  else if (n_ch == TOTAL_CH)
  {
    n_ch = 0;
    start_Hh = start_H / 2;
    for (i = 0; i < TOTAL_CH; i++)
    {
      phw[i] = pw[i];
    }
    fstarthalf = true;
    Timer1.setPeriod(start_Hh); 
    digitalWrite(OUTPUT_PIN, HIGH);
  }
  else
  {
    Timer1.setPeriod(phw[n_ch]); 
    digitalWrite(OUTPUT_PIN, HIGH);
    n_ch++;
  }
}

void setupPPM() // ---------- setup ppm signal configuration
{
  pinMode(OUTPUT_PIN, OUTPUT);
  digitalWrite(OUTPUT_PIN, LOW);
  // CH_OFFSET = 2*CH_MAX - TIME_LOW + 20;// commom offset
  // TOTAL_CH_OFFSET = 8*CH_OFFSET;
  //問題4と同様//
    pw[0] = ; // roll
    pw[1] = ; // pitch
    pw[2] = ;     // throttle
    pw[3] = ; // yaw
    pw[4] = ;              // AUX1
    pw[5] = ;              // AUX2
    pw[6] = ;              // AUX3
    pw[7] = ;              // AUX4
    start_H = ;
    ////////////////////////////////////////
  Timer1.initialize(PPM_PERIOD);
  Timer1.attachInterrupt(Pulse_control);
}
