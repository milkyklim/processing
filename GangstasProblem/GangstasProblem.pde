/*
  gangsta problem 
 */

final int N = 50; // # of gangstas 
PVector[] coord;  
color BACKGROUND = color(0); 
color FILL = color(0);
color STROKE = color(255);
int STROKEWEIGHT = 2;
int[] gNearest; 

float EPS = 0.001; 

PVector[] bullet;

int[] dead = {
  0, 0
}; // used to store # of dead gangstas 

PGraphics cross; 
PImage logo;

int gRadius; // radius of the gangsta

void setup() {
  background(BACKGROUND);
  size(530, 530);

  gRadius = 20;
  // +5 to fit crosses
  cross = createGraphics(gRadius + 5, gRadius + 5);
  logo = loadImage("data/logo_whitedSmall.png");

  crossCreate(cross);

  coord = new PVector[N];
  gNearest = new int[N];
  bullet = new PVector[N];
  
  println("INIT DONE!");
}

int frameN = 5;

void draw() {
  background(0);
  gangstaInit(coord, bullet, dead);
  gangstaFindNearest(coord, gNearest); 
  gangstaShotShow(coord, gNearest, bullet, frameN - 1);
  gangstaShow(coord, false, frameN - 1);
  gangstaDeadShow(coord, gNearest, cross, dead);
  image(logo, width - logo.width, height - logo.height);
  
  delay(5000);
}


// create sign for dead gangstas 
void crossCreate(PGraphics p) {
  p.beginDraw();  
  p.background(BACKGROUND, 0);
  p.stroke(255, 0, 0);
  p.strokeWeight(STROKEWEIGHT);
  p.line(0, 0, gRadius, gRadius);
  p.line(0, gRadius, gRadius, 0);  
  p.endDraw();
}

