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


boolean flagKeyPressed = false;

/*
  @IDEA: there are two layers with inverted colors 
 */
PGraphics bwLayer, wbLayer, curLayer;
/* 
 false -- bwLayer
 true -- wbLayer
 */
boolean switchLayers = true;

/*
    add variables to control the work flow
 0: general fractal structure
 1: random angle
 2: random angle + random number of branches
 */
int control = 1;

void setup() {
  size(300, 300);
  background(FILL);
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

  bwLayer = createGraphics(width, height);
  wbLayer = createGraphics(width, height);
  curLayer = createGraphics(width, height);

  bwLayer.beginDraw();
  bwLayer.background(BACKGROUND);
  bwLayer.fill(FILL);
  bwLayer.endDraw();

  wbLayer.beginDraw();
  wbLayer.background(FILL);
  wbLayer.fill(BACKGROUND);
  wbLayer.endDraw();

  curLayer = wbLayer;  

  /* 
   we can pre-calculate the tree here 
   but draw it step by step 
   */

  branches = generateTree(branches);
  
  noLoop();
}

void draw() {
  ArrayList<Branch> tmpBranches = branches;
  try {
    for (Branch b : tmpBranches) {
      curLayer = b.display(curLayer);
    }
  } 
  catch (Exception e) {
    // @TODO: Find a better way to fix this problem!
    e.printStackTrace();
  }
  
  image(curLayer, 0, 0);

  // save all steps 
  // save("data/item" + idx + ".png");
  /* we display the tree only when it is finished */
  //if (idx > steps) {

  //  noLoop();
  //  save("data/item" + idx + ".png");
  //}
  //idx++;


}


void keyPressed() {
  if (keyCode == 'r' || keyCode == 'R') {
    // keep color, new tree
    clearBackground();
    generateNewFullTree();
  }
  if (keyCode == 's' || keyCode == 'S') {
    // switch colors, keep tree
    clearBackground();
    switchLayers = !switchLayers;
    curLayer = (switchLayers ? wbLayer : bwLayer);
  }
  if (keyCode == 'n' || keyCode == 'N') {
    // switch colors, switch tree
    clearBackground();
    switchLayers = !switchLayers;
    curLayer = (switchLayers ? wbLayer : bwLayer);
    generateNewFullTree();
  }
}

void mouseClicked() {
  clearBackground();
  generateNewFullTree();
}

void clearBackground() { 
  // reset canvas 
  bwLayer.beginDraw();
  bwLayer.background(BACKGROUND);
  bwLayer.fill(FILL);
  bwLayer.stroke(FILL);
  bwLayer.endDraw();

  // reset canvas 
  wbLayer.beginDraw();
  wbLayer.background(FILL);
  wbLayer.fill(BACKGROUND);
  wbLayer.stroke(BACKGROUND);
  wbLayer.endDraw();

  redraw();
}

void generateNewFullTree() {
  idx = 0; 
  branches.clear();
  branches.add(new Branch(inS, outS, 0, 0));
  branches = generateTree(branches);
}