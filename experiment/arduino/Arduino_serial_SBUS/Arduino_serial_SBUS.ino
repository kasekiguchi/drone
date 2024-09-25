// Teensy 4.1 用の停止信号送信プログラム
#define SERIAL_PORT Serial2  // Teensy 4.1のSerial2を使用

void setup() {
  SERIAL_PORT.begin(100000, SERIAL_8N1);  // 100,000bps, 8データビット、パリティなし、1ストップビット
}

void loop() {
  // 停止信号（全ビットを0にする例）
  uint8_t stopSignal[] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };  // 8バイトの停止信号
  SERIAL_PORT.write(stopSignal, sizeof(stopSignal));  // 信号を送信
  SERIAL_PORT.flush();  // 送信完了を待機
  
  delay(20);  // 20msごとに停止信号を送信
}