class Pedestrian{
  /* characteristics important for tracking */
  private int id;
  private float x;
  private float y; 

  /* color intensities */
  private int intRed;
  private int intGreen;
  private int intBlue;
  
  /* difference vector variables */
  private int objArea; /* object area in pixels */
  private int objHeight; /* object min rectangle height */
  private int objWidth; /* object min rectangle width */
  
  /* TODO: Setters \ Getters */
  private int objRed; /* object red histogram */
  private int objGreen; /* object green histogram */
  private int objBlue; /* object blue histogram */
  
  /* size == 256 */
  private int[] frequencyRed = new int [256]; /* object red frequency */
  private int[] frequencyGreen = new int [256]; /* object green frequency */
  private int[] frequencyBlue = new int [256]; /* object blue frequency */
  
  /* TODO: Constructor */
  
  /* getters */
  public float getX(){
    return this.x;
  }
  
  public float getY(){
    return this.y;
  }
  
  public int getId(){
    return this.id;
  }
  
  public int getIntRed(){
    return this.intRed;
  }
  
  public int getIntGreen(){
    return this.intGreen;
  }
  
  public int getIntBlue(){
    return this.intGreen;
  }
  
  public int getObjArea(){
    return this.objArea;
  }
  
  public int getObjHeight(){
    return this.objHeight;
  }
  
  public int getObjWidth(){
    return this.objWidth;
  }
  
  public int getFrequencyRed(int i){
    return this.frequencyRed[i];
  }

  public int getFrequencyGreen(int i){
    return this.frequencyGreen[i];
  }  
  
  public int getFrequencyBlue(int i){
    return this.frequencyBlue[i];
  }
  
  /* setters */
  public void setX(float x_){
    this.x = x_; 
  }
  
  public void setY(float y_){
    this.y = y_; 
  }
  
  public void setId(int  id_){
    this.id = id_; 
  }
  
  public void setIntRed(int intRed_){
    this.intRed = intRed_;
  }
  
  public void setIntGreen(int intGreen_){
    this.intGreen = intGreen_;
  }
  
  public void setIntBlue(int intBlue_){
    this.intBlue = intBlue_;
  }
  
  public void setObjArea(int objArea_){
    this.objArea = objArea_;
  }
  
  public void setObjHeight(int objHeight_){
    this.objHeight = objHeight_;
  }
  
  public void setObjWidth(int objWidth_){
    this.objWidth = objWidth_;
  }
  
  public void setObjRed(int objRed_){
    this.objRed = objRed_;
  }
  
  public void setObjGreen(int objGreen_){
    this.objGreen = objGreen_;
  }
  
  public void setObjBlue(int objBlue_){
    this.objBlue = objBlue_;
  }
  
  public void setFrequencyRed(int val, int i){
    frequencyRed[i] = val;
  }

  public void setFrequencyGreen(int val, int i){
    frequencyGreen[i] = val;
  }  
  
  public void setFrequencyBlue(int val, int i){
    frequencyBlue[i] = val;
  }
  
  public void addFrequencyRed(int val, int i){
    frequencyRed[i] += val;
  }

  public void addFrequencyGreen(int val, int i){
    frequencyGreen[i] += val;
  }  
  
  public void addFrequencyBlue(int val, int i){
    frequencyBlue[i] += val;
  }
  
  /* METHODS */
  
  public void getFrequencies(PImage img, int iStart, int jStart){
    img.loadPixels();
    /* boundaries check necessary */
    for(int i = 0; i < BINSIZE; ++i){
      for (int j = 0; j < BINSIZE; ++j){
        int idx = img.pixels[(iStart + i)*width + (j + jStart)];
        this.addFrequencyRed(1, idx >> 16 & 0xff);
        this.addFrequencyGreen(1, idx >> 8 & 0xff);
        this.addFrequencyBlue(1, idx & 0xff);
      }
    }
  }
  
}