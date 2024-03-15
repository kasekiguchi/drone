#include <ESP32Servo.h>
// https://kanpapa.com/today/2022/12/esp32-otafab-study-servo.html

#define SERVO_PIN 5

Servo myServo;

void setup() {
  myServo.attach(SERVO_PIN);
}

void loop() {
  myServo.write(0);
  delay(1000);
  myServo.write(90);
  delay(1000);
  myServo.write(180);
  delay(1000);
  myServo.write(90);
  delay(1000);
}
