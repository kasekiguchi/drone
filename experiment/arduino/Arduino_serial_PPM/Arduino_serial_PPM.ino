// PPM は　Down pulse
// 各チャンネルは H (= CH_OFFSET - pw)と　L (= TIME_LOW)からなる
// REMAINING_W = sum(H[i]+L[i])
// PPM 1周期は start_H + TOTAL_CH_H + TIME_LOW からなる
#include <TimerOne.h>

uint8_t i; //符号なし8bit整数型(0~255)
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
#define TOTAL_INPUT 4 // number of input channels　インプットも8ではないの？
#define TOTAL_CH 8    // number of channels
// https://create-it-myself.com/research/study-ppm-spec/
// PPM信号の周期  [us] = 22.5 [ms] // オシロスコープでプロポ信号を計測した結果：上のリンク情報とも合致
#define PPM_PERIOD 22500 // PPMの周期判定はHIGHの時間が一定時間続いたら新しい周期の始まりと認知すると予想できるので、22.5より多少短くても問題無い＝＞これにより信号が安定した
#define TIME_LOW 400     // PPM信号 LOW時の幅 [us] // 上のリンク情報に合わせる ここ資料に合わせると300なのでは？
#define CH_MIN 0         // PPM幅の最小 [us] おそらくMATLABからの信号の最小
#define CH_NEUTRAL 500   // PPM幅の中間 [us] おそらくMATLABからの信号の中間
#define CH_MAX 1000      // PPM幅の最大 [us] おそらくMATLABからの信号の最大
// PPM Channelの基本構造
// TIME_LOW + CH_OFFSET = 2000 = 2 [ms]
// TIME_LOW + CH_MAX + CH_OFFSET = 1000 = 1 [ms]　計算が合わない3[ms]となるのでは？　400+1000+1620=3020
// volatile uint16_t CH_OFFSET; // 共通オフセット値 2*CH_MAX - TIME_LOW + 20 = 2000 - 400 + 20
#define CH_OFFSET 1620        // transmitterシステムでは20が必要　どういうこと？
#define TOTAL_CH_OFFSET 12960 //  8*CH_OFFSET ここで8チャンネル分のオフセットを足し合わせてる
//（特にroll入力が他の値が増加することで必要なoffset値が一度変化するので、AUX5をMAX値にしておくことで変化した後の値で一定にした。）　意味が分からないがこれがCH1が不安定な原因か？AUX5とはなに4までしかないのでは
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
  Serial.begin(115200); // MATLABの設定と合わせる　この数字は何？　パソコンとマイコンの通信速度を合わせている
  // Serial.setTimeout(10); //
  Serial.println("Start"); //シリアル通信でメッセージをPCに送信
  pinMode(LED_PIN, OUTPUT); //pinMode:ピンの動作を入力か出力に設定　13ピンが出力
  digitalWrite(LED_PIN, HIGH); //digitalWrite:指定したピンにHIGH(UNOは5V)もしくはLOW(0V)を出力　13ピンから5V出力
  pinMode(GLED_PIN, OUTPUT); //15(A1)ピンを出力に設定
  digitalWrite(GLED_PIN, LOW); //15(A1)ピンから0V出力
  pinMode(RLED_PIN, OUTPUT); //14(A0)ピンを出力に設定
  digitalWrite(RLED_PIN, HIGH); //14(A0)ピンから5V出力
  pinMode(EM_PIN, INPUT_PULLUP); // emergency_stop を割り当てるピン 3ピンを入力に設定でプルアップ抵抗を有効
  pinMode(RST_PIN, INPUT_PULLUP); //A4ピンを入力に設定でプルアップ抵抗を有効

  setupPPM(); // ppm 出力開始

  // 緊急停止
  // attachInterrupt(digitalPinToInterrupt(EM_PIN), emergency_stop, RISING); // 緊急停止用　値の変化で対応（短絡から5V）
  while (Serial.available() <= 0) //受信データがゼロ以下の時繰り返す　繰り返す中身がない．
  {
  }
  last_received_time = micros(); //micros():Arduinoボードがプログラムの実行を開始した時から現在までの時間をマイクロ秒単位で返す約70分で0に戻る
}

void loop()
{
  receive_serial(); //ここは半透明となっているため動かさない
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
void receive_serial() // ---------- loop function : receive signal by UDP UDPとは？信号を受け取ったら実行するってこと？
{
  // ch : 0 - 1000 is converted to 1000 - 2000 throttle on FC
  if (Serial.available() > 0) //受け取った信号が0より大きいのならここを実行する
  {
    last_received_time = micros(); //最後に信号を受け取った時間を記録している？
    Serial.println("received"); //シリアル通信でメッセージをPCに送信
    Serial.readBytes(packetBuffer, 2 * TOTAL_CH); //2 * TOTAL_CH(8)バイトの数値をシリアル通信で受信してpacketBufferに保存
    Serial.println(micros() - last_received_time); //シリアル通信でメッセージをPCに送信　現在時間から最後に信号を受け取った時間を引いている
    if (packetBuffer) //もしpacketBufferならとはどういう意味？
    {
      REMAINING_W = PPM_PERIOD; //REMAINING_WにPPM_PERIOD(22500)を代入
      for (i = 0; i < TOTAL_CH; i++) //i=0から始めて，i<すべてのオフセットを足し合わせたTOTAL_CH_OFFSETの間12960まで1ずつ加算して繰り返す　恐らく8チャンネル繰り返せるようにしている
      {
        pw[i] = uint16_t(packetBuffer[i]) * 100 + uint16_t(packetBuffer[i + TOTAL_CH]); //16*100+　ここら辺よくわからない
        if (i == 0) //チャンネルが始まっていないとき
        {
          pw[0] = pw[0] + 5;
        }
        if (pw[i] < CH_MIN) //受け取った信号が0未満の時
        {
          pw[i] = CH_MIN; //0
        }
        else if (pw[i] > CH_MAX) //1000より大きいとき
        {
          pw[i] = CH_MAX; //1000
        }

        pw[i] = CH_OFFSET - pw[i]; // transmitter システムの場合必要 1620-pw
        REMAINING_W -= pw[i]; //REMAINING_W - pw[i] これ何やっているか全くわからん

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
  if (digitalRead(OUTPUT_PIN) == HIGH) //2ピンから出力されている出力が5Vの時実行
  {
    Timer1.setPeriod(TIME_LOW);    // 次の割込み時間を指定
    digitalWrite(OUTPUT_PIN, LOW); // PPM -> LOW　2ピンからの出力を0にする
  }
  else if (n_ch == TOTAL_CH) //2ピンの出力が5Vでなく，n_chが8に等しいとき
  {
    n_ch = 0; //n_chを0に戻す
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

void setupPPM() // ---------- setup ppm signal configuration　ppm信号構成のセットアップ これは何も信号を送信していないときのPPM信号の出力設定だと思う
{
  pinMode(OUTPUT_PIN, OUTPUT); //2ピンを出力に設定
  digitalWrite(OUTPUT_PIN, LOW); //2ピンが0Vを出力
  // CH_OFFSET = 2*CH_MAX - TIME_LOW + 20;// commom offset
  // TOTAL_CH_OFFSET = 8*CH_OFFSET;
  pw[0] = CH_OFFSET - CH_NEUTRAL; // roll 1620-500=1120
  pw[1] = CH_OFFSET - CH_NEUTRAL; // pitch 1620-500=1120
  pw[2] = CH_OFFSET - CH_MIN;     // throttle 1620- 0=1620
  pw[3] = CH_OFFSET - CH_NEUTRAL; // yaw 1620-500=1120
  pw[4] = CH_OFFSET;              // AUX1 1620
  pw[5] = CH_OFFSET;              // AUX2 1620
  pw[6] = CH_OFFSET;              // AUX3 1620
  pw[7] = CH_OFFSET;              // AUX4 1620
  start_H = PPM_PERIOD - (TOTAL_CH_OFFSET - 3 * CH_NEUTRAL - CH_MIN) - 9 * TIME_LOW; //22500-(12960 - 3*500 - 0) - 9 * 
  // CPUのクロック周波数でPPM信号を制御
  Timer1.initialize(PPM_PERIOD); //マイクロ秒単位で設定 initialize(microseconds): Timer1の初期化とマイクロ秒単位でのタイマー時間指定　フレーム幅が終わったらタイマーを初期化
  Timer1.attachInterrupt(Pulse_control); //attachInterrupt(func): タイマー終了時に呼び出す関数の指定 タイマーが終了したら1つ前のvoidのPulse_controlを読み込んでいる？
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
