import processing.serial.*;

Serial myPort;        // The serial port
int xPos = 1;         // horizontal position of the graph
float height_old = 0;
float height_new = 0;
float inByte = 0;
int BPM = 0;
int beat_old = 0;
float[] beats = new float[500];  // Used to calculate average BPM
int beatIndex;
float threshold = 620.0;  //Threshold at which BPM calculation occurs
boolean belowThreshold = true;
PFont font;

String movement = "";
float val = 1;
String temp;


void setup () {
  // set the window size:
  size(1000, 400);        

  // List all the available serial ports
  
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 38400);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
  // set inital background:
  background(0xff);
  font = createFont("Arial", 12, true);
}


void draw () {
     //Map and draw the line for new data point
     inByte = map(inByte, 0, 1023, 0, height);
     height_new = height - inByte; 
     line(xPos - 1, height_old, xPos, height_new);
     height_old = height_new;
    
      // at the edge of the screen, go back to the beginning:
      if (xPos >= width) {
        xPos = 0;
        background(0xff);
      } 
      else {
        // increment the horizontal position:
        xPos++;
      }
      
      // draw text for BPM periodically
      if (millis() % 128 == 0){
        fill(0xFF);
        rect(0, 0, 400, 30);
        fill(0x00);
        temp = movement.substring(10,14);
       
         
         val= Float.parseFloat(temp);
         System.out.println(val);
        
        
        if (inByte > 140 || inByte < 110){
          
          if (val > 1.2 || val < 0.8)
          text("BPM " + inByte + " Warning " + movement + " Warning", 15,10);
          else 
          text("BPM: " + inByte + " Warning " + movement , 15,10);
        
      
    }
          
          /*if (val > 1.2)
              text("BPM: " + inByte + " Warning "  + movement , 15, 10);
          
          else
            text("BPM: " + inByte + " Warning " + movement + " Warning", 15,10);
          }
      } */
        else       
           {
          if (val > 1.2 || val < 0.8)
          text("BPM " + inByte + " " +movement + " Warning", 15,10);
          else 
          text("BPM: " + inByte + " " +movement , 15,10);}
}
          
      
}


void serialEvent (Serial myPort) 
{
  // get the ASCII string:
 
 
  
  String inString = myPort.readStringUntil('\n');
  

  

  if (inString != null && !inString.contains("Movement") ) 
  {
    // trim off any whitespace:
    inString = trim(inString);

    // If leads off detection is true notify with blue line
    if (inString.equals("!")) 
    { 
      stroke(0, 0, 0xff); //Set stroke to blue ( R, G, B)
      inByte = 512;  // middle of the ADC range (Flat Line)
    }
    // If the data is good let it through
    else 
    {
      stroke(0xff, 0, 0); //Set stroke to red ( R, G, B)
      inByte = float(inString); 
      
      // BPM calculation check
      if (inByte > threshold && belowThreshold == true )
      {
        calculateBPM();
        belowThreshold = false;
      }
      else if(inByte < threshold)
      {
        belowThreshold = true;
      }
    }
  }
  else if (inString != null && inString.contains("Movement")){
    movement = inString;
  }
}
  
void calculateBPM () 
{  
  int beat_new = millis();    // get the current millisecond
  int diff = beat_new - beat_old;    // find the time between the last two beats
  float currentBPM = 60000 / diff;    // convert to beats per minute
  beats[beatIndex] = currentBPM;  // store to array to convert the average
  float total = 0.0;
  for (int i = 0; i < 500; i++){
    total += beats[i];
  }
  BPM = int(total / 500);
  beat_old = beat_new;
  beatIndex = (beatIndex + 1) % 500;  // cycle through the array instead of using FIFO queue
  }
