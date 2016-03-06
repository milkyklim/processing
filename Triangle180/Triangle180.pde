/*
  sketch: draws triangle and shows that the sum of the angles is 180 degrees 
 */
PVector[] vertex; // triangle vertices
float bMax, bMin; // calculate coefficients
PVector [] kb;    // stores k and b coefficients for each  
float bCur;       // current b -cooefficient 
float direction;  // define the direction and step size for the moving line 
int angleRadius;  // marker for angles 
int angleStep;    // distance between markers

PGraphics[] angleMoving;

int pmillis = 0; // neccesary to freeze the image 

void setup() {
  background(255);
  size(530, 530);
  frameRate(50);

  bCur = 0;
  direction = -1;  
  vertex = new PVector[3];
  kb = new PVector[3];
  angleRadius = 40;  
  angleStep = 12;   

  vertex[0] = new PVector(400, 70);
  vertex[1] = new PVector(20, 350); 
  vertex[2] = new PVector(500, 450);

  // calculate all coefficients 
  kb[0] = coefficientsCalculate(vertex[0], vertex[1]);  
  kb[2] = coefficientsCalculate(vertex[0], vertex[2]);
  kb[1] = coefficientsCalculate(vertex[1], vertex[2]);  
  bMax = kb[1].y;
  bMin = vertex[0].y - kb[1].x*vertex[0].x;
  bCur = kb[1].y; // = bMin - to start from the top 
  // -----

  angleMoving = new PGraphics[2]; //  [0] - left, [1] - right moving angle
  angleMoving[0] = createGraphics(200, 200);
  angleMoving[1] = createGraphics(200, 200);

  angleMoving = createAnglesMoving();
}

void draw() {

  if (!(millis() - pmillis < 3000 && direction > 0)) {

    coordinatePlane();  
    strokeWeight(4);
    stroke(255, 0, 0);
    strokeCap(SQUARE);
    drawAngles(vertex);

    drawAnglesMovingP(kb, bCur, angleMoving);
    strokeCap(ROUND);
    stroke(0);  

    drawTriangleLines(kb);
    drawTriangle(vertex);

    stroke(255, 0, 0);
    drawLineMoving(kb[1].x, bCur);   // moving line 

    bCur += direction;
    if (bCur < bMin || bCur >  bMax) {
      bCur -= direction;
      direction *= -1;

      pmillis = millis();
    }
  }
  // saveFrame("data/triangle/triangle-##.png");
}

/* returns the k and b of the line equation 
 res[0] = k
 res[1] = b
 */
PVector coefficientsCalculate(PVector a, PVector b) {
  PVector res = new PVector(1, 1);

  try { // division by zero
    res.x = (a.y - b.y)/(a.x - b.x);
    res.y = a.y - res.x*a.x;
  }
  catch(Exception e)
  {
    println("division by zero");
  }
  return res;
}

// return y-coordinate for the given equation 
float yReturn(float x, float k, float b) {
  return k*x + b;
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

// draw initial triangle 
void drawTriangle(PVector[] a) {
  line(a[0].x, a[0].y, a[1].x, a[1].y);
  line(a[0].x, a[0].y, a[2].x, a[2].y);
  line(a[2].x, a[2].y, a[1].x, a[1].y);
}

// draw initial triangle lines  
void drawTriangleLines(PVector[] coeff) {
  pushStyle();
  strokeWeight(1);
  line(0, yReturn(0, coeff[0].x, coeff[0].y), width, yReturn(width, coeff[0].x, coeff[0].y));
  line(0, yReturn(0, coeff[1].x, coeff[1].y), width, yReturn(width, coeff[1].x, coeff[1].y));
  line(0, yReturn(0, coeff[2].x, coeff[2].y), width, yReturn(width, coeff[2].x, coeff[2].y));
  popStyle();
}

// solve the system of equations 
// find intersection point 
PVector intersectionFind(PVector first, PVector second) {
  PVector res = new PVector(1, 1);
  res.x = (second.y - first.y)/(first.x - second.x);
  res.y = first.y + res.x*first.x;
  return res;
}

// draw angles in the traingle 
void drawAngles(PVector[] a) {
  PVector Ox = new PVector(10.0, 0); // horizontal vector 
  PVector [] vec = new PVector[3];
  vec[0] = PVector.sub(a[0], a[1]);
  vec[1] = PVector.sub(a[0], a[2]);
  vec[2] = PVector.sub(a[2], a[1]); 

  float [] angleTmp = new float[3]; // stores help-angles 
  angleTmp[0] = PVector.angleBetween(PVector.sub(vec[2], vec[0]), Ox);
  arc(a[0].x, a[0].y, angleRadius, angleRadius, 0 + angleTmp[0], PVector.angleBetween(vec[0], vec[1]) + angleTmp[0]); 
  angleTmp[1] = PVector.angleBetween(PVector.sub(vec[0], vec[1]), Ox);
  arc(a[1].x, a[1].y, angleRadius  + angleStep, angleRadius + angleStep, - PVector.angleBetween(vec[2], vec[0]) + angleTmp[1], 0 + angleTmp[1]);   
  arc(a[1].x, a[1].y, angleRadius, angleRadius, - PVector.angleBetween(vec[2], vec[0]) + angleTmp[1], 0 + angleTmp[1]); 

  angleTmp[2] = PI + angleTmp[1];
  arc(a[2].x, a[2].y, angleRadius + 2*angleStep, angleRadius + 2*angleStep, 0 + angleTmp[2], angleTmp[2] + PI - PVector.angleBetween(vec[1], vec[2]));
  arc(a[2].x, a[2].y, angleRadius + angleStep, angleRadius + angleStep, 0 + angleTmp[2], angleTmp[2] + PI - PVector.angleBetween(vec[1], vec[2]));
  arc(a[2].x, a[2].y, angleRadius, angleRadius, 0 + angleTmp[2], angleTmp[2] + PI - PVector.angleBetween(vec[1], vec[2]));

  // Extra Outer Angle ! 
  arc(a[0].x, a[0].y, angleRadius, angleRadius, - PVector.angleBetween(vec[0], vec[1]) - PVector.angleBetween(vec[2], vec[0]) + angleTmp[1], -PVector.angleBetween(vec[2], vec[0]) + angleTmp[1]);
}


// draw moving angles
void drawAnglesMoving(PVector[] a, PVector[] kb, float b) {
  PVector Ox = new PVector(10.0, 0); // horizontal vector 
  PVector [] vec = new PVector[3];
  vec[0] = PVector.sub(a[0], a[1]);
  vec[1] = PVector.sub(a[0], a[2]);
  vec[2] = PVector.sub(a[2], a[1]); 
  float [] angleTmp = new float[3]; // stores help-angles 
  angleTmp[1] = PVector.angleBetween(PVector.sub(vec[0], vec[1]), Ox);
  angleTmp[2] = PI + angleTmp[1];

  // find first right dot
  PVector tmp = new PVector(kb[1].x, b);
  PVector dot = new PVector(0, 0);
  dot = intersectionFind(kb[2], tmp);  
  arc(dot.x, dot.y, angleRadius + 2*angleStep, angleRadius + 2*angleStep, 0 + angleTmp[2], angleTmp[2] + PI - PVector.angleBetween(vec[1], vec[2]));
  arc(dot.x, dot.y, angleRadius + angleStep, angleRadius + angleStep, 0 + angleTmp[2], angleTmp[2] + PI - PVector.angleBetween(vec[1], vec[2]));
  arc(dot.x, dot.y, angleRadius, angleRadius, 0 + angleTmp[2], angleTmp[2] + PI - PVector.angleBetween(vec[1], vec[2]));

  // find second left dot
  dot = intersectionFind(kb[0], tmp);  
  arc(dot.x, dot.y, angleRadius + angleStep, angleRadius + angleStep, -PVector.angleBetween(vec[2], vec[0]) + angleTmp[1], 0 + angleTmp[1]);
  arc(dot.x, dot.y, angleRadius, angleRadius, -PVector.angleBetween(vec[2], vec[0]) + angleTmp[1], 0 + angleTmp[1]);
}


PGraphics [] createAnglesMoving() {
  PGraphics[] angles = new PGraphics[2]; //  [0] - left, [1] - right moving angle
  angles[0] = createGraphics(200, 200);
  angles[1] = createGraphics(200, 200);

  // turn on drawing 
  angles[1].beginDraw();
  angles[1].strokeWeight(4);
  angles[1].stroke(255, 0, 0);
  angles[1].strokeCap(SQUARE);
  angles[1].background(255, 0); // !transparent

  angles[0].beginDraw();
  angles[0].strokeWeight(4);
  angles[0].stroke(255, 0, 0);
  angles[0].strokeCap(SQUARE);
  angles[0].background(255, 0); // !transparent

  PVector Ox = new PVector(10.0, 0); // horizontal vector 
  PVector [] vec = new PVector[3];
  vec[0] = PVector.sub(vertex[0], vertex[1]);
  vec[1] = PVector.sub(vertex[0], vertex[2]);
  vec[2] = PVector.sub(vertex[2], vertex[1]); 

  float [] angleTmp = new float[3]; // stores help-angles 
  angleTmp[1] = PVector.angleBetween(PVector.sub(vec[0], vec[1]), Ox);
  angleTmp[2] = PI + angleTmp[1];

  // right
  angles[1].arc(angles[1].width/2, angles[1].height/2, angleRadius + 2*angleStep, angleRadius + 2*angleStep, 0 + angleTmp[2], angleTmp[2] + PI - PVector.angleBetween(vec[1], vec[2]));
  angles[1].arc(angles[1].width/2, angles[1].height/2, angleRadius + angleStep, angleRadius + angleStep, 0 + angleTmp[2], angleTmp[2] + PI - PVector.angleBetween(vec[1], vec[2]));
  angles[1].arc(angles[1].width/2, angles[1].height/2, angleRadius, angleRadius, 0 + angleTmp[2], angleTmp[2] + PI - PVector.angleBetween(vec[1], vec[2]));
  angles[1].endDraw();

  // left 
  angles[0].arc(angles[0].width/2, angles[0].height/2, angleRadius + angleStep, angleRadius + angleStep, -PVector.angleBetween(vec[2], vec[0]) + angleTmp[1], 0 + angleTmp[1]);
  angles[0].arc(angles[0].width/2, angles[0].height/2, angleRadius, angleRadius, -PVector.angleBetween(vec[2], vec[0]) + angleTmp[1], 0 + angleTmp[1]);
  angles[0].endDraw();

  return angles;
}

// draw moving angles
void drawAnglesMovingP(PVector[] kb, float b, PGraphics[] angles) {
  // find first right dot
  PVector tmp = new PVector(kb[1].x, b);
  PVector dot = new PVector(0, 0);
  dot = intersectionFind(kb[2], tmp);  
  image(angles[1], dot.x - angles[1].width/2, dot.y - angles[1].height/2);

  // find second left dot
  dot = intersectionFind(kb[0], tmp);  
  image(angles[0], dot.x - angles[0].width/2, dot.y - angles[0].height/2);
}


void drawLineMoving(float x, float b) {
  line(0, yReturn(0, x, b), width, yReturn(width, x, b));
}

void mouseClicked() {
  save("data/printScreen.png");
}

