/* //<>//
  creates Tree Fractal
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


/*
    add variables to control the work flow
 0: general fractal structure
 1: random angle
 2: random angle + random number of branches
 */
int control = 1;

void setup() {
  size(300, 300);
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

  branches = new ArrayList<Branch>();
  branches.add(new Branch(inS, outS, 0, 0));

  /* 
   we can pre-calculate the tree here 
   but draw it step by step 
   */

  branches = generateTree(branches);
}

void draw() {
  if (idx == 0) background(BACKGROUND);
  pushMatrix();

  translate(width/2, height);
  for (Branch b : branches) {
    b.display();
  }

  popMatrix();

  // save all steps 
  // save("data/item" + idx + ".png");
  /* we display the tree only when it is finished */
  //if (idx > steps) {

  //  noLoop();
  //  save("data/item" + idx + ".png");
  //}
  //idx++;

  noLoop();
}

void keyPressed() {
  if (keyCode == 'r' || keyCode == 'R') {
    idx = 0; 
    branches.clear();
    branches.add(new Branch(inS, outS, 0, 0));
    branches = generateTree(branches);
    loop();
  }
}

void mouseClicked() {
  idx = 0; 
  branches.clear();
  branches.add(new Branch(inS, outS, 0, 0));
  branches = generateTree(branches);
  loop();
}