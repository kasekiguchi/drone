// PPM は　Down pulse
// 各チャンネルは H (= CH_OFFSET - pw)と　L (= TIME_LOW)からなる
// REMAINING_W = sum(H[i]+L[i])
// PPM 1周期は start_H + TOTAL_CH_H + TIME_LOW からなる
#include <TimerOne.h>

uint8_t i; //符号なし8bit整数型(0~255)のi
#define LED_PIN 13 //13ピン(D10)をLED_PINと定義 現在結線されておらず，動作に関係していない．プログラム中には何度も登場するため確認が必要
// [ Green Red ] : HIGHで消灯、LOWで点滅
// 飛行可能（初期状態）： [ LOW HIGH ]
// Arming           :  [ LOW LOW  ]
// Emergence        :  [ HIGH LOW ]
#define GLED_PIN 15 // A1　15ピン(A1)をGLED_PINと定義　警告灯に接続
#define RLED_PIN 14 // A0　14ピン(A0)をRLED_PINと定義　警告灯に接続
#define EM_PIN 5    // 2 or 3のみ　ここでは3ピン(D3)をEM_PINと定義 緊急停止に関連
#define RST_PIN 18  // A4　18ピン(A4)をRST_PINと定義　プログラムのリセットに関係
volatile boolean isEmergency = false; //volatile:変数をレジスタではなくRAMからロードするよう,コンパイラに指示(割り込み関係のコードが関係)　変数isEmergencyにfalseを格納
boolean fReset = false; //変数boolean fResetにfalseを格納
boolean fInitial = true; //変数boolean fInitialにtrueを格納
boolean fstarthalf = false; //変数boolean fInitialにtrueを格納
/////////////////// PPM関係 ////////////////////
#define OUTPUT_PIN 2 // ppm output pin　2ピン(D2)をOUTPUT_PINと定義　このピンからPPM信号を出力する
char packetBuffer[255]; //char:符号付きの型(signed)で,-128から127までの数値として扱われる　受信したデータの格納場所packetBufferを定義している　[255]は一度に受信できる最大のバッファサイズ
#define TOTAL_INPUT 4 // number of input channels　使用されていないため考えなくてよい
#define TOTAL_CH 8    // number of channels 1フレームにおけるチャンネルの数を8と定義
// https://create-it-myself.com/research/study-ppm-spec/
// PPM信号の周期  [us] = 22.5 [ms] // オシロスコープでプロポ信号を計測した結果：上のリンク情報とも合致
#define PPM_PERIOD 22500 // PPMの周期判定はHIGHの時間が一定時間続いたら新しい周期の始まりと認知すると予想できるので、22.5より多少短くても問題無い＝＞これにより信号が安定した
#define TIME_LOW 360     // PPM信号 LOWパルス幅 [us]
#define CH_MIN 0         // PPM幅の最小 [us] MATLABから送信される信号の最小を定義　オフセットにも関係
#define CH_NEUTRAL 500   // PPM幅の中間 [us] MATLABから送信される信号の中間を定義　オフセットにも関係
#define CH_MAX 1000      // PPM幅の最大 [us] MATLABから送信される信号の最大を定義　オフセットにも関係
// PPM Channelの基本構造
// TIME_LOW + CH_OFFSET = 2000 = 2 [ms]　
// TIME_LOW + CH_MAX + CH_OFFSET = 1000 = 1 [ms]　計算が合わないこの計算式では3[ms]となるはずである．　400 + 1000 + 1620 = 3020　もしくは，CH_MAXが-となっていることが正しいと考えられる
// volatile uint16_t CH_OFFSET; // 共通オフセット値 2*CH_MAX - TIME_LOW + 20 = 2000 - 400 + 20 = 1620 ★オフセットとは周波数オフセットを表しているのか確認
// #define CH_OFFSET 1620       // transmitterシステムでは20が必要　★オフセットには20が追加されているが何故必要であるのかが不明
// #define TOTAL_CH_OFFSET 12960 //  8*CH_OFFSET 1フレーム分の合計オフセットを定義
#define CH_OFFSET 1655       // transmitterシステムでは20が必要　★オフセットには20が追加されているが何故必要であるのかが不明
#define TOTAL_CH_OFFSET 13240 //  8*CH_OFFSET 1フレーム分の合計オフセットを定義
//（特にroll入力が他の値が増加することで必要なoffset値が一度変化するので、AUX5をMAX値にしておくことで変化した後の値で一定にした。）
// CH1の値が他のCHの値に比べて不安定なのは上記の動作が原因だと考えられる　transmitterのプログラムで行っている可能性あり AUX5の意味が不明AUX4までしか定義されていないはずである
// volatile uint16_t TOTAL_CH_OFFSET = 0; // CH_OFFSETの合計
volatile uint8_t n_ch = TOTAL_CH; // 現在の chを保存　符号なし8bit整数型(0~255)n_chに1フレームにおけるチャンネルの数8を代入
volatile uint16_t t_sum = 0;      // us単位  1周期中の現在の使用時間　16bit整数型(-32768~32767)t_sumに1周期の始まりである0を代入
volatile uint16_t pw[TOTAL_CH];   // ch毎のパルス幅を保存　16bit整数型(-32768~32767)pwはch毎のパルス幅を記録して，その上限は8である
volatile uint16_t phw[TOTAL_CH];  // PPM周期を保つため、Pulse_control内のみで使用
volatile boolean isReceive_Data_Updated = false; //boolean isReceive_Data_Updatedにfalseを代入
volatile uint16_t start_H = PPM_PERIOD; //16bit整数型(-32768~32767)start_HにPPM_PERIOD(22500)を代入 スタート時のパルス幅
volatile uint16_t start_Hh = PPM_PERIOD; //16bit整数型(-32768~32767)start_HhにPPM_PERIOD(22500)を代入
volatile uint16_t REMAINING_W; //16bit整数型(-32768~32767)REMAINING_Wを定義
volatile uint16_t plus = 0;
//////////// シリアル通信が途絶えたとき用 ////////////////////////////////
volatile unsigned long last_received_time;

// ==================================================================
void setup()
{
  Serial.begin(115200); // MATLABの設定と合わせる　パソコンとマイコンの通信速度を合わせている
  // Serial.setTimeout(10); //
  Serial.println("Start"); //シリアル通信でメッセージ(Start)をPCに送信
  pinMode(LED_PIN, OUTPUT); //pinMode:ピンの動作を入力か出力に設定　13ピンが出力
  digitalWrite(LED_PIN, HIGH); //digitalWrite:指定したピンにHIGH(UNOは5V)もしくはLOW(0V)を出力　13ピンから5V出力
  pinMode(GLED_PIN, OUTPUT); //15(A1)ピンを出力に設定
  digitalWrite(GLED_PIN, LOW); //15(A1)ピンから0V出力
  pinMode(RLED_PIN, OUTPUT); //14(A0)ピンを出力に設定
  digitalWrite(RLED_PIN, HIGH); //14(A0)ピンから5V出力
  pinMode(EM_PIN, INPUT_PULLUP); // emergency_stop を割り当てるピン D3ピンを入力に設定でプルアップ抵抗を有効
  pinMode(RST_PIN, INPUT_PULLUP); //A4ピンを入力に設定でプルアップ抵抗を有効

  setupPPM(); // ppm 出力開始

  // 緊急停止
 attachInterrupt(digitalPinToInterrupt(EM_PIN), emergency_stop, RISING); // 緊急停止用　値の変化で対応（短絡から5V）
  while (Serial.available() <= 0) //受信データを受け取っていない時繰り返す　繰り返す中身がないため何もしない．
  {
  }
  last_received_time = micros(); //micros():Arduinoボードがプログラムの実行を開始した時から現在までの時間をマイクロ秒単位で返す約70分で0に戻る　最後に受信されたメッセージが読み取られた時刻をast_received_timeに格納
}

void loop()
{
  //receive_serial(); //ここは半透明となっているため動かない　信号を受信した場合
    if (!isEmergency)
    {
      receive_serial();
    }
    else
    {
      if (digitalRead(EM_PIN) == HIGH && fReset == false)
      {
        delay(500); // delay 前後で非常停止ボタンが押された状態ならreset可能に（チャタリング防止）
        if (digitalRead(EM_PIN) == HIGH)
        {
          
          Serial.println("Reset available.");
          digitalWrite(LED_PIN, LOW);
          digitalWrite(RLED_PIN, LOW);
          digitalWrite(GLED_PIN, HIGH);
          
          fReset = true;
        }
      }
      else if (fReset == true && digitalRead(EM_PIN) == false) // reset可能の状態で非常停止ボタンを戻したらリセット
      {
        //software_reset();
        SCB_AIRCR = 0x05FA0004; //Teensy
      }
    }
    
}
//*********** local functions  *************************//
void receive_serial() // ---------- loop function : receive signal by UDP 信号を受信したら実行
{
  // ch : 0 - 1000 is converted to 1000 - 2000 throttle on FC
  if (Serial.available() > 0) //信号を受信したら実行する
  {
    last_received_time = micros(); //最後に信号を受け取った時間を更新している
    Serial.println("received"); //シリアル通信でメッセージ(received)をPCに送信 信号が受信できたことを通知
    Serial.readBytes(packetBuffer, 2 * TOTAL_CH); //2 * TOTAL_CH(8) = 16バイトの数値をシリアル通信で受信してpacketBufferに保存
    Serial.println(micros() - last_received_time); //シリアル通信でメッセージをPCに送信　現在時間から最後に信号を受け取った時間を引いている
    if (packetBuffer) //もしpacketBufferならとはどういう意味？
    {
      REMAINING_W = PPM_PERIOD; //REMAINING_WにPPM_PERIOD(22500)を代入
      for (i = 0; i < TOTAL_CH; i++) //i=0から始めて，i<8まで1ずつ加算して繰り返す　恐らく8チャンネル繰り返せるようにしている
      {
        pw[i] = uint16_t(packetBuffer[i]) * 100 + uint16_t(packetBuffer[i + TOTAL_CH]); //16bit整数型(-32768~32767)の受信データ * 100 + 16bit整数型(-32768~32767)の受信データ[i+8] 全部で16バイトあるため
        // if (i == 0) //チャンネルが始まっていないとき(Start)
        // {
        //   pw[0] = pw[0] +8; // pw = ? + 5 
        // }
        if (pw[i] < CH_MIN) //受け取った信号が0未満の時
        {
          pw[i] = CH_MIN; // pw = 0
        }
        else if (pw[i] > CH_MAX) //1000より大きいとき
        {
          pw[i] = CH_MAX; // pw = 1000
        }
        pw[i] = CH_OFFSET - pw[i]; // transmitter システムの場合必要 1620-pw 1620 - pw ここでは信号が上下限を超えた時を決定している
        REMAINING_W -= pw[i]; //REMAINING_W - pw[i] 1フレームの内現在の残りから，使用したパルス幅を引いている
        

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
      last_received_time = micros();
      isReceive_Data_Updated = true; //isReceive_Data_Updatedにtrueを代入
      // if (pw[0] + pw[1] + pw[2] + pw[3] + pw[4] + pw[5] + pw[6] + pw[7] <= 11068)
      //   {
      //     pw[0] = pw[0] - 8;
      //   }
      start_H = REMAINING_W - 9 * TIME_LOW;// 9 times LOW time in each PPM period 1フレームから8つのHigh幅を引いた残り - 1フレーム分のLowパルス幅 = Start時のパルス幅
      //start_H = REMAINING_W - ( pw[0] + pw[1] + pw[2] + pw[3] + pw[4] + pw[5] + pw[6] + pw[7] ) - 9 * TIME_LOW;
      Serial.println(micros() - last_received_time); //最後に信号を受け取ってからどれくらい進行したか
    }
  }
  else if (micros() - last_received_time >= 500000) // Stop propellers after 0.5s signal lost. 0.5s信号が送られてこなかったら実行する 停止状態となる信号を送信するためのもの
  {
    pw[0] = CH_OFFSET - CH_NEUTRAL; // roll 1620 - 500 =1120
    pw[1] = CH_OFFSET - CH_NEUTRAL; // pitch 1620 - 500 =1120
    pw[2] = CH_OFFSET - CH_MIN;     // throttle 1620 - 0 =1620
    pw[3] = CH_OFFSET - CH_NEUTRAL; // yaw 1620 - 500 =1120
    pw[4] = CH_OFFSET;              // AUX1 1620
    pw[5] = CH_OFFSET;              // AUX2 1620
    pw[6] = CH_OFFSET;              // AUX3 1620
    pw[7] = CH_OFFSET;              // AUX4 1620
    start_H = PPM_PERIOD - (TOTAL_CH_OFFSET - 3 * CH_NEUTRAL - CH_MIN) - 9 * TIME_LOW; // 22500 - (12960 - 3 * 500 - 0) - 9 * 400 = 7440 Startのパルス幅
    //start_H = PPM_PERIOD - (( pw[0] + pw[1] + pw[2] + pw[3] + pw[4] + pw[5] + pw[6] + pw[7] + pw[8])) - 9 * TIME_LOW; // 22500 - (12960 - 3 * 500 - 0) - 9 * 400 = 7440 Startのパルス幅
    //        digitalWrite( GLED_PIN, HIGH );
    // digitalWrite( RLED_PIN, LOW );
  }
}

void Pulse_control() //★パルスの制御
{
  // if(fstarthalf == true)
  // {
  //   fstarthalf = false;
  //   Timer1.setPeriod(start_Hh);     // start 判定の H 時間待つ Start時のパルス幅分次の操作を行う
  //   digitalWrite(OUTPUT_PIN, HIGH); // PPM -> HIGH 2ピンから出力されている出力を5Vにする
  // }
  if (digitalRead(OUTPUT_PIN) == LOW) //D2ピンから出力されている出力が5Vの時実行 Lowパルスの制御
  {
    Timer1.setPeriod(TIME_LOW);    // 次の割込み時間を指定　Timer1.setPeriod:ライブラリが初期化された後に新しい期間を設定 次の操作を400us行う
    digitalWrite(OUTPUT_PIN, HIGH); // PPM -> LOW　D2ピンからの出力を0にする
  }
  else if (n_ch == TOTAL_CH) //2ピンの出力が5Vでなく，n_chが8に等しいとき(1フレームが終了した時)
  {
    n_ch = 0; //n_chを0に戻す
    start_Hh = start_H; //スタート時のパルス幅をstart_Hhに代入
    //    memcpy(phw, pw, sizeof(pw));// PPM 1周期を22.5 msに保つため、途中で変更されたものには対応しない
    for (i = 0; i < TOTAL_CH; i++) // PPM 1周期を22.5 msに保つため、途中で変更されたものには対応しない i = 0からi < 8 が成り立つ間iを1ずつ増やして繰り返す
    {
      phw[i] = pw[i]; //チャンネルiのHighパルス幅をphw[i]に代入
    }
    fstarthalf = true;
    Timer1.setPeriod(start_Hh);     // start 判定の H 時間待つ Start時のパルス幅分次の操作を行う
    digitalWrite(OUTPUT_PIN, LOW); // PPM -> HIGH D2ピンから出力されている出力を5Vにする
  }
  else //上記2つのどちらでもないとき
  {
    Timer1.setPeriod(phw[n_ch]);    // 時間を指定 Highパルス幅分次の操作を実行する
    digitalWrite(OUTPUT_PIN, LOW); // PPM -> HIGH D2ピンから出力されている出力を5Vにする
    n_ch++; //チャンネルを進める
  }
}

void setupPPM() // ---------- setup ppm signal configuration　ppm信号構成のセットアップ これは何も信号を送信していないときのPPM信号の出力設定だと思う
{
  pinMode(OUTPUT_PIN, OUTPUT); //D2ピンを出力に設定
  digitalWrite(OUTPUT_PIN, LOW); //D2ピンが0Vを出力
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
  start_H = PPM_PERIOD - (TOTAL_CH_OFFSET - 3 * CH_NEUTRAL - CH_MIN) - 9 * TIME_LOW; //22500-(12960 - 3*500 - 0) - 9 * 400 = 7440 Startのパルス幅
  // start_H = PPM_PERIOD - (( pw[0] + pw[1] + pw[2] + pw[3] + pw[4] + pw[5] + pw[6] + pw[7] + pw[8])) - 9 * TIME_LOW; // 22500 - (12960 - 3 * 500 - 0) - 9 * 400 = 7440 Startのパルス幅
  // CPUのクロック周波数でPPM信号を制御
  Timer1.initialize(PPM_PERIOD); //マイクロ秒単位で設定 initialize(microseconds): Timer1の初期化とマイクロ秒単位でのタイマー時間指定　フレーム幅が終わったらタイマーを初期化
  Timer1.attachInterrupt(Pulse_control); //attachInterrupt(func): タイマー終了時に呼び出す関数の指定 タイマーが終了したら1つ前のvoidのPulse_controlを読み込んでいる？
}
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
  delay(500);
  pinMode(RST_PIN, OUTPUT);
  digitalWrite(RST_PIN, LOW);
  Serial.println("RECOVERY"); // resetするので表示されないのが正しい挙動
}
