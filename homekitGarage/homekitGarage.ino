#include "HomeSpan.h"
#include "DEV_GARAGE.h"

const int closedSensorPin = 22; // The status pin connected to the garage
const int openSensorPin = 23; // The status pin connected to the garage
const int relayPin = 16; // The relay pin that actually controls the garage

void setup()
{
    Serial.begin(115200);

    homeSpan.enableWebLog(100,"pool.ntp.org","UTC+10",""); //  enableWebLog(uint16_t maxEntries, const char *timeServerURL, const char *timeZone, const char *logURL)`
    homeSpan.setWifiCredentials("mojo", "knightscorner");  // Set your Wi-Fi credentials
    homeSpan.setPairingCode("92747402");                                  // pairing pin
    homeSpan.setControlPin(0);  // 
    homeSpan.setStatusPin(15);  //
    homeSpan.setStatusAutoOff(10);

    homeSpan.enableOTA("snowpole"); // Enable OTA updates
    
    homeSpan.begin(Category::GarageDoorOpeners, "Garage Door");
    new SpanAccessory();
        new Service::AccessoryInformation();
            new Characteristic::Identify();
            new Characteristic::Name("Garage Door");
            new Characteristic::Manufacturer("LeesGeek");
            new Characteristic::Model("G-Opener");
            new Characteristic::FirmwareRevision("1.0.0");
            new Characteristic::CurrentDoorState();
            new Characteristic::TargetDoorState();
            new Characteristic::ObstructionDetected();

        new DEV_GARAGE(closedSensorPin, openSensorPin, relayPin);
}

void loop()
{
    homeSpan.poll();
}
