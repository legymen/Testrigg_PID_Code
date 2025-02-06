#include <Servo.h>

const int PWM_PIN = 11;
const int MIN_MS = 1000;
const int MAX_MS = 2000;
char data;

Servo ESC;

void setup() {
  Serial.begin(9600);

  ESC.attach(PWM_PIN, MIN_MS, MAX_MS);
  Serial.println("Press 1 to start the calibration.");
}

void loop() {
  if (Serial.available()) {
    data = Serial.read();

    switch (data) {
      // 1
      case 49 : Serial.println("Sending MAX throttle. Connect ESC to battery, wait for the beeps, then press 2 to continue.");
                ESC.writeMicroseconds(MAX_MS);
      // 2
      case 50 : Serial.println("Sending MIN throttle");
                ESC.writeMicroseconds(MIN_MS);
    }
  }
}
