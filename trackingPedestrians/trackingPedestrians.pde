/*color histograms or bins 8×8×8 */


import processing.video.*; 
Capture video;

PImage pFrame, cFrame, inFrame;
PGraphics outFrame;

final int EPS = 50; 

void setup(){
  size(640, 480);
  video = new Capture(this, width, height, 30); /* ? */
  video.start();
  pFrame = createImage(video.width, video.height, RGB);
  cFrame = createImage(video.width, video.height, RGB);
  inFrame = createImage(video.width, video.height, RGB);
  outFrame = createGraphics(video.width, video.height);
  frameRate(24);
}

void draw(){
  if (video.available()) {
    inFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height); 
    //frame.updatePixels();
    video.read();
    pFrame.copy(inFrame, 0, 0, width, height, 0, 0, width, height); 
    // pFrame.filter(ERODE);
    pFrame.filter(GRAY);
    pFrame.filter(ERODE);
    // pFrame.filter(BLUR, 2);

    track();
    pushMatrix();
      scale(-1, 1);
      translate(-width, 0);
      image(outFrame, 0,0);
    popMatrix();
  }
  /* copy last image */
  cFrame.copy(pFrame, 0, 0, width, height, 0, 0, width, height);
}

void track(){
  pFrame.loadPixels();
  cFrame.loadPixels();
  outFrame.loadPixels();
  // outFrame.beginDraw();
  // outFrame.noStroke();
  for (int i = 0; i < height; ++i)
    for (int j = 0; j < width; ++j){
      //println(hex(outFrame.pixels[i*width + j]), hex(pFrame.pixels[i*width + j]));
      // if (abs(cFrame.pixels[i*width + j] - pFrame.pixels[i*width + j]) < 10)
      if (isSameG(i, j))
        outFrame.pixels[i*width + j] = cFrame.pixels[i*width + j];
      else 
        outFrame.pixels[i*width + j] = color(255, 0, 0);
  }
  // outFrame.endDraw();
  outFrame.updatePixels();
}

boolean isSameG(int i, int j){
  int c = cFrame.pixels[i*width + j];
  int p = pFrame.pixels[i*width + j];
  return abs(c & 0xff - p & 0xff) < EPS;
}

boolean isSame(int i, int j){
  int c = cFrame.pixels[i*width + j];
  int p = pFrame.pixels[i*width + j];
  /* maybe it is more useful to check each color separetly ?*/
  return (abs(c >> 16 & 0xff - p >> 16 & 0xff) < EPS &&
          abs(c >> 8 & 0xff - p >> 8 & 0xff) < EPS && 
          abs(c & 0xff - p & 0xff) < EPS);
  
  /* check if colors are close to each other */
  //return dist(c >> 16 & 0xff, p >> 16 & 0xff, c >> 8 & 0xff, p >> 8 & 0xff, c & 0xff, p & 0xff) < EPS;
  
}


