//float w = 1;
//void setup() {
//  size(800, 800);
//}

//void draw() {
//  background(255);
//  noStroke();
//  pushMatrix();
//  translate(width*0.5, height*0.5);
//  fill(250, 231, 83);
//  sun(0, 0, 80, 100, 40); 
//  popMatrix();


//  if (w < 300) {
//    println(w);
//    fill(117, 211, 252);
//    rect(50, 400+w, 60, 300-w);
//    w += 0.5;
//    if (mousePressed) {
//      w = 0;
//    }
//  } else if (w == 300) {
//    noLoop();
//    background(0);
//    text("Remember to Water Your Plant!", width/2, height/2);
//  }
//  // instruction for watering the plant
//  fill(0);
//  text("Click the Button to Water the Plant", 10, 140);
//}

//void sun(float x, float y, float radius1, float radius2, int npoints) {
//  float angle = TWO_PI / npoints;
//  float halfAngle = angle/2.0;
//  beginShape();
//  for (float a = 0; a < TWO_PI; a += angle) {
//    float sx = x + cos(a) * radius2;
//    float sy = y + sin(a) * radius2;
//    vertex(sx, sy);
//    sx = x + cos(a+halfAngle) * radius1;
//    sy = y + sin(a+halfAngle) * radius1;
//    vertex(sx, sy);
//  }
//  endShape(CLOSE);
//}

float theta;   

void setup() {
  fullScreen();
}

void draw() {
  background(0);
  frameRate(10);
  stroke(255);
  // Let's pick an angle 0 to 90 degrees based on the mouse position
  float a = (mouseX / (float) width) * 90f;
  // Convert it to radians
  theta = radians(a);
  // Start the tree from the bottom of the screen
  translate(width/2,height);
  // Draw a line 120 pixels
  line(0,0,0,-120);
  // Move to the end of that line
  translate(0,-120);
  // Start the recursive branching!
  branch(500);

}

void branch(float h) {
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.66;
  
  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 2) {
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
    line(0, 0, 0, -h);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
    
    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);
    popMatrix();
  }
}
