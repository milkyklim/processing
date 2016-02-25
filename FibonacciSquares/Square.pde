class Square {
  private int x; // x-left corner
  private int y; // y-right corner
  private int f; // size
  private float scaleFactor; // scaling factor


  Square(int x_, int y_, int f_) {
    this.x = x_;
    this.y = y_;
    this.f = f_;
  }

  int getX() {
    return x;
  }

  int getY() {
    return y;
  }

  int getF() {
    return f;
  }

  float getScaleFactor() {
    return scaleFactor;
  }

  void setX(int x_) {
    this.x = x_;
  }

  void setY(int y_) {
    this.y = y_;
  }

  void setF(int f_) {
    this.f = f_;
  }
}