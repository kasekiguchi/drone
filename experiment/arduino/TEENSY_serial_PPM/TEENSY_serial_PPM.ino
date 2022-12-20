// PPM は　Down pulse
// 各チャンネルは H (= CH_OFFSET - pw)と　L (= TIME_LOW)からなる
// TOTAL_CH_W = sum(H[i]+L[i])
// PPM 1周期は start_H + TOTAL_CH_H + TIME_LOW からなる
#include <TimerOne.h>

/////////////////// PPM関係 ////////////////////
char packetBuffer[1023];
#define TOTAL_INPUT 4      // number of input channels
#define TOTAL_CH 8         // number of channels
// https://create-it-myself.com/research/study-ppm-spec/
#define PPM_PERIOD 22500  // PPM信号の周期  [us] = 22.5 [ms] // オシロスコープでプロポ信号を計測した結果：上のリンク情報とも合致
#define TIME_LOW 400       // PPM信号 LOW時の幅　 // 同上 Futaba はこちら
#define TIME_HIGH_MIN 0  // PPM幅の最小 [us] : MATLAB側のプログラムを変えないように最後に100を足すようにしている
#define TIME_HIGH_MAX 1000 // PPM幅の最大 [us] : MATLAB側のプログラムを変えないように最後に100を足すようにしている

#define CH_MIN 0  // PPM幅の最小 [us] 
#define CH_NEUTRAL 500 // PPM幅の中間 [us] 
#define CH_MAX 1000 // PPM幅の最大 [us] 

#define CH_OFFSET 600 // 共通オフセット値

//（特にroll入力が他の値が増加することで必要なoffset値が一度変化するので、AUX5をMAX値にしておくことで変化した後の値で一定にした。）
volatile uint16_t TOTAL_CH_OFFSET = 0; // CH_OFFSETの合計
volatile uint8_t n_ch = TOTAL_CH;      // 現在の chを保存
volatile uint16_t pw[TOTAL_CH];  // ch毎のパルス幅を保存
volatile uint16_t phw[TOTAL_CH]; // PPM周期を保つため、Pulse_control内のみで使用
volatile uint16_t start_H = PPM_PERIOD;
volatile uint16_t start_Hh = PPM_PERIOD;
volatile uint16_t TOTAL_CH_W;

#define OUTPUT_PIN 2 // PPM出力のピン番号 加速度使うなら０

uint8_t i;

//*********** local functions  *************************//

void setupPPM()// ---------- setup ppm signal configuration
{

  pinMode(OUTPUT_PIN, OUTPUT);
  digitalWrite(OUTPUT_PIN, LOW);
      pw[0] = CH_NEUTRAL; // roll
      pw[1] = CH_NEUTRAL; // pitch
      pw[2] = CH_MIN;              // throttle
      pw[3] = CH_NEUTRAL; // yaw
      pw[4] = CH_MIN; // AUX1
      pw[5] = CH_MIN; // AUX2
      pw[6] = CH_MIN; // AUX3
      pw[7] = CH_MIN; // AUX4
  start_H = PPM_PERIOD - 8 * CH_OFFSET - 3 * CH_NEUTRAL - 9 * TIME_LOW;
  // CPUのクロック周波数でPPM信号を制御
  Timer1.initialize(PPM_PERIOD); //マイクロ秒単位で設定
  Timer1.attachInterrupt(Pulse_control);
}


void receive_serial()// ---------- loop function : receive signal by UDP
{
  // ch : 0 - 1000 is converted to 1000 - 2000 throttle on FC
  if (Serial.available() > 0)
  {
    Serial.readBytesUntil(';', packetBuffer, 2 * TOTAL_CH + 1);
    if (packetBuffer)
    {
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
      }
    //  Serial8.println("msg = " + String(pw[0]) + ", " + String(pw[1]) + ", " + String(pw[2]) + ", " + String(pw[3]) + ", " + String(pw[4]) + ", " + String(pw[5]) + ", " + String(pw[6]) + ", " + String(pw[7]) + ";");
      start_H = PPM_PERIOD - TOTAL_CH_W - 8*CH_OFFSET - 9*TIME_LOW;// 9 times LOW time in each PPM period      
    }
  }
}

void Pulse_control()
{
  if (digitalRead(OUTPUT_PIN) == LOW) // TeensyのPPM出力をオシロスコープで見るとLOW-HIGHの関係が逆転しているため
  {
    digitalWrite(OUTPUT_PIN, HIGH);                 // PPM -> LOW
    Timer1.setPeriod(TIME_LOW);// 次の割込み時間を指定
    //Serial.println(TIME_LOW);
  }
  else if (n_ch == TOTAL_CH)
  {
    n_ch = 0;
    start_Hh = start_H;
    for(i = 0; i < TOTAL_CH; i++)// PPM 1周期を22.5 msに保つため、途中で変更されたものには対応しない
    {
      phw[i] =  pw[i];
    }
    digitalWrite(OUTPUT_PIN, LOW); //PPM -> HIGH
    Timer1.setPeriod(start_Hh);// start 判定の H 時間待つ    
    //Serial.println(start_Hh);
  }
  else
  {
    Timer1.setPeriod(phw[n_ch] + CH_OFFSET);// 時間を指定    
    digitalWrite(OUTPUT_PIN, LOW); //PPM -> HIGH
    n_ch++;
  }
}

// ==================================================================
void setup()
{
  Serial.begin(115200);
  //Serial8.begin(9600);

  /////////////////// PPM関係 ////////////////////
  setupPPM();

  while(Serial.available() <= 0){}
//  while(Serial8.available() <= 0){}
}

void loop()
{
  receive_serial();
}
