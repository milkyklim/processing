/*
  Creates Koch's snowflake 
*/

ArrayList<KochLine> lines;

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
  lines = new ArrayList<KochLine>();

  // define Koch's curve
  lines.add(new KochLine(one, two));
  lines.add(new KochLine(two, three));
  lines.add(new KochLine(three, one));


}

void draw() {
  background(255);

  for (KochLine l : lines)
   l.display();
   
  lines = generate(lines);

  // save each step
  save("data/snow" + steps + ".png");
  if (steps > 7)
    noLoop();
  steps++;
}


ArrayList<KochLine> generate(ArrayList<KochLine> lines) {
  ArrayList next = new ArrayList<KochLine>();
  for (KochLine l : lines) {
    PVector a = l.kochA();
    PVector b = l.kochB();
    PVector c = l.kochC();
    PVector d = l.kochD();
    PVector e = l.kochE();

    next.add(new KochLine(a, b));
    next.add(new KochLine(b, c));
    next.add(new KochLine(c, d));
    next.add(new KochLine(d, e));
  }

  return next;
}

class KochLine {

  PVector start;
  PVector end;

  PVector kochA() {
    return start.get();
  }

  PVector kochB() {
    PVector v = PVector.sub(end, start);
    v.div(3);
    v.add(start);
    return v;
  }

  PVector kochC() {
    PVector a = start.get();

    PVector v = PVector.sub(end, start);
    v.div(3);
    a.add(v);

    v.rotate(-PI/3);
    a.add(v);

    return a;
  }
  PVector kochD() {
    PVector v = PVector.sub(end, start);
    v.mult(2.0/3);
    v.add(start);
    return v;
  }

  PVector kochE() {
    return end.get();
  }

  KochLine(PVector a, PVector b) {
    start = a.get();
    end = b.get();
  }

  void display() {
    stroke(0);
    line(start.x, start.y, end.x, end.y);
  }
}

