#include <WiFi.h>
#include "esp_system.h"
// https://massapple.hatenablog.com/entry/2018/10/30/012359
// motor x2 + servo x1
const int servo = 22; //サーボのピン番号22pin
const int frequ = 50; //周波数50Hz
const int Amotor1 = 17;
const int Amotor2 = 16;
//const int Bmotor1 = 19;
//const int Bmotor2 = 18;
const char* ssid = "KMHOME"; //ご自分のルーターのSSIDに書き換えてください。
const char* password = "kasekiGU"; //ご自分のルーターのパスワードに書き換えてください。
 
WiFiServer server(80);
 
void setup()
{
    delay(1000);
    Serial.begin(115200);
    
  //サーボのPWMの設定チャンネル、ピン、周波数の定義
   ledcSetup(0, frequ, 8);  // 0ch 50 Hz 8bit resolution
   ledcAttachPin(servo, 0); // 15pin, 0ch
   //モーターの設定、ピン番号
    pinMode(Amotor1,OUTPUT); //set Amotor1 
    pinMode(Amotor2,OUTPUT); //set Amotor2
//    pinMode(Bmotor1,OUTPUT); //set Bmotor1
//    pinMode(Bmotor2,OUTPUT); //set Bmotor2
 
    delay(10);
  //シリアルモニタ表示
    Serial.println();
    Serial.println();
    Serial.print("Connecting to ");
    Serial.println(ssid);
    
  //wifiのssid,パスワード設定
    WiFi.begin(ssid, password);
 
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
 //シリアルモニタ表示
    Serial.println("");
    Serial.println("WiFi connected");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
     
    server.begin();
 
}
//モーター制御変更時0.5sだけ停止
void stop(){
          digitalWrite(Amotor1, LOW);
          digitalWrite(Amotor2, LOW);
  //        digitalWrite(Bmotor1, LOW);
  //        digitalWrite(Bmotor2, LOW);
          delay(500);
}
void loop(){
 WiFiClient client = server.available();
 
  if (client) {
    Serial.println("new client");
    String currentLine = "";
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        Serial.write(c);
        if (c == '\n') {
          if (currentLine.length() == 0) {
            
            //操作ページの設定
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type:text/html");
            client.println(); 
            client.println("<!DOCTYPE html>");
            client.println("<html>");
            client.println("<head>");
            client.println("<meta name='viewport' content='initial-scale=1.5'>");
            client.println("</head>");
            client.println("<body>");
            client.println("<form method='get'>");
            client.println("<font size='4'>ESP-WROOM-32<br>");
            client.println("</font><br>");
            client.println("<br>");
            client.println("<center>");
            client.println("<input type='submit' name=0 value='F' style='background-color:#248; color:#fff;border-style: none; height:50px; width:50px; '>");
            client.println("</center>");
            client.println("<p style='padding-top':15px;>");
            client.println("</p>");
            client.println("<center>");
            client.println("<input type='submit' name=2 value='L' style='background-color:#248; color:#fff;border-style: none; height:50px; width:50px; '>");
            client.println("<input type='submit' name=4 value='S' style='background-color:#be0000; color:#fff;border-style: none; height:50px; width:50px; '>");
            client.println("<input type='submit' name=3 value='R' style='background-color:#248; color:#fff;border-style: none; height:50px; width:50px; '>");
            client.println("</center>");
            client.println("<p style='padding-top':15px;>");
            client.println("</p>");            
            client.println("<center>");
            client.println("<input type='submit' name=1 value='B' style='background-color:#248; color:#fff;border-style: none; height:50px; width:50px; '>");
            client.println("</center>");
            client.println("<p style='padding-top':15px;>");
            client.println("<center>");
            client.println("<input type='submit' name=5 value='open' style='background-color:#666666; color:#fff;border-style: none; height:50px; width:50px; '>");
            client.println("<input type='submit' name=6 value='close' style='background-color:#666666; color:#fff;border-style: none; height:50px; width:50px; '>");
            client.println("</center>");
            client.println("</form>");
            client.println("</body>");
            client.println("</html>");
             client.println();
            break;
          } else {
            currentLine = "";
          }
        } else if (c != '\r') {
          currentLine += c;
        }
 
    //モーター制御文
        if (currentLine.endsWith("GET /?0=F")) {
          stop();
          digitalWrite(Amotor1, HIGH);
    //      digitalWrite(Bmotor1, HIGH);   
        }
        if (currentLine.endsWith("GET /?1=B")) {
          stop();
          digitalWrite(Amotor2, HIGH);
    //      digitalWrite(Bmotor2, HIGH);
        }
         if (currentLine.endsWith("GET /?3=R")) {
          stop();
          digitalWrite(Amotor1, HIGH);
    //      digitalWrite(Bmotor2, HIGH); 
         }
         if (currentLine.endsWith("GET /?2=L")) {
          stop();
          digitalWrite(Amotor2, HIGH);
    //      digitalWrite(Bmotor1, HIGH);  
         }
         if (currentLine.endsWith("GET /?4=S")) {
         stop();
         }
         //サーボ制御文（制御パルス:0.5ms～2.4ms PMWサイクル20mS ）
         
         if (currentLine.endsWith("GET /?5=open")) {
         delay(50);
         ledcWrite(0,30);    //（最大パルス値*PMW最大値）/PMWサイクル≒30
         }
         if (currentLine.endsWith("GET /?6=close")) {
         delay(50);
         ledcWrite(0,6);  //（最小パルス値*PMW最小値）/PMWサイクル≒6     
         }
      }
    }
     
    client.stop();
    Serial.println("client disonnected");
  }
}
