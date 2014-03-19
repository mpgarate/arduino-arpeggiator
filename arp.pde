import java.util.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

import processing.serial.*;
Serial arduinoPort;

String input;

float hz(String s){
  return Frequency.ofPitch(s).asHz();
}

/* C Major
float [] indexToHz = new float[] {
  hz("C4"),
  hz("D4"),
  hz("E4"),
  hz("F4"),
  hz("G4"),
  hz("A4"),
  hz("B4")
};
*/

// A Minor
float [] indexToHz = new float[] {
  hz("A4"),
  hz("B4"),
  hz("C5"),
  hz("D5"),
  hz("E5"),
  hz("F5"),
  hz("G5")
};

Boolean activeNotes[];

Minim minim;
AudioPlayer note;
AudioOutput out;
Oscil wave;

int startTime;


class SineInstrument implements Instrument
{
  Oscil wave;
  Line  ampEnv;
  
  SineInstrument( float frequency )
  {
    // make a sine wave oscillator
    // the amplitude is zero because 
    // we are going to patch a Line to it anyway
    wave   = new Oscil( frequency, 0, Waves.SINE );
    ampEnv = new Line();
    ampEnv.patch( wave.amplitude );
  }
  
  // this is called by the sequencer when this instrument
  // should start making sound. the duration is expressed in seconds.
  void noteOn( float duration )
  {
    // start the amplitude envelope
    ampEnv.activate( duration, 0.5f, 0 );
    // attach the oscil to the output so it makes sound
    wave.patch( out );
  }
  
  // this is called by the sequencer when the instrument should
  // stop making sound
  void noteOff()
  {
    wave.unpatch( out );
  }
}


void setup()
{
  String portName = Serial.list()[0];
  arduinoPort = new Serial(this, portName, 9600);
     
  minim = new Minim(this);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  
  // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
  //wave = new Oscil( 440, 0.5f, Waves.SINE );
  // patch the Oscil to the output
  //wave.patch( out );
}

void playNoteIndex(int noteIndex){
  out.playNote( 0.0, 0.1, new SineInstrument(indexToHz[noteIndex]) );
}
 
 
void serialEvent(Serial port) { 
  int input = port.read();
  playNoteIndex(input - 48);
  println( "Raw Input: " + input); 
} 
 
void draw()
{
  
}
