// void setup() {
//     Serial.begin(9600);

//     for (int pin = 2; pin <= 28; pin++) { // D0～D13を確認
//         int interruptNum = digitalPinToInterrupt(pin);
//         Serial.print("Pin ");
//         Serial.print(pin);
//         Serial.print(" -> Interrupt Number: ");
//         Serial.println(interruptNum);
//     }
// }

// void loop() {
// }

volatile bool interruptFlag = false;

void interruptHandler() {
    interruptFlag = true;
}

void setup() {
    Serial.begin(9600);
    pinMode(0, INPUT_PULLUP);  // D5をプルアップ入力に設定
    attachInterrupt(digitalPinToInterrupt(0), interruptHandler, RISING);
}

void loop() {
    if (interruptFlag) {
        Serial.println("Interrupt Triggered on D5!");
        interruptFlag = false;
    }
}
