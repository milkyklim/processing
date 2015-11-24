class Node {
  private boolean moving;
  private PVector coord;
  private PVector v;
  private PVector a;
  private float mass;
  
  /* for colorful gif :) */
  private int nodeColor; 
  
  /* constructor */
  public Node() {
    this.moving = false;
    this.v = new PVector(0.0, 0.0);
    this.a = new PVector(0.0, 0.0);
    this.coord = new PVector(0.0, 0.0);
    this.mass = 1.0;
    this.nodeColor = 0;
  }

  public Node(boolean moving, PVector coord, PVector v,  PVector a, float mass, int nodeColor) {
    this.moving = moving;
    this.coord = new PVector(0.0, 0.0);
    this.coord.set(coord);
    this.v = new PVector(0.0, 0.0);
    this.v.set(v);
    this.a = new PVector(0.0, 0.0);
    this.a.set(a);
    this.mass = mass;
    this.nodeColor = nodeColor;
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
  
  public void setNodeColor(int nodeC){
    this.nodeColor = nodeC;
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
  
  public int getNodeColor(){
    return this.nodeColor;
  }
  
  public void update(){
    
  }
}
