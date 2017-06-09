

int resistanceValues[] = {0, 0, 0, 0, 0 };


void setup()
{
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  pinMode(A0, INPUT_PULLUP);   // current flows
  pinMode(2, INPUT);
  pinMode(3, INPUT);
  pinMode(4, INPUT);
  pinMode(5, INPUT);
  pinMode(6, INPUT);

  establishContact();
}

void loop()
{
  if (Serial.available() > 0) {
    int b = Serial.read();
    
    for (int i = 2; i < 7; i++) {
      pinMode(i, OUTPUT);
      digitalWrite(i, LOW);
      resistanceValues[i - 2] = analogRead(A0);
      pinMode(i, INPUT);
    }

    for (int i = 0; i < 5; i++) {
      Serial.print(resistanceValues[i]);

      Serial.print(", ");
    }
    Serial.println();
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    delay(300);
  }
}
