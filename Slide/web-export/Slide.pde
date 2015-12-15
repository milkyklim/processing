final float radius = 20.0; /* radius of the point */
/* define boundaries */
final int top = 0;
final int right = 1;
final int bottom = 2;
final int left = 3;

float g = 9.81; /* gravity */

PVector vec; 
final int n = 3; /* define this in setup */
boolean isNodeIn = false;
int nodeIn = -1;

Accelerometer accel;
Node[] Nodes;

float mu = 0.9; /* friction coefficent */

float eps = 1e-3;

void setup() {
  /* created nodes */
  accel = new Accelerometer();
  size(540, 540, P2D);

  initNodes(n);
  frameRate(300); /* for better interactivity */
}

void initNodes(int nNodes) {
  Nodes = new Node[nNodes];
  for (int i = 0; i < nNodes; ++i) {

    Nodes[i] = new Node();
    Nodes[i].setMoving(true);
    Nodes[i].setV(random(0, 1), 0.0);
    //Nodes[i].setV(0.0, 0.0); /* everything initialized to static mode */
    Nodes[i].setCoord(random(radius, width - radius), random(radius, height - radius));

    for (int j = 0; j < i; ++j) {
      // @TODO: check whether two circles intersect
    }
  }
}

void debug() {
  for (int i = 0; i < n; ++i) {
    for (int j = i + 1; j < n; ++j) {
      if (dist(Nodes[i].getCoordX(), Nodes[i].getCoordY(), Nodes[j].getCoordX(), Nodes[j].getCoordY()) < 2*radius) {
        println("Happened!");
      }
    }
  }
}


void draw() {
  background(255);
  fill(12, 200, 244);
  for (int i = 0; i < n; ++i) {
    ellipse(Nodes[i].getCoordX(), Nodes[i].getCoordY(), 2*radius, 2*radius);
  }
  //if (mousePressed) {
  // move();
  sliding();
  // debug();
  //}
}


/* @TODO: ADD ZERO CHECK FOR VX AND VY 
   DIVISION BY ZERO */
void move() {
  /* temporary variables */
  PVector tmp;
  float x, y, vx, vy;
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

      if (timeHit[right] >= 0 && timeHit[right] < 1) {
        x = width - radius - 1;  /* @IMP: This "-1" prevents nasty bug */
        vx *= -1;
      } else {
        if (timeHit[left] >= 0 && timeHit[left] < 1) {
          x = radius + 1;  /* @IMP: This "+1" prevents nasty bug */
          vx *= -1;
        } else {
          x += vx;
        }
      }

      if (timeHit[bottom] >= 0 && timeHit[bottom] < 1) {
        y = height - radius - 1; /* @IMP: This "-1" prevents nasty bug */
        vy *= -1;
      } else {
        if (timeHit[top] >=0 && timeHit[top] < 1) { 
          y = radius + 1;  /* @IMP: This "+1" prevents nasty bug */
          vy *= -1;
        } else {
          y += vy;
        }
      }

      /* Assignment part */
      Nodes[i].setCoordX(x);
      Nodes[i].setCoordY(y);
      Nodes[i].setVx(vx);
      Nodes[i].setVy(vy);
      /* @TODO: may be this is not the best place for this check?*/
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


//void mousePressed() {
//  /* check if the mouse is above the node */
//  nodeIn = inside();
//  isNodeIn = (nodeIn != -1) ? true : false;
//}

//void mouseDragged() {
//  /* move current node */
//  /* restrict coordinates to the screen size */
//  /* is there a better way to do that? */
//  if (isNodeIn) {
//    Nodes[nodeIn].setCoord(mouseX, mouseY);
//    if (Nodes[nodeIn].getCoordX() > width) {
//      Nodes[nodeIn].setCoordX(width);
//    }
//    if ((Nodes[nodeIn].getCoordX() < 0)) {
//      Nodes[nodeIn].setCoordX(0);
//    }
//    if (Nodes[nodeIn].getCoordY() > height) {
//      Nodes[nodeIn].setCoordY(height);
//    }
//    if ((Nodes[nodeIn].getCoordY() < 0)) {
//      Nodes[nodeIn].setCoordY(0);
//    }
//  }
//}



//void mouseReleased() {
//  if (isNodeIn) {
//    if ((mouseX - pmouseX) > eps || (mouseY - pmouseY) > eps) { /* if the node was moving */
//      Nodes[nodeIn].setMoving(true);
//      Nodes[nodeIn].setV((mouseX - pmouseX), (mouseY - pmouseY));
//    }
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
      if ((x[0] - x[1])*(x[0] - x[1]) + (y[0] - y[1])*(y[0] - y[1])<= 4*radius*radius) { 
        /* do not collide is circles intersect */
        if ((x[0] - x[1])*(vX[1] - vX[0]) + (y[0] - y[1])*(vY[1] - vY[0]) > 0) {
          Nodes[i].setVx( (vX[0]*(m[0] - m[1]) + 2*m[1]*vX[1]) / (m[0] + m[1]) );
          Nodes[j].setVx( (vX[1]*(m[1] - m[0]) + 2*m[0]*vX[0]) / (m[0] + m[1]) );
          Nodes[i].setVy( (vY[0]*(m[0] - m[1]) + 2*m[1]*vY[1]) / (m[0] + m[1]) );
          Nodes[j].setVy( (vY[1]*(m[1] - m[0]) + 2*m[0]*vY[0]) / (m[0] + m[1]) );
        }
      }
    }
  }
}

void sliding() {
  /* temporary variables */
  PVector tmp;
  float x, y, vx, vy;
  float[] timeHit = new float[4]; 
  /* get coordinate */

  /* @TODO: there is some thing called low_filtering check web for that */
  float accX, accY, accZ;
  float angleX, angleY, angleZ;
  /* @TODO: looks like we need to switch x and y axes*/
  angleX = accel.getY();
  angleY = accel.getX();
  angleZ = accel.getZ();
  
  /* @IMP: Check the formula you got 
    a_x = g (- mu cos(alpha) + sin(alpha)) */
  
  /* @IMP: in a static posiiton there should be no movement at all */  
  accX = abs(angleX) > eps ? g*(sin(angleX) - mu*(cos(angleX))) : 0; 
  accY = abs(angleY) > eps ? g*(sin(angleY) - mu*(cos(angleY))) : 0; 
    
  // accX = abs(accX) > eps ? g*sin(radians(accX)) : 0;  /* -90 to 90 => radians */
  // accY = abs(accY) > eps ? g*sin(radians(accY)) : 0; /* -90 to 90 => radians */
  /*@TODO: need to adjust accelerations \ find the right value */
  accX /= 10;
  accY /= 10;

  fill(0, 0, 0);
  textSize(32);
  text("X axis: " + accX, width/2, height/2 - 50);  
  text("Y axis: " + accY, width/2, height/2);

  fill(255, 0, 0);
  ellipse(width/3, height/3, 60, 60);

  for (int i = 0; i < n; ++i) {
    //    //    if (Nodes[i].getMoving()) {
    //    /* speed */
    x = Nodes[i].getCoordX();
    y = Nodes[i].getCoordY();
    /* @TODO: check time-frame conversion */
    /* @TODO: here we need 9th grade and proper vector algebra */
    vx = Nodes[i].getVx() + accX*1.0/frameRate; /* !friction  */
    vy = Nodes[i].getVy() + accY*1.0/frameRate; /* !friction */


    /* @TODO: division by zero fix */
    if (abs(vx) < 0.001) vx = eps;
    if (abs(vy) < 0.001) vy = eps;

    /*@TODO: here should be the formula for the movement 
     with acceleration
     v_x = v_0x + a_x *t 
     v_y = v_0y + a_y *t 
     a should be calculated from angle */
    /* @TODO: ma = N + mg */

    timeHit[top] = -(y - radius)/vy;
    timeHit[right] = (width - (x + radius))/vx;
    timeHit[bottom] = (height - (y + radius))/vy; 
    timeHit[left] = -(x - radius)/vx; 

    if (timeHit[right] >= 0 && timeHit[right] < 1) {
      x = width - radius - 1;  /* @IMP: This "-1" prevents nasty bug */
      vx *= -1;
    } else {
      if (timeHit[left] >= 0 && timeHit[left] < 1) {
        x = radius + 1;  /* @IMP: This "+1" prevents nasty bug */
        vx *= -1;
      } else {
        x += vx;
      }
    }

    if (timeHit[bottom] >= 0 && timeHit[bottom] < 1) {
      y = height - radius - 1; /* @IMP: This "-1" prevents nasty bug */
      vy *= -1;
    } else {
      if (timeHit[top] >=0 && timeHit[top] < 1) { 
        y = radius + 1;  /* @IMP: This "+1" prevents nasty bug */
        vy *= -1;
      } else {
        y += vy;
      }
    }

    /* Assignment part */
    Nodes[i].setCoordX(x);
    Nodes[i].setCoordY(y);
    Nodes[i].setVx(vx);
    Nodes[i].setVy(vy);

    Nodes[i].setAx(accX);
    Nodes[i].setAy(accY);    

    /* @TODO: should we store acceleration */

    //    /* @TODO: may be this is not the best place for this check?*/
    collide(i);
    //    //    }
  }

  fill(0, 255, 0);
  ellipse(width/3, height/3, 60, 60);
}

/* filter out high-frequency noise */
float[] filterLowPass(float[] val, float[] pVal) {
  float alpha = 0.8;
  float[] res = new float[3];

  for (int i = 0; i < 3; ++i)
    res[i] = val[i]*alpha + (1.0 - alpha)*pVal[i];

  return res;
} 


class Node {
  private boolean moving;
  private PVector coord;
  private PVector v;
  private PVector a;
  private float mass;
  
  /* constructor */
  public Node() {
    this.moving = false;
    this.v = new PVector(0.0, 0.0);
    this.a = new PVector(0.0, 0.0);
    this.coord = new PVector(0.0, 0.0);
    this.mass = 1.0;
  }

  public Node(boolean moving, PVector coord, PVector v,  PVector a, float mass) {
    this.moving = moving;
    this.coord = new PVector(0.0, 0.0);
    this.coord.set(coord);
    this.v = new PVector(0.0, 0.0);
    this.v.set(v);
    this.a = new PVector(0.0, 0.0);
    this.a.set(a);
    this.mass = mass;
  }

  public void setMoving(boolean moving) {
    this.moving = moving;
  }

  public void setA(float ax, float ay) {
    this.a.set(ax, ay);
  }

  public void setV(float vx, float vy) {
    this.v.set(vx, vy);
  }

  public void setCoord(float x, float y) {
    this.coord.set(x, y);
  }

  /* proper setters */
  public void setA(PVector a) {
    this.a = a;
  }
  
  public void setAx(float ax) {
    this.a.x = ax;
  }
  
  public void setAy(float ay) {
    this.a.y = ay;
  }
  
  
  public void setV(PVector v) {
    this.v = v;
  }
  
  public void setVx(float vx) {
    this.v.x = vx;
  }
  
  public void setVy(float vy) {
    this.v.y = vy;
  }

  public void setCoord(PVector coord) {
    this.coord = coord;
  }
  
  public void setCoordX(float coordX) {
    this.coord.x = coordX;
  }
  
  public void setCoordY(float coordY) {
    this.coord.y = coordY;
  }  
  
  public void setMass(float mass){
    this.mass = mass;
  }
  
  /* --------------- */
  public boolean getMoving() {
    return this.moving;
  }
  
  public PVector getA() {
    return this.a;
  }

  public float getAx() {
    return this.a.x;
  }

  public float getAy() {
    return this.a.y;
  }
  
  public PVector getV() {
    return this.v;
  }

  public float getVx() {
    return this.v.x;
  }

  public float getVy() {
    return this.v.y;
  }

  public PVector getCoord() {
    return this.coord;
  }
  
  public float getCoordX() {
    return this.coord.x;
  }
  
  public float getCoordY() {
    return this.coord.y;
  }
  
  public float getMass(){
    return this.mass;
  }
  
  public void update(){
    
  }
}

