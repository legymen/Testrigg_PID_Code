#include <Wire.h>
#include <Servo.h>

const float BIAS_POWER = 35;
const float DESIRED_ANGLE = 0;
const float MAX_MOTOR_POWER = 50;

const int POT_PIN_KP = A0;
const int POT_PIN_KI = A1;
const int POT_PIN_KD = A2;
const int ESC_PWM_PIN = 11;

float Kp = 0;
float Ki = 0;
float Kd = 0;

Servo ESC;

float roll;
float pitch;
float measuredAngle, error, previousError, deltaError, sumError, pidPower;

void setup() {
  sumError = 0;

  Serial.begin(9600);
  Serial.println("Initializing ...");
  startgyro(); // Kalibrerar även gyron.

  ESC.attach(ESC_PWM_PIN, 1000, 2000);
  ESC.write(0);
  Serial.println("Zeroing BLDC ... starting in 4 sec");
  delay(4000);

  Serial.println("Lets go!");
}

void loop() {
  Kp = analogRead(POT_PIN_KP); 
  Kd = analogRead(POT_PIN_KD);
  Ki = analogRead(POT_PIN_KI);
  
  
  getangles(pitch, roll);
  measuredAngle = (-1) * roll;

  error = DESIRED_ANGLE - measuredAngle;
  deltaError = error - previousError;
  previousError = error;
  sumError = sumError + error;

  pidPower = BIAS_POWER + Kp * error + Ki * sumError + Kd * deltaError;
  pidPower = constrain(pidPower, -3000, 3000);
  pidPower = map(pidPower, -3000, 3000, -BIAS_POWER, MAX_MOTOR_POWER - BIAS_POWER) + BIAS_POWER;
  ESC.write(pidPower); 

  schreibeinformation();
}

void schreibeinformation()
{
  Serial.print(Kp, 2);
  Serial.print(", ");
  Serial.print(Ki, 5);
  Serial.print(", ");
  Serial.print(Kd, 5);
  Serial.print(", ");
  Serial.print(error, 1);
  Serial.print(", ");
  Serial.print(sumError, 1);
  Serial.print(", ");
  Serial.print(deltaError, 1);
  Serial.print(", ");
  Serial.println(pidPower);
}
