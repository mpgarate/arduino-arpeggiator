import java.util.*;
import ddf.minim.*;

import processing.serial.*;
Serial arduinoPort;

String input;

String [] indexToStringMap = new String[] {"C4","D4","E4","F4"};

Boolean activeNotes[];

Minim minim;
AudioPlayer note;

int startTime;
void playNote(int noteIndex){
  String noteName = indexToStringMap[noteIndex];
  println(noteName);
  note = minim.loadFile(noteName + ".wav");
  note.play();
}

void setup()
{
  String portName = Serial.list()[0];
  arduinoPort = new Serial(this, portName, 9600);
   
  minim = new Minim(this);
  startTime = millis();
}
 
void draw()
{
  if (arduinoPort.available() > 0){
    input = arduinoPort.readStringUntil('\n');
    if (input != null){
      input = trim(input);
      playNote(parseInt(input));
      startTime = millis();
      println(input);
    }
  }
  
  
  int passedTime = millis() - startTime;
  
  if (passedTime > 100){
    minim.stop();
  }
}
