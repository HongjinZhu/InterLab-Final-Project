void setup() {
  Serial.begin(9600);
}
void loop() {
  // potentiometers
  int P1 = analogRead(A0);
  // button
  int buttonValue = digitalRead(10);

  Serial.print(P1);
  Serial.print(",");
  Serial.print(buttonValue);
  Serial.println(); // add linefeed after sending the last sensor value

  // too fast communication might cause some latency in Processing
  // this delay resolves the issue.
  delay(10);
}
