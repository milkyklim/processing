color BACKGROUND; 

// blue #5DC5E2
// green #74B743
// yellow #EFE61F
// red #ED6B5B

int nTiles; // # of tiles
int tileSize; 
int offsetSize;
int nOffsets; // # offsets
int topOffset;
int leftOffset;

int[] tileType;

void setup() {
  BACKGROUND = color(255, 255, 255);

  background(BACKGROUND);
  size(530, 530);

  nTiles = 8; 
  offsetSize = 10;
  nOffsets = nTiles - 1;

  topOffset = ((width - nOffsets*offsetSize)%nTiles)/2;
  leftOffset = topOffset; 
  tileSize = (width - 2*leftOffset - nOffsets*offsetSize)/nTiles;
  println(tileSize*nTiles + leftOffset*2 + nOffsets*offsetSize == width ? "FINE!" : "PROBLEM!");

  tileType = new int [nTiles*nTiles];
}


void draw() {
  background(BACKGROUND);
  
  pushMatrix();
  translate(width - leftOffset - 2*offsetSize - 2.5*tileSize, 3*offsetSize + topOffset + 3.5*tileSize);
  rotate(-PI/4);
  
  pushStyle();
    noStroke();
    fill(#5DC5E2);
    rect(0, 0, height, height);
  popStyle();
  popMatrix();

  pushMatrix();
  translate(topOffset, leftOffset);
  initTileType(tileType);
  firstSum(nTiles, nTiles, tileSize, offsetSize, tileType, topOffset, leftOffset);
  //secondSum(nTiles, nTiles - 1, tileSize, offsetSize, tileType);
  popMatrix();


  // String timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  // println(timestamp);

  //save("data/pic" + timestamp + ".png");
  noLoop();
}


void initTileType(int[] tType) {
  for (int i = 0; i < tType.length; ++i) {
    tType[i] = 0;
  }
}


void mouseClicked() {
  background(BACKGROUND);
  loop();
}