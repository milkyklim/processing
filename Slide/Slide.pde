final float radius = 40.0; /* radius of the point */

PVector vec; 
final int n = 2; /* define this in setup */
boolean isNodeIn = false;
int nodeIn = -1;

//Accelerometer accel;

Node[] Nodes;

/* friction */
float mu = 1.0;

float eps = 1e-3;

void setup() {
  /* created nodes */
  Nodes = new Node[n]; // <-- attention n is used here!  
 // accel = new Accelerometer();
  size(640, 360, P2D);
  for (int i = 0; i < n; ++i) {
    Nodes[i] = new Node(); 
    Nodes[i].setCoord(random(10, width), random(10, height));
    Nodes[i].setV(random(0, 1), random(0, 1));
    Nodes[i].setMoving(true);
   }
  frameRate(300); /* for better interactivity */
}

void draw() {
  background(255);
  fill(12, 200, 244);
  for (int i = 0; i < n; ++i) {
    ellipse(Nodes[i].getCoordX(), Nodes[i].getCoordY(), radius, radius);
  }
//if (!mousePressed) /* check this one  it is wrong */
//  
//  fill(255, 0, 0);
//  ellipse(width/2, height/2, 60, 60);
  move();
  // sliding();
//  fill(0, 255, 0);
//  ellipse(0, 0, 60, 60);
}


void move(){
  /* temporary variables */
  PVector tmp;
  float x, y, vx, vy;
  float distX, distY;
  float timeHitX, timeHitY; 
  float timeHitX2, timeHitY2; 
  
  for (int i = 0; i < n; ++i)
    if (Nodes[i].getMoving()){
      /* speed */
      x = Nodes[i].getCoordX();
      y = Nodes[i].getCoordY();
      vx = mu*Nodes[i].getVx(); /* !friction */
      vy = mu*Nodes[i].getVy(); /* !friction */
      
      timeHitX = (width - (x + radius))/vx; /* checks only right boundary */
      timeHitY = (height - (y + radius))/vy; /* checks only bottom boundary */

      timeHitX2 = -(x + radius)/vx; /* checks only left boundary */
      timeHitY2 = -(y + radius)/vy; /* checks only top boundary */

      
      /* there is X wall collision! */
      if (timeHitX > 0 && timeHitX < 1){
        x += vx*timeHitX;
        //x = width - radius;
        vx *= -1;   
      }
      else {
        x += vx;
      }
      
      if (timeHitY >0 && timeHitY < 1){
        y += vy*timeHitY;
        vy *= -1; 
      }
      else {
        y += vy;
      }
//      
//      if (timeHitX2 > 0 && timeHitX2 < 1){
//        x += vx*timeHitX2;
//        vx *= -1;   
//      }
//      else {
//        x += vx;
//      }
//      
//      if (timeHitY2 >0 && timeHitY2 < 1){
//        y += vy*timeHitY2;
//        vy *= -1; 
//      }
//      else {
//        y += vy;
//      }
      
      
      /* Assignment part */
      Nodes[i].setCoordX(x);
      Nodes[i].setCoordY(y);
      Nodes[i].setVx(vx);
      Nodes[i].setVy(vy);         
      
//      tmp = Nodes[i].getV();
//      tmp.mult(mu);
//      Nodes[i].setV(tmp);
//      
//      Nodes[i].setCoord(Nodes[i].getCoordX() + Nodes[i].getVx(), Nodes[i].getCoordY() + Nodes[i].getVy());
//      if (pow(Nodes[i].getVx(), 2) + pow(Nodes[i].getVy(), 2) <= eps)
//        Nodes[i].setMoving(false);
//      /* check if we hit the boundaries of the sketch */
//      if ((Nodes[i].getCoordX() > width) || (Nodes[i].getCoordX() < 0)) {
//        Nodes[i].setVx(Nodes[i].getVx()*(-1));
//      }
//      if ((Nodes[i].getCoordY() > height) || (Nodes[i].getCoordY() < 0)) {
//        Nodes[i].setVy(Nodes[i].getVy()*(-1));
//      }    
  
      // collide(i);
      
    }
}

/* checks if the cursor is above node */
int inside() {
  int res = -1;
  for (int i= 0; i < n; ++i) {
    /* can be optimized */
    if (dist(Nodes[i].getCoordX(), Nodes[i].getCoordY(), mouseX, mouseY) < radius) {  
      res = i;
    }
  }
  return res;
}
 //<>//

void mousePressed() {
  /* check if the mouse is above the node */
  nodeIn = inside();
  isNodeIn = (nodeIn != -1) ? true : false;
}

void mouseDragged() {
  /* move current node */
  /* restrict coordinates to the screen size */
  /* is there a better way to do that? */
  if (isNodeIn) {
    Nodes[nodeIn].setCoord(mouseX, mouseY);
    if (Nodes[nodeIn].getCoordX() > width) {
        Nodes[nodeIn].setCoordX(width);
    }
    if ((Nodes[nodeIn].getCoordX() < 0)) {
        Nodes[nodeIn].setCoordX(0);
    }
    if (Nodes[nodeIn].getCoordY() > height) {
        Nodes[nodeIn].setCoordY(height);
    }
    if ((Nodes[nodeIn].getCoordY() < 0)) {
        Nodes[nodeIn].setCoordY(0);
    } 
  }
}

void mouseReleased(){
  if (isNodeIn) {
    if ((mouseX - pmouseX) > eps || (mouseY - pmouseY) > eps){ /* if the node was moving */
      Nodes[nodeIn].setMoving(true);
      Nodes[nodeIn].setV((mouseX - pmouseX), (mouseY - pmouseY));
    }
  }
}
//
//void sliding(){
//  PVector tmp;
//
//  for (int i = 0; i < n; ++i){
//      /* speed */
//  
//    fill(255, 0, 0);
//    ellipse(width/3, height/3, 60, 60);
//
//    int coordX, coordY, coordZ;
//    coordX = accel.getX();
//    coordY = accel.getY();
//    coordZ = accel.getZ();  
//  
//    float speedY = map(coordX, -10, 10, -2, 2);
//    float speedX = map(coordY, -10, 10, -2, 2);
//    // textSize(32);
//    // text(speedX + " " + speedY, 10, 30); 
//    
//    fill(0, 255, 0);
//    ellipse(width/3, height/3, 60, 60);
//    
//    if(Nodes[i].getCoordX() + speedX > width)
//      Nodes[i].setCoordX(width);
//    else
//      Nodes[i].setCoordX(Nodes[i].getCoordX() + speedX);
//      
//    if(Nodes[i].getCoordX() + speedX < 0)
//      Nodes[i].setCoordX(0);
//    else
//      Nodes[i].setCoordX(Nodes[i].getCoordX() + speedX);
//      
//    if(Nodes[i].getCoordY() + speedY > height)
//      Nodes[i].setCoordY(height);
//    else
//      Nodes[i].setCoordY(Nodes[i].getCoordY() + speedY);
//      
//    if(Nodes[i].getCoordY() + speedY < 0)
//      Nodes[i].setCoordY(0); 
//    else
//      Nodes[i].setCoordY(Nodes[i].getCoordY() + speedY);   
//    
//    //Nodes[i].setCoord(Nodes[i].getCoordX() + speedX, Nodes[i].getCoordY() + speedY);     
//  }
//}

void collide(int i){
    for(int j = 0; j <n; ++j){
      if (i != j){
        /* there is a way to improve this */
        if (dist(Nodes[i].getCoordX(), Nodes[i].getCoordY(), Nodes[j].getCoordX(), Nodes[j].getCoordY()) <= 2*radius){
          /* what do we do if there is a collision? */  
          float newVel1 = (Nodes[i].getVx()*(Nodes[i].getMass() - Nodes[j].getMass()) + 2*Nodes[j].getMass()*Nodes[j].getVx()) / (Nodes[i].getMass() + Nodes[j].getMass());
          float newVel2 = (Nodes[j].getVx()*(Nodes[j].getMass() - Nodes[i].getMass()) + 2*Nodes[i].getMass()*Nodes[i].getVx()) / (Nodes[i].getMass() + Nodes[j].getMass());          
          Nodes[i].setVx(newVel1);
          Nodes[j].setVx(newVel2);
          newVel1 = (Nodes[i].getVy()*(Nodes[i].getMass() - Nodes[j].getMass()) + 2*Nodes[j].getMass()*Nodes[j].getVy()) / (Nodes[i].getMass() + Nodes[j].getMass());
          newVel2 = (Nodes[j].getVy()*(Nodes[j].getMass() - Nodes[i].getMass()) + 2*Nodes[i].getMass()*Nodes[i].getVy()) / (Nodes[i].getMass() + Nodes[j].getMass()); 
          Nodes[i].setVy(newVel1);
          Nodes[j].setVy(newVel2);        
        }
      }
    }
}

/* currently this is a n^2 algo
   is there any way to speed this up? */
boolean collide2(){
  for(int i = 0; i < n; ++i){
    for(int j = 0; j <n; ++j){
      if (i != j){
        /* there is a way to improve this */
        if (dist(Nodes[i].getCoordX(), Nodes[i].getCoordY(), Nodes[j].getCoordX(), Nodes[j].getCoordY()) <= 2*radius){
          /* what do we do if there is a collision? */  
          float newVel1 = (Nodes[i].getVx()*(Nodes[i].getMass() - Nodes[j].getMass()) + 2*Nodes[j].getMass()*Nodes[j].getVx()) / (Nodes[i].getMass() + Nodes[j].getMass());
          float newVel2 = (Nodes[j].getVx()*(Nodes[j].getMass() - Nodes[i].getMass()) + 2*Nodes[i].getMass()*Nodes[i].getVx()) / (Nodes[i].getMass() + Nodes[j].getMass());          
          Nodes[i].setVx(newVel1);
          Nodes[j].setVx(newVel2);
        }
      }
    }
  }
  return false;
}
