// PPM は　Down pulse
// 各チャンネルは H (= CH_OFFSET - pw)と　L (= TIME_LOW)からなる
// REMAINING_W = sum(H[i]+L[i])
// PPM 1周期は start_H + TOTAL_CH_H + TIME_LOW からなる
#include <TimerOne.h>

uint8_t i;
#define LED_PIN 13
// [ Green Red ] : HIGHで消灯、LOWで点滅
// 飛行可能（初期状態）： [ LOW HIGH ]
// Arming           :  [ LOW LOW  ]
// Emergence        :  [ HIGH LOW ]
#define GLED_PIN 15 // A1
#define RLED_PIN 14 // A0
#define EM_PIN 3    // 2 or 3のみ
#define RST_PIN 18  // = A4
volatile boolean isEmergency = false;
boolean fReset = false;
boolean fInitial = true;
/////////////////// PPM関係 ////////////////////
#define OUTPUT_PIN 2 // ppm output pin
char packetBuffer[255];
#define TOTAL_INPUT 4 // number of input channels
#define TOTAL_CH 8    // number of channels
// https://create-it-myself.com/research/study-ppm-spec/
// PPM信号の周期  [us] = 22.5 [ms] // オシロスコープでプロポ信号を計測した結果：上のリンク情報とも合致
#define PPM_PERIOD 22500 // PPMの周期判定はHIGHの時間が一定時間続いたら新しい周期の始まりと認知すると予想できるので、22.5より多少短くても問題無い＝＞これにより信号が安定した
#define TIME_LOW 400     // PPM信号 LOW時の幅 [us] // 上のリンク情報に合わせる
#define CH_MIN 0         // PPM幅の最小 [us]
#define CH_NEUTRAL 500   // PPM幅の中間 [us]
#define CH_MAX 1000      // PPM幅の最大 [us]
// PPM Channelの基本構造
// TIME_LOW + CH_OFFSET = 2000 = 2 [ms]
// TIME_LOW + CH_MAX + CH_OFFSET = 1000 = 1 [ms]
// volatile uint16_t CH_OFFSET; // 共通オフセット値 2*CH_MAX - TIME_LOW + 20 = 2000 - 400 + 20
#define CH_OFFSET 1620        // transmitterシステムでは20が必要
#define TOTAL_CH_OFFSET 12960 //  8*CH_OFFSET
//（特にroll入力が他の値が増加することで必要なoffset値が一度変化するので、AUX5をMAX値にしておくことで変化した後の値で一定にした。）
// volatile uint16_t TOTAL_CH_OFFSET = 0; // CH_OFFSETの合計
volatile uint8_t n_ch = TOTAL_CH; // 現在の chを保存
volatile uint16_t t_sum = 0;      // us単位  1周期中の現在の使用時間
volatile uint16_t pw[TOTAL_CH];   // ch毎のパルス幅を保存
volatile uint16_t phw[TOTAL_CH];  // PPM周期を保つため、Pulse_control内のみで使用
volatile boolean isReceive_Data_Updated = false;
volatile uint16_t start_H = PPM_PERIOD;
volatile uint16_t start_Hh = PPM_PERIOD;
volatile uint16_t REMAINING_W;

//////////// シリアル通信が途絶えたとき用 ////////////////////////////////
volatile unsigned long last_received_time;

// ==================================================================
void setup()
{
  Serial.begin(115200); // MATLABの設定と合わせる
  // Serial.setTimeout(10); //
  Serial.println("Start");
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, HIGH);
  pinMode(GLED_PIN, OUTPUT);
  digitalWrite(GLED_PIN, LOW);
  pinMode(RLED_PIN, OUTPUT);
  digitalWrite(RLED_PIN, HIGH);
  pinMode(EM_PIN, INPUT_PULLUP); // emergency_stop を割り当てるピン
  pinMode(RST_PIN, INPUT_PULLUP);

  setupPPM(); // ppm 出力開始

  // 緊急停止
  // attachInterrupt(digitalPinToInterrupt(EM_PIN), emergency_stop, RISING); // 緊急停止用　値の変化で対応（短絡から5V）
  while (Serial.available() <= 0)
  {
  }
  last_received_time = micros();
}

void loop()
{
  receive_serial();
  /*  if (!isEmergency)
    {
      receive_serial();
    }
    else
    {
      if (digitalRead(EM_PIN) == HIGH && fReset == false)
      {
        delay(5000); // delay 前後で非常停止ボタンが押された状態ならreset可能に（チャタリング防止）
        if (digitalRead(EM_PIN) == HIGH)
        {
          Serial.println("Reset available.");
          digitalWrite(LED_PIN, HIGH);
          digitalWrite(RLED_PIN, HIGH);
          digitalWrite(GLED_PIN, LOW);
          fReset = true;
        }
      }
      else if (fReset == true && digitalRead(EM_PIN) == false) // reset可能の状態で非常停止ボタンを戻したらリセット
      {
        software_reset();
      }
    }
    */
}
//*********** local functions  *************************//
void receive_serial() // ---------- loop function : receive signal by UDP
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
        if (i == 0)
        {
          pw[0] = pw[0] + 5;
        }
        if (pw[i] < CH_MIN)
        {
          pw[i] = CH_MIN;
        }
        else if (pw[i] > CH_MAX)
        {
          pw[i] = CH_MAX;
        }

        pw[i] = CH_OFFSET - pw[i]; // transmitter システムの場合必要
        REMAINING_W -= pw[i];

        /*
    if (i == 4)
    {
      if(pw[i] < CH_OFFSET - CH_NEUTRAL){// arming 時
        if (fInitial == true){
        //Serial.println("Deactivate arming");
        digitalWrite( GLED_PIN, HIGH );
        digitalWrite( RLED_PIN, LOW );
        }else{
        //Serial.println("Arming");
        digitalWrite( GLED_PIN, LOW );
        digitalWrite( RLED_PIN, LOW );
        }
        else
        {
          Serial.println("Arming");
          digitalWrite(GLED_PIN, LOW);
          digitalWrite(RLED_PIN, LOW);
        }
      }
      else
      {
        if (fInitial == true)
        {
          fInitial = false;
        }
        //Serial.println("Ready");
        digitalWrite( GLED_PIN, LOW );
        digitalWrite( RLED_PIN, HIGH );
      }
    }
*/
      }
      // last_received_time = micros();
      isReceive_Data_Updated = true;
      start_H = REMAINING_W - 9 * TIME_LOW; // 9 times LOW time in each PPM period
      Serial.println(micros() - last_received_time);
    }
    else if (micros() - last_received_time >= 500000) // Stop propellers after 0.5s signal lost.
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
      //        digitalWrite( GLED_PIN, HIGH );
      // digitalWrite( RLED_PIN, LOW );
    }
  }
}

void Pulse_control()
{
  if (digitalRead(OUTPUT_PIN) == HIGH)
  {
    Timer1.setPeriod(TIME_LOW);    // 次の割込み時間を指定
    digitalWrite(OUTPUT_PIN, LOW); // PPM -> LOW
  }
  else if (n_ch == TOTAL_CH)
  {
    n_ch = 0;
    start_Hh = start_H;
    //    memcpy(phw, pw, sizeof(pw));// PPM 1周期を22.5 msに保つため、途中で変更されたものには対応しない
    for (i = 0; i < TOTAL_CH; i++) // PPM 1周期を22.5 msに保つため、途中で変更されたものには対応しない
    {
      phw[i] = pw[i];
    }
    Timer1.setPeriod(start_Hh);     // start 判定の H 時間待つ
    digitalWrite(OUTPUT_PIN, HIGH); // PPM -> HIGH
  }
  else
  {
    Timer1.setPeriod(phw[n_ch]);    // 時間を指定
    digitalWrite(OUTPUT_PIN, HIGH); // PPM -> HIGH
    n_ch++;
  }
}

void setupPPM() // ---------- setup ppm signal configuration
{
  pinMode(OUTPUT_PIN, OUTPUT);
  digitalWrite(OUTPUT_PIN, LOW);
  // CH_OFFSET = 2*CH_MAX - TIME_LOW + 20;// commom offset
  // TOTAL_CH_OFFSET = 8*CH_OFFSET;
  pw[0] = CH_OFFSET - CH_NEUTRAL; // roll
  pw[1] = CH_OFFSET - CH_NEUTRAL; // pitch
  pw[2] = CH_OFFSET - CH_MIN;     // throttle
  pw[3] = CH_OFFSET - CH_NEUTRAL; // yaw
  pw[4] = CH_OFFSET;              // AUX1
  pw[5] = CH_OFFSET;              // AUX2
  pw[6] = CH_OFFSET;              // AUX3
  pw[7] = CH_OFFSET;              // AUX4
  start_H = PPM_PERIOD - (TOTAL_CH_OFFSET - 3 * CH_NEUTRAL - CH_MIN) - 9 * TIME_LOW;
  // CPUのクロック周波数でPPM信号を制御
  Timer1.initialize(PPM_PERIOD); //マイクロ秒単位で設定
  Timer1.attachInterrupt(Pulse_control);
}
/*
void emergency_stop()
{
  if (!isEmergency)
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
    isEmergency = true;
    digitalWrite(LED_PIN, LOW);
    digitalWrite(RLED_PIN, LOW);
    digitalWrite(GLED_PIN, HIGH);
    Serial.println("EMERGENCY !! ");
  }
}
void software_reset()
{
  Serial.println("Reset!");
  //delay(500);
  pinMode(RST_PIN, OUTPUT);
  digitalWrite(RST_PIN, LOW);
  Serial.println("RECOVERY"); // resetするので表示されないのが正しい挙動
}
*/
