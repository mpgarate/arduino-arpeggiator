import java.util.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

import processing.serial.*;
Serial arduinoPort;

String input;

float [] indexToHz = new float[] {440.0, 493.88, 523.25};

Boolean activeNotes[];

Minim minim;
AudioPlayer note;
AudioOutput out;
Oscil wave;

int startTime;

void setup()
{
  String portName = Serial.list()[0];
  arduinoPort = new Serial(this, portName, 9600);
   
  startTime = millis();
  
   minim = new Minim(this);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  
  // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
  wave = new Oscil( 440, 0.5f, Waves.SINE );
  // patch the Oscil to the output
  wave.patch( out );
}


void playNote(int noteIndex){
  wave.setFrequency(indexToHz[noteIndex]);
  wave.setAmplitude(0.5);
}

void stopNote(){
  wave.setAmplitude(0);
}
 
void draw()
{
  if (arduinoPort.available() > 0){
    input = arduinoPort.readStringUntil('\n');
    if (input != null){
      input = trim(input);
      int noteValue = parseInt(input));
      if (noteValue == -1){
        stopNote();
      }
      playNote(noteValue);
      startTime = millis();
      println(input);
    }
  }
}
