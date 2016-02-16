boolean[] pBoard, cBoard;  
PImage img; 

int xSize = 4; 
int ySize = 4;

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
  println(xNum * xSize * yNum * ySize + " " +  WIDTH * HEIGHT);

  pBoard = new boolean[xNum*yNum];
  cBoard = new boolean[xNum*yNum];

  // initialize
  for (int i = 0; i < pBoard.length; ++i) {
    pBoard[i] = false; 
    cBoard[i] = random(0, 2) < 1 ? true : false;
  }

  img.loadPixels();
  noStroke();

  println(img.pixels.length);

  frameRate(24);
}

void draw() {
  background(255);
  // strokeWeight(1);


  // initialize
  for (int i = 0; i < pBoard.length; ++i) {
    pBoard[i] = cBoard[i]; 
    // cBoard[i] = random(0, 2) < 1 ? true : false;
  }

  for (int i =0; i < xNum; ++i) {
    for (int j = 0; j < yNum; ++j) {
      int res = 0; // neigbors counter
      if (pBoard[(i + 1 + xNum)%xNum + xNum*((j + 1 + yNum)%yNum)]) res++;
      if (pBoard[(i + 1 + xNum)%xNum + xNum*((j     + yNum)%yNum)]) res++;
      if (pBoard[(i + 1 + xNum)%xNum + xNum*((j - 1 + yNum)%yNum)]) res++;
      if (pBoard[(i     + xNum)%xNum + xNum*((j + 1 + yNum)%yNum)]) res++;
      if (pBoard[(i     + xNum)%xNum + xNum*((j - 1 + yNum)%yNum)]) res++;
      if (pBoard[(i - 1 + xNum)%xNum + xNum*((j + 1 + yNum)%yNum)]) res++;
      if (pBoard[(i - 1 + xNum)%xNum + xNum*((j     + yNum)%yNum)]) res++;
      if (pBoard[(i - 1 + xNum)%xNum + xNum*((j - 1 + yNum)%yNum)]) res++;

      // current cell is alive
      if ((res == 3 || res == 2) && pBoard[i + xNum*j]) 
        cBoard[i + xNum*j] = true;
      else // new live 
      if ((res == 3) && !pBoard[i + xNum*j]) 
        cBoard[i + xNum*j] = true;
      else cBoard[i + xNum*j] = false;
    }
  }


  // image(img, 0, 0);

  // plot initial points
  for (int j = 0; j < yNum; ++j) {
    for (int i = 0; i < xNum; ++i) {
      if (cBoard[i + xNum*j]) {
        fill(img.pixels[xSize*i + img.width*ySize*j]);
        ellipse(xSize*i, ySize*j, xSize, ySize);
      }
    }
  }
}

void mouseClicked() {
  for (int i = 0; i < cBoard.length; ++i) {
    cBoard[i] = random(0, 2) < 1 ? true : false;
  }
}