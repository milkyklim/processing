/* 
  change color of the text in/out ellipse
*/

final float EPS = 0.0001;
final int TEXTSIZE = 32;
int step = 5;

float r, xEllipse = 50, yEllipse = 50;
String msg = "milkyklim\nread it backwards";

/* speed up the program a bit 
   and drop transparent pixels */
int xOffset = 100;
int yOffset = 100;
boolean switchColor = true;

color[] colors = {color(255, 0  , 128),
                   color(128, 255, 128),
                   color(255, 255, 0),
                   color(0  , 255, 128)};

void setup() {
  size(500, 300);
  background(255);
  drawText();
  r = dist(xEllipse, yEllipse, width, height) + 5;
  frameRate(200);
  smooth();
}

void draw() {
  if (frameCount != 1)
    // background(switchColor ? 0 : 255);
    background(switchColor ? colors[0] : colors[2]);
  /* Covered text */
  noStroke();
  fill(switchColor ? colors[3] : colors[1]); 
  ellipseMode(RADIUS);
  ellipse(xEllipse, yEllipse, r, r);
  drawText();
  if (r >= 0) 
    r -= step;
  else {
    switchColor = !switchColor;  //<>//
    println(switchColor ? colors[3] : colors[1]);
    r = dist(xEllipse, yEllipse, width, height) + 5; 
    
    // here should be color randomness
  }
}

void drawText() {
  PGraphics white = createGraphics(width - 2*xOffset, height - 2*yOffset);
  PGraphics black = createGraphics(width - 2*xOffset, height - 2*yOffset); 
  /* create Text */
  white.beginDraw();
  white.noStroke();
  white.background(0, 0);
  white.fill(switchColor ? colors[1] : colors[3]);
  white.textAlign(CENTER, CENTER);
  white.textSize(TEXTSIZE);
  white.text(msg, white.width/2, white.height/2);
  white.endDraw();

  black.beginDraw();
  black.noStroke();
  black.background(0, 0);
  black.fill(switchColor ? colors[3] : colors[1]);
  black.textAlign(CENTER, CENTER);
  black.textSize(TEXTSIZE);
  black.text(msg, black.width/2, black.height/2);
  black.endDraw();

  black.loadPixels();

  for (int i = 0; i < black.width; ++i) {
    for (int j = 0; j < black.height; ++j) {     
      if (alpha(black.pixels[i + black.width*j]) != 0) { /* work only with letters */
        if (isInside(i + xOffset, j + yOffset)) { /* inside circle */
            /* do nothing */
        } else {
            /* invert color */
          black.pixels[i + black.width*j] = colors[1];
        }
      }
    }
  }

  black.updatePixels();
  imageMode(CENTER);
  image(white, width/2, height/2);
  image(black, width/2, height/2);
}

boolean isInside(int i, int j) {
  boolean res = true;
  if ((dist(xEllipse, yEllipse, i, j) - r) > EPS) {
    res = false;
  }
  return res;
}

void mousePressed() {
  if (mouseButton == RIGHT)
    noLoop();
  else
    loop();
}