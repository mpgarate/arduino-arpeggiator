const int btn1 = 7;
boolean btn1_is_on = false;
const int btn2 = 5;
boolean btn2_is_on = false;

void setup(){
  Serial.begin(9600);
}

void loop(){
  int btnVal1 = digitalRead(btn1);
  int btnVal2 = digitalRead(btn2);
  
  if (btnVal1 == 1 && !btn1_is_on){
    Serial.print("1");
    Serial.write(",");
  }
  else if (btn1 == 0){
    btn1_is_on = true;
  }
  if (btnVal2 == 1 && !btn2_is_on){
    Serial.print("2");
    Serial.write(",");
  }
  else if (btn2 == 0){
    btn2_is_on = true;
  }
  
  //Serial.write(potVal1 + "," + potVal2 + '\n');
  Serial.write("*");
}
