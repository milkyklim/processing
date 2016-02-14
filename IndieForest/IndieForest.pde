/* //<>// //<>// //<>//
  creates Tree Fractal
 */

ArrayList<ArrayList<Branch>> branches;
float angle; // define the rotation of the branch
int idx;  // used fod counting number of frames
int jdx;  // used for counting number of trees
int offset; 
int steps; // number of frames to save\generate
float scaleFactor; // scale factor for the length of the branches 
float initLength;  // initial length of the root
PVector inS;
PVector outS;

color BACKGROUND; 
color FILL; 

int TREEN; // number of trees

Hero hero;

boolean flagKeyPressed = false;
boolean activeLayer = true;

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
  size(800, 300, P2D);
  background(FILL);
  angle = PI/2; 
  idx = 0;   
  steps = 5; 
  scaleFactor = 1.5; 
  initLength = 75; 
  jdx = 0;
  offset = 40;

  //---------------
  //strokeJoin(ROUND);
  //strokeCap(SQUARE);
  //---------------

  BACKGROUND = color(0);
  FILL = color(255);
  TREEN = 20;

  bwLayer = createGraphics(width, height);
  wbLayer = createGraphics(width, height);
  curLayer = createGraphics(width, height);

  /* create hero */
  hero = new Hero(width, height);
  hero.hero.beginDraw();
  hero.hero.background(0, 0); // this layer is transparent except objects 
  hero.hero.noStroke();
  hero.hero.fill(0); // @TODO: change 
  // hero.hero.ellipse(width/2, height/2, 60, 60);
  hero.hero.rect(0, height/2, width, 90);
  hero.hero.endDraw();

  bwLayer.beginDraw();
  bwLayer.background(BACKGROUND);
  bwLayer.fill(FILL);
  // bwLayer.noStroke();  // @DEBUG
  bwLayer.endDraw();

  wbLayer.beginDraw();
  wbLayer.background(FILL);
  wbLayer.fill(BACKGROUND);
  wbLayer.endDraw();

  inS = new PVector(0, 0);
  outS = new PVector(0, -initLength);

  // create forest 
  branches = new ArrayList<ArrayList<Branch>>(); 
  ArrayList<Branch> tmpBranches = new ArrayList<Branch>();
  for (int i = 0; i < TREEN; ++i) {
    branches.add(i, new ArrayList<Branch>()); // root of the new tree
    tmpBranches.clear(); // stores current tree
    tmpBranches.add(new Branch(inS, outS, 0, 0)); // place
    branches.get(i).addAll(generateTree(tmpBranches));
  }

  noLoop();
}

void draw() {

  int xShift = -width/2 + 30;
  int yShift = 30;
  
  for (ArrayList<Branch> tree : branches) {
    ArrayList<Branch> tmpBranches = tree;
    //println("size: " + tmpBranches.size()); // looks like we get the full tree here SOOQA! 
    //println(tmpBranches.get(0).getStartX() + " " + tmpBranches.get(0).getEndX());
    try {
      // if (branches.indexOf(tree) == 2) {
      for (Branch b : tmpBranches) {
        // curLayer = b.display(curLayer);
        // display tree branch-by-branch

        b.display(wbLayer, xShift, 0);
        b.display(bwLayer, xShift, 0);
      }
      // @ TODO: Here should be the part to reset the hero
      //  }
      
    }
    catch (Exception e) {
      // @TODO: Find a better way to fix this problem!
      e.printStackTrace();
    }
    xShift += offset;
  }

  // @DEBUG @TODO: Delete this part 
  PGraphics[] layers = new PGraphics[3];
  layers[0] = hero.hero;
  layers[1] = switchLayers ? wbLayer : bwLayer;
  layers[2] = switchLayers ? bwLayer : wbLayer;

  layers = switchPixelColors(layers);

  //  @TODO: We should put both pictures but one should be on top of another
  for (int i = layers.length - 1; i >= 0; --i)
    image(layers[i], 0, 0);

  // image(curLayer, 0, 0);


  // image(activeLayer ?  bwLayer : wbLayer, 0, 0);
  // image(activeLayer ?  wbLayer : bwLayer, 0, 0);


  // save all steps 
  // save("data/item" + idx + ".png");
  /* we display the tree only when it is finished */
  //if (idx > steps) {

  //  noLoop();
  //  save("data/item" + idx + ".png");
  //}
  //idx++;

  save("data/output.png");
}

// function to switch transparency of the pixels
PGraphics[] switchPixelColors(PGraphics[] layers) {
  /* [0] top level -- hero 
   [1] first (top/visible) background
   [2] second (lower) background */
  /* this is the first iteration of this function 
   @TODO: add offsets! that makes the code more efficient 
   */

  // use pixels from all layers 
  for (int i = 0; i < layers.length; ++i)
    layers[i].loadPixels();

  for (int i = 0; i < layers[0].width; ++i) {
    for (int j = 0; j < layers[0].height; ++j) {
      if (alpha(layers[0].pixels[i + layers[0].width*j]) != 0) { //work only with objects
        if ((layers[0].pixels[i + layers[0].width*j] == layers[2].pixels[i + layers[2].width*j])) {
          // do nothing ! 
          // println("HELLO!");
        } else {
          // println("WTF!");
          layers[0].pixels[i + layers[0].width*j] = color(layers[0].pixels[i + layers[0].width*j], 0);
          layers[1].pixels[i + layers[1].width*j] = color(layers[1].pixels[i + layers[1].width*j], 0);
        }
      }
    }
  }

  for (int i = 0; i < layers.length; ++i)
    layers[i].updatePixels();

  return layers;
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

  switchLayers = !switchLayers;
  curLayer = (switchLayers ? wbLayer : bwLayer);

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

  hero.hero.beginDraw();
  hero.hero.background(0, 0, 0, 0); // this layer is transparent except objects 
  hero.hero.noStroke();
  hero.hero.fill(0); // @TODO: change 
  // hero.hero.ellipse(width/2, height/2, 60, 60);
  hero.hero.rect(0, height/2, width, 90);
  hero.hero.endDraw();

  redraw();
}

void generateNewFullTree() {
  idx = 0; 
  branches.clear();
  //branches.add(new Branch(inS, outS, 0, 0));
  //branches = generateTree(branches);

  // create forest 
  // branches = new ArrayList<ArrayList<Branch>>(); 
  // create each tree in the forest 
  for (int i = 0; i < TREEN; ++i) {
    branches.add(new ArrayList<Branch>());
  }

  inS.x = 0;
  outS.x = 0;

  for (int i = 0; i < TREEN; ++i) {
    branches.get(i).add(new Branch(inS, outS, 0, 0));
    // println(i + " " + inS.x);
    // inS.x += offset;
    // outS.x += offset;
  }  

  for (ArrayList<Branch> tree : branches) {
    tree = generateTree(tree);
  }
}