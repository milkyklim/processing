/* //<>// //<>//
  creates Tree Fractal
 */

ArrayList<Branch> branches;
float angle; // define the rotation of the branch
int idx;  // used fod counting number of frames
int steps; // number of frames to save\generate
float scaleFactor; // scale factor for the length of the branches 
float initLength;  // initial length of the root
PVector inS;
PVector outS;

color BACKGROUND; 
color FILL;

int control = 1;

void setup() {
  size(530, 300);
  background(255);
  angle = PI/2; 
  idx = 0;   
  steps = 4; 
  scaleFactor = 1.5; 
  initLength = 75; 
  
  BACKGROUND = color(0);
  FILL = color(255);

  inS = new PVector(0, 0);
  outS = new PVector(0, -initLength);

  /*
    add variables to control the work flow
   0: general fractal structure
   1: random angle
   2: random angle + random number of branches
   */


  branches = new ArrayList<Branch>();
  branches.add(new Branch(inS, outS));
}

void draw() {
  if (idx == 0) background(BACKGROUND);
  pushMatrix();

  translate(width/2, height);
  for (Branch b : branches)
    b.display();

  branches = generate(branches, steps);

  popMatrix();

  // save all steps 
  save("data/item" + idx + ".png");
  if (idx > steps)
    noLoop();
  idx++;
}

ArrayList<Branch> generate(ArrayList<Branch> branches, int a) {

  // strokeWeight(); 
  ArrayList next = new ArrayList<Branch>();
  for (Branch t : branches) {
    for (int i = 0; i < (control == 2 ? (int)random(1, 4) : 1); ++i){

    // right branch
    next.add(new Branch(t.end, t.pointNext(control < 1 ? angle : random(-PI/2, PI/2))));
    // left branch
    next.add(new Branch(t.end, t.pointNext(control < 1 ? -angle : random(-PI/2, PI/2))));
    }  
}

  return next;
}


class Branch {
  PVector start; // start point
  PVector end; // end point

  // calulates the end point of the next branch\leaf
  PVector pointNext(float angle) {
    PVector a = end.get();
    PVector v = PVector.sub(end, start);

    v.div(scaleFactor); // scale vector by two 
    v.rotate(angle); // rotate vector by given angle 
    a.add(v); // "attach" vector to the end point

    return a;
  }

  Branch(PVector s, PVector e) {
    start = s;
    end = e;
  }

  void display() {
    // stroke(random(255), random(255), random(255));
    strokeWeight(2);
    stroke(FILL);
    fill(FILL);
    line(start.x, start.y, end.x, end.y);
  }
}

void keyPressed() {
  if (keyCode == 'r' || keyCode == 'R') {
    idx = 0; 
    // background(255);
    branches.clear();
    branches.add(new Branch(inS, outS));

    loop();

  }
}