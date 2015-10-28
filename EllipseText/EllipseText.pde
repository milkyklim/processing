// import gifAnimation.*;
// GifMaker gifExport;

float k = 1.0;
float b = 0.0;
int step = 1;

float r, xEllipse = 50, yEllipse = 50;
String msg = "milkyklim\nread it backwards";

float EPS = 0.0001;
int TEXTSIZE = 32;

int both = 1;

boolean switchColor = true;

void setup() {
  size(500, 300);

  background(255);
  drawText();
  r = dist(xEllipse, yEllipse, width, height) + 5;
  frameRate(200);
  // gifExport = new GifMaker(this, "export.gif");
  // gifExport.setRepeat(0);             // make it an "endless" animation
  // gifExport.setTransparent(0,0,0);    // black is transparent
}

void draw() {
  if (frameCount != 1)
    background(switchColor ? 0 : 255);
  /* Covered text */
  noStroke();
  fill(switchColor ? 255 : 0); 
  ellipseMode(RADIUS);
  ellipse(xEllipse, yEllipse, r, r);
  drawText();

  if (r >= 0) r -= step;
  else {
    switchColor = !switchColor; 
    r = dist(xEllipse, yEllipse, width, height) + 5; 
//    if (both == 2){ // perform two loops and stop
//      // gifExport.finish();  
//      noLoop();  
//    }
//    both++;
  }

  // gifExport.setDelay(0);
  // gifExport.addFrame();
}

void drawText() {
  PGraphics white = createGraphics(width, height); // take out of here
  PGraphics black = createGraphics(width, height); // take out of here
  /* create Text */
  white.beginDraw();
  white.noStroke();
  white.fill(switchColor ? 255 : 0);
  white.textAlign(CENTER, CENTER);
  white.textSize(TEXTSIZE);
  white.text(msg, white.width/2, white.height/2);
  white.endDraw();

  black.beginDraw();
  black.noStroke();
  black.fill(switchColor ? 0 : 255);
  black.textAlign(CENTER, CENTER);
  black.textSize(TEXTSIZE);
  black.text(msg, black.width/2, black.height/2);
  black.endDraw();

  // white.loadPixels();
  black.loadPixels();

  for (int i = 0; i < black.width; ++i) {
    for (int j = 0; j < black.height; ++j) {     
      if (alpha(black.pixels[i + black.width*j]) != 0) { /* work only with letters */
        if (isInside(i, j)) { /* inside circle */
            /* do nothing */
        } else {
            /* invert color */
          black.pixels[i + black.width*j] = color(black.pixels[i + black.width*j], 0);
        }
      }
    }
  }


  black.updatePixels();
  imageMode(CENTER);
  image(white, width/2, height/2);
  image(black, width/2, height/2);

  // if (width == inspire.width) println("WIDTH FINE!");
  // if (height == inspire.height) println("HEIGHT FINE!");
}

boolean isInside(int i, int j) {
  boolean res = true;
  if ( (dist(xEllipse, yEllipse, i, j) - r) > EPS) {
    res = false;
  }
  return res;
}

void mousePressed() {
  // r = (int) dist(xEllipse, yEllipse, width, height) + 5;
  if (mouseButton == RIGHT)
    noLoop();
  else
    loop();
}

