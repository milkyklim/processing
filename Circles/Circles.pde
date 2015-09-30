/* response studying */
/* playing with circles */
int x = -1;
int y = -1;
int r = -1;
int Rmax;

void setup(){
  size(500, 280);
  background(255);
  Rmax = (int)sqrt((float) width*width + height*height);
}

void draw(){
  if((r != -1) && (r < Rmax)){
    ellipse(x, y, 2*r, 2*r);
    ++r;
  }
  else{
      r = -1;
      x = -1;
      y = -1;
  }
}

void mouseClicked(){
  if (mouseButton == LEFT ){
    x = mouseX;
    y = mouseY;
    r = 1; 
    fill(color(random(255),random(255),random(255)));
  }
  if (mouseButton == RIGHT ){
    r = -1;
    x = -1;
    y = -1;
    background(255);
  }
}
  
