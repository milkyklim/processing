void firstSum(int n, int m, int size, int offset, int[] tType, int tOffset, int lOffset) {
  drawCircles(n, m, size, offset, tType);
  drawLinesFirst(n, size, offset, tOffset, lOffset);
}

void secondSum(int n, int m, int size, int offset, int[] tType, int tOffset, int lOffset) {
  drawCircles(n, m, size, offset, tType);
  drawLinesSecond(n, size, offset, tOffset, lOffset);
  drawLinesBottom(n, size, offset, lOffset);
}

void drawCircles(int n, int m, int size, int offset, int[] tType) {
  pushMatrix();
  for (int i = 0; i < n; ++i) {
    for (int j = 0; j < m; ++j) {

      noStroke();
      fill(0);
      ellipseMode(CORNER);
      strokeCap(SQUARE);

      switch (tType[j + n*i]) {
      case 0:
        stroke(0);
        strokeWeight(2);
        noFill();
        // -2 to fit in the cell
        ellipse(i*(size + offset), j*(size + offset), size - 2, size - 2);
        break;
      case 1:
        ellipse(i*(size + offset), j*(size + offset), size, size);
        break;
      }
    }
  }
  popMatrix();
}

void drawLinesFirst(int nTiles, int tileSize, int offsetSize, int topOffset, int leftOffset) {
  pushMatrix();
  stroke(0);
  strokeCap(ROUND);
  strokeWeight(2);

  for (int i = 0; i < nTiles - 1; ++i) {
    int xy = tileSize*(i + 1) + offsetSize/2 + i*offsetSize;
    line(0, xy - topOffset/2, xy - topOffset/2, xy - topOffset/2);
    line(xy - leftOffset/2, 0, xy - leftOffset/2, xy -  topOffset/2);
  }
  popMatrix();
}

void drawLinesSecond(int nTiles, int tileSize, int offsetSize, int topOffset, int leftOffset) {
  pushMatrix();
  stroke(0);
  strokeCap(ROUND);
  strokeWeight(2);

  int[] xy = new int [3];

  for (int i = 0; i < nTiles - 1; ++i) {
    xy[0] = tileSize*(i) + offsetSize/2 + (i - 1)*offsetSize;
    xy[1] = tileSize*(i + 1) + offsetSize/2 + i*offsetSize;
    xy[2] = tileSize*(i + 2) + offsetSize/2 + (i + 1)*offsetSize;

    if (i != nTiles - 2)
      line(xy[1] - leftOffset/2, xy[1] - topOffset/2, xy[2] - leftOffset/2, xy[1] - topOffset/2);
    if (i != nTiles - 2 && i != 0)
      line(xy[1] - leftOffset/2, xy[1] - topOffset/2, xy[1] - leftOffset/2, xy[0] - topOffset/2);
    else {
      if (i == nTiles - 2)
        line(xy[1] - leftOffset/2, xy[1] - 3*topOffset, xy[1] - leftOffset/2, xy[0] - topOffset/2);
      if (i == 0)
        line(xy[1] - leftOffset/2, xy[1] - topOffset/2, xy[1] - leftOffset/2, xy[0] + 3*topOffset);
    }
  }
  popMatrix();
}

void drawLinesBottom(int nTiles, int tileSize, int offsetSize, int leftOffset) {
  pushMatrix();
  stroke(0);
  strokeCap(ROUND);
  strokeWeight(2);

  int[] xy = new int [3];

  for (int i = 0; i < 11; ++i) {
    xy[0] = tileSize*(i) + offsetSize/2 + (i - 1)*offsetSize;
    xy[1] = tileSize*(i + 1) + offsetSize/2 + i*offsetSize;
    xy[2] = tileSize*(i + 2) + offsetSize/2 + (i + 1)*offsetSize;

    int xx = tileSize*(nTiles - 1) + offsetSize/2 + (nTiles - 2)*offsetSize;

    line(0, xx + i*6, width - 2*leftOffset - 1, xx + i*6);
  }  
  popMatrix();
}