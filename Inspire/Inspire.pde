/* inspire -- idea stolen from booklet */
// import gifAnimation.*;
// GifMaker gifExport;
/* for speed up */
int offsetX = 60;
int offsetY = 120;
color[] colors;

int localPos = 0;
String msg = "Hello!\n You are on\n milkyklim.com"; /* welcome message */
boolean go = false;

void setup() {
  colors = new color[6];
  colorMode(RGB);
  colors[0] = color(0, 0, 0); 
  colors[1] = color(0, 0, 255);
  colors[2] = color(255, 0, 255);
  colors[3] = color(255, 255, 0);
  colors[4] = color(0, 255, 0);
  colors[5] = color(255, 128, 0); 
  size(540, 540);
  drawText();
  // gifExport = new GifMaker(this, "Inspire.gif");
  // gifExport.setRepeat(0); // make an "endless" animation
  // save("init.png");
}

void draw() {
  if (keyPressed) go = true;
  if (go){ 
    drawText();
    // gifExport.setDelay(1);
    // gifExport.addFrame();
  }
}

void mouseClicked(){
  // if (go) gifExport.finish();                
  go = !go;
}

void drawText(){
  int n = colors.length;
  PGraphics inspire = createGraphics(width - 2*offsetX, height - 2*offsetY, JAVA2D);
  /* create Text */
  inspire.beginDraw();
  inspire.stroke(0);
  inspire.textAlign(CENTER, CENTER);
  inspire.textSize(48);
  inspire.text(msg, inspire.width/2, inspire.height/2);
  inspire.endDraw();
  /* draw background -- lines */
  for (int i = 0; i < n; ++i) { 
    for (int j = i + 1; j < width; j +=n) {
      stroke(colors[i]);
      line(j, 0, j, height);
    }
  }
  /* define colors for each pixel of the text */
  inspire.loadPixels();
  loadPixels();
  for (int i = 0; i < inspire.width; ++i){
    for (int j = 0; j < inspire.height; ++j){
      if (alpha(inspire.pixels[i*inspire.height + j]) != 0){ /* work only with letters */
        inspire.pixels[i*inspire.height + j] = pixels[(i + offsetX)*height + (j + offsetY + 1)%height];
      }
    }
  }

 /* start animation */
  if(go){
    for (int i = 0; i < inspire.width; ++i){
      for (int j = 0; j < inspire.height; ++j){
        if ((j + offsetY)%n != localPos){ 
          inspire.pixels[i*inspire.height + j] = color(0);
        }
        else{
          /* keep it as it is */
        }
      }
    }
    ++localPos;
    localPos %= n;
  }
  inspire.updatePixels();
  /* display text */
  imageMode(CENTER);
  image(inspire, width/2, height/2);
}

/* to change the text */
void keyPressed(){
  if (key == '1') {
    msg ="Here ...";
  }
  if (key == '2') {
    msg ="... we ...";
  }
  if (key == '3') {
    msg ="...\nGO!";
  }
  if (key == 'G' || key == 'g'){
    msg = "TIME TO SAVE\nGOTHAM!";
  } 
}



