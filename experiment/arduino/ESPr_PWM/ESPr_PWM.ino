#define LED  16
#define AIN1 13  // Right Motor Blue
#define AIN2 15  // Right Motor Yellow
#define PWMA 2
#define STBY 12
 
// PWN
#define PWN_FREQ 150000 // PWM frequency: 1000Hz(1kHz)
#define PWN_RANGE 100 // PWN range: 100
#define SPEED 30  
 
void setup() {
  pinMode(LED, OUTPUT);     // Initialize the LED_BUILTIN pin as an output
   
  // Initialize GPIO mode
  pinMode(AIN1, OUTPUT);
  pinMode(AIN2, OUTPUT);
  pinMode(STBY, OUTPUT);
 
  // Initialize PWN
  analogWriteFreq(PWN_FREQ);
  analogWriteRange(PWN_RANGE);
 
  digitalWrite(AIN1, LOW);
  digitalWrite(AIN2, LOW);
  analogWrite(PWMA, SPEED);
   
  digitalWrite(STBY, LOW);
   
}
 
// the loop function runs over and over again forever
void loop() {
  digitalWrite(LED, LOW);   // Turn the LED on (Note that LOW is the voltage level
                                    // but actually the LED is on; this is because 
                                    // it is active low on the ESP-01)
  delay(1000);                      // Wait for a second
  digitalWrite(LED, HIGH);  // Turn the LED off by making the voltage HIGH
  delay(2000);                      // Wait for two seconds (to demonstrate the active low LED)
}
