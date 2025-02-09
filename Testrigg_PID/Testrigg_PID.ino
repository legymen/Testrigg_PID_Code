// This is the code for operating a prototype of a PID regulator
// rest rig. Constructed in 2025 by TE23 and their teacher


#include <Wire.h>
#include <Servo.h>

// Set-constants
const float BIAS_POWER = 60;
const float DESIRED_ANGLE = 0;
const float MAX_MOTOR_POWER = 80; // NOTE! FOR SAFETY!
const float LOOP_DELAY_TIME_MS // Loop delay time in millisecs

// Pins
const int POT_PIN_KP = A0;
const int POT_PIN_KI = A1;
const int POT_PIN_KD = A2;
const int ESC_PWM_PIN = 11;

// PID-constants
float Kp = 1;
float Ki = 1;
float Kd = 1;

// Global variables
Servo BLDC_motor; //Object for the bldc-motor with its ESC

float roll;
float pitch;
float measuredAngle, error, previousError, derivativeError, sumError, pidPower, P, I, D, dt;
float previousDerivative = 0;
float now, lasttime;

void setup() {
  
  // Calibrating the gyro
  Serial.begin(921600);
  Serial.println("Initializing gyro ...");
  startgyro();

  // Attaching and zeroing the bldc
  BLDC_motor.attach(ESC_PWM_PIN, 1000, 2000);
  BLDC_motor.write(0);
  Serial.println("Zeroing BLDC ... starting in 4 sec");
  delay(4000);
  Serial.println("Lets go!");
  
  lasttime = micros();
  sumError = 0;
}

void loop() {
  
  // Calculating the loop-time dt
  now = micros();
  dt = (now - lasttime) / 1000000;
  lasttime = now;

  // Read PID-constants from the potentiometers
  Kp = analogRead(POT_PIN_KP); 
  Kp /= (1023 / 80);

  Ki = analogRead(POT_PIN_KI);
  Ki /= (1023 / 37);

  Kd = analogRead(POT_PIN_KD);
  Kd /= (1023 / 20);

  // Read the current angle from the accelerometer sensor
  getangles(pitch, roll);
  measuredAngle = (-1) * roll;

  // Calculate error, error integral and error derivative
  error = DESIRED_ANGLE - measuredAngle;
  sumError = sumError + error * dt;
  sumError = constrain(sumError, -40000, 40000);
  derivativeError = (error - previousError) / dt;
  previousError = error;
  
  // Calculate the PID-power
  P = Kp * error;
  I = Ki * sumError;
  D = Kd * derivativeError;
  pidPower = P + I + D;
  pidPower = constrain(pidPower, -3000, 3000);

  // Map PID-power for the motor, add bias power and run the motor
  pidPower = map(pidPower, -3000, 3000, -180, 180) + BIAS_POWER;
  pidPower = constrain(pidPower, 0, MAX_MOTOR_POWER); // NOTE! FOR SAFETY!
  BLDC_motor.write(pidPower); 

  // Display info in the computers console
  schreibeinformation();
  
  // Loop-delay for stability
  delay(LOOP_DELAY_TIME_MS);
}

void schreibeinformation()
{
  Serial.print("Kp=");
  Serial.print(Kp, 2);
  Serial.print(", Ki=");
  Serial.print(Ki, 2);
  Serial.print(", Kd =");
  Serial.print(Kd, 2);
  Serial.print(", error=");
  Serial.print(error, 1);
  Serial.print(", sumError=");
  Serial.print(sumError, 1);
  Serial.print(", dt=");
  Serial.print(dt, 6);
  Serial.print(", pidPower=");
  Serial.println(pidPower);
}
