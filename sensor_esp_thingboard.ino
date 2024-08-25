#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

#define DE 22
#define RE 21

const char* ssid = "---";
const char* password = "------";
const char* thingsboardServer = "http://sensor.insti.srv:8080";
const char* accessToken = "------";

void connectToWiFi() {
    Serial.print("Connecting to Wi-Fi...");
    WiFi.begin(ssid, password);
    int attempts = 0;
    while (WiFi.status() != WL_CONNECTED && attempts < 20) {
        delay(1000);
        Serial.print(".");
        attempts++;
    }
    if (WiFi.status() == WL_CONNECTED) {
        Serial.println("Connected");
        Serial.print("IP Address: ");
        Serial.println(WiFi.localIP());
    } else {
        Serial.println("Failed to connect to WiFi. Restarting...");
        ESP.restart();
    }
}


void sendTelemetryData(String data) {
    if (WiFi.status() == WL_CONNECTED) {
        HTTPClient http;
        String serverPath = String(thingsboardServer) + "/api/v1/" + accessToken + "/telemetry";
        
        http.begin(serverPath.c_str());
        http.addHeader("Content-Type", "application/json");

        // Example telemetry data
        String jsonData = data;

        int httpResponseCode = http.POST(jsonData);

        if (httpResponseCode > 0) {
            String response = http.getString();
            Serial.println(httpResponseCode);
            Serial.println(response);
        } else {
            Serial.print("Error on sending POST: ");
            Serial.println(httpResponseCode);
        }

        http.end();
    } else {
        Serial.println("WiFi not connected");
    }
}



void setup() {
  Serial.begin(9600);  
  delay(2000);  // Small delay to ensure Serial is ready
  Serial.println("Initialization");
  connectToWiFi();

  // Debug print to confirm before Serial1.begin
  Serial.println("Before Serial1.begin");

  Serial1.begin(4800, SERIAL_8N1, 16, 17);   // Initialize hardware serial communication at 4800 baud rate, using GPIO 16 for RX and GPIO 17 for TX

  // Debug print to confirm after Serial1.begin
  Serial.println("After Serial1.begin");

  pinMode(DE, OUTPUT);
  pinMode(RE, OUTPUT);
  digitalWrite(DE, LOW);
  digitalWrite(RE, LOW);

  // Debug print to confirm pinMode and digitalWrite setup
  Serial.println("Pin modes and initial states set");

  Serial.println("Initialization complete");
}

void loop() {
  // Clear the receive buffer
  while (Serial1.available()) {
    Serial1.read();
  }

  byte queryData[] = { 0x01, 0x03, 0x00, 0x00, 0x00, 0x07, 0x04, 0x08 };
  byte receivedData[19];
  
  // Start RS485 transmission
  digitalWrite(DE, HIGH);
  digitalWrite(RE, HIGH);
  delay(10);  // Small delay to ensure DE and RE are set before sending data

  Serial.println("Sending query");
  Serial1.write(queryData, sizeof(queryData));
  Serial1.flush();

  // End RS485 transmission
  digitalWrite(DE, LOW);
  digitalWrite(RE, LOW);

  // Wait to ensure data is received
  delay(1000);

  // Read the response
  for (size_t i = 0; i < sizeof(receivedData); i++) {
    if (Serial1.available()) {
      receivedData[i] = Serial1.read();
      Serial.print(receivedData[i], HEX); // Print each byte in hex format
      Serial.print(" ");
    } else {
      receivedData[i] = 0;  // Default to 0 if no data is received
    }
  }
  Serial.println(); // New line after printing all bytes

  // Check if we received the expected number of bytes
  if (sizeof(receivedData) >= 19) {        
    // Parse and print the received data in decimal format
    unsigned int soilHumidity = (receivedData[3] << 8) | receivedData[4];
    unsigned int soilTemperature = (receivedData[5] << 8) | receivedData[6];
    unsigned int soilConductivity = (receivedData[7] << 8) | receivedData[8];
    unsigned int soilPH = (receivedData[9] << 8) | receivedData[10];
    unsigned int nitrogen = (receivedData[11] << 8) | receivedData[12];
    unsigned int phosphorus = (receivedData[13] << 8) | receivedData[14];
    unsigned int potassium = (receivedData[15] << 8) | receivedData[16];



StaticJsonDocument<200> sensorValues;
  sensorValues["Temperature"] = ((float)soilTemperature / 10.0);
  sensorValues["Humidity"] = ((float)soilHumidity / 10.0);
  sensorValues["Conductivity"] = soilConductivity;
  sensorValues["Ph"] = ((float)soilPH / 10.0);
  sensorValues["Nitrogen"] = nitrogen;
  sensorValues["Phosphorous"] = phosphorus;
  sensorValues["Potassium"] = potassium;
  
  // Serialize the JSON document to a string
  String outputValues;
  serializeJson(sensorValues, outputValues);

  // Print the JSON string
  Serial.println(outputValues);

  // Send data to thingsboard
  sendTelemetryData(outputValues);

  } 
  else 
  {
    Serial.println("No data available");
  } 
  
  delay(30000);
}
