#include <Arduino_HTS221.h>
#include <Arduino_LPS22HB.h>
#include <Arduino_LSM9DS1.h>

void setup() {
  Serial.begin(9600);
  while (!Serial);

  // Initialize the temperature and humidity sensor
  if (!HTS.begin()) {
    Serial.println("Failed to initialize humidity temperature sensor!");
    while (1);
  }

  // Initialize the barometric pressure sensor
  if (!BARO.begin()) {
    Serial.println("Failed to initialize barometric pressure sensor!");
    while (1);
  }

  // Initialize accelerometer

  if (!IMU.begin()){
    Serial.println("Failed to initialize the IMU");
    while(1);
  }

  Serial.println("Environmental Monitoring System");
}

void loop() {
  // Read temperature (Celsius)
  float temperature = HTS.readTemperature();
  
  // Read humidity (%)
  float humidity = HTS.readHumidity();
  
  // Read barometric pressure (hPa)
  float pressure = BARO.readPressure();

  // Read position
  float x,y,z;
  if (IMU.accelerationAvailable()){
   IMU.readAcceleration(x,y,z);
  }

  // Print the values to the Serial Monitor
  Serial.print("Temperature: ");
  Serial.print(temperature);
  Serial.println(" °C");
  
  Serial.print("Humidity: ");
  Serial.print(humidity);
  Serial.println(" %");
  
  Serial.print("Pressure: ");
  Serial.print(pressure);
  Serial.println(" hPa");

  Serial.print("Accel: ");
  Serial.print(x);
  Serial.print(y);
  Serial.print(z);
  
  // Wait for 1 second before the next reading
  delay(10000);
}