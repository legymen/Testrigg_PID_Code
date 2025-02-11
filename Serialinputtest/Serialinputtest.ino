#include <Wire.h>
#include <Servo.h>
// 16:23 2025-01-29.
const float BIAS_POWER = 60;
const float DESIRED_ANGLE = 0;
const float MAX_MOTOR_POWER = 90;

const int POT_PIN_KP = A0;
const int POT_PIN_KI = A1;
const int POT_PIN_KD = A2;
const int ESC_PWM_PIN = 11;
const int ZERO_BTN_PIN = 5;

float Kp = 1;
float Ki = 1;
float Kd = 1;

const float D_ALPHA = 0.15;

Servo ESC;

float roll;
float pitch;
float measuredAngle, error, previousError, deltaError, sumError, pidPower, D, dt;
float previousDerivative = 0;
float now;
float lasttime;

void setup() {
  sumError = 0;
  pinMode(ZERO_BTN_PIN, INPUT_PULLUP);

  Serial.begin(921600);
  Serial.println("Initializing ...");
  //startgyro(); // Kalibrerar även gyron.

  ESC.attach(ESC_PWM_PIN, 1000, 2000);
  ESC.write(0);
  //Serial.println("Zeroing BLDC ... starting in 4 sec");
  //delay(4000);

  Serial.println("Let's go!");
  lasttime = micros();
}

void loop() {
  now = micros();
  dt = (now - lasttime) / 1000000;
  lasttime = now;

  listenforinput();

  if (digitalRead(ZERO_BTN_PIN) == HIGH) {
    sumError = 0;
  }

  //getangles(pitch, roll);
  measuredAngle = (-1) * roll;

  error = DESIRED_ANGLE - measuredAngle;
  sumError += error * dt;
  sumError = constrain(sumError, -40000, 40000);

  float rawDerivative = (error - previousError) / dt;
  float P = Kp * error;
  float I = Ki * sumError;
  D = Kd * ((D_ALPHA * previousDerivative) + ((1 - D_ALPHA) * rawDerivative));

  previousError = error;
  previousDerivative = rawDerivative;

  pidPower = P + I + D;
  pidPower = constrain(pidPower, -3000, 3000);
  // Ta kanske bort BIAS_POWER från mapen?
  pidPower = map(pidPower, -3000, 3000, -BIAS_POWER, 180 - BIAS_POWER) + BIAS_POWER;
  pidPower = constrain(pidPower, 0, MAX_MOTOR_POWER);
  ESC.write(pidPower); 

  //schreibeinformation();
  delay(30);
}

void listenforinput()
{
  String input;
  if (Serial.available())
  {
    input = Serial.readString();
  }
  
  if (input[0] == 'P')
  {
    input.remove(0, 1);
    Kp = input.toFloat();
    Serial.print("P: "); Serial.println(Kp); 
  }
  else if (input[0] == 'I')
  {
    input.remove(0, 1);
    Ki = input.toFloat();
    Serial.print("I: "); Serial.println(Ki); 
  }
  else if (input[0] == 'D')
  {
    input.remove(0, 1);
    Kd = input.toFloat();
    Serial.print("D: "); Serial.println(Kd); 
  }
}

void schreibeinformation()
{
  Serial.print(Kp, 2);
  Serial.print(", ");
  Serial.print(Ki, 2);
  Serial.print(", ");
  Serial.print(Kd, 2);
  Serial.print(", ");
  Serial.print(error, 1);
  Serial.print(", ");
  Serial.print(sumError, 1);
  Serial.print(", ");
  Serial.print(dt, 6);
  Serial.print(", ");
  Serial.println(pidPower);
}
