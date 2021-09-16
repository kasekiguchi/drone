// PPM は　Down pulse
#include <TimerOne.h>

uint8_t i;
#define PIN_LED 13
volatile int state = HIGH;
volatile boolean isEmergency = false;
#define OUTPUT_PIN 2 // ppm output pin
/////////////////// PPM関係 ////////////////////
char packetBuffer[255];
#define TOTAL_INPUT 4      // number of input channels
#define TOTAL_CH 8         // number of channels
// https://create-it-myself.com/research/study-ppm-spec/
#define PPM_PERIOD 22500  // PPM信号の周期  [us] = 22.5 [ms] // オシロスコープでプロポ信号を計測した結果：上のリンク情報とも合致
#define TIME_LOW 400       // PPM信号 LOW時の幅 [us] // 上のリンク情報に合わせる
#define TIME_HIGH_MIN 600  // PPM幅の最小 [us] : MATLAB側のプログラムを変えないように最後に100を足すようにしている
#define TIME_HIGH_MAX 1600 // PPM幅の最大 [us] : MATLAB側のプログラムを変えないように最後に100を足すようにしている
// TIME_LOW + TIME_HIGH_MAX = 2000 = 2 [ms]
// TIME_LOW + TIME_HIGH_MIN = 1000 = 1 [ms]

volatile uint8_t n_ch = 0;      // 現在の chを保存
volatile uint16_t t_sum = 0;     // us単位  1周期中の現在の使用時間
volatile uint16_t pw[TOTAL_CH]; // ch毎のパルス幅を保存

volatile unsigned long t_now;
volatile unsigned long last_received_time;
volatile boolean isReceive_Data_Updated = false;

// ==================================================================
void setup()
{
  Serial.begin(115200); // MATLABの設定と合わせる
  // Serial.print("Start");

  delay(1000);
  setupPPM();
  // 緊急停止
  pinMode( PIN_LED, OUTPUT );
  digitalWrite( PIN_LED, state );
  //attachInterrupt(digitalPinToInterrupt(EM_PIN), emergency_stop, RISING); // 緊急停止用　LOWからHIGHで停止
  attachInterrupt(1, emergency_stop, CHANGE); // 緊急停止用　値の変化で対応（短絡から解放）
  last_received_time = micros();
}

void loop()
{
  if (!isEmergency)
  {
    receive_serial();
  }
}
//*********** local functions  *************************//
void receive_serial()// ---------- loop function : receive signal by UDP
{
  if (Serial.available() > 0) {
    Serial.readBytesUntil('¥n', packetBuffer, 2 * TOTAL_CH + 1);
    if (packetBuffer)
    {
      for (i = 0; i < TOTAL_CH; i++)
      {
        pw[i] = uint16_t(packetBuffer[i]) * 100 + uint16_t(packetBuffer[i + TOTAL_CH]);
      }
      /*      Serial.print("Received :[");
            for (i = 0; i < TOTAL_CH; i++)
            {
              Serial.print(" ");
              Serial.print(pw[i]);
              Serial.print(" ");
            }
            Serial.print("]\r\n");
      */
      last_received_time = micros();
      isReceive_Data_Updated = true;
    }
    else if (micros() - last_received_time >= 500000)// Stop propellers after 0.5s signal lost.
    {
      pw[0] = 1100;
      pw[1] = 1100;
      pw[2] = 600; // throttle
      pw[3] = 1100;
      pw[4] = 600; // AUX1
      pw[5] = 600; // AUX2
      pw[6] = 600; // AUX3
      pw[7] = 600; // AUX4
    }

  }
}

void Pulse_control()
{
  /*
    t_now = micros(); // 現在の周波数のカウントを取得 micro sec

    Serial.print(t_now);
    Serial.print("\t");
    Serial.print(n_ch);
    Serial.print("\t");
    Serial.print(t_sum);
    Serial.print("\t");
    Serial.println(digitalRead(OUTPUT_PIN));
    //*/
  if (digitalRead(OUTPUT_PIN) == HIGH)
  {
    digitalWrite(OUTPUT_PIN, LOW);                 // PPM -> LOW
    Timer1.setPeriod(TIME_LOW);// 次の割込み時間を指定
    t_sum += TIME_LOW;
  }
  else if (digitalRead(OUTPUT_PIN) == LOW)
  {
    digitalWrite(OUTPUT_PIN, HIGH); //PPM -> HIGH
    if (n_ch == TOTAL_CH)
    {
      Timer1.setPeriod(PPM_PERIOD - t_sum);// PPM１周期分待つ
      t_sum = 0;
      n_ch = 0;
    }
    else
    {
      if (pw[n_ch] + 100 < TIME_HIGH_MIN)
      {
        pw[n_ch] = TIME_HIGH_MIN;
      }
      else if (pw[n_ch] + 100 > TIME_HIGH_MAX)
      {
        pw[n_ch] = TIME_HIGH_MAX;
      }
      if (n_ch == 6)
      {
        pw[n_ch] = TIME_HIGH_MIN;
      }
      if (n_ch == 7)
      {
        pw[n_ch] = TIME_HIGH_MAX;
      }
      Timer1.setPeriod(100 + pw[n_ch]);// 時間を指定
      t_sum += pw[n_ch];
      n_ch++;
    }
  }
}

void setupPPM()// ---------- setup ppm signal configuration
{
  pinMode(OUTPUT_PIN, OUTPUT);
  digitalWrite(OUTPUT_PIN, LOW);

  pw[0] = 1100; // roll
  pw[1] = 1100; // pitch
  pw[2] = 600; // throttle
  pw[3] = 1100; // yaw
  pw[4] = 600; // AUX1
  pw[5] = 600; // AUX2
  pw[6] = 600; // AUX3
  pw[7] = 600; // AUX4

  // CPUのクロック周波数でPPM信号を制御
  Timer1.initialize(PPM_PERIOD); //マイクロ秒単位で設定
  Timer1.attachInterrupt(Pulse_control);

}
void emergency_stop()
{
  pw[0] = 1100;
  pw[1] = 1100;
  pw[2] = 600; // throttle
  pw[3] = 1100;
  pw[3] = 600;
  pw[4] = 600; // AUX1
  pw[5] = 600; // AUX2
  pw[6] = 600; // AUX3
  pw[7] = 600; // AUX4
  isEmergency = true;
  state = LOW;
  digitalWrite( PIN_LED, state );
}
