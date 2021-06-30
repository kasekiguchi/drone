// PPM は　Down pulse
#include <TimerOne.h>

uint8_t i;
#define LED_PIN 13
#define EM_PIN 2
#define RST_PIN 18 // = A4
volatile int LED_state = HIGH;
volatile boolean isEmergency = false;
boolean fReset = false;
/////////////////// PPM関係 ////////////////////
#define OUTPUT_PIN A1 // ppm output pin
char packetBuffer[255];
#define TOTAL_INPUT 4      // number of input channels
#define TOTAL_CH 8         // number of channels
// https://create-it-myself.com/research/study-ppm-spec/
#define PPM_PERIOD 22500  // PPM信号の周期  [us] = 22.5 [ms] // オシロスコープでプロポ信号を計測した結果：上のリンク情報とも合致
#define TIME_LOW 300       // PPM信号 LOW時の幅 [us] // 上のリンク情報に合わせる
#define CH_MIN 0  // PPM幅の最小 [us] 
#define CH_NEUTRAL 500 // PPM幅の中間 [us] 
#define CH_MAX 1000 // PPM幅の最大 [us] 
// PPM Channelの基本構造
// TIME_LOW + CH_MAX + CH_OFFSET = 2000 = 2 [ms]
// TIME_LOW + CH_MIN + CH_OFFSET = 1000 = 1 [ms]
volatile uint16_t CH_OFFSET[TOTAL_CH]; // 各CH毎にOffsetを変えられるように
（特にroll入力が他の値が増加することで必要なoffset値が一度変化するので、AUX5をMAX値にしておくことで変化した後の値で一定にした。）
volatile uint16_t TOTAL_CH_OFFSET = 0; // CH_OFFSETの合計
volatile uint8_t n_ch = TOTAL_CH;      // 現在の chを保存
volatile uint16_t t_sum = 0;     // us単位  1周期中の現在の使用時間
volatile uint16_t pw[TOTAL_CH];  // ch毎のパルス幅を保存
volatile uint16_t phw[TOTAL_CH]; // PPM周期を保つため
volatile boolean isReceive_Data_Updated = false;
volatile uint16_t start_H = 0;

//////////// シリアル通信が途絶えたとき用 ////////////////////////////////
volatile unsigned long last_received_time;

// ==================================================================
void setup()
{
  Serial.begin(115200); // MATLABの設定と合わせる
  Serial.println("Start");

  delay(1000);
  setupPPM();
  // 緊急停止
  pinMode(EM_PIN, INPUT_PULLUP);// emergency_stop を割り当てるピン
  pinMode(RST_PIN, INPUT_PULLUP);
  pinMode(LED_PIN, OUTPUT );
  digitalWrite( LED_PIN, LED_state );
  //attachInterrupt(digitalPinToInterrupt(EM_PIN), emergency_stop, RISING); // 緊急停止用　LOWからHIGHで停止
  attachInterrupt(0, emergency_stop, RISING); // 緊急停止用　値の変化で対応（短絡から5V）(0: 2pin, 1: 3pin)
  last_received_time = micros();
}

void loop()
{
  if (!isEmergency)
  {
    receive_serial();
  }
  else
  {
    if (digitalRead(EM_PIN) == true)
    {
      delay(3000);// delay 前後で非常停止ボタンが押された状態ならreset可能に（チャタリング防止）
      if (digitalRead(EM_PIN) == true)
      {
        fReset = true;
        Serial.println("Reset available.");
      }
    }
    else if (fReset == true && digitalRead(EM_PIN) == false)
    {
      software_reset();
    }
  }
}
//*********** local functions  *************************//
void receive_serial()// ---------- loop function : receive signal by UDP
{
  // ch : 0 - 1000 is converted to 1000 - 2000 throttle on FC
  if (Serial.available() > 0)
  {
    Serial.readBytesUntil('¥n', packetBuffer, 2 * TOTAL_CH + 1);
    if (packetBuffer)
    {
      start_H = PPM_PERIOD;
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
        pw[i] = CH_MAX + CH_OFFSET[i] - pw[i];
        start_H -= (pw[i] + TIME_LOW);
      }
      last_received_time = micros();
      isReceive_Data_Updated = true;
      start_H -= TIME_LOW;// 9 times LOW time in each PPM period
    }
    else if (micros() - last_received_time >= 500000)// Stop propellers after 0.5s signal lost.
    {
      pw[0] = CH_MAX + CH_OFFSET[0] - CH_NEUTRAL; // roll
      pw[1] = CH_MAX + CH_OFFSET[1] - CH_NEUTRAL; // pitch
      pw[2] = CH_MAX + CH_OFFSET[2] - CH_MIN; // throttle
      pw[3] = CH_MAX + CH_OFFSET[3] - CH_NEUTRAL; // yaw
      pw[4] = CH_MAX + CH_OFFSET[4] - CH_MIN; // AUX1
      pw[5] = CH_MAX + CH_OFFSET[5] - CH_MIN; // AUX2
      pw[6] = CH_MAX + CH_OFFSET[6] - CH_MIN; // AUX3
      pw[7] = CH_MAX + CH_OFFSET[7] - CH_MIN; // AUX4
      start_H = PPM_PERIOD - (8 * CH_MAX + TOTAL_CH_OFFSET - 3 * CH_NEUTRAL - 5 * CH_MIN) - 9 * TIME_LOW;
    }
  }
}

void Pulse_control()
{
  if (digitalRead(OUTPUT_PIN) == HIGH)
  {
    Timer1.setPeriod(TIME_LOW);// 次の割込み時間を指定
    digitalWrite(OUTPUT_PIN, LOW);                 // PPM -> LOW
  }
  else if (n_ch == TOTAL_CH)
  {
    Timer1.setPeriod(start_H);// start 判定の H 時間待つ
    digitalWrite(OUTPUT_PIN, HIGH); //PPM -> HIGH
    n_ch = 0;
    memcpy(phw, pw, sizeof(pw));// PPM 1周期を22.5 msに保つため、途中で変更されたものには対応しない
  }
  else
  {
    Timer1.setPeriod(phw[n_ch]);// 時間を指定
    digitalWrite(OUTPUT_PIN, HIGH); //PPM -> HIGH
    n_ch++;
  }
}

void setupPPM()// ---------- setup ppm signal configuration
{
  pinMode(OUTPUT_PIN, OUTPUT);
  digitalWrite(OUTPUT_PIN, LOW);
  CH_OFFSET[0] = CH_MAX - TIME_LOW + 15; 
  CH_OFFSET[1] = CH_MAX - TIME_LOW + 22; 
  CH_OFFSET[2] = CH_MAX - TIME_LOW + 21; 
  CH_OFFSET[3] = CH_MAX - TIME_LOW + 22; 
  CH_OFFSET[4] = CH_MAX - TIME_LOW + 21; 
  CH_OFFSET[5] =  - TIME_LOW + 21; 
  CH_OFFSET[6] = CH_MAX - TIME_LOW + 21; 
  CH_OFFSET[7] = CH_MAX - TIME_LOW + 21;
  for( i = 0; i < TOTAL_CH; i++)
  {
    TOTAL_CH_OFFSET += CH_OFFSET[i];
  }
  pw[0] = CH_MAX + CH_OFFSET[0] - CH_NEUTRAL; // roll
  pw[1] = CH_MAX + CH_OFFSET[1] - CH_NEUTRAL; // pitch
  pw[2] = CH_MAX + CH_OFFSET[2] - CH_MIN; // throttle
  pw[3] = CH_MAX + CH_OFFSET[3] - CH_NEUTRAL; // yaw
  pw[4] = CH_MAX + CH_OFFSET[4] - CH_MIN; // AUX1
  pw[5] = CH_MAX + CH_OFFSET[5] - CH_MIN; // AUX2
  pw[6] = CH_MAX + CH_OFFSET[6] - CH_MIN; // AUX3
  pw[7] = CH_MAX + CH_OFFSET[7] - CH_MIN; // AUX4
  start_H = PPM_PERIOD - (8 * CH_MAX + TOTAL_CH_OFFSET - 3 * CH_NEUTRAL - 5 * CH_MIN) - 9 * TIME_LOW;
  // CPUのクロック周波数でPPM信号を制御
  Timer1.initialize(PPM_PERIOD); //マイクロ秒単位で設定
  Timer1.attachInterrupt(Pulse_control);

}
void emergency_stop()
{
  pw[0] = CH_MAX + CH_OFFSET[0] - CH_NEUTRAL; // roll
  pw[1] = CH_MAX + CH_OFFSET[1] - CH_NEUTRAL; // pitch
  pw[2] = CH_MAX + CH_OFFSET[2] - CH_MIN; // throttle
  pw[3] = CH_MAX + CH_OFFSET[3] - CH_NEUTRAL; // yaw
  pw[4] = CH_MAX + CH_OFFSET[4] - CH_MIN; // AUX1
  pw[5] = CH_MAX + CH_OFFSET[5] - CH_MIN; // AUX2
  pw[6] = CH_MAX + CH_OFFSET[6] - CH_MIN; // AUX3
  pw[7] = CH_MAX + CH_OFFSET[7] - CH_MIN; // AUX4
  start_H = PPM_PERIOD - (8 * CH_MAX + TOTAL_CH_OFFSET - 3 * CH_NEUTRAL - 5 * CH_MIN) - 9 * TIME_LOW;
  LED_state = LOW;
  isEmergency = true;
  digitalWrite( LED_PIN, LED_state );
  Serial.println("EMERGENCY !! ");
}
void software_reset() {
  pinMode(RST_PIN, OUTPUT);
  Serial.println("Reset!");
  digitalWrite(RST_PIN, LOW);
  Serial.println("RECOVERY");// resetするので表示されないのが正しい挙動
}
