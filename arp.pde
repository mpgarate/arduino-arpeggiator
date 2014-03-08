import java.util.*;
import ddf.minim.*;

import processing.serial.*;
Serial arduinoPort;

String input;
int btnVal1;
int btnVal2;

String [] btnVals;
String [] indexToStringMap = new String[] {"C4","D4"};

Boolean activeNotes[];

Minim minim;
AudioPlayer note, lastNote;

int savedTime;
int totalTime = 1000;

int lastIndex = -1;

LinkedList list = new LinkedList();

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

void setup()
{
  String portName = Serial.list()[0];
  arduinoPort = new Serial(this, portName, 9600);
  
  size(100, 100);
 
  minim = new Minim(this);
 
  savedTime = millis();
}
 
void draw()
{
  // clear all notes on each pulse
  activeNotes = new Boolean[] {false,false,false,false,false,false,false};
  
  //list = new LinkedList();
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
  
  
  int passedTime = millis() - savedTime;
  //println(passedTime + " : " + totalTime);
  if (passedTime > totalTime){
    playNextNote(activeNotes);
    println("last index:" + lastIndex);
    savedTime = millis();
  }
  
  background(0);
}
