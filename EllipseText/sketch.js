/* 
  change color of the text in/out ellipse
*/

var EPS = 0.0001;
var TEXTSIZE = 32;
var step = 1;

var r, xEllipse = 50, yEllipse = 50;
var msg = "milkyklim\nread it backwards";

/* speed up the program a bit 
   and drop transparent pixels */
var xOffset = 100;
var yOffset = 100;
var switchColor = true;

function setup() {
  createCanvas(500, 300);
  background(255);
  drawText();
  r = dist(xEllipse, yEllipse, width, height) + 5;
  frameRate(200);
}

function draw() {
  if (frameCount != 1)
    background(switchColor ? 0 : 255);
  /* Covered text */
  noStroke();
  fill(switchColor ? 255 : 0); 
  ellipseMode(RADIUS);
  ellipse(xEllipse, yEllipse, r, r);
  drawText();
  if (r >= 0) 
    r -= step;
  else {
    switchColor = !switchColor; 
    r = dist(xEllipse, yEllipse, width, height) + 5; 
  }
}

function drawText() {
  var white = createGraphics(width - 2*xOffset, height - 2*yOffset);
  var black = createGraphics(width - 2*xOffset, height - 2*yOffset); 
  /* create Text */
  // white.beginDraw();
  white.noStroke();
  white.background(0, 0);
  white.fill(switchColor ? 255 : 0);
  white.textAlign(CENTER, CENTER);
  white.textSize(TEXTSIZE);
  white.text(msg, white.width/2, white.height/2);
  // white.endDraw();

  //black.beginDraw();
  black.noStroke();
  black.background(0, 0);
  black.fill(switchColor ? 0 : 255);
  black.textAlign(CENTER, CENTER);
  black.textSize(TEXTSIZE);
  black.text(msg, black.width/2, black.height/2);
  //black.endDraw();

  black.loadPixels();

  for (var i = 0; i < black.width; ++i) {
    for (var j = 0; j < black.height; ++j) {  

   	  console.log(black.width);
      // console.log(black.pixels[4*(i + black.width*j)]);

      if (alpha(black.pixels[i + black.width*j]) != 0) { /* work only with letters */
        if (isInside(i + xOffset, j + yOffset)) { /* inside circle */
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
}

function isInside(i, j) {
  var res = true;
  if ((dist(xEllipse, yEllipse, i, j) - r) > EPS) {
    res = false;
  }
  return res;
}

function mousePressed() {
  if (mouseButton == RIGHT)
    noLoop();
  else
    loop();
}
