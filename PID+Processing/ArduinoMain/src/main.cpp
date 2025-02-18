#include <Arduino.h>

float kP = 0;
float kI = 0;
float kD = 0;

float P = 0;
float I = 0;
float D = 0;

void setup() {
  Serial.begin(921600);
}

void loop() {

  if (Serial.available() > 0)
  {
    String switchletter = Serial.readStringUntil('\n');
    String value = Serial.readStringUntil('\n');
    if (switchletter.equals("p"))
    {
      kP = value.toInt();
    }
    else if (switchletter.equals("i"))
    {
      kI = value.toInt();
    }
    else if (switchletter.equals("d"))
    {
      kD = value.toInt();
    }
  }

  I += kI;

  unsigned long e = micros();
  unsigned long time = micros();
  Serial.print("t"); Serial.print(time/1000000.0, 1); Serial.print("e"); Serial.print((e/1000000.0) + kP, 1), Serial.print("s"), Serial.println(I);

  delay(30);
}

