import gifAnimation.*;
GifMaker gifExport;
boolean startGif = false;

final float radius = 20.0; /* radius of the point */
/* define boundaries of a screen */
final int top = 0;
final int right = 1;
final int bottom = 2;
final int left = 3;

final color blue = #2537b5;
final color red = #ff3804;
final color black = #000000;
final color white = #ffffff;
final int colorsN = 3;
final color[] colorSet = {
  blue, red, black
};

final int n = 150; /* number of dots */
final float mu = 1.0; /* friction coefficent */
final float EPS = 1e-3;

Node[] Nodes;

void setup() {
  size(540, 540, P2D);
  frameRate(55);
  background(white);
  noStroke();
  smooth();
  initNodes(n);

}

void initNodes(int nNodes) {
  Nodes = new Node[nNodes];
  for (int i = 0; i < nNodes; ++i) {
    Nodes[i] = new Node();
    Nodes[i].setMoving(true);
    Nodes[i].setV(random(0, 1.0), random(0, 1.0));
    Nodes[i].setCoord(random(radius, width - radius), random(radius, height - radius));
    Nodes[i].setNodeColor(i%colorsN);
  }
  gifExport = new GifMaker(this, "Inspire.gif");
  gifExport.setRepeat(0); // make an "endless" animation
//  save("init.png");
}

void draw() {
  background(white);
  for (int i = 0; i < n; ++i) {
    fill(colorSet[Nodes[i].getNodeColor()], 200);
    ellipse(Nodes[i].getCoordX(), Nodes[i].getCoordY(), 2*radius, 2*radius);
  }
  move();
  if (startGif){
    gifExport.setDelay(1);
    gifExport.addFrame();
  }
}

void keyPressed(){
  if (keyCode == 's' || keyCode == 'S'){
    startGif = true;
  }
  if (keyCode == 'f' || keyCode == 'F'){
    gifExport.finish();
    exit();
  }
}


void move() {
  /* temporary variables */
  float x, y, vx, vy;
  float[] timeHit = new float[4]; 

  for (int i = 0; i < n; ++i)
    if (Nodes[i].getMoving()) {
      /* speed */
      x = Nodes[i].getCoordX();
      y = Nodes[i].getCoordY();
      vx = mu*Nodes[i].getVx(); /* !friction */
      vy = mu*Nodes[i].getVy(); /* !friction */

      /* prevent divsion by zero */
      if (abs(vx) < EPS) 
        vx = EPS; 
      if (abs(vy) < EPS) 
        vy = EPS;        

      timeHit[top] = -(y - radius)/vy;
      timeHit[right] = (width - (x + radius))/vx;
      timeHit[bottom] = (height - (y + radius))/vy; 
      timeHit[left] = -(x - radius)/vx; 

      if (timeHit[right] >= 0 && timeHit[right] < 1) {
        x = width - radius - 1;  /* @IMP: This "-1" prevents nasty bug */
        vx *= -1;
      } else {
        if (timeHit[left] >= 0 && timeHit[left] < 1) {
          x = radius + 1;  /* @IMP: This "+1" prevents nasty bug */
          vx *= -1;
        } else {
          x += vx;
        }
      }

      if (timeHit[bottom] >= 0 && timeHit[bottom] < 1) {
        y = height - radius - 1; /* @IMP: This "-1" prevents nasty bug */
        vy *= -1;
      } else {
        if (timeHit[top] >=0 && timeHit[top] < 1) { 
          y = radius + 1;  /* @IMP: This "+1" prevents nasty bug */
          vy *= -1;
        } else {
          y += vy;
        }
      }

      /* Assignment part */
      Nodes[i].setCoordX(x);
      Nodes[i].setCoordY(y);
      Nodes[i].setVx(vx);
      Nodes[i].setVy(vy);
    }

  for (int i = 0; i < n; ++i)
    collide(i);
}

void collide(int i) {
  float[] vX = new float [2];
  float[] vY = new float [2];
  float[] x = new float[2];
  float[] y = new float[2];
  float[] m = new float[2];

  for (int j = 0; j <n; ++j) {
    vX[0] = Nodes[i].getVx();
    vY[0] = Nodes[i].getVy();
    x[0] = Nodes[i].getCoordX();
    y[0] = Nodes[i].getCoordY();
    m[0] = Nodes[i].getMass();

    if (i != j) {
      vX[1] = Nodes[j].getVx();
      vY[1] = Nodes[j].getVy();
      x[1] = Nodes[j].getCoordX();
      y[1] = Nodes[j].getCoordY();
      m[1] = Nodes[j].getMass();

      if ((x[0] - x[1])*(x[0] - x[1]) + (y[0] - y[1])*(y[0] - y[1])<= 4*radius*radius) { 
        /* do not collide is circles intersect */
        if ((x[0] - x[1])*(vX[1] - vX[0]) + (y[0] - y[1])*(vY[1] - vY[0]) > 0) {
          Nodes[i].setVx( (vX[0]*(m[0] - m[1]) + 2*m[1]*vX[1]) / (m[0] + m[1]) );
          Nodes[j].setVx( (vX[1]*(m[1] - m[0]) + 2*m[0]*vX[0]) / (m[0] + m[1]) );
          Nodes[i].setVy( (vY[0]*(m[0] - m[1]) + 2*m[1]*vY[1]) / (m[0] + m[1]) );
          Nodes[j].setVy( (vY[1]*(m[1] - m[0]) + 2*m[0]*vY[0]) / (m[0] + m[1]) );
          /* set new color */
          int newColor = (int)(random(0, colorsN));
          int curColor = Nodes[j].getNodeColor();
          Nodes[j].setNodeColor(newColor != curColor ? newColor : (curColor + 1) % colorsN);
        }
      }
    }
  }
}
