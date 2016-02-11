/* //<>// //<>//
  creates Tree Fractal
 
 should produce Forest now 
 */

ArrayList<Branch> branches;
float angle; // define the rotation of the branch
int idx;  // used fod counting number of frames
int jdx;  // used for counting number of trees
int margin; 
int steps; // number of frames to save\generate
float scaleFactor; // scale factor for the length of the branches 
float initLength;  // initial length of the root
PVector inS;
PVector outS;

color BACKGROUND; 
color FILL;

int control = 1;

void setup() {
  size(800, 300);
  background(BACKGROUND);
  angle = PI/2; 
  idx = 0;   
  steps = 5; 
  scaleFactor = 1.5; 
  initLength = 75; 

  jdx = 0;
  margin = 20;

  //---------------
  //strokeJoin(ROUND);
  //strokeCap(SQUARE);
  //---------------

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

  translate(width/2, height);


  branches = new ArrayList<Branch>();
  branches.add(new Branch(inS, outS, 0));

  //for (int i = 0; i < steps+1; ++i){
  //  for (Branch b : branches)
  //    b.display();
  //  branches = generate(branches, steps);

  //}
}

void draw() {
  if (idx == 0) background(BACKGROUND);
  pushMatrix();

  // translate(0, height);
  translate(width/2, height);
  for (Branch b : branches){
    b.display();
  }

  //translate((jdx + 1)*margin, 0);
  //branches.add(new Branch(inS, outS, 0));
  //for (Branch b : branches)
  //  b.display();
  //for (int i = 0; i < steps; ++i) {  
  branches = generate(branches, steps);
  //for (Branch b : branches)
  //  b.display();
  //}
  popMatrix();

  //save all steps 
  save("data/item" + idx + ".png");
  if (idx > steps)
    noLoop();
  idx++;

  // branches.clear();
  // jdx++;
  // if ((jdx + 1)*margin > width) {
  //  save("data/res.png");
  //  noLoop();
  // }
}

ArrayList<Branch> generate(ArrayList<Branch> branches, int a) {

  // strokeWeight(); 
  ArrayList next = new ArrayList<Branch>();
  for (Branch t : branches) {

    for (int i = 0; i < (control == 2 ? (int)random(1, 4) : 1); ++i) {
      // right branch
      noiseSeed(1000*(int)random(5000));
      float tmp = control < 1 ? angle : random(-PI/2, PI/2);
      next.add(new Branch(t.end, t.pointNext(tmp), tmp));
      // left branch
      noiseSeed(1000*(int)random(5000));
      tmp = control < 1 ? -angle : random(-PI/2, PI/2);
      next.add(new Branch(t.end, t.pointNext(tmp), tmp));
    }
  }

  return next;
}


class Branch {
  PVector start; // start point
  PVector end; // end point

  float noisy; // necessary for wind  

  // calulates the end point of the next branch\leaf
  PVector pointNext(float angle) {
    PVector a = end.get();
    PVector v = PVector.sub(end, start);

    v.div(scaleFactor); // scale vector by two 
    v.rotate(angle); // rotate vector by given angle 
    a.add(v); // "attach" vector to the end point

    return a;
  }

  Branch(PVector s, PVector e, float noisyIn) {
    start = s;
    end = e;
    noisy = noisyIn;
  }

  void display() {
    strokeWeight(steps - idx + 2);
    stroke(FILL);
    fill(FILL);
    line(start.x, start.y, end.x, end.y);
  }
}

void keyPressed() {
  if (keyCode == 'r' || keyCode == 'R') {
    idx = 0; 
    branches.clear();
    branches.add(new Branch(inS, outS, 0));
    loop();
  }
}

void mouseClicked() {
  idx = 0; 
  branches.clear();
  branches.add(new Branch(inS, outS, 0));
  loop();
}