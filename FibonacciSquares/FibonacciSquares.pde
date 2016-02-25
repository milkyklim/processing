PGraphics preScreen;

ArrayList<Square> squares;

int[] f = {10, 10, 20, 30};

int xCur = 0;
int yCur = 0;

int idx = 3;

void setup() {
  size(530, 530);
  background(255);

  preScreen = createGraphics(530, 530);


  squares = new ArrayList<Square>();
  squares.add(new Square(xCur, 0, f[0]));
  yCur += f[0];
  squares.add(new Square(0, yCur, f[1]));
  xCur += f[0];
  squares.add(new Square(xCur, 0, f[2]));


  preScreen.beginDraw();
  preScreen.background(255);
  preScreen.rect(squares.get(0).getX(), squares.get(0).getY(), squares.get(0).getF(), squares.get(0).getF());
  preScreen.rect(squares.get(1).getX(), squares.get(1).getY(), squares.get(1).getF(), squares.get(1).getF());
  preScreen.rect(squares.get(2).getX(), squares.get(2).getY(), squares.get(2).getF(), squares.get(2).getF());

  preScreen.endDraw();

  xCur += f[2];
  yCur += f[1];

  int tmp = f[3] + f[2]; 
  f[0] = f[1];
  f[1] = f[2];
  f[2] = f[3];
  f[3] = tmp;

  println(xCur, yCur);




  noLoop();
}


void draw() {
  /* 
   for scaling we always use right-most square 
   that is f[2] + f[3]
   */

  float scaleFactor = 1.0;///(f[2] + f[3]);

  image(preScreen, 0, 0);
  //scale(1.0*f[1]/f[2], 1.0*f[1]/f[2]);

  preScreen.beginDraw();
  if (idx %2 == 0) {
    squares.add(new Square(xCur, 0, f[2]));
    preScreen.rect(squares.get(idx).getX(), 0, squares.get(idx).getF(), squares.get(idx).getF());
    xCur += f[2];
    // preScreen.fill(random(255));
    // text(f[2], xCur, 0);
  } else {
    squares.add(new Square(0, yCur, f[2]));
    preScreen.rect(0, squares.get(idx).getY(), squares.get(idx).getF(), squares.get(idx).getF());
    yCur += f[2];  
    // fill(0);
    // text(f[2], 0, yCur);
  }
  preScreen.endDraw();


  //rect(width/2-50, height/2-50, 100, 100);
  // fill(0);
  //text(f[0], width/2, height/2);
  //fill(255); 
  int tmp = f[3] + f[2]; 
  f[0] = f[1];
  f[1] = f[2];
  f[2] = f[3];
  f[3] = tmp;


  ++idx;
  //delay(500);
  resizeSquares();
  noLoop();
}

void resizeSquares(){
  for (Square s : squares){
    int x = s.getX();
    int y = s.getY();
    if (x > 0) x--;
    if (y > 0) y--;    
    s.setX(x);
    s.setY(y);
  }
}

void mouseReleased() {
  loop();
  //background(255);
  //f[0] = 1;
  //f[1] = 1;
  //f[2] = 2;
  //xCur = 0;
  //yCur = 0;
  //idx = 0;

  //rect(xCur, 0, f[0], f[0]);
  //rect(0, yCur, f[1], f[1]);

  //xCur += f[0];
  //yCur += f[0];
}