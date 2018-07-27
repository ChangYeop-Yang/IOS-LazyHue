#include <dht.h>
#include "MQ135.h"

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
MQ135 MQ = MQ135(GAS_APIN);

void setup() {
  // put your setup code here, to run once:

  Serial.begin(9600);

  // MARK: DHT11
  DHT.read11(DHT11_DPIN);

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
}

void loop() {
  // put your main code here, to run repeatedly:

  Serial.print("- Humidity (%): ");
  Serial.println((float)DHT.humidity, 2);

  Serial.print("- Temperature (°C): ");
  Serial.println((float)DHT.temperature, 2);

  Serial.print("- CDS (%): ");
  Serial.println(analogRead(CDS_APIN));

  Serial.print("- SOUND (dB): ");
  Serial.println(analogRead(SOUND_APIN));

  measureIndoorCO2();
  
  delay(1000);
}

// MARK: - Sensory Method
int measureIndoorCO2() {

  const int measurementCO2 = analogRead(MQ.getPPM());
  
  Serial.print("- CO2 (PPM): ");
  Serial.println(measurementCO2, DEC);

  if (measurementCO2 >= 1000) {
    digitalWrite(LED_RED_DPIN, HIGH);
    Serial.println("⌘ 현재 기준치 초과 실내 대기질 농도가 너무 높습니다.");
  }
  
  return measurementCO2;
}

