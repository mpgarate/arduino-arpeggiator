const int btn1 = 7;
const int btn2 = 8;
const int ledPin0 = 0;
const int ledPin1 = 1;

void setup(){
  Serial.begin(9600);
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin0, OUTPUT);
}

void loop(){
  if (Serial.available() > 0 ){
    Serial.write("handling serial");
    int noteIndex = Serial.read();
    // handle lit LED information
    if (noteIndex > 0){
      if (noteIndex == 0){
        digitalWrite(ledPin0, HIGH);
        digitalWrite(ledPin1, LOW);
      }
      if (noteIndex == 1){
        digitalWrite(ledPin1, HIGH);
        digitalWrite(ledPin0, LOW);
      }
    }
    // handle request for active notes
    else if (noteIndex == -100){
      int btnVal1 = digitalRead(btn1);
      int btnVal2 = digitalRead(btn2);
      
      if (btnVal1 == 1){
        Serial.print("1");
        Serial.write(",");
      }
      if (btnVal2 == 1){
        Serial.print("2");
        Serial.write(",");
      }
      Serial.write('\n');
    }
  }
  //Serial.write(potVal1 + "," + potVal2 + '\n');
}
