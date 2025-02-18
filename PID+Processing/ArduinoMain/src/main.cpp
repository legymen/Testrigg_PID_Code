#include <Arduino.h>

void setup() {
  Serial.begin(921600);
}

void loop() {
  unsigned long e = micros();
  unsigned long time = micros();
  Serial.print("t"); Serial.print(time/1000000.0, 1); Serial.print("e"); Serial.println(e/1000000.0, 1);
  delay(30);
}

