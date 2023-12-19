class Blob {
  float x, y, w, h;

  String val;

  FloatList xlist = new FloatList();
  FloatList ylist = new FloatList();

  Blob(float _x, float _y) {
    x = _x;
    y = _y;

    xlist.append(_x);
    ylist.append(_y);

    h = 1;
    w = 1;
  }

  void setVal(float v){
    if(v == 10){
      val = "+";
    }else if(v == 11){
      val = "-";
    }else if(v == 12){
      val = "x";
    }else{
      val = str(int(v));
    }
  }

  void add(float _x, float _y) {

    xlist.append(_x);
    ylist.append(_y);

    if (x + w <_x) {
      w += _x - x - w;
    } else if (_x < x) {
      w += x - _x;
      x = _x;
    }

    if (y + h < _y) {
      h += _y - y - h;
    } else if (_y < y) {
      h += y - _y;
      y = _y;
    }
  }

  void show() {
    stroke(0, 255, 0);
    fill(255, 0);
    rect(x, y, w, h);
  }

  boolean isNear(float _x, float _y) {
    boolean found = false;
    float cx = max(min(x + w, _x), x);
    float cy = max(min(y + h, _y), y);

    if (dist(cx, cy, _x, _y) < 3 && dist(cx, cy, _x, _y) != 0) {
      found = true;
    }

    return found;
  }

  float calDistance(float _x, float _y) {
    float minDist = 99999999;
    for (int i = 0; i < xlist.size(); i++) {
      if (dist(xlist.get(i), ylist.get(i), _x, _y) < minDist) {
        minDist = dist(xlist.get(i), ylist.get(i), _x, _y);
      }
    }
    return minDist;
  }

  boolean isNearBlob(Blob b) {
    float treshold = 2;
    if ((x > b.x && x < b.x + b.w && y > b.y && y < b.y + b.h) ||
      (x + w > b.x && x + w < b.x + b.w && y > b.y && y < b.y + b.h)||
      (x > b.x && x < b.x + b.w && y + h > b.y && y + h < b.y + b.h)||
      (x + w > b.x && x + w < b.x + b.w && y + h > b.y && y + h < b.y + b.h) ||
      ((abs(x + w - b.x) < treshold) && y > b.y && y < b.y + b.h) ||
      ((abs(x - b.x - b.w) < treshold) && y > b.y && y < b.y + b.h)||
      ((abs(y + h - b.y) < treshold) && x > b.x && x < b.x + b.w)||
      ((abs(y - b.y - b.h) < treshold) && x > b.x && x < b.x + b.w)) {
      return true;
    } else return false;
  }
}
