
const int POSSIBLE_NOTES = 7;
//const int button_pins[] = {13, 12, 11, 10, 9, 8, 7};
const int button_pins[] = {7, 8, 9, 10, 11, 12, 13};

int button_values[] = {0, 0, 0, 0, 0, 0, 0};

const int led_pins[] = {A1, A0, 2, 3, 4, 5, 6};

// active_notes[i] == 1 if note i is active
int active_notes[] = {0, 0, 0, 0, 0, 0, 0};

int next_note = -1;

long previousMillis = 0;
long interval = 150;

void setup(){
  Serial.begin(115200);
  int i = 0;
  for(i = 0; i < POSSIBLE_NOTES; i++){
    pinMode(led_pins[i], OUTPUT);
  }
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
    for (i = 0; i < previous_note + 1; i++) {
      if (active_notes[i] == 1){
        next_note = i;
        break;
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
  //Serial.flush();
}

void start_led(int i){
  if (i == -1) return;
  digitalWrite(led_pins[i], HIGH);
}

// stop single led with previous_note
void stop_leds(){
  int i = 0;
  for(i = 0; i < POSSIBLE_NOTES; i++){
    digitalWrite(led_pins[i], LOW);
  }
}

void loop(){
  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval){
    play_note(next_note);
    
    stop_leds();
    start_led(next_note);
    
    set_button_values();
    set_active_notes();
    
    next_note = get_next_note();
    
    previous_note = next_note;
    previousMillis = currentMillis;
  }
}
