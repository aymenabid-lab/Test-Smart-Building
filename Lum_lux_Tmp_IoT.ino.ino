/* Photocell reading program */
// Constants
#define DELAY 5000 // Delay between two measurements in ms =>1000=1s
#define VIN 5 // V power voltage
#define R 10000 //ohm resistance value
// Parameters
const int sensorPinLum = A1; // Pin connected to sensor
//TMP36 Pin Variables
const int sensorPinTmp = A0; //the analog pin the TMP36's Vout (sense) pin is connected to
                        //the resolution is 10 mV / degree centigrade with a
                        //500 mV offset to allow for negative temperatures

//Variables
int sensorVal; // Analog value from the sensor
int lux; //Lux value

void setup(void) {
  Serial.begin(9600); //Start the serial connection with the computer
                       //to view the result open the serial monitor 
}

void loop(void) {
  
  //**********Luminosity*************
  sensorVal = analogRead(sensorPinLum);
  lux=sensorLumToPhys(sensorVal);
  Serial.println(F("Sensor analogue reading value(byte)="));
  Serial.println(sensorVal); // the analog reading
  Serial.println(F("Physical Luminosity value(Lumen)="));
  Serial.println(lux); // the analog reading
  
  delay(DELAY);   //waiting a at m-second

  //*********Tempertaure***************  
  //getting voltage reading from the temperature sensor   
  int reading = analogRead(sensorPinTmp); 
  Serial.println(F("Sensor analogue reading value(byte)="));
  Serial.println(reading);
  // converting that reading to voltage, for 3.3v arduino use 3.3
  float voltage = reading * 5.0;
  voltage /= 1024.0; 
 // print out the voltage
 Serial.println(F("5v Voltage value(V)="));
 Serial.println(voltage); 
 // now print out the temperature
 float temperatureC = (voltage - 0.5) * 100 ;  //converting from 10 mv per degree wit 500 mV offset
                                               //to degrees ((voltage - 500mV) times 100)
 Serial.println("Physical Temperature degrees (C)");                                               
 Serial.println(temperatureC); 
 // now convert to Fahrenheit
 float temperatureF = (temperatureC * 9.0 / 5.0) + 32.0;
 Serial.println("Physical Temperature degrees (F)");                                               
 Serial.println(temperatureF);
 Serial.println("+++++++++++++");
 delay(DELAY);    //waiting a at m-second

delay(DELAY);    //waiting a at m-second
 //delay(60*DELAY-1000);  
}
int sensorLumToPhys(int raw){
// Conversion rule
float Vout = float(raw) * (VIN / float(1024));    // Conversion analog to voltage
float RLDR = (R * (VIN - Vout))/Vout; // Conversion voltage to resistance
int phys=500/(RLDR/1000); // Conversion resitance to lumen
return phys;
}
