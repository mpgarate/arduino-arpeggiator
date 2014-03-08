import java.util.*;
import ddf.minim.*;

import processing.serial.*;
Serial arduinoPort;

String input;
int btnVal1;
int btnVal2;

String [] btnVals;

Minim minim;
AudioPlayer C4,D4,E4,F4,G4,A4,B4, lastNote;

int savedTime;
int totalTime = 1000;

LinkedList list = new LinkedList();

void playNextNote(){
  if (list.size() == 0) return;
  println(list.getFirst());
  //if (Integer.parseInt(list.getFirst().toString()) == 0) return;
  println(list.getFirst());
  A4 = minim.loadFile(list.getFirst() + ".wav");
  Object first = list.pop();
  list.offerLast(first);
  A4.play();
}

void setup()
{
  
  String portName = Serial.list()[0];
  arduinoPort = new Serial(this, portName, 9600);
  
  /*
  list.add("C4");
  list.add("D4");
  list.add("E4");
  list.add("F4");
  list.add("G4");
  list.add("A4");
  list.add("B4");
  // this loads mysong.wav from the data folder
  B4 = minim.loadFile("B4.wav");
  C4 = minim.loadFile("C4.wav");
  D4 = minim.loadFile("D4.wav");
  E4 = minim.loadFile("E4.wav");
  F4 = minim.loadFile("F4.wav");
  G4 = minim.loadFile("G4.wav");
*/
  size(100, 100);
 
  minim = new Minim(this);
 
  
  savedTime = millis();
}
 
void draw()
{
  while (arduinoPort.available() > 0){
    input = arduinoPort.readStringUntil('*');
    if (input != null){
      btnVals = splitTokens(input,",*");
      if (btnVals.length == 1){
        println("btnVals is 1");
        //continue;
      }
      for (int i = 0; i < btnVals.length; i++){
        list.add(btnVals[i]);
        println("got: " + btnVals[i]);
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
