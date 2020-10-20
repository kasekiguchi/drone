// arduino の設定は
// http://trac.switch-science.com/wiki/esp_dev_arduino_ide
// CPU Frequency を 160 MHzにしないとFCにPPMを送れない．
// PPM は　Down pulse
#include <Arduino.h>
#include <ESP8266WiFi.h> //https://github.com/esp8266/Arduino
//#include <WiFiUDP.h>
#include <Wire.h> //I2Cライブラリ
//#include <SPI.h> // I2Cならいらないかも
#include <SparkFunLSM9DS1.h>
#define CPU_FRE 160 // CPUクロック周波数 [MHz]
//#include <math.h>

uint8_t i;

#define EM_PIN 4 // emergency stop pin
#define OUTPUT_PIN 2 // ppm output pin
/////////////////// PPM関係 ////////////////////
char packetBuffer[255];
#define TOTAL_INPUT 4      // number of input channels
#define TOTAL_CH 8         // number of channels
// https://create-it-myself.com/research/study-ppm-spec/
#define PPM_PERIOD 22500  // PPM信号の周期  [us] = 22.5 [ms] // オシロスコープでプロポ信号を計測した結果：上のリンク情報とも合致
#define TIME_LOW 300       // PPM信号 LOW時の幅 [us] // 上のリンク情報に合わせる
//#define TIME_HIGH_MIN 700  // PPM幅の最小 [us] // 上のリンク情報に合わせる
//#define TIME_HIGH_MAX 1700 // PPM幅の最大 [us] // 上のリンク情報に合わせる
#define TIME_HIGH_MIN 600  // PPM幅の最小 [us] : MATLAB側のプログラムを変えないように最後に100を足すようにしている
#define TIME_HIGH_MAX 1600 // PPM幅の最大 [us] : MATLAB側のプログラムを変えないように最後に100を足すようにしている

uint8_t n_ch = 0;      // 現在の chを保存
uint16_t t_sum = 0;     // us単位  1周期中の現在の使用時間
uint16_t pw[TOTAL_CH]; // ch毎のパルス幅を保存

unsigned long t_now;
unsigned long last_received_time;
boolean isReceive_Data_Updated = false;
boolean isEmergency = false;
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
      Serial.print("Received :[");
      for (i = 0; i < TOTAL_CH; i++)
      {
        Serial.print(" ");
        Serial.print(pw[i]);
        Serial.print(" ");
      }
      Serial.print("]\r\n");

      last_received_time = ESP.getCycleCount();
      isReceive_Data_Updated = true;
    }
    else if (ESP.getCycleCount() - last_received_time >= 2.000 * CPU_FRE * 1000000L)// Stop propellers after 0.5s signal lost.
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
  t_now = ESP.getCycleCount(); // 現在の周波数のカウントを取得
  if (digitalRead(OUTPUT_PIN) == HIGH)
  {
    digitalWrite(OUTPUT_PIN, LOW);                 // PPM -> LOW
    timer0_write(t_now + TIME_LOW * CPU_FRE * 1L); // 次の割込み時間を指定
    t_sum += TIME_LOW;
  }
  else if (digitalRead(OUTPUT_PIN) == LOW)
  {
    digitalWrite(OUTPUT_PIN, HIGH); //PPM -> HIGH
    if (n_ch == TOTAL_CH)
    {
      timer0_write(t_now + (PPM_PERIOD - t_sum) * CPU_FRE * 1L); //PPM１周期分待つ
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
      timer0_write(t_now + (100 + pw[n_ch]) * CPU_FRE * 1L); //時間を指定
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
  noInterrupts();
  timer0_isr_init();
  timer0_attachInterrupt(Pulse_control);// timer 終了時に呼び出す関数の登録
  timer0_write(ESP.getCycleCount() + 0.030 * CPU_FRE * 1000000L); // 30 msec (CPU_FRE*10^6 == 1sec) : 次の割り込み時間を設定
  interrupts();
  unsigned long last_received_time = ESP.getCycleCount();
}

void emergency_stop()
{
  pw[0] = 1100; // roll
  pw[1] = 1100; // pitch
  pw[2] = 600; // throttle
  pw[3] = 1100; // yaw
  pw[4] = 600; // AUX1
  pw[5] = 600; // AUX2
  pw[6] = 600; // AUX3
  pw[7] = 600; // AUX4
  isEmergency = true;
}
// ==================================================================
void setup()
{
  Serial.begin(115200);
  Serial.print("Start");
  // 緊急停止
  pinMode(EM_PIN, INPUT);
  attachInterrupt(EM_PIN, emergency_stop, RISING); // 緊急停止用　LOWからHIGHで停止
  /////////////////// PPM関係 ////////////////////
  setupPPM();
}

void loop()
{
  if (!isEmergency)
  {
    receive_serial();
  }
}
