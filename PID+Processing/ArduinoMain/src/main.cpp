#include <Arduino.h>

void setup() {
  Serial.begin(921600);
}

void loop() {
  int data = analogRead(A4);
  unsigned long time = micros();
  Serial.print("d"); Serial.print(data); Serial.print("t"); Serial.println(time/1000000.0, 1);
  delay(30);
}

