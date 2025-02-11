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
  if (Serial.available())
  {
    data = Serial.read();
  }

  switch (data) {
    // 1
    case 49 : Serial.println("Sending MIN throttle");
              ESC.writeMicroseconds(MIN_MS);
    break;
    // 2
    case 50 : 
              Serial.println("Sending MAX throttle. Connect ESC to battery, wait for the beeps, then press 2 to continue.");
              ESC.writeMicroseconds(MAX_MS);
    break;
    // 3
    case 51 : Serial.println("Testing different levels.");
              for (int i = 0; i < 2000; i++)
              {
                ESC.writeMicroseconds(i);
                Serial.println(i);
                delay(200);
              }
    break;
    // 4
    case 52 : 
            Serial.print("4");
            int speed = 1000;
            while (true)
            {
              while(!Serial.available());
              int input = Serial.parseInt();
              speed = input == 0 ? speed : input;

              Serial.println(speed);
              if (speed <= 3000 && speed >= 1000)
              {
                ESC.writeMicroseconds(speed);
              }
              else
              {
                ESC.writeMicroseconds(1000);
              }
            }
  
    break;
  }
}
