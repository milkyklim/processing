// initialize positions of gangstas
void gangstaInit(PVector[] xy, PVector[] b, int[] dead) {
  dead[0] = 0;
  dead[1] = 0;
  for (int i = 0; i < N; ++i) {
    int x = (int)random(0 + gRadius, width - gRadius);
    int y = (int)random(0 + gRadius, height - gRadius); 
    while (overlap (x, y, xy, i)) {
      x = (int)random(0 + gRadius, width - gRadius);
      y = (int)random(0 + gRadius, height - gRadius);

      // if (millis() > 10) exit();
    }
    xy[i] = new PVector(x, y);
    b[i] = new PVector(x, y);
  }
}

// check if there is an overlap 
boolean overlap(int x_, int y_, PVector[] xy_, int n) {
  boolean res = false;
  for (int i = 0; i < n; ++i) {
    if (dist(x_, y_, xy_[i].x, xy_[i].y) < 2*gRadius)
      res = true;
    // inside logo
    if (x_ > width - 90 - gRadius && y_ >  width - 120 - gRadius)
      res = true;
  }
  // println(n);
  return res;
}

// draw gangstas
void gangstaShow(PVector[] xy_, boolean dig, int sT) {
  pushStyle();
  for (int i = 0; i < N; ++i) {
    fill(FILL);
    stroke(STROKE, map(sT, 0, frameN, 0, 255));
    strokeWeight(STROKEWEIGHT);
    ellipse(xy_[i].x, xy_[i].y, gRadius, gRadius);
    if (dig) {
      fill(FILL);
      textAlign(CENTER, CENTER);
      text(i, xy_[i].x, xy_[i].y);
    }
  }
  popStyle();
}  

// find nearest gangsta
void gangstaFindNearest(PVector[] xy_, int[] gA) {
  for (int i = 0; i < xy_.length; ++i) {
    int iMin = i;
    float tMin = width*width;
    for (int j = 0; j < xy_.length; ++j)
      if (i != j) {
        if (dist(xy_[i].x, xy_[i].y, xy_[j].x, xy_[j].y) < tMin) {
          tMin = dist(xy_[i].x, xy_[i].y, xy_[j].x, xy_[j].y);
          iMin = j;
        }
      }
    gA[i] = iMin;
  }
}

// print nearest gangsta 
void gangstaPrintNearest(int[] gA) {
  for (int i = 0; i < gA.length; ++i)
    println(i + " " + gA[i]);
}

// put cross on top of dead gangsta
void gangstaDeadShow(PVector[] xy_, int[] gA, PGraphics p, int[] dead) {
  // cheap vestion with bit manipulations 

  for (int i = 0; i < xy_.length; ++i) {
    if (gA[i] <= 30)
      dead[0] = dead[0] | (1 << gA[i]);
    else
      dead[1] = dead[1] | (1 << (gA[i] - 31));
  }
  
  for (int i = 0; i < xy_.length; ++i) {
    if (i <= 30) {
      if (((dead[0] & (1 << i)) >> i) == 1)
        image(p, xy_[i].x - gRadius/2, xy_[i].y - gRadius/2);
    } else
      if (((dead[1] & (1 << (i - 31))) >> (i - 31)) == 1)
        image(p, xy_[i].x - gRadius/2, xy_[i].y - gRadius/2);
  }


  // fast expensive version 
  //boolean [] dead = new boolean [xy_.length];
  //for (int i = 0; i < gA.length; ++i) {
  //  if (!dead[gA[i]])
  //    image(p, xy_[i].x - gRadius/2, xy_[i].y - gRadius/2);
  //  dead[gA[i]] = true;
  //}
}

// draw line to the nearest gangsta!
void gangstaShotShow(PVector[] xy_, int[] gA, PVector[] shot, int sT) {
  pushStyle();
  stroke(STROKE, map(sT, 0, frameN, 0, 255));
  strokeWeight(STROKEWEIGHT);
  fill(STROKE);
  for (int i = 0; i < xy_.length; ++i) {
    // check for double lines 
    if (gA[gA[i]] !=  i || i < gA[i]) {     
      line(xy_[gA[i]].x, xy_[gA[i]].y, xy_[i].x, xy_[i].y);
    }
  }
  popStyle();
}