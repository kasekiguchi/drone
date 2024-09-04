// #include <AltSoftSerial.h>

// // 定義
// #define FUTABA_BAUD_RATE 115200
// #define NUM_CHANNELS 8

// AltSoftSerial futabaSerial; // AltSoftSerialインスタンスの作成

// void setup() {
//   // シリアルポートの初期化
//   futabaSerial.begin(FUTABA_BAUD_RATE);
// }

// void loop() {
//   // ランダムなチャンネルデータを生成
//   uint16_t channels[NUM_CHANNELS];
//   for (int i = 0; i < NUM_CHANNELS; i++) {
//     channels[i] = random(0, 1001); // 0から1000の範囲のランダムな値
//   }

//   // Futabaプロトコルのデータパケットを作成
//   uint8_t packet[NUM_CHANNELS * 2 + 2];
//   packet[0] = 0xA2; // ヘッダバイト

//   int packetIndex = 1;
//   for (int i = 0; i < NUM_CHANNELS; i++) {
//     packet[packetIndex++] = lowByte(channels[i]);
//     packet[packetIndex++] = highByte(channels[i]);
//   }

//   // チェックサムの計算
//   uint8_t checksum = 0;
//   for (int i = 0; i < packetIndex; i++) {
//     checksum ^= packet[i];
//   }
//   packet[packetIndex] = checksum;

//   // パケットを送信
//   futabaSerial.write(packet, NUM_CHANNELS * 2 + 2);

//   // 送信間隔の設定
//   delay(20); // 20ms間隔で送信（Futabaプロトコルは一般的に50Hzの更新レート）
// }

// #include <AltSoftSerial.h>

// // デジタルピンを使用したシリアル通信の初期化
// AltSoftSerial altSerial;

// // データ送信間隔（ミリ秒）
// const int interval = 20;

// void setup() {
//   // シリアルモニタの初期化
//   Serial.begin(9600);
//   // AltSoftSerialの初期化（100,000 bpsに設定）
//   altSerial.begin(100000);
// }

// void loop() {
//   static unsigned long lastTime = 0;
//   unsigned long currentTime = millis();
  
//   // 20ミリ秒ごとにデータを送信
//   if (currentTime - lastTime >= interval) {
//     lastTime = currentTime;

//     // 送信するデータの作成（ここでは例として固定データを使用）
//     uint8_t data[] = {0xA2, 0x00, 0x1F, 0xD0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
    
//     // データを送信
//     for (int i = 0; i < sizeof(data); i++) {
//       altSerial.write(data[i]);
//     }

//     // シリアルモニタに送信したデータを表示
//     Serial.print("Sent: ");
//     for (int i = 0; i < sizeof(data); i++) {
//       Serial.print(data[i], HEX);
//       Serial.print(" ");
//     }
//     Serial.println();
//   }
// }

#include <SoftwareSerial.h>

const int txPin = 2;  // D2ピンをTX（送信ピン）として使用
SoftwareSerial mySerial(txPin, -1); // RXピンは不要なので-1

// 送信するチャンネルデータの初期化（最大16チャンネル）
uint16_t channels[16] = {1024, 1024, 1024, 1024, 1024, 1024, 1024, 1024,
                         1024, 1024, 1024, 1024, 1024, 1024, 1024, 1024};

// CRC8の計算用関数
uint8_t calculateCRC(uint8_t *data, uint8_t len) {
  uint8_t crc = 0;
  for (uint8_t i = 0; i < len; i++) {
    crc ^= data[i];
  }
  return crc;
}

// CRSFフレームの送信
void sendCRSF() {
  uint8_t packetLength = 2 + 16 * 2 + 1; // ヘッダー、チャンネルデータ、CRC
  uint8_t crsfPacket[packetLength + 2];  // ヘッダー + パケット長 + データ + CRC

  crsfPacket[0] = 0xC8; // CRSFアドレス（TXモジュール宛）
  crsfPacket[1] = packetLength;

  // チャンネルデータの追加
  for (uint8_t i = 0; i < 16; i++) {
    crsfPacket[2 + i * 2] = channels[i] & 0xFF;        // チャンネルデータ（下位バイト）
    crsfPacket[3 + i * 2] = (channels[i] >> 8) & 0xFF; // チャンネルデータ（上位バイト）
  }

  // CRCの計算と追加
  crsfPacket[packetLength + 1] = calculateCRC(crsfPacket, packetLength + 1);

  // パケットの送信
  for (uint8_t i = 0; i < packetLength + 2; i++) {
    mySerial.write(crsfPacket[i]);
  }
}

void setup() {
  mySerial.begin(115200); // CRSFの通信速度
}

void loop() {
  sendCRSF();  // CRSFフレームの送信
  delay(14);   // 通常70Hzでの送信レート
}