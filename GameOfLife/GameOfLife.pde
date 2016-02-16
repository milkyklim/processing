boolean[] pBoard, cBoard; // previous, current board
PImage img; 

int Size; // radius of the cell
int cStroke; // initial size of the stroke/ellipse 

final int WIDTH = 640;
final int HEIGHT = 426;

int xNum; // total number of points in x direction
int yNum; // total number of points in y direction

void setup() {
  img = loadImage("data/input.jpg"); // load pic for color 
  size(640, 426); // have to take these from the image 
  background(255); 

  Size = 5; // radius of the cell
  cStroke = Size; // initial size of the stroke/ellipse 

  xNum = WIDTH/Size; // count number of cells in x-direction 
  yNum = HEIGHT/Size;  // count number of cells in y-direction 

  pBoard = new boolean[xNum*yNum];
  cBoard = new boolean[xNum*yNum];

  // initialize
  for (int i = 0; i < pBoard.length; ++i) {
    pBoard[i] = false; 
    cBoard[i] = random(0, 2) < 1 ? true : false;
  }

  noStroke();
  //frameRate(24); // to keep it slow
}

void draw() {
  background(255);

  // restart game  
  if (lifeSum(cBoard) < 4000) mouseClicked();

  if (frameCount%Size == 0) { // update every Size-frame step
    // copy current to previous board 
    for (int i = 0; i < pBoard.length; ++i) {
      pBoard[i] = cBoard[i];
    }
    cBoard = boardUpdate(pBoard, cBoard);
    cStroke = Size;
  }
  // image(img, 0, 0);
  boardDraw(cBoard, pBoard, img, cStroke);
  cStroke--;
}

/*
 count number of alive cells  //<>//
 cB -- array, current board
 */
int lifeSum(boolean[] cB) {
  int res = 0;
  for (int i = 0; i < cB.length; ++i) {
    if (cB[i]) res++;
  }
  return res;
}

/* 
 draw current board
 cB -- array, current board 
 pB -- array, previous board
 img -- initial pic
 cS -- size of the stroke\ellipse //<>//
 */
void boardDraw(boolean[] cB, boolean[] pB, PImage img, int cS) {
  // plot points
  img.loadPixels();
  for (int j = 0; j < yNum; ++j) { //<>//
    for (int i = 0; i < xNum; ++i) {
      if (cB[i + xNum*j] && pB[i + xNum*j]) {
        //strokeWeight(Size);
        fill(img.pixels[Size*i + img.width*Size*j]);
        ellipse(Size*i, Size*j, Size, Size);
      }
      if (cB[i + xNum*j] && !pB[i + xNum*j]) {
        // strokeWeight(Size);
        fill(img.pixels[Size*i + img.width*Size*j]);
        ellipse(Size*i, Size*j, Size - cS, Size - cS);
      }
      if (!cB[i + xNum*j] && pB[i + xNum*j]) {
        //strokeWeight(cS);
        fill(img.pixels[Size*i + img.width*Size*j]);
        ellipse(Size*i, Size*j, cS, cS);
      }
    }
  }
}

/*
  update board applying game of life rules  
 */
boolean[] boardUpdate(boolean[] pB, boolean[] cB) {
  for (int i = 0; i < xNum; ++i) {
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

/*
  restart picture
 */
void mouseClicked() {
  background(255);
  for (int i = 0; i < cBoard.length; ++i) {
    cBoard[i] = random(0, 2) < 1 ? true : false;
  }
}