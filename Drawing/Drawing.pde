/* drawGrid: draw the equispaced grid 
   offset -- the grid offset */
void drawGrid(int offset){
  pushStyle();
  strokeWeight(1);
  stroke(128, 128);
  for (int i = 0; i <= width; i += offset){
    line(i, 0, i, height);
  }
  for (int i = 0; i <= height; i += offset){
    line(0, i, width, i);
  }
  popStyle();
}

/* mouseTrack: print out mouse coordinates
  if mouse was moved */
void mouseTrack(){
  if (pmouseX != mouseX && pmouseY != mouseY)
    println(mouseX, mouseY);
}

void setup(){
  size(500, 400);
  background(255);
  cursor(CROSS);
}

void draw(){
  background(255); 
  drawGrid(5);
  mouseTrack();
}
