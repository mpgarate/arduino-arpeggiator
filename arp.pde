import java.util.*;
import ddf.minim.*;

import processing.serial.*;
import cc.arduino.*;
Serial arduinoPort;
Arduino arduino;

String input;
int btnVal1;
int btnVal2;

String [] btnVals;
String [] indexToStringMap = new String[] {"C4","D4"};

Boolean activeNotes[];

Minim minim;
AudioPlayer note, lastNote;

int savedTime;
int totalTime = 200;

int lastIndex = -1;

LinkedList list = new LinkedList();

// arduino pins
int btn1 = 7;
int btn2 = 5;

void setup()
{
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list() [0], 9600);
  
  String portName = Serial.list()[0];
  //arduinoPort = new Serial(this, portName, 9600);
  
  size(100, 100);
 
  minim = new Minim(this);
 
  savedTime = millis();
}
 
void draw()
{
  int btnVal1 = arduino.digitalRead(btn1);
  int btnVal2 = arduino.digitalRead(btn2);
  
  
  // clear all notes on each pulse
  activeNotes = new Boolean[] {false,false,false,false,false,false,false};
  
  //list = new LinkedList();
  /*
  while (arduinoPort.available() > 0){
    input = arduinoPort.readStringUntil('*');
    if (input != null){
      btnVals = splitTokens(input,",*");
      
      for (int i = 0; i < btnVals.length; i++){
        int value = parseInt(btnVals[i]);
        activeNotes[value] = true;
      }
    }
  }
  */
  
  if (btnVal1 == 1){
    activeNotes[0] = true;
  }
  if (btnVal2 == 1){
    activeNotes[1] = true;
  }
  
  int passedTime = millis() - savedTime;
  //println(passedTime + " : " + totalTime);
  if (passedTime > totalTime){
    playNextNote(activeNotes);
    println("last index:" + lastIndex);
    savedTime = millis();
  }
  else if (passedTime > 100){
    minim.stop();
  }  
  background(0);
}

void playNextNote(Boolean[] activeNotes){
  if (activeNotes.length == 0) return;
  String noteName = "";
  int noteIndex = -1;
  for(int i = lastIndex + 1; i < activeNotes.length; i++){
    if (activeNotes[i] == true){
      noteName = indexToStringMap[i-1];
      noteIndex = i;
      break;
    }
  }
  if (noteIndex == -1){
    for (int i = 0; i < lastIndex + 1; i++){
      if (activeNotes[i] == true){
        noteName = indexToStringMap[i-1];
        noteIndex = i;
        break;
      }
    }  
  }
  
  if (noteName.length() == 0 || noteIndex == -1){
    return;
  }
  note = minim.loadFile(noteName + ".wav");
  note.play();
  
  lastIndex = noteIndex;
}
