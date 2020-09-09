// 2020/09/04 : 飛行を確認：UDPでの９軸センサー情報取得はオフ
// 9軸センサー情報を取得するにはsetup, loop のコメントを外し，OUTPUT_PINを0にし，ESPｒへの接続pin を2 -> 0に変更する必要がある．
#include <Arduino.h>
#include <ESP8266WiFi.h> //https://github.com/esp8266/Arduino
#include <WiFiUDP.h>
#include <Wire.h> //I2Cライブラリ
#include <SPI.h> // I2Cならいらないかも
#include <SparkFunLSM9DS1.h>
#define CPU_FRE 160 // CPUクロック周波数 [MHz]
#include <math.h>

uint8_t i;

unsigned int droneNumber = 25; //機体番号を入力

#define OUTPUT_PIN 2 // PPM出力のピン番号

const char *ssid = "acsl-mse-arl-YAMAHA";
const char *password = "wifi-acsl-mse";

//アルディーノの値を受け取るMatlabを実行しているPCのIP
const char *to_udp_address = "192.168.50.4"; //送信先のアドレス
const int to_udp_port = 8000;               //送信相手のポート番号

// ESPrのIPアドレスの設定
IPAddress myIP(192, 168, 50, 100+droneNumber);  // 機体により下番号変更

IPAddress gateway(192, 168, 50, 4);//アルディーノの値を受け取るMatlabを実行しているPCのIP
const int my_udp_port = 8000+droneNumber;        //開放する自ポート

/////////////////// WiFi関係 ////////////////////


//IPAddress myIP(192, 168, 1, 100+droneNumber);  // 機体により下番号変更
//IPAddress gateway(192, 168, 1, 1);//アルディーノの値を受け取るMatlabを実行しているPCのIP
//IPAddress myIP(192, 168, 9, 100 + droneNumber); // 機体により下番号変更
//IPAddress gateway(192, 168, 9, 1);
IPAddress subnet(255, 255, 255, 0);

WiFiUDP udp;

boolean connected = false;
unsigned long tmptmp;
uint8_t old_receive_data = 0;
uint32_t now_time = 0;
int16_t interval = 100;    //UDPデータ送信間隔
boolean isReceive_Data_Updated = false;

/////////////////// 9軸関係 ////////////////////
//  read : https : //learn.sparkfun.com/tutorials/lsm9ds1-breakout-hookup-guide
LSM9DS1 imu;
//#define DECLINATION -8.58 // Declination (degrees) in Boulder, CO.
//https://www.magnetic-declination.com/
#define DECLINATION -7.39 // Declination (degrees) in Tokyo Japan.
double gxVal = 0; //ジャイロｘ軸用データーレジスタ
double gyVal = 0; //ジャイロｙ軸用データーレジスタ
double gzVal = 0; //ジャイロｚ軸用データーレジスタ
double axVal = 0; //Axis ｘ用データーレジスタ
double ayVal = 0; //Axis ｙ用データーレジスタ
double azVal = 0; //Axis ｚ用データーレジスタ
double mxVal = 0; //Mag ｘ用データーレジスタ
double myVal = 0; //Mag ｙ用データーレジスタ
double mzVal = 0; //Mag ｚ用データーレジスタ
double rxVal = 0; //roll用データーレジスタ
double ryVal = 0; //pitch用データーレジスタ
double rzVal = 0; //yaw用データーレジスタ
double send_i = 0;
char T[100];
char GX[100];
char GY[100];
char GZ[100];
char AX[100];
char AY[100];
char AZ[100];
char MX[100];
char MY[100];
char MZ[100];
char RX[100];
char RY[100];
char RZ[100];
char SENDVAL[255];
/////////////////// PPM関係 ////////////////////
char packetBuffer[255];
#define TOTAL_INPUT 4      // number of input channels
#define TOTAL_CH 8         // number of channels
#define TIME_PERIOD 22500  // PPM信号の周期 // オシロスコープでプロポ信号を計測した結果
#define TIME_LOW 400       // PPM信号 LOW時の幅　 // 同上
//#define TIME_HIGH_MIN 700  // PPM幅の最小        // 最小600 に余裕をもたせた値
//#define TIME_HIGH_MAX 1500 // PPM幅の最大　      // 最大1600 に余裕をもたせた値
#define TIME_HIGH_MIN 600  // PPM幅の最小
#define TIME_HIGH_MAX 1600 // PPM幅の最大

uint8_t n_ch = 0;      // 現在の chを保存
uint8_t t_sum = 0;     // us単位  1周期中の現在の使用時間
uint16_t pw[TOTAL_CH]; // ch毎のパルス幅を保存

unsigned long t_now;
unsigned long t_lost;

void setup()
{
  Serial.begin(115200);
  delay(1000);
  connectToWiFi();

  /////////////////// PPM関係 ////////////////////
  setupPPM();
  
  ///////////////9軸関係/////////////////////////////
//  connectToLSM9DS1();
}

void loop()
{
//  read_calc_LSM9DS1();
//  if (isReceive_Data_Updated) // 送るのは送ってきた直後の値
//  {
//    sendUDP(); 
//    isReceive_Data_Updated = false;
//  }
  receiveUDP();
}


//*********** local functions  *************************//
void receiveUDP()
{
  int packetSize = udp.parsePacket();
  if (packetSize)
  {
    int len = udp.read(packetBuffer, packetSize);
    if (len > 0)
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
      //Serial.printf("Received %d bytes from %s, port %d\n", packetSize, udp.remoteIP().toString().c_str(), udp.remotePort());

      t_lost = ESP.getCycleCount();
      isReceive_Data_Updated = true;
    }
  else if (ESP.getCycleCount() - t_lost >= 2.000 * CPU_FRE * 1000000L)// Stop propellers after 1s signal lost. 
  {
//    for (i = 0; i < TOTAL_INPUT; i++)
//    {
//      pw[i] = 1100;
//    }
    pw[0] = 1100;
    pw[1] = 1100;
    pw[2] = 600; // throttle
    pw[3] = 1100;
    for (i = TOTAL_INPUT; i < TOTAL_CH; i++)
    {
      pw[i] = 600;
    }
  }
  }
}

void sendUDP()
{
    udp.beginPacket(to_udp_address, to_udp_port);
    udp.write(SENDVAL);
    udp.endPacket();
    Serial.println(SENDVAL);
}

void connectToWiFi()
{
  WiFi.begin(ssid, password);
  WiFi.config(myIP, gateway, subnet);
  Serial.println("start_connect");
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println("CONNECTED!");

  Serial.println("WiFi connected");
  Serial.print("Local IP address: ");
  Serial.println(myIP);
  Serial.println(WiFi.localIP());
}

void setupPPM()
{
  udp.begin(my_udp_port);

  pinMode(OUTPUT_PIN, OUTPUT);
  digitalWrite(OUTPUT_PIN, LOW);

  for (i = 0; i < TOTAL_INPUT; i++)
  {
    pw[i] = 1100;
  }
  pw[2] = 600; // throttle
  for (i = TOTAL_INPUT; i < TOTAL_CH; i++)
  {
    pw[i] = 600;
  }

  // CPUのクロック周波数でPPM信号を制御
  noInterrupts();
  timer0_isr_init();
  timer0_attachInterrupt(Pulse_control);
  timer0_write(ESP.getCycleCount() + 0.030 * CPU_FRE * 1000000L); // 30 msec (CPU_FRE*10^6 == 1sec)
  interrupts();
  unsigned long t_lost = ESP.getCycleCount();
}

void connectToLSM9DS1()
{
  Wire.begin();             // I2C 開始
  if (imu.begin() == false) //センサ接続エラー時の表示
  {
    Serial.println("Failed to communicate with LSM9DS1.");
    Serial.println("Double-check wiring.");
    Serial.println("Default settings in this sketch will "
                   "work for an out of the box LSM9DS1 "
                   "Breakout, but may need to be modified "
                   "if the board jumpers are.");
    while (1)
    ;
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
      timer0_write(t_now + (TIME_PERIOD - t_sum) * CPU_FRE * 1L); //時間を指定
      t_sum = 0;
      n_ch = 0;
    }
    else
    {
      if (n_ch == 0 || n_ch == 1 || n_ch == 3)
      {
        if (pw[n_ch] < TIME_HIGH_MIN)
        {
          pw[n_ch] = TIME_HIGH_MIN;
        }
        else if (pw[n_ch] > TIME_HIGH_MAX)
        {
          pw[n_ch] = TIME_HIGH_MAX;
        }
      }
      else if (n_ch == 2)
      {
        if (pw[n_ch] < 600)
        {
          pw[n_ch] = 600;
        }
        else if (pw[n_ch] > TIME_HIGH_MAX)
        {
          pw[n_ch] = TIME_HIGH_MAX;
        }
      }
      timer0_write(t_now + pw[n_ch] * CPU_FRE * 1L); //時間を指定
      t_sum += pw[n_ch];
      n_ch++;
    }
  }
}
void read_calc_LSM9DS1(){
  // Update the sensor values whenever new data is available
  if (imu.gyroAvailable())
  {
    // To read from the gyroscope,  first call the
    // readGyro() function. When it exits, it'll update the
    // gx, gy, and gz variables with the most current data.
    imu.readGyro();
  }
  if (imu.accelAvailable())
  {
    // To read from the accelerometer, first call the
    // readAccel() function. When it exits, it'll update the
    // ax, ay, and az variables with the most current data.
    imu.readAccel();
  }
  if (imu.magAvailable())
  {
    // To read from the magnetometer, first call the
    // readMag() function. When it exits, it'll update the
    // mx, my, and mz variables with the most current data.
    imu.readMag();
  }
  calc_Attitude(imu.ax, imu.ay, imu.az,
           -imu.my, -imu.mx, imu.mz);
  tmptmp = millis();
  gxVal = (imu.calcGyro(imu.gx));
  gyVal = (imu.calcGyro(imu.gy));
  gzVal = (imu.calcGyro(imu.gz));
  axVal = (imu.calcAccel(imu.ax));
  ayVal = (imu.calcAccel(imu.ay));
  azVal = (imu.calcAccel(imu.az));
  mxVal = (imu.calcMag(imu.mx));
  myVal = (imu.calcMag(imu.my));
  mzVal = (imu.calcMag(imu.mz));

  // Convert everything from degrees/s to radians/s:
  // おそらく．degree/s で算出されていそう（calc_Attitudeの中でわざわざdegreeに変換していたので．）
  gxVal *= PI / 180.0;
  gyVal *= PI / 180.0;
  gzVal *= PI / 180.0;

  //dtostrf(浮動小数点値, 文字列の長さ, 小数点以下の桁数, 文字列バッファ)
  //”文字列の長さ”では、指定された長さの中に右詰めで値を表示して左側はスペースで埋められます。 0を指定すると左側から値が表示されます。
  //”小数点以下の桁数”では、四捨五入して切り捨てる桁数を表します。
  //char buf[16];
  //dtostrf((double)1234.5, 9, 3, buf);
  //出力結果： " 1234.500"
  dtostrf(gxVal, 10, 5, GX);
  dtostrf(gyVal, 10, 5, GY);
  dtostrf(gzVal, 10, 5, GZ);
  dtostrf(axVal, 10, 5, AX);
  dtostrf(ayVal, 10, 5, AY);
  dtostrf(azVal, 10, 5, AZ);
  dtostrf(mxVal, 10, 5, MX);
  dtostrf(myVal, 10, 5, MY);
  dtostrf(mzVal, 10, 5, MZ);
  dtostrf(rxVal, 10, 5, RX);
  dtostrf(ryVal, 10, 5, RY);
  dtostrf(rzVal, 10, 5, RZ);
  dtostrf(tmptmp, 8, 0, T);
  sprintf(SENDVAL, "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s", T, GX, GY, GZ, AX, AY, AZ, MX, MY, MZ, RX, RY, RZ);
}

// https://github.com/sparkfun/SparkFun_LSM9DS1_Arduino_Library/blob/master/examples/LSM9DS1_Basic_I2C/LSM9DS1_Basic_I2C.ino
// Calculate pitch, roll, and heading.
// Pitch/roll calculations take from this app note:
// http://cache.freescale.com/files/sensors/doc/app_note/AN3461.pdf?fpsp=1
// Heading calculations taken from this app note:
//https : //cdn-shop.adafruit.com/datasheets/AN203_Compass_Heading_Using_Magnetometers.pdf
void calc_Attitude(float ax, float ay, float az, float mx, float my, float mz)
{
  rxVal = atan2(ay, az);
  ryVal = atan2(-ax, sqrt(ay * ay + az * az));

  if (my == 0)
    rzVal = (mx < 0) ? PI : 0;
  else
    rzVal = atan2(mx, my); // = atan(mx/my)

  // add by sekiguchi
  if (my < 0)
    rzVal = 3 * PI / 2 - rzVal;
  else
    rzVal = PI / 2 - rzVal;

  rzVal -= DECLINATION * PI / 180; // Japan is negative by https://www.magnetic-declination.com/

  //  if (rzVal > PI)
  //    rzVal -= (2 * PI);
  //  else if (rzVal < -PI)
  //    rzVal += (2 * PI);

  //  // Convert everything from radians to degrees:
  //  heading *= 180.0 / PI;
  //  pitch *= 180.0 / PI;
  //  roll *= 180.0 / PI;

  //  Serial.print("Pitch, Roll: ");
  //  Serial.print(pitch, 2);
  //  Serial.print(", ");
  //  Serial.println(roll, 2);
  //  Serial.print("Heading: ");
  //  Serial.println(heading, 2);
}
