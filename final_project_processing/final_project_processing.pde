import processing.serial.*;
import processing.sound.*;

int a;
int b;
int c;
float rate;
float w = 1;
float theta; 

PImage img1;
PImage img2;
PImage img3;
PImage img4;

boolean image2Loaded = false;
boolean image3Loaded = false;
boolean image4Loaded = false;

// declare an AudioIn object
AudioIn microphone;
// declare an Amplitude analysis object to detect the volume of sounds
Amplitude analysis;

PFont myFont;

String myString = null;
Serial myPort;

int NUM_OF_VALUES = 2;
int[] Values;

void setup() {
  fullScreen();

  img1 = loadImage("image1.jpg");
  img2 = loadImage("image2.jpg");
  img3 = loadImage("image3.jpg");
  img4 = loadImage("image4.jpg");
  a=0;

  microphone = new AudioIn(this, 0);
  // start the mic input without routing it to the speakers
  microphone.start();
  // create the Amplitude analysis object
  analysis = new Amplitude(this);
  // use the microphone as the input for the analysis
  analysis.input(microphone);

  myFont = createFont("Georgia", 32);
  textFont(myFont);
  textAlign(LEFT, CENTER);

  setupSerial();
}

void draw() {
  updateSerial();
  printArray(Values);
  background(255);

  // loading the image
  float colorValue = Values[0]/4;
  rate = map(Values[0], 0, 1023, 0, 10);
  image(img1, 0, 0, width, height);
  tint(colorValue, colorValue, colorValue, a); 
  image(img2, 0, 0, width, height);
  tint(colorValue, colorValue, colorValue, 255-a);
  if (a<255) {
    a+= rate;
  } else {
    image2Loaded = true;
  }

  if (image2Loaded) {
    image(img2, 0, 0, width, height);
    tint(colorValue, colorValue, colorValue, b); 
    image(img3, 0, 0, width, height);
    tint(colorValue, colorValue, colorValue, 255-b);
    if (b<255) {
      b+= rate;
    } else {
      image3Loaded = true;
    }
  }

  if (image3Loaded) {
    image(img3, 0, 0, width, height);
    tint(colorValue, colorValue, colorValue, c); 
    image(img4, 0, 0, width, height);
    tint(colorValue, colorValue, colorValue, 255-c);
    if (c<255) {
      c+= rate;
    } else {
      image4Loaded = true;
    }
  }

  if (image4Loaded) {
    noLoop();
    background(255);
    fill(32, 193, 21);
    text("SUCCESS!", width/2, height/2);
  }

  // font for instruction
  String lightLevel;
  fill(0);
  textMode(SHAPE);

  if (Values[0] < 400) {
    lightLevel = "DARK";
    fill(255);
  } else if (Values[0] < 850) {
    lightLevel = "MEDIUM";
  } else {
    lightLevel = "BRIGHT";
  }
  text("Brightness: " + lightLevel, 10, 60);

  // instruction for watering the plant
  text("Click the Button to Water the Plant", 10, 140);

  // analyze the audio for its volume level
  float volume = analysis.analyze();
  // map the volume value to a useful scale
  int vol = round(map(volume, 0, 1, 0, 1000));
  println(vol);

  // detecing light level from the environment
  text("Noise: " + str(vol) + "%", 10, 20);

  // detecting noise level from the environment
  if (vol > 80) {
    text("KEEP QUIET!", 10, 100);
  }
  if (Values[0] >= 600) {
    noStroke();
    pushMatrix();
    translate(width*0.9, height*0.1);
    fill(250*Values[0]/1023, 231*Values[0]/1023, 83*Values[0]/1023);
    sun(0, 0, 80, 100, 40); 
    popMatrix();
  }

  // signs for watering the plant
  if (w < 300) {
    println(w);
    fill(117, 211, 252);
    rect(10, 400 + w, 60, 300 - w);
    w += 5;
    if (w > 200) {
      fill(255, 0, 0);
      text("CAUTION! WATER YOUR PLANT!", 200, height/2);
    }
    if (Values[1] == 1) {
      w = 0;
    }
  } else {
    noLoop();
    background(0);
    fill(255);
    text("Remember to Water Your Plant!", 200, height/2);
  }
}

void setupSerial() {
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.clear();
  myString = myPort.readStringUntil( 10 );  // 10 = '\n'  Linefeed in ASCII
  myString = null;

  Values = new int[NUM_OF_VALUES];
}

void updateSerial() {
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil( 10 ); // 10 = '\n'  Linefeed in ASCII
    if (myString != null) {
      String[] serialInArray = split(trim(myString), ",");
      if (serialInArray.length == NUM_OF_VALUES) {
        for (int i=0; i<serialInArray.length; i++) {
          Values[i] = int(serialInArray[i]);
        }
      }
    }
  }
}

void sun(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
