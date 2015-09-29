/* This program naturally uses hexagonal # to get cool looking pattern */
/* Rotation formula 
 x' = cos sin * x
 y'  -sin cos   y
 => 
 x' =  x cos + y sin
 y' = -x sin + y cos
 */

int NN = 5;    /* global number of circles */
int nn = 5;    /* current number of circles */
int cMIN = 3;  /* min number of circles */
int cMAX = 9;  /* max number of circles */

float r = 40.0; /* radius of a small circle */ 
int fading = 0; /* defines circles fading */

void setup() {
  /* to fit on tumblr */
  size(600, 800);
}

void draw() {
  background(255); 
  noFill();
  strokeWeight(1.0);
  fading += 4;
  /* to catch errors */
  if (fading > 255) fading = 255;
  NN = nn;

  float[] posX = new float[6*(NN - 3)*(NN - 2)/2 + 1]; /* full inner circles */
  float[] posY = new float[6*(NN - 3)*(NN - 2)/2 + 1]; /* full inner circles */
  
  float[] posXhalf = new float [6*(NN - 2)]; /* half inner circles */
  float[] posYhalf = new float [6*(NN - 2)]; /* half inner circles */
  
  float[] posXarc = new float [6*(NN - 1)]; /* extra arcs */
  float[] posYarc = new float [6*(NN - 1)]; /* extra arcs */

  float[] distColorCirc = new float[6*(NN - 3)*(NN - 2)/2 + 1]; /* circles coloring */
  float[] distColorHalf = new float [6*(NN - 2)]; /* half-circles coloring */
  float[] distColorArc = new float [6*(NN - 1)];  /* arcs coloring */  
  /* to adjust coloring */
  float maxDist = 0.0;
  float minDist = width;
  
  pushMatrix();
  translate(width/2, height/2);
  /* get all inner points*/
  for (int ii = 1; ii < NN; ++ii) 
    getHex(posX, posY, ii);

  /* get points for half-circles */
  getHexOut(posXhalf, posYhalf, NN - 1);
  /* get points for etxtra arcs */
  getHexOut(posXarc, posYarc, NN);
  
  /* draw all half-circles and extra arcs */
  multipleArc(distColorArc, posXarc, posYarc, NN, PI/3, 2*PI/3);
  multipleArc(distColorHalf, posXhalf, posYhalf, NN - 1, 0, PI);
  /* adjust coloring scale */
  minMaxDist(distColorCirc, posX, posY, maxDist, minDist);
  /* draw inner circles */
  if (NN > 3) /* to prevent ugly overlapping */
    // for (int i = 0; i < posX.length; ++i){
    for (int i =  posX.length - 1; i >= 0; --i){    
      stroke(map(dist(posX[i], posY[i], mouseX - width/2, mouseY - height/2), maxDist/40*NN, minDist/40*NN, fading, 255));     
      ellipse(posX[i], posY[i], 2*r, 2*r);  
    }

  /* global ellipse */
  stroke(0);
  ellipse(0, 0, 2*r*(NN - 2), 2*r*(NN - 2));
  popMatrix();
}

/* calculates the coordinates of the hexagon's nodes */
void getHex(float x[], float y[], int start) {
  /* initialize and skip */
  if (start == 1 || start == 2) {
    x[0] = 0;
    y[0] = 0;
  }
  else{
    /* where to write current points */
    int iMin = 6*(start - 3)*(start - 2)/2 + 1;
    int iMax = 6*(start - 2)*(start - 1)/2;
  
    /* inititialize current hexagon */
    x[iMin] = -r/2.0 * (start - 2);
    y[iMin] = r*sqrt(3.0)/2.0 * (start - 2);
  
    for (int i = iMin + 1; i < iMin + start - 1; ++i) {
      x[i] = x[i - 1] + r;
      y[i] = y[i - 1];
    }
  
    for (int j = iMin; j < iMax - start + 3; ++j) {
      x[j + start - 2] =  x[j]*cos(PI/3) + y[j]*sin(PI/3);
      y[j + start - 2] = -x[j]*sin(PI/3) + y[j]*cos(PI/3);
    }
  }
}

/* calculates the coordinates of the points to draw  
   half circles and extra arcs*/
void getHexOut(float x[], float y[], int start) {
  /* initialize current hexagon */
  x[0] = -r/2 * (start - 1);
  y[0] = r*sqrt(3.0)/2 * (start - 1);

  for (int i = 1; i < start - 1; ++i) {
    x[i] = x[i - 1] + r;
    y[i] = y[i - 1];
  }
  
  for (int j = 0; j < x.length - start + 1; ++j) {
    x[j + start - 1] =  x[j]*cos(PI/3) + y[j]*sin(PI/3);
    y[j + start - 1] = -x[j]*sin(PI/3) + y[j]*cos(PI/3);
  }
}

/* draws arcs and rotates them as necessary */
void multipleArc(float[] dColor, float x[], float y[], int start, float angleS, float angleF) {
  float maxDist = 0.0;
  float minDist = width;
  minMaxDist(dColor, x, y, maxDist, minDist);
  int k = 0;
  for (int j = 0; j < x.length - (start - 2); j += (start - 1)) {
    stroke(map(dist(x[j], y[j], mouseX - width/2, mouseY - height/2), maxDist/40*NN, minDist/40*NN, fading, 255));
    arc(x[j], y[j], 2*r, 2*r, angleS + PI + PI*(1 - k)/3, angleF + PI - PI*k/3); 
    int i = j + 1;
    while (i  < j + 1 + start - 2){
      stroke(map(dist(x[i], y[i], mouseX - width/2, mouseY - height/2), maxDist/40*NN, minDist/40*NN, fading, 255));
      arc(x[i], y[i], 2*r, 2*r, angleS + PI - PI*k/3, angleF + PI - PI*k/3);
      ++i;
    }
    ++k;
  }
}

/* defines min/max distance between mouse position and given array of positions; 
   is used to adjust coloring */
void minMaxDist(float[] dColor, float[] x, float[] y, float maxDist, float minDist){
  for (int i =0; i < x.length; ++i){
    dColor[i] = dist(x[i], y[i], mouseX - width/2, mouseY - height/2); 
    if (dColor[i] > maxDist)
      maxDist = dColor[i]; 
    if (dColor[i] < minDist)
      minDist = dColor[i];   
  }
}

void mousePressed() {
  /* increase/decrease radius of the main circle*/
  if (mouseButton == LEFT)
    nn += (nn + 1 > cMAX) ? 0 : 1;
  if (mouseButton == RIGHT){
    nn -= (nn - 1 < cMIN) ? 0 : 1;
  }
}

void mouseMoved(){
    /* reset coloring */
    fading = 0;
}

/* for debugging */
void printOut(float a[], float b[]) {
  for (int i = 0; i < a.length; ++i)
    println(i + " : " + a[i] + " " + b[i]);
}

