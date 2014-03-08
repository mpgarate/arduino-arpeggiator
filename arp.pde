import java.util.*;
import ddf.minim.*;

import processing.serial.*;
Serial arduinoPort;

String input;
int btnVal1;
int btnVal2;

String [] btnVals;
String [] indextoStringMap = new String[] {"C4","D4"};

Boolean activeNotes[];

Minim minim;
AudioPlayer C4,D4,E4,F4,G4,A4,B4, lastNote;

int savedTime;
int totalTime = 1000;

LinkedList list = new LinkedList();

void playNextNote(){
  if (list.size() == 0) return;
  println(list.getFirst());
  //if (Integer.parseInt(list.getFirst().toString()) == 0) return;
  A4 = minim.loadFile(list.getFirst() + ".wav");
  Object first = list.pop();
  list.offerLast(first);
  A4.play();
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
  list = new LinkedList();
  activeNotes = new Boolean[] {false,false,false,false,false,false,false};
  
  while (arduinoPort.available() > 0){
    input = arduinoPort.readStringUntil('*');
    if (input != null){
      btnVals = splitTokens(input,",*");
      
      for (int i = 0; i < btnVals.length; i++){
        int value = parseInt(btnVals[i]);
        println("got value: " + value);
        if (activeNotes[value] == false){
          String noteName = indextoStringMap[value - 1];
          list.add(noteName);
          activeNotes[value] = true;
        }
        else{
          activeNotes[value] = true;
        }
      }
    }
  }
  
  
  int passedTime = millis() - savedTime;
  //println(passedTime + " : " + totalTime);
  if (passedTime > totalTime){
    lastNote = null;
    playNextNote();
    savedTime = millis();
    lastNote = A4;
  }
  
  background(0);
}
