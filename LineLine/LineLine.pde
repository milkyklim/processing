/* inspire -- idea stolen from booklet */
//import gifAnimation.*;
//GifMaker gifExport;
/* for speed up */
int offsetX = 60;
int offsetY = 120;
color[] colors;

int localPos = 0;
String msg = "Merry\n Christmas!"; /* welcome message */
boolean go = false;

void setup() {
  colors = new color[4];
  colorMode(RGB);
  colors[0] = #2D4059; 
  colors[1] = #F07B3F;
  colors[2] = #EA5455;
  colors[3] = #FFD460;
  size(540, 540);
  drawText();
//  gifExport = new GifMaker(this, "LineLine.gif");
//  gifExport.setRepeat(0); // make an "endless" animation
  save("init.png");
}

int idx = 0;
void draw() {
  if (keyPressed) go = true;
  if (go){ 
    drawText();
//    if (idx < 4){
//      gifExport.setDelay(100);
//      gifExport.addFrame();
//      idx++;
//    }
//    if (idx == 4){
//      gifExport.finish();  
//    }
  }
}

void mouseClicked(){              
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
