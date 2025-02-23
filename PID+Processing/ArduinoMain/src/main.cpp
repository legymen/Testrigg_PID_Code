#include <Arduino.h>

float kP = 0;
float kI = 0;
float kD = 0;

float P = 0;
float I = 0;
float D = 0;

void setup() {
  Serial.begin(115200);
}

void loop() {

  if (Serial.available() > 0)
  {
    String switchletter = Serial.readStringUntil('\n');
    String value = Serial.readStringUntil('\n');
    if (switchletter.equals("p"))
    {
      kP = value.toFloat();
    }
    else if (switchletter.equals("i"))
    {
      kI = value.toFloat();
    }
    else if (switchletter.equals("d"))
    {
      kD = value.toFloat();
    }
  }

  I += kI;

  unsigned long time = micros();
  Serial.print("t"); Serial.print(time/1000000.0, 2); Serial.print("e"); Serial.print((time/1000000.0) + kP, 2), Serial.print("s"), Serial.println(I, 2);

  delay(50);
}

