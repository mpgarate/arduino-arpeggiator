
const int POSSIBLE_NO = 3;
//const int button_pins[] = {13, 12, 11, 10, 9, 8, 7};
const int button_pins[] = {13, 12, 11}; //, 10, 9, 8, 7};
int button_values[] = {0, 0, 0}; //, 0, 0, 0, 0};

// active_notes[i] == 1 if note i is active
int active_notes[] = {0, 0, 0}; //, 0, 0, 0, 0};

void setup(){
  Serial.begin(9600);
}

int get_button_value(int i){
  return digitalRead(button_pins[i]);
}

void set_button_values(){
  int i = 0;
  for (i=0; i < POSSIBLE_NOTES; i++){
    button_values[i] = get_button_value(i);
  }
}

void set_active_notes(){
  int i = 0;
  for (i=0; i < POSSIBLE_NOTES; i++){
    if (button_values[i] == 1){
      active_notes[i] = 1;
    }
    else{
      active_notes[i] = 0;
    }
  }
}

// here notes are indicies starting fro 0
int previous_note = -1;

int get_next_note(){
  int next_note = -1;
    
  // get next active note
  int i;
  for (i = previous_note+1; i < POSSIBLE_NOTES; i++) {
    if (active_notes[i] == 1){
      next_note = i;
      break;
    }
  }
  // if no notes found
  if (next_note == -1){
    // loop from beginning
    for (i = 0; i < previous_note+1; i++); {
      if (active_notes[i] == 1){
        next_note = i;
        Serial.println("next_note: " + i);
      }
    }
  }
  
  if(next_note == -1){
    // no active notes
  }
  
  return next_note;
}

void play_note(int note){
  // if no note to play
  if (note == -1)
  {
    return;
  }
  Serial.print(note);
  Serial.write("\n");
}

void loop(){
  set_button_values();
  set_active_notes();
  int next_note = get_next_note();
  play_note(next_note);
  previous_note = next_note;
  
  //Serial.write(potVal1 + "," + potVal2 + '\n');
  delay(100);
}
