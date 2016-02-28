/* //<>// //<>//
  creates fibonacci spiral
 */

PGraphics rectScreen;
PGraphics textScreen;
PGraphics spiralScreen;

ArrayList<Integer> fib;
ArrayList<Integer> x;
ArrayList<Integer> y;


int idx;
int factor;

final int MAXN = 8;
final int lastFib = 13; // the last fib # for this implementation, necessary for text size

float fA;
float fB;

boolean controlSpiral = false;
boolean controlText = true;
boolean controlRect = true;

void setup() {
  fib = new ArrayList<Integer>();
  x = new ArrayList<Integer>();
  y = new ArrayList<Integer>();

  idx = 0;
  factor = 20;

  fib.add(1*factor);
  fib.add(1*factor);

  x.add(0);
  y.add(0);

  fA = HALF_PI;
  fB = 0;


  rectScreen = createGraphics(530, 280);
  rectScreen.beginDraw();
  rectScreen.background(255, 0);
  rectScreen.rectMode(CORNERS);
  rectScreen.textAlign(CENTER, CENTER);
  rectScreen.noFill();
  rectScreen.endDraw();

  spiralScreen = createGraphics(530, 280);
  spiralScreen.beginDraw();
  spiralScreen.background(255, 0);
  spiralScreen.rectMode(CORNERS);
  spiralScreen.textAlign(CENTER, CENTER);
  spiralScreen.noFill();
  spiralScreen.endDraw();

  textScreen = createGraphics(530, 280);
  textScreen.beginDraw();
  textScreen.background(255, 0);
  textScreen.rectMode(CORNERS);
  textScreen.textAlign(CENTER, CENTER);
  // textScreen.noFill();
  textScreen.endDraw();

  size(530, 280);
  background(255);
  rectMode(CORNERS);
  textAlign(CENTER, CENTER);
  noFill();
}

void draw() {

  textScreen.beginDraw();
  rectScreen.beginDraw();
  spiralScreen.beginDraw(); 

  // restart animation
  if (idx >= MAXN) {
    background(255);
    spiralScreen.background(255, 0);  
    textScreen.background(255, 0);  
    // textScreen.tint(255, 25);
    rectScreen.background(255, 0);  

    x.clear();
    y.clear();
    fib.clear();

    fib.add(1*factor);
    fib.add(1*factor);

    x.add(0);
    y.add(0);

    idx = 0;
    fA = HALF_PI;
    fB = 0;
  } else {

    textScreen.pushMatrix();
    rectScreen.pushMatrix();
    spiralScreen.pushMatrix();
    pushMatrix();

    textScreen.translate(90, 70);
    rectScreen.translate(90, 70);
    spiralScreen.translate(90, 70); 
    // translate(90, 70);

    textScreen.translate(width/2, height/2);
    rectScreen.translate(width/2, height/2);
    spiralScreen.translate(width/2, height/2);
    // translate(width/2, height/2);


    if (idx >= 2) fib.add(fib.get(idx - 1) + fib.get(idx - 2));
    if (idx >= 1) {
      x.add(x.get(idx - 1) +  signX(idx - 1)*fib.get(idx - 1));
      y.add(y.get(idx - 1) +  signY(idx - 1)*fib.get(idx - 1));
      if (controlText) {
        textScreen.fill(0);
        textScreen.textSize(map(fib.get(idx - 1), 1, lastFib*factor, 12, 64));
        textScreen.text(fib.get(idx - 1)/factor, x.get(idx - 1) + signX(idx - 1)*fib.get(idx - 1)/2, y.get(idx - 1) + signY(idx- 1)*fib.get(idx - 1)/2);
      }
      // noFill();
      if (controlRect) {
        rectScreen.rect(x.get(idx - 1), y.get(idx - 1), x.get(idx), y.get(idx));
      }
      if (controlSpiral) {
        if (idx%2 == 1) {
          spiralScreen.arc(x.get(idx - 1), y.get(idx - 1) + signY(idx)*fib.get(idx - 1), 2*fib.get(idx - 1), 2*fib.get(idx - 1), fB, fA);
        } else {
          spiralScreen.arc(x.get(idx - 1) + signX(idx)*fib.get(idx - 1), y.get(idx - 1), 2*fib.get(idx - 1), 2*fib.get(idx - 1), fB, fA);
        }
      }
      fA = fA - HALF_PI;
      fB = fB - HALF_PI;
    }
    println(x.get(idx)  + " " + y.get(idx));

    ++idx;

    popMatrix();

    textScreen.popMatrix();
    rectScreen.popMatrix();
    spiralScreen.popMatrix();
  }

  textScreen.endDraw();
  rectScreen.endDraw();
  spiralScreen.endDraw();

  image(rectScreen, 0, 0);
  image(textScreen, 0, 0);
  image(spiralScreen, 0, 0);

  saveFrame("data/rectangles-#####.png");
  noLoop();
}

void mouseReleased() {
  loop();
}

void keyPressed() {
  // turn on/off spiral 
  if (keyCode == 's' || keyCode == 'S') {
    controlSpiral = !controlSpiral;
  }

  if (keyCode == 't' || keyCode == 'T') {
    controlText = !controlText;
  }

  if (keyCode == 'r' || keyCode == 'R') {
    controlRect = !controlRect;
  }
}

int signX(int i) {
  int res = 1;
  if (i % 4 == 0)
    res = 1;
  if (i % 4 == 1)
    res = -1;
  if (i % 4 == 2)
    res = -1;
  if (i % 4 == 3)
    res = 1;
  return res;
}

int signY(int i) {
  int res = 1;
  if (i % 4 == 0)
    res = -1;
  if (i % 4 == 1)
    res = -1;
  if (i % 4 == 2)
    res = 1;
  if (i % 4 == 3)
    res = 1;
  return res;
}
