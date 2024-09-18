// Teensy 4.1 のピン指定
#define TX_PIN 1  // TXピンを指定（Teensy 4.1ではピン1がTX）

void setup() {
  // ハードウェアシリアルを初期化（ボーレートを100000bpsに設定）
  Serial1.begin(100000, SERIAL_8N1);
  pinMode(TX_PIN, OUTPUT);
}

void loop() {
  // 定位（静止状態）の信号を送信
  sendStaticSignal();
  delay(20);  // フレーム間の遅延
}

void sendStaticSignal() {
  // SFHSSのシンプルな静止パケット（仮）
  uint8_t packet[] = {
    0xA2,  // ヘッダー（仮）
    0x00, 0x00,  // チャンネル1（仮）
    0x00, 0x00,  // チャンネル2（仮）
    0x00, 0x00,  // チャンネル3（仮）
    0x00, 0x00,  // チャンネル4（仮）
    0x00, 0x00,  // チャンネル5（仮）
    0x00, 0x00,  // チャンネル6（仮）
    0x00, 0x00,  // チャンネル7（仮）
    0x00, 0x00,  // チャンネル8（仮）
    0x00         // チェックサム（仮）
  };

  // パケットを送信
  Serial1.write(packet, sizeof(packet));
}