#include <Wire.h>

const float DESIRED_ANGLE = 0;

float roll;
float pitch;
float measuredAngle, error;

void setup() {

  Serial.begin(9600);
  Serial.println("Initializing ...");
  startgyro(); // Kalibrerar även gyron.

  Serial.println("Lets go!");
}

void loop() {
  
  getangles(pitch, roll);
  measuredAngle = (-1) * roll;

  error = DESIRED_ANGLE - measuredAngle;

  Serial.print("measuredAngle = ");
  Serial.print(measuredAngle, 1);
  Serial.print(",   ");
  Serial.print("error = ");
  Serial.println(error, 1);
}

