#include <dht.h>
#include <Timer.h>
#include "MQ135.h"
#include <SoftwareSerial.h>

// MARK: - DPIN Port Number
#define TILT_DPIN 11
#define DHT11_DPIN 10
#define BUTTON_DPIN 9
#define LED_RED_DPIN 6
#define LED_BLUE_DPIN 5
#define LED_GREEN_DPIN 4

// MARK: - APIN Port Number
#define CDS_APIN A4
#define GAS_APIN A5
#define SOUND_APIN A3

// MARK: - DHT 11
dht DHT;

// MARK: - MQ135
const MQ135 MQ = MQ135(GAS_APIN);

// MARK: - Timer
const Timer sensorTimer;

// MARK: - ESP8266 Variable
const SoftwareSerial esp8266_Serial = SoftwareSerial(2, 3);

// MARK: - Struct
typedef struct sensory {
  float humidity = 0.0;
  float temperature = 0.0;

  int cds = 0;
  int noise = 0;
  int co2 = 0;
} Valsensory;

Valsensory sensoryDatas;

void setup() {
  // put your setup code here, to run once:

  Serial.begin(9600);

  // MARK: DHT11
  DHT.read11(DHT11_DPIN);

  // MARK: ESP8266
  esp8266_Serial.begin(9600);
  settingESP8266();

  // MARK: 3 Colors LED
  pinMode(LED_BLUE_DPIN, OUTPUT);
  pinMode(LED_RED_DPIN, OUTPUT);
  pinMode(LED_GREEN_DPIN, OUTPUT);

  // MARK: Mini Sound Sensor
  pinMode(SOUND_APIN, INPUT);

  // MARK: Button Sensor
  pinMode(BUTTON_DPIN, INPUT);

  // MARK: Tilt Sensor
  pinMode(TILT_DPIN, INPUT);

  // MARK: setting Collect Sensor Date Timmer 300000
  sensorTimer.every(60000, collectSensorDate);
}

void loop() {
  // put your main code here, to run repeatedly:

  // MARK: Detect Tilt Sensor
  detectTilt();

  // MARK: Update Sensor Timer.
  sensorTimer.update();

  // MARK: Push Button
  sendNetworkButton(digitalRead(BUTTON_DPIN));
}

// MARK: - Sensory Method
void settingESP8266() {

    // Setting ESP8266 Configuration
    esp8266_Serial.println("AT+RST\r");
    
    if ( esp8266_Serial.find("OK") ) {
      Serial.println("⌘ ESP8266 module is operating success.");
      
      esp8266_Serial.println("AT+CIOBAUD?\r\n");
      esp8266_Serial.println("AT+CWMODE=3\r\n");
      esp8266_Serial.println("AT+CWJAP=\"YCY-Android-Note7\",\"1q2w3e4r!\"\r\n");
      esp8266_Serial.println("AT+CIPMUX=0\r\n");
      esp8266_Serial.println("AT+CIPSERVER=1,80\r\n");

      digitalWrite(LED_GREEN_DPIN, HIGH); delay(1000);
      digitalWrite(LED_GREEN_DPIN, LOW);
    }
}

void collectSensorDate() {

  sensoryDatas.humidity = (float)DHT.humidity;
  sensoryDatas.temperature = (float)DHT.temperature;
  sensoryDatas.cds = analogRead(CDS_APIN);
  
  Serial.print("- Humidity (%): ");
  Serial.println(sensoryDatas.humidity, 2);

  Serial.print("- Temperature (°C): ");
  Serial.println(sensoryDatas.temperature, 2);

  Serial.print("- CDS (%): ");
  Serial.println(sensoryDatas.cds);

  int measurementCO2 = measureIndoorCO2();
  int measurementNoise = measureIndoorNoise();

  sensoryDatas.co2 = measurementCO2;
  sensoryDatas.noise = measurementNoise;
}

void sendNetworkButton(const bool isPush) {

  if (isPush == HIGH) {
    Serial.println("⌘ 현재 센서 정보를 서버로 전송합니다. 잠시만 기다려주세요.");
    delay(3000);    
  }
  
}

int measureIndoorCO2() {

  const int measurementCO2 = analogRead(MQ.getPPM());
  
  Serial.print("- CO2 (PPM): ");
  Serial.println(measurementCO2, DEC);

  if (measurementCO2 >= 1000) {
    digitalWrite(LED_RED_DPIN, HIGH); delay(3000);
    digitalWrite(LED_RED_DPIN, LOW);
    
    Serial.println("⌘ 현재 기준치 초과 실내 대기질 농도가 너무 높습니다.");
  }
  
  return measurementCO2;
}

int measureIndoorNoise() {

  const int meaurementSound = analogRead(SOUND_APIN);

  Serial.print("- SOUND (dB): ");
  Serial.println(analogRead(SOUND_APIN));

  if (meaurementSound >= 50) {
    digitalWrite(LED_BLUE_DPIN, HIGH); delay(3000);
    digitalWrite(LED_BLUE_DPIN, LOW);
    
    Serial.println("⌘ 현재 실내의 소음 기준이 초과하였습니다.");
  }

  return meaurementSound;
}

void detectTilt() {

  int tiltValue = digitalRead(TILT_DPIN);

  if (tiltValue == HIGH) {
    digitalWrite(LED_RED_DPIN, HIGH); delay(3000);
    digitalWrite(LED_RED_DPIN, LOW);

    Serial.println("⌘ 현재 Arduino에 대한 움직임이 감지 되었습니다.");
  }
}

bool sendSensorData(int temp, int cmd, int noise) {
  
//  const String basic_serverURL = "coldy24.iptime.org";
//
//  if ( esp8266_Serial.find("OK") ) {
//        Serial.println("- Main Server TCP Connection Ready.");
//        
//        String query;
//        query.concat("GET /setKitchenData?TEMP=");  query.concat(temp);
//        query.concat("&CMD=");                  query.concat(cmd);  
//        query.concat("&NOISE=");                query.concat(noise);
//        query.concat("&FLARE=");                query.concat(currentState.flare_Flag);
//        query.concat("&GAS=");                  query.concat(analogRead(GAS_APIN));     query.concat("\r\n");
//    
//        if ( esp8266_Serial.find(">") ) {
//            delay(5000);
//            Serial.println("- Please, Input GET Request Query.");
//            esp8266_Serial.println(query);
//          
//            if ( esp8266_Serial.find("SEND OK") ) {
//                Serial.println("- Success send server packet.");
//              }
//              
//            esp8266_Serial.println("AT+CIPCLOSE\r");
//        }
//  } 
}
