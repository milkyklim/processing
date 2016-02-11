/*
  @DONE: rewrite as a proper class 
  setters + getters
*/ 

class Branch {
  private PVector start; // start point
  private PVector end; // end point
  private float noisy; // necessary for wind  
  private int generation; // generation\level of the branch

  Branch(PVector s, PVector e, float noisyIn, int generation) {
    this.start = s;
    this.end = e;
    this.noisy = noisyIn;
    this.generation = generation;
  }
  
  void setStart(PVector s){
    this.start = s; 
  }
  
  void setEnd(PVector e){
    this.end = e; 
  }

  void setNoisy(float noisyIn){
    this.noisy = noisyIn; 
  }
  
  void setGeneration(int g){
    this.generation = g;
  }
  
  PVector getStart(){
    return this.start; 
  }
  
  PVector getEnd(){
    return this.end; 
  }
  
  float getNoisy(){
    return this.noisy;
  }
  
  int getGeneration(){
    return this.generation;
  }


  // calulates the end point of the next branch\leaf
  PVector pointNext(float angle) {
    PVector a = end.get();
    PVector v = PVector.sub(end, start);

    v.div(scaleFactor); // scale vector by two 
    v.rotate(angle); // rotate vector by given angle 
    a.add(v); // "attach" vector to the end point
    return a;
  }
  
  // displays the fractal
  void display() {
    strokeWeight(steps - generation + 1);
    stroke(FILL);
    fill(FILL);
    line(start.x, start.y, end.x, end.y);
  }
}


/* generates the next generation of branches */
ArrayList<Branch> generate(ArrayList<Branch> branches, int generation) {
  ArrayList next = new ArrayList<Branch>();
  for (Branch t : branches) {
    for (int i = 0; i < (control == 2 ? (int)random(1, 4) : 1); ++i) {
      // right branch
      noiseSeed(1000*(int)random(5000));
      float tmp = control < 1 ? angle : random(-PI/2, PI/2);
      next.add(new Branch(t.end, t.pointNext(tmp), tmp, generation));
      // left branch
      noiseSeed(1000*(int)random(5000));
      tmp = control < 1 ? -angle : random(-PI/2, PI/2);
      next.add(new Branch(t.end, t.pointNext(tmp), tmp, generation));
    }
  }

  return next;
}

/* generates the full tree in one run */
ArrayList<Branch> generateTree(ArrayList<Branch> b){
  ArrayList<Branch> branchFull = new ArrayList<Branch>();
  ArrayList<Branch> branchTmp = new ArrayList<Branch>(); // temporary variable the loop 
  branchTmp = b;
  branchFull = b;
  for (int i = 0; i < steps; ++i) { // over all branches
    branchTmp = generate(branchTmp, i + 1);
    branchFull.addAll(branchTmp); 
  }
  return branchFull;
}