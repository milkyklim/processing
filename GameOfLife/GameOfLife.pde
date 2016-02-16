boolean[] pBoard, cBoard;  
PImage img; 

int xSize = 4; 
int ySize = 4;

int cStroke = 4;

final int WIDTH = 640;
final int HEIGHT = 426;

int xNum; // total number of points in x direction
int yNum; // total number of points in y direction

void setup() {
  img = loadImage("data/input.jpg");
  size(640, 426); // have to take these from the image 
  background(255); 

  xNum = WIDTH/xSize; 
  yNum = HEIGHT/ySize; 

  // check if all points are there
  // println(xNum * xSize * yNum * ySize + " " +  WIDTH * HEIGHT);

  pBoard = new boolean[xNum*yNum];
  cBoard = new boolean[xNum*yNum];

  // initialize
  for (int i = 0; i < pBoard.length; ++i) {
    pBoard[i] = false; 
    cBoard[i] = random(0, 2) < 1 ? true : false;
  }

  noStroke();

  // println(img.pixels.length);

  frameRate(24);
}

void draw() {
  background(255);

  // initialize
  //for (int i = 0; i < pBoard.length; ++i) {
  //  pBoard[i] = cBoard[i]; 
  //  // cBoard[i] = random(0, 2) < 1 ? true : false;
  //}

  if (frameCount%xSize == 0) { // update every xSize-frame
    for (int i = 0; i < pBoard.length; ++i) {
      pBoard[i] = cBoard[i]; 
      // cBoard[i] = random(0, 2) < 1 ? true : false;
    }
    cBoard = boardUpdate(pBoard, cBoard);
    cStroke = xSize; //<>//
    println(frameCount);
  }
  // image(img, 0, 0);
  boardDraw(cBoard, pBoard, img, cStroke);
  cStroke--;
  // xSize--;
}

void boardDraw(boolean[] cB, boolean[] pB, PImage img, int cS) {
  // plot points
  img.loadPixels();
  for (int j = 0; j < yNum; ++j) {
    for (int i = 0; i < xNum; ++i) {
      if (cB[i + xNum*j] && pB[i + xNum*j]) {
        //strokeWeight(xSize);
        fill(img.pixels[xSize*i + img.width*ySize*j]); //<>//
        ellipse(xSize*i, ySize*j, xSize, ySize);
      }
      if (cB[i + xNum*j] && !pB[i + xNum*j]) {
        // strokeWeight(xSize);
        fill(img.pixels[xSize*i + img.width*ySize*j]); //<>//
        ellipse(xSize*i, ySize*j, xSize - cS, ySize - cS);
        // println(xSize - cS);
      }
      if (!cB[i + xNum*j] && pB[i + xNum*j]) {
        //strokeWeight(cS);
        fill(img.pixels[xSize*i + img.width*ySize*j]);
        ellipse(xSize*i, ySize*j, cS, cS);
        // println(cS);
      }
    }
  }
}


boolean[] boardUpdate(boolean[] pB, boolean[] cB) {
  for (int i =0; i < xNum; ++i) {
    for (int j = 0; j < yNum; ++j) {
      int res = 0; // neigbors counter
      if (pB[(i + 1 + xNum)%xNum + xNum*((j + 1 + yNum)%yNum)]) res++;
      if (pB[(i + 1 + xNum)%xNum + xNum*((j     + yNum)%yNum)]) res++;
      if (pB[(i + 1 + xNum)%xNum + xNum*((j - 1 + yNum)%yNum)]) res++;
      if (pB[(i     + xNum)%xNum + xNum*((j + 1 + yNum)%yNum)]) res++;
      if (pB[(i     + xNum)%xNum + xNum*((j - 1 + yNum)%yNum)]) res++;
      if (pB[(i - 1 + xNum)%xNum + xNum*((j + 1 + yNum)%yNum)]) res++;
      if (pB[(i - 1 + xNum)%xNum + xNum*((j     + yNum)%yNum)]) res++;
      if (pB[(i - 1 + xNum)%xNum + xNum*((j - 1 + yNum)%yNum)]) res++;

      // current cell is alive
      if ((res == 3 || res == 2) && pB[i + xNum*j]) 
        cB[i + xNum*j] = true;
      else // new live 
      if ((res == 3) && !pB[i + xNum*j]) 
        cB[i + xNum*j] = true;
      else cB[i + xNum*j] = false;
    }
  }

  return cB;
}

void mouseClicked() {
  background(255);
  for (int i = 0; i < cBoard.length; ++i) {
    cBoard[i] = random(0, 2) < 1 ? true : false;
  }
}