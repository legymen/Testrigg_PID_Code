float CalRoll = 0;
float CalPitch = 0;
float RateRoll, RatePitch, RateYaw;
float AccX, AccY, AccZ;
float AngleRoll, AnglePitch;
int index = 0;
const int datacount = 30;

float rollarray[datacount];
float pitcharray[datacount];

void startgyro()
{
  Wire.setClock(400000);
  Wire.begin();
  delay(250);
  Wire.beginTransmission(0x68);
  Wire.write(0x6B);
  Wire.write(0x00);
  Wire.endTransmission();

  // Calibrate the gyro sensor.
  for (int k = 0; k < 2000; k++) {
    gyro_signals();
    CalRoll += AngleRoll;
    CalPitch += AnglePitch;
    delay(1);
  }

  CalRoll /= 2000;
  CalPitch /= 2000;
}

void gyro_signals() {
  Wire.beginTransmission(0x68);
  Wire.write(0x1A);
  Wire.write(0x05);
  Wire.endTransmission();

  Wire.beginTransmission(0x68);
  Wire.write(0x1C);
  Wire.write(0x10);
  Wire.endTransmission();

  Wire.beginTransmission(0x68);
  Wire.write(0x3B);
  Wire.endTransmission();
  Wire.requestFrom(0x68,6);
  int16_t AccXLSB = Wire.read() << 8 |
    Wire.read();
  int16_t AccYLSB = Wire.read() << 8 |
    Wire.read();
  int16_t AccZLSB = Wire.read() << 8 |
    Wire.read();

  Wire.beginTransmission(0x68);
  Wire.write(0x1B);
  Wire.write(0x8);
  Wire.endTransmission();
  Wire.beginTransmission(0x68);
  Wire.write(0x43);
  Wire.endTransmission();

  Wire.requestFrom(0x68,6);
  int16_t GyroX = Wire.read()<<8 | Wire.read();
  int16_t GyroY = Wire.read()<<8 | Wire.read();
  int16_t GyroZ = Wire.read()<<8 | Wire.read();

  RateRoll = (float) GyroX/65.5;
  RatePitch = (float) GyroY/65.5;
  RateYaw = (float) GyroZ/65.5;

  AccX = (float) AccXLSB/4096 - 0.04;
  AccY = (float) AccYLSB/4096 - 0.03;
  AccZ = (float) AccZLSB/4096 - 0.08;

  AngleRoll=atan(AccY/sqrt(AccX*AccX+AccZ*AccZ))*1/(3.142/180);
  AnglePitch=-atan(AccX/sqrt(AccY*AccY+AccZ*AccZ))*1/(3.142/180);
}

void getangles(float &pitch, float &roll)
{
  gyro_signals();
  float rollsum = 0;
  float pitchsum = 0;
  if (index == datacount)
  {
    index = 0;
  }

  rollarray[index] = AngleRoll;
  pitcharray[index] = AnglePitch;
  index += 1;

  for (int j = 0; j < datacount; j++) 
  {
    rollsum += rollarray[j];
    pitchsum += pitcharray[j];
  }

  rollsum /= datacount;
  pitchsum /= datacount;

  rollsum -= CalRoll;
  pitchsum -= CalPitch;

  pitch = pitchsum;
  roll = rollsum;
}