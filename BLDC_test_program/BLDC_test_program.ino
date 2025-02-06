#include <Servo.h>

const int POT_PIN = A0;
const int ESC_PWM_PIN = 11;

const int MAX_MOTOR_POWER = 80;

Servo ESC;

int motorPower;

void setup() {

  Serial.begin(9600);

  Serial.println("Initializing ...");
  delay(1000);

  ESC.attach(ESC_PWM_PIN, 1000, 2000);
  ESC.write(0);
  
  Serial.println("Zeroing BLDC ... starting in 4 sec");
  delay(4000);
  Serial.println("Lets go!");
}

void loop() {

  motorPower = analogRead(POT_PIN);
  motorPower = map(motorPower, 0, 1023, 0, MAX_MOTOR_POWER);

  ESC.write(motorPower);

  Serial.print("motorPower = ");
  Serial.println(motorPower);
}

