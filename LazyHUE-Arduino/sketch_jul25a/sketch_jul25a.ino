#include <dht.h>
#include "MQ135.h"

// MARK: - DPIN Port Number
#define DHT11_DPIN 10

// MARK: - APIN Port Number
#define CDS_APIN A4
#define GAS_APIN A5

// MARK: - DHT 11
dht DHT;

// MARK: - MQ135
MQ135 MQ = MQ135(GAS_APIN);

void setup() {
  // put your setup code here, to run once:

  Serial.begin(9600);

  // MARK: DHT11
  DHT.read11(DHT11_DPIN);  
}

void loop() {
  // put your main code here, to run repeatedly:

  Serial.print("- Humidity (%): ");
  Serial.println((float)DHT.humidity, 2);

  Serial.print("- Temperature (°C): ");
  Serial.println((float)DHT.temperature, 2);

  Serial.print("- CDS (%): ");
  Serial.println(analogRead(CDS_APIN));

  Serial.print("- CO2 (PPM): ");
  Serial.println(analogRead(MQ.getPPM()), DEC);
  
  delay(1000);
}
