


#include <Wire.h>                 // Must include Wire library for I2C
#include "SparkFun_MMA8452Q.h"    // Click here to get the library: http://librarymanager/All#SparkFun_MMA8452Q

MMA8452Q accel;                   // create instance of the MMA8452 class



void setup() {
  Serial.begin(38400);
  Serial.println("MMA8452Q Basic Reading Code!");
  Wire.begin();
  pinMode(10, INPUT); // Setup for leads off detection LO +
  pinMode(11, INPUT); // Setup for leads off detection LO -

  // Init all values in array to 0
 

  if (accel.begin() == false) {
    Serial.println("Not Connected. Please check connections and read the hookup guide.");
    while (1);
  }
}

 float total = 0.0;
 float accelMag = 0.0;
 int count = 0;
 float average = 0.0;

 float squaredX = 0.0;
 float squaredY = 0.0;
 float squaredZ = 0.0;

 float accelTotal = 0.0;
 String aWord;

 
void loop() {
      count ++;
      aWord = "Movement: ";
      
      squaredX = pow(accel.getCalculatedX(), 2);
      squaredY = pow(accel.getCalculatedY(), 2);
      squaredZ = pow(accel.getCalculatedZ(), 2);

      accelTotal = (squaredX + squaredY + squaredZ);

      
      accelMag =  sqrt(accelTotal);
      total += accelMag;
      average = total/count;
      aWord += accelMag;
      
    
      // if(accelMag >= average +1 || accelMag <= average -1){
         //aWord += " WARNING";
        
        //}

      if(count % 4 == 0){
        Serial.println(aWord);
      }
      
  if((digitalRead(10) == 1)||(digitalRead(11) == 1)){
    Serial.println('!');
  }
  else{
    // send the value of analog input 0:
      Serial.println(analogRead(A0));
  }
  delay(10);
  //Wait for a bit to keep serial data from saturating
  

}
