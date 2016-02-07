/* //<>//
  Creates Serpinski Triangle
 */

ArrayList<SerpinskiTriangle> triangles;

int steps = 0;

float[] x = new float [3];
float[] y= new float [3];
PVector one, two, three;

int marginX = 100;
int marginY = 150;

void setup() {
  size(530, 530);
  background(255);

  x[0] = 0 + marginX;
  x[1] = width - marginX;
  x[2] = width/2;

  y[0] = 0 + marginY;
  y[1] = 0 + marginY;

  y[2] = marginY + (width - 2*marginX)*tan(PI/3)/2;

  // define vertices
  one = new PVector(x[0], y[0]);
  two = new PVector(x[1], y[1]);
  three = new PVector(x[2], y[2]);

  // define edges 
  triangles = new ArrayList<SerpinskiTriangle>();

  // define triangle
  triangles.add(new SerpinskiTriangle(one, two, three));
}

void draw() {
  background(255);

  for (SerpinskiTriangle t : triangles)
    t.display();

  triangles = generate(triangles);

  // debug 
  // noFill();
  // stroke(255, 0, 0);
  // ellipse(x[0], y[0], 2*(width - 2*marginX), 2*(width - 2*marginX));
  // ellipse(x[1], y[1], 2*(width - 2*marginX), 2*(width - 2*marginX));
  // ellipse(x[2], y[2], 2*(width - 2*marginX), 2*(width - 2*marginX));
  // stroke(0);
  // fill(0);

  // save each step
  save("data/item" + steps + ".png");
  if (steps > 5)
    noLoop();
  steps++;
}


ArrayList<SerpinskiTriangle> generate(ArrayList<SerpinskiTriangle> trianlges) {
  ArrayList next = new ArrayList<SerpinskiTriangle>();
  for (SerpinskiTriangle t : triangles) {
    PVector x = t.a.get();
    PVector y = t.b.get();
    PVector z = t.c.get();
    // length of the side
    float len = dist(x.x, x.y, y.x, y.y);  

    // new points 
    PVector leftPoint = new PVector(x.x + cos(PI/3)*len/2, x.y + sin(PI/3)*(len/2));
    PVector rightPoint = new PVector( y.x + cos(2*PI/3)*len/2, y.y + sin(PI/3)*len/2);

    next.add(new SerpinskiTriangle(x.x, x.y, y.x - len/2, y.y, leftPoint.x, leftPoint.y));
    next.add(new SerpinskiTriangle(x.x + len/2, x.y, y.x, y.y, rightPoint.x, rightPoint.y));
    next.add(new SerpinskiTriangle(leftPoint.x, leftPoint.y, rightPoint.x, rightPoint.y, z.x, z.y));
  }

  return next;
}

class SerpinskiTriangle {

  PVector a;
  PVector b;
  PVector c;

  SerpinskiTriangle(PVector ax, PVector bx, PVector cx ) {
    a = ax.get();
    b = bx.get();
    c = cx.get();
  }

  SerpinskiTriangle(float ax, float ay, float bx, float by, float cx, float cy ) {
    a = new PVector(ax, ay);
    b = new PVector(bx, by);
    c = new PVector(cx, cy);
  }

  void display() {
    fill(0);
    stroke(0);
    triangle(a.x, a.y, b.x, b.y, c.x, c.y);
  }
}