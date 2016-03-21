/*
  draw limacon
*/

int staticR = 120;
int FILL = 0;

int sIdx = 0; // initial index
int fIdx = 0; // final index

float[] x;
float[] y;
float[] phi;

int N; // number of points for limacon

void setup() {
  background(255);
  size(530, 530);
  frameRate(50);

  N = 100;

  x = new float[N];
  y = new float[N];
  phi = new float[N];

  calculatePhi(phi);
  calculateLimacon(phi, x, y);
  
}

void draw() {
  coordinatePlane();
  // noFill();
  // strokeWeight(4);

  pushMatrix();
  translate(width/2, height/2);

  drawInnerCircle(phi, sIdx, fIdx);
  drawLimacon(sIdx, fIdx);
  popMatrix();

  // check boundaries
  if (fIdx != N) ++fIdx;
  else  ++sIdx;   

  if (sIdx == fIdx) {
    sIdx = 0;
    fIdx = 0;
  }
  
  //saveFrame("data/limacon-##.png");
}


// calculate phi angle 
void calculatePhi(float[] phi_) {
  float step = TWO_PI/N;
  phi_[0] = 0;
  for (int i = 1; i < N; ++i) {
    phi_[i] = (step*i);
  }
}

// calculate limacon points
void calculateLimacon(float[] phi_, float[] x_, float[] y_) {  
  // float step = TWO_PI/N;
  for (int i = 0; i < N; ++i) {
    float rho = staticR*(1 - 0.42*cos(phi_[i]));
    y_[i] = rho*sin(-phi_[i]);
    x_[i] = rho*cos(-phi_[i]);
  }
}

// draw limacon point by point 
void drawLimacon(int sIdx_, int fIdx_) {
  pushStyle();
  noFill();
  strokeWeight(4);
  stroke(255, 0, 0);
  for (int i = sIdx_; i < fIdx_; ++i) {
    ellipse(x[i], y[i], 2, 2);
  }
  popStyle();
}

// draw inner circle point by point
void drawInnerCircle(float[] phi_, int sIdx_, int fIdx_) {
  pushStyle();
  stroke(0);
  strokeWeight(2);
  sIdx_ = sIdx_ - sIdx_%2;
  for (int i = sIdx_; i < fIdx_; i += 2) {
    float x = staticR/2*cos(-phi_[i]);
    float y = staticR/2*sin(-phi_[i]);
    ellipse(x, y, 2, 2);
  }
//  if (fIdx != 0 && sIdx == 0)
//    drawOuterCircle(phi[fIdx - 1]);
  popStyle();
}

// draw outer sliding circle
void drawOuterCircle(float phi) {
  pushStyle();
  stroke(0);
  strokeWeight(2);  
  
  float y = staticR*cos(phi);
  float x = staticR*sin(phi);
  
  ellipse(x, y, 2, 2); // center 
  ellipse(x, y, staticR, staticR);
  popStyle();
}


// draw coordinate plane 
// sheet-like plane
void coordinatePlane() {
  pushStyle();
  background(220);
  int step = 53; 
  stroke(255);
  strokeWeight(5);
  // y's
  for (int i = 0; i <= width; i += step) {
    line(i, 0, i, height);
  }
  // x's
  for (int i = 0; i <= height; i += step) {
    line(0, i, width, i);
  }
  stroke(128);
  // x-axis
  line(width/2, 0, width/2, height);
  // y-axis
  line(0, height/2, width, height/2);

  // @TODO: fix an issue with borders
  popStyle();
}

void mouseClicked(){
  if (mouseButton == LEFT)
    noLoop();
  else 
    loop();
}

