final float radius = 20.0; /* radius of the point */
/* define boundaries */
final int top = 0;
final int right = 1;
final int bottom = 2;
final int left = 3;

PVector vec; 
final int n = 10; /* define this in setup */
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
    /*@TODO: Check that current circle does not intersect other circles */
    Nodes[i].setCoord(random(radius, width - radius), random(radius, height - radius));
    Nodes[i].setV(random(0, 1), random(0, 1));
    Nodes[i].setMoving(true);
  }
  frameRate(300); /* for better interactivity */
}

void draw() {
  background(255);
  fill(12, 200, 244);
  for (int i = 0; i < n; ++i) {
    ellipse(Nodes[i].getCoordX(), Nodes[i].getCoordY(), 2*radius, 2*radius);
  }
  //if (mousePressed) {
  move();
  //}
}

void move() {
  /* temporary variables */
  PVector tmp;
  float x, y, vx, vy;
  float distX, distY;
  float timeHitX, timeHitY; 
  float timeHitX2, timeHitY2; 
  float[] timeHit = new float[4]; 

  for (int i = 0; i < n; ++i)
    if (Nodes[i].getMoving()) {
      /* speed */
      x = Nodes[i].getCoordX();
      y = Nodes[i].getCoordY();
      vx = mu*Nodes[i].getVx(); /* !friction */
      vy = mu*Nodes[i].getVy(); /* !friction */

      timeHit[top] = -(y - radius)/vy;
      timeHit[right] = (width - (x + radius))/vx;
      timeHit[bottom] = (height - (y + radius))/vy; 
      timeHit[left] = -(x - radius)/vx; 

      //if (timeHitX >= 0 && timeHitX < 1) { /* collision with right wall */
      if (timeHit[right] >= 0 && timeHit[right] < 1) {
        // x += vx*timeHitX;
        x = width - radius - 1;
        vx *= -1;
        // println(frameCount + " right");
      } else {
        /* there is X wall collision! */
        if (timeHit[left] >= 0 && timeHit[left] < 1) { /* collision with left wall */
          // x += vx*timeHitX2;
          x = radius + 1;
          vx *= -1;
          // println(frameCount + " left");
        } else {
          x += vx;
        }
      }

      if (timeHit[bottom] >= 0 && timeHit[bottom] < 1) { /* collision with top wall */
        y = height - radius - 1;
        //y += vy*timeHitY;
        vy *= -1;
        // println(frameCount + " bottom");
      } else {
        if (timeHit[top] >=0 && timeHit[top] < 1) { /* collision with bottom wall */
          y = radius + 1;
          // y += vy*timeHitY2;
          vy *= -1;
          // println(frameCount + " top");
        } else {
          // println(frameCount + " " + timeHitY2 + " " + vy + " " + y);
          y += vy;
        }
      }

      /* Assignment part */
      Nodes[i].setCoordX(x);
      Nodes[i].setCoordY(y);
      Nodes[i].setVx(vx);
      Nodes[i].setVy(vy);
      collide(i);
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



void mouseReleased() {
  if (isNodeIn) {
    if ((mouseX - pmouseX) > eps || (mouseY - pmouseY) > eps) { /* if the node was moving */
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

void collide(int i) {
  float[] vX = new float [2];
  float[] vY = new float [2];
  float[] x = new float[2];
  float[] y = new float[2];
  float[] m = new float[2];

  for (int j = 0; j <n; ++j) {
    vX[0] = Nodes[i].getVx();
    vY[0] = Nodes[i].getVy();
    x[0] = Nodes[i].getCoordX();
    y[0] = Nodes[i].getCoordY();
    m[0] = Nodes[i].getMass();
    
    if (i != j) {
      vX[1] = Nodes[j].getVx();
      vY[1] = Nodes[j].getVy();
      x[1] = Nodes[j].getCoordX();
      y[1] = Nodes[j].getCoordY();
      m[1] = Nodes[j].getMass();

      /* there is a way to improve this */
      if (dist(x[0], y[0], x[1], y[1]) <= 2*radius) {       
        Nodes[i].setVx( (vX[0]*(m[0] - m[1]) + 2*m[1]*vX[1]) / (m[0] + m[1]) );
        Nodes[j].setVx( (vX[1]*(m[1] - m[0]) + 2*m[0]*vX[0]) / (m[0] + m[1]) );
        Nodes[i].setVy( (vY[0]*(m[0] - m[1]) + 2*m[1]*vY[1]) / (m[0] + m[1]) );
        Nodes[j].setVy( (vY[1]*(m[1] - m[0]) + 2*m[0]*vY[0]) / (m[0] + m[1]) );
      }
    }
  }

  // @TODO: Remove
  // for (int j = 0; j <n; ++j) {
  //   if (i != j) {
  //     /* there is a way to improve this */
  //     if (dist(Nodes[i].getCoordX(), Nodes[i].getCoordY(), Nodes[j].getCoordX(), Nodes[j].getCoordY()) <= 2*radius) {
  //       float newVel1 = (Nodes[i].getVx()*(Nodes[i].getMass() - Nodes[j].getMass()) + 2*Nodes[j].getMass()*Nodes[j].getVx()) / (Nodes[i].getMass() + Nodes[j].getMass());
  //       float newVel2 = (Nodes[j].getVx()*(Nodes[j].getMass() - Nodes[i].getMass()) + 2*Nodes[i].getMass()*Nodes[i].getVx()) / (Nodes[i].getMass() + Nodes[j].getMass());          
  //       Nodes[i].setVx(newVel1);
  //       Nodes[j].setVx(newVel2);
  //       newVel1 = (Nodes[i].getVy()*(Nodes[i].getMass() - Nodes[j].getMass()) + 2*Nodes[j].getMass()*Nodes[j].getVy()) / (Nodes[i].getMass() + Nodes[j].getMass());
  //       newVel2 = (Nodes[j].getVy()*(Nodes[j].getMass() - Nodes[i].getMass()) + 2*Nodes[i].getMass()*Nodes[i].getVy()) / (Nodes[i].getMass() + Nodes[j].getMass()); 
  //       Nodes[i].setVy(newVel1);
  //       Nodes[j].setVy(newVel2);
  //     }
  //   }
  // }
}

/* currently this is a n^2 algo
 is there any way to speed this up? */
boolean collide2() {
  for (int i = 0; i < n; ++i) {
    for (int j = 0; j <n; ++j) {
      if (i != j) {
        /* there is a way to improve this */
        if (dist(Nodes[i].getCoordX(), Nodes[i].getCoordY(), Nodes[j].getCoordX(), Nodes[j].getCoordY()) <= 2*radius) {
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
